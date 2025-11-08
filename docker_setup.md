Part C.4: Dockerfile ConfigurationThis guide provides the multi-stage Dockerfile templates needed for each of the four application repositories. These files are required for the GitHub Actions (Part C.3) to build and containerize your applications.Important Note: The following Dockerfiles assume a standard project structure (e.g., project files like .csproj are in the root, or the Express server file is server.js in the root).You must inspect the actual file and folder structure of each repository and modify the COPY paths and ENTRYPOINT/CMD commands to match the real project layout.1. .NET 9 Application DockerfileThis file should be created in the root directory of the following repositories:DiasRestApiDiasDalApiFile Name: Dockerfile# === STAGE 1: Build ===
# Use the .NET 9 SDK image for building
FROM [mcr.microsoft.com/dotnet/sdk:9.0](https://mcr.microsoft.com/dotnet/sdk:9.0) AS build
WORKDIR /src

# --- VERIFY THIS STEP ---
# This assumes .csproj is in the root.
# If it's in a subfolder (e.g., ./MyProject/), change this:
# COPY ./MyProject/*.csproj ./MyProject/
# RUN dotnet restore ./MyProject/*.csproj
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the source code and build the app
# --- VERIFY THIS STEP ---
# Adjust source and destination if needed
COPY . .
RUN dotnet publish -c Release -o /app/publish

# === STAGE 2: Final ===
# Use the smaller ASP.NET runtime image for the final container
FROM [mcr.microsoft.com/dotnet/aspnet:9.0](https://mcr.microsoft.com/dotnet/aspnet:9.0) AS final
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port your app runs on (matches your docker-compose.yml)
EXPOSE 8080

# --- VERIFY THIS STEP ---
# You MUST change this .dll name to match the project's assembly name.
# For DiasRestApi:
ENTRYPOINT ["dotnet", "DiasRestApi.dll"]
#
# For DiasDalApi (you will need to edit this file in that repo):
# ENTRYPOINT ["dotnet", "DiasDalApi.dll"]
Customization Checklist for .NET:[ ] Project Structure: Check if the .csproj file is in the root. If not, update the COPY and RUN dotnet restore commands in STAGE 1.[ ] Entrypoint: Change the .dll name in the ENTRYPOINT command to match the assembly name of the project (DiasRestApi.dll for one, DiasDalApi.dll for the other).2. React/Express Application DockerfileThis file should be created in the root directory of the following repositories:DiasAdminUidias-edu-hubFile Name: Dockerfile# === STAGE 1: Build React App ===
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all source code
COPY . .

# --- VERIFY THIS STEP ---
# This assumes your build script is 'npm run build'
# and the output folder is 'build'.
# If the output is 'dist', change the 'COPY' in STAGE 2.
RUN npm run build

# === STAGE 2: Build Production Server ===
FROM node:20-alpine AS final
WORKDIR /app

# Copy package files and install *only* production dependencies
COPY package.json package-lock.json ./
RUN npm install --omit=dev

# --- VERIFY THIS STEP ---
# This assumes the React build output is './build'.
# If it's './dist', change this line:
COPY --from=build /app/build ./build

# --- VERIFY THIS STEP ---
# This assumes your server is a single 'server.js' file in the root.
# If it's 'index.js', or in a '/server' folder, you MUST
# update the COPY and CMD lines.
#
# Example for a '/server' folder:
# COPY ./server ./server
# CMD [ "node", "server/index.js" ]
#
COPY ./server.js ./

# Expose the port your Express server runs on
EXPOSE 3000

# --- VERIFY THIS STEP ---
# This must match the server file to run.
CMD [ "node", "server.js" ]
Customization Checklist for React/Express:[ ] React Build Output: Check if your React app builds to a build or dist folder. Update the COPY --from=build line in STAGE 2 to match.[ ] Server File(s): Check where your Express server file is (server.js, index.js, /server/index.js, etc.). Update the COPY and CMD commands in STAGE 2 to copy the correct files and run the correct start command.