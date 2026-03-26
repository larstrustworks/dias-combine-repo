# Convert Single Endpoint

We are now in the process of converting endpoints from our old legacy repos to the DiasRestApi. What we've done so far:

1. **Phase 1 (Discovery)**: Created endpoint inventory using `/Templates/map-endpoints.md`
2. **Phase 2 (Scaffolding)**: Created placeholder controllers using `/Templates/create-placeholders.md`
3. **Phase 2.5 (Specification)**: Created ENDPOINT_SPEC.md files using `/Templates/create-endpoint-specs.md`

The endpoint list is located here:

<endpoint file>

In the endpoint file, the column dias_controller_path has the exact path to the controller folder for each endpoint.

**IMPORTANT**: Before starting conversion, read the ENDPOINT_SPEC.md file located at:
```
{dias_controller_path}/docs/ENDPOINT_SPEC.md
```

This spec was created during Phase 2.5 and contains comprehensive analysis of the endpoint's business logic, dependencies, and conversion considerations. Use it as the foundation for your analysis.

Now we need to convert one endpoint at a time from the legacy repo, and for this prompt you should convert endpoint with key:

<endpoint key>

## Framework: ASP.NET Core (.NET 9) (REQUIRED)

DiasRestApi uses ASP.NET Core on .NET 9 exclusively. All endpoints MUST use:
- Controller class inheriting from `BaseController` (or `ControllerBase` for simple cases)
- Route attributes: `[HttpGet]`, `[HttpPost]`, `[HttpPut]`, `[HttpDelete]`
- `[ApiController]` attribute on the controller class
- Dependency injection via constructor injection
- Controller auto-discovery (standard ASP.NET Core convention)
- No manual route registration needed

**Reference:** See existing controllers in `DiasRestApi/dotnet_version/src/Controllers/`

## Endpoint Mapping Convention

When converting legacy endpoints, follow this URL mapping:
- **Legacy endpoint**: Original path from legacy repo
- **Converted endpoint**: `/legacy/{legacy-repo-name}/{original-path}`
- **Example**: `GET /Cvr/GetCvr/{cvrNumber}` → `GET /legacy/Cvr/Cvr/GetCvr/{cvrNumber}`

## Code Quality Standards

All converted endpoints MUST meet these standards:

| Standard | Requirement |
|----------|-------------|
| Build | Zero errors on `dotnet build` |
| Return Types | Explicit return types on all methods (`Task<IActionResult>`, etc.) |
| Namespaces | Follow project namespace conventions (`DiasRestApi.Controllers.*`) |
| XML Docs | XML documentation comments on public members |
| C# | Nullable reference types enabled, proper typing |

**Code Quality Checklist** (verify before marking conversion complete):
- [ ] Zero build errors
- [ ] Explicit return types on all methods
- [ ] Proper namespace following project conventions
- [ ] XML documentation on public members
- [ ] Nullable reference types handled correctly
- [ ] All tests passing
- [ ] Documentation complete and accurate

## Conversion Process

### Step 0: Verify Legacy Response Format (MANDATORY GATE)

**⛔ DO NOT PROCEED TO STEP 1 UNTIL THIS IS COMPLETE**

ENDPOINT_SPEC.md response format is UNRELIABLE. You MUST verify from authoritative source.

#### Step 0.1: Trace the Route (CRITICAL - V4)

**Do NOT trust any XSLT without tracing the route first!**

1. **Find the Camel route**
   ```
   Legacy/integration/{repo}/src/main/java/**/*Route*.java
   ```
   Search for the endpoint path to find which route handles it.

2. **Trace to the FINAL transformation before response**
   - Read the route from start to end
   - Identify the LAST step that transforms data
   - Look for these patterns in order:

#### Step 0.2: Identify Transformation Type (Decision Tree)

**Check in this order - use the FIRST match:**

**2A: XSLT Transformation**
- Pattern: `.to("xslt:filename.xsl")` as LAST transformation
- Location: `Legacy/integration/{repo}/src/main/resources/{filename}.xsl`
- If found: READ THE ENTIRE XSLT FILE → **STOP - XSLT is authoritative**

**2B: Java Processor/Mapper**
- Pattern: `.process(new SomeProcessor())` or `.bean(SomeMapper.class)` as LAST transformation
- If found:
  1. Open the Processor class
  2. Find which Mapper it calls: `SomeMapper.convert(...)`
  3. READ THE ENTIRE MAPPER CLASS
  4. Note the **return type** - this determines response structure:
     - `List<X>` → flat JSON array `[...]`
     - `X` → single object `{...}`
  5. Find model class in DiasLegacyModels:
     ```
     DiasLegacyModels/{jar-name}-{version}/{package-path}/{ClassName}.java
     ```
  6. Read `@XmlElement` annotations for exact JSON property names
  7. **STOP - Mapper + Model is authoritative**

**2C: Camel REST outType Definition**
- Pattern: `.outType(X.class)` or `.outTypeList(X.class)` in REST definition
- `outTypeList(X.class)` → Response is flat array: `[{...}, {...}]`
- `outType(X.class)` → Response is single object or as defined by X
- Find model class in DiasLegacyModels for exact structure

**2D: Jackson JSON Serialization**
- Pattern: `.marshal().json(JsonLibrary.Jackson)`
- Check what object type is in the body at that point
- Find the Java class to understand structure

**2E: Neither Found?**
- Check golden response: `DiasRestApi/dotnet_version/src/Controllers/{legacy-repo}/golden-responses/{endpoint-key}.json`
- If nothing exists: **STOP AND ASK USER**
  > "I cannot find XSLT, Java Mapper, or outType definition. Please provide a golden master response from the legacy endpoint."

#### Example Trace (Landing Endpoint)
```
Route: LandingRouteBuilder.java
  ↓
REST definition: .outTypeList(dk.naturerhverv.fishery.landing.v2.LandingDeclarationType.class)
  ↓
Final transformation: .process(new CdmTypeToBmLandingDeclarationProcessor())
  ↓
Processor calls: CdmToLandingMapper.convert(cdm, includeHistory)
  ↓
Mapper returns: List<LandingDeclarationType> (FLAT ARRAY)
  ↓
Model class: DiasLegacyModels/landing-service-*/dk/naturerhverv/fishery/landing/v2/LandingDeclarationType.java
```

#### Step 0.3: Document Verified Source

After finding authoritative source, document:
```markdown
## Response Format Verification

**Transformation Type**: [XSLT / Java Mapper / outType / Golden Master]
**Source File**: [path to file]
**Trace Path**: [Route → Processor → Mapper → Model]
**Output Format**: [flat array / wrapped object / single object]
**Model Class**: [full class name if applicable]
```

#### Verification Checkpoint

Before proceeding, you must have:
- [ ] Route traced and FINAL transformation identified
- [ ] Transformation type documented (XSLT / Mapper / outType / Golden Master)
- [ ] Authoritative source read completely
- [ ] For Java models: Found class in DiasLegacyModels and read `@Xml*` annotations
- [ ] Exact JSON structure documented
- [ ] Exact property casing confirmed
- [ ] **Type mapping table created with ALL fields from Java model (V5)**
- [ ] **Nullable fields identified that need explicit null (V5)**
- [ ] **String fields that look like numbers identified (V5)**

#### Step 0.4: Create Type Mapping from Java Model (V5 - MANDATORY)

**⛔ This step cannot be skipped!**

After identifying the authoritative source, create a complete type mapping from the Java model class.

1. **Find ALL Java Model Classes** used in the response
2. **Read ALL fields and their types** from the model class
3. **Create Type Mapping Table** in design.md:

```markdown
## Type Mapping: [ClassName]

| Field | Java Type | C# Type | JSON Type | Nullable | Notes |
|-------|-----------|---------|-----------|----------|-------|
| UserId | String | string | string | no | |
| PhoneNumber | String | string? | string | yes | |
| FormType | Integer | int | number | no | |
| serialNumber | String | string? | string | yes | Must be explicit null |
```

**Type Mapping Rules (Java → C#)**:
| Java Type | C# Type | JSON Type |
|-----------|---------|-----------|
| `String` | `string` / `string?` | `string` (never parse to number!) |
| `Integer`, `int` | `int` / `int?` | `number` |
| `Long`, `long` | `long` / `long?` | `number` |
| `BigDecimal`, `Double`, `Float` | `decimal` / `double` | `number` |
| `Boolean`, `boolean` | `bool` / `bool?` | `boolean` |
| `List<T>` | `List<T>` | `array` (even if single element) |
| Any nullable field | Nullable type (`T?`) | `type \| null` (explicit null if not in XML) |

**Common string fields that look like numbers**:
- `UserId`, `PhoneNumber`, `PNumber`, `LandingDeclaration`, `LogbookNumber`, `referenceNumber`, `FAO.Area`, `Size`

**JSON Serialization Configuration** (preserve string types):
```csharp
var options = new JsonSerializerOptions
{
    PropertyNamingPolicy = null, // Preserve original casing from model
    DefaultIgnoreCondition = JsonIgnoreCondition.Never, // Include null fields
    WriteIndented = false
};
```

#### What is NOT Used for Response Format

- **XSD Schema Files** (`.to("validator:*.xsd")`) - INPUT validation only, NOT response format
- **domainservicemodel XSD files** - Used to generate Java classes, NOT needed for conversion

#### Common Mistakes to Avoid (V5)

| Wrong | Correct |
|-------|---------|
| Found XSLT file, used it | Traced route, verified XSLT is FINAL transformation |
| Stopped at Processor | Followed Processor → Mapper → Model chain |
| Assumed wrapped response `{ "List": {...} }` | Checked Mapper return type (may be flat array `[...]`) |
| Used XSD for response format | XSD is for input validation only |
| Guessed property casing | Read `@XmlElement` annotations in model class |
| Copied from other converted endpoints | Verified from route tracing |
| Let serializer auto-convert strings to numbers | Use string types in C# model, configure JsonSerializer (V5) |
| Missing null fields in output | Add ALL nullable fields from Java model (V5) |
| Only included fields from golden master | Include ALL fields from Java model class (V5) |

**ONLY PROCEED TO STEP 1 AFTER VERIFICATION IS COMPLETE**

### Step 1: Deep Analysis

Before writing any code, perform thorough analysis of the legacy endpoint:

**1.1 Create a Codemap**
- Trace the complete request flow from REST endpoint to response
- Document all classes, methods, and transformations involved
- Note the call chain: Controller → Service → DAO/External calls

**1.2 Identify Dependencies**
- List all external service calls (SOAP, REST, database)
- Note any shared utilities or helper classes used
- Document configuration dependencies (properties, environment variables)

**1.3 Document Business Logic**
- Map all business rules and validations
- Note conditional logic and branching paths
- Document error handling and exception flows

**1.4 Identify Edge Cases**
- Empty/null input handling
- Error scenarios and their responses
- Boundary conditions (max lengths, date ranges, etc.)

**Output**: Document findings for use in Step 2 Cross-Validation.

### Step 2: Cross-Validation (MANDATORY GATE)

**⛔ DO NOT PROCEED TO STEP 3 UNTIL VALIDATION IS COMPLETE**

Compare findings from Step 0 (Response Format) and Step 1 (Deep Analysis) to ensure consistency.

#### 2.1 Validation Checklist

| Aspect | Step 0 Finding | Step 1 Finding | Match? |
|--------|----------------|----------------|--------|
| Route path traced | | | ☐ |
| External service calls identified | | | ☐ |
| Model classes used | | | ☐ |
| Transformation chain | | | ☐ |
| Data flow (input → output) | | | ☐ |

#### 2.2 If ALL Match ✅

Proceed to Step 3 with high confidence. Create "Consolidated Analysis" combining:
- Response format and Type Mapping from Step 0
- Business logic and edge cases from Step 1
- Dependencies list from both steps

#### 2.3 If MISMATCH Found ❌

**Do NOT proceed. Instead:**

1. **Identify the discrepancy** - Which specific aspect doesn't match?
2. **Investigate deeper** - Re-trace the route, re-read the code
3. **Determine authoritative source** - Which finding is correct?
4. **Document the resolution** - Why was there a mismatch? Which source was wrong?

**Common mismatch causes:**
- Step 0 traced wrong route branch
- Step 1 missed a transformation step
- Multiple code paths for same endpoint
- Conditional logic not fully traced

**If unresolvable:**
> ⛔ STOP and ask user: "I found conflicting information between route tracing and code analysis. [Describe mismatch]. Please help clarify which is correct."

#### 2.4 Output: Consolidated Analysis

Create a summary document with:
```markdown
## Consolidated Analysis

### Response Format (from Step 0)
- Transformation Type: [XSLT / Java Mapper / outType]
- Output Format: [flat array / wrapped / single object]
- Type Mapping: [reference to table]

### Business Logic (from Step 1)
- Main flow: [description]
- Edge cases: [list]
- Error handling: [description]

### Dependencies (combined)
- External services: [list]
- Model classes: [list]
- Shared utilities: [list]

### Validation Status
- Cross-validation: ✅ PASSED / ❌ FAILED (resolved)
- Discrepancies found: [none / list with resolutions]
```

**ONLY PROCEED TO STEP 3 AFTER CROSS-VALIDATION IS COMPLETE**

### Step 3: Review ENDPOINT_SPEC.md

- Read the ENDPOINT_SPEC.md file in {dias_controller_path}/docs/
- Compare with your Consolidated Analysis from Step 2
- Note any discrepancies between ENDPOINT_SPEC.md and your analysis
- Update ENDPOINT_SPEC.md if needed (with verified information only)
- Use Consolidated Analysis as foundation for requirements.md

### Step 4: Decide Approach (SDD or Direct Implementation)

After completing Steps 0-3, assess the endpoint complexity:

**Simple endpoint** (direct DalService proxy, minimal/no transformation, few fields):
- Skip SDD — proceed directly to Step 5 using the Consolidated Analysis from Steps 0-3 as your guide
- Still create documentation (Step 8) and specs folder with a brief summary

**Complex endpoint** (multiple services, conditional logic, XSLT transformations, many model classes):
- Use Spec-Driven Development: create requirements.md, design.md, tasks.md
- Include Consolidated Analysis, Type Mapping, and all dependencies
- Auto-approve requirements and design without asking user for review
- All file paths in tasks.md MUST use full paths from repository root: `DiasRestApi/dotnet_version/src/Controllers/...`

**When in doubt**, lean toward direct implementation — the analysis gates (Steps 0-3) already catch the real issues. SDD adds value mainly when you need to track many moving parts.

### Step 5: Implementation

Conversion results in a SELF CONTAINED controller module in the exact path from dias_controller_path. The controller module folder should have:

```
DiasRestApi/dotnet_version/src/Controllers/{legacy-repo}/{method}/{path}/
├── HandlerController.cs              # Main endpoint controller (replaces notimplemented_handler_controller.cs)
├── Services/                          # Business logic services
│   ├── {Feature}Service.cs
│   └── ExternalServicesService.cs     # For external API calls (rare)
├── Models/                            # Data models (C# DTOs)
│   └── {Model}.cs
├── docs/                              # Documentation
│   ├── ENDPOINT_SPEC.md
│   ├── CONVERSION_SUMMARY.md
│   ├── TEST_INSTRUCTIONS.md
│   ├── MODELS_USED.md
│   └── SERVICES_USED.md
├── specs/                             # Spec files (archived after completion)
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
└── README.md                          # Overview and links
```

**Note:** Unit tests are placed in `DiasRestApi/dotnet_version/tests/DiasRestApi.UnitTests/Controllers/{repo}/{endpoint}/` following the existing test project structure.

**Self-Contained Requirements**:
- DO NOT reference existing shared services (except DalService and BaseController)
- DO NOT reference existing shared models (except ErrorResponse, DalConnection, etc.)
- DO copy and adapt any needed functionality into the module
- DO use consistent naming if multiple modules need similar functionality

#### 5.1 Database Communication

For database operations, use the existing DalService:
```
DiasRestApi/dotnet_version/src/Services/DalService.cs
```

The DalService communicates with DiasDalApi (see /DiasDalApi folder) and supports forwarding HTTP requests to the DAL layer.

**Database Operation Guidelines**:
- Inject `IDalService` via constructor injection
- Configure `DalConnection` with the appropriate connection settings
- Build `HttpRequestMessage` for the DAL operation
- Use `ForwardRequestAsync` to execute the request
- Document all data objects in docs/MODELS_USED.md
- Prefer DalService over external domain service calls when possible

**Example DalService usage:**
```csharp
public class MyEndpointController : BaseController
{
    private readonly IDalService _dalService;
    private readonly IDalConfigurationService _dalConfigService;

    public MyEndpointController(
        IDalService dalService,
        IDalConfigurationService dalConfigService,
        IErrorStatusMapper errorStatusMapper,
        ILogger<MyEndpointController> logger)
        : base(errorStatusMapper, logger)
    {
        _dalService = dalService;
        _dalConfigService = dalConfigService;
    }

    [HttpGet("/legacy/{repo}/{path}")]
    public async Task<IActionResult> Handle([FromRoute] string param)
    {
        var connection = await _dalConfigService.GetConnectionAsync("default");
        var request = new HttpRequestMessage(HttpMethod.Get, $"/api/{param}");
        var response = await _dalService.ForwardRequestAsync(request, connection);
        var content = await response.Content.ReadAsStringAsync();
        return Content(content, "application/json");
    }
}
```

#### 5.2 External Service Calls

**⛔ FORBIDDEN: Direct Domain Service Calls**

**NEVER** create direct SOAP/REST calls to domain services:
- ❌ landing-domain
- ❌ vessel-domain
- ❌ sales-domain
- ❌ Any other *-domain service

**ALWAYS** use DalService to communicate with DiasDalApi, which handles all domain service communication.

**Note:** This restriction applies ONLY to *-domain services. For non-domain integrations (third-party APIs, external systems), you MAY create direct calls in `ExternalServicesService.cs`.

**Why no direct domain calls?**
- DiasDalApi is already connected to all domain services
- DalService provides a unified interface
- Direct calls bypass logging, error handling, and connection management
- Direct calls create duplicate infrastructure

**Correct Pattern:**
```csharp
// ✅ CORRECT: Use DalService via constructor injection
private readonly IDalService _dalService;

var request = new HttpRequestMessage(HttpMethod.Get, "/api/landing/declaration");
var response = await _dalService.ForwardRequestAsync(request, connection);

// ❌ WRONG: Direct SOAP call - DO NOT DO THIS
var soapClient = new SoapClient("http://landing-domain/...");
var result = await soapClient.CallAsync("getLandingDeclaration", ...);
```

**If the legacy endpoint calls non-domain integration services:**
- Isolate external calls in `ExternalServicesService.cs`
- Document why DalService cannot be used
- These are rare exceptions (most data comes from domain services)

### Step 6: 1-to-1 Conversion Verification

The converted endpoint MUST match the legacy endpoint exactly:
- Same response structure
- Same status codes
- Same error messages
- Same business logic behavior
- Comparison testing will verify this

**Verification Approach**:
- Compare actual responses from legacy and converted endpoints
- Document any intentional differences in CONVERSION_SUMMARY.md
- Use the Type Mapping from Step 0 to ensure correct data types

The new HandlerController.cs should have the same comment header as the current notimplemented_handler_controller.cs and handle the same endpoint route.

### Step 7: Testing

Create comprehensive tests:
- **Unit tests**: In `DiasRestApi/dotnet_version/tests/DiasRestApi.UnitTests/Controllers/{repo}/{endpoint}/` for all business logic
- **Integration tests**: Optional, in `DiasRestApi/dotnet_version/tests/DiasRestApi.IntegrationTests/Controllers/` if needed
- **Comparison tests**: Verify 1-to-1 match with legacy endpoint

**Test Framework:** xUnit + Moq (as used in the existing test project). See `DiasRestApi.UnitTests.csproj`.

**Test Patterns:**
- Use `[Fact]` for single test cases, `[Theory]` with `[InlineData]` for parameterized tests
- Mock dependencies using `Moq` (`Mock<IDalService>`, etc.)
- Follow Arrange/Act/Assert pattern
- Set up `ControllerContext` with `DefaultHttpContext` when needed

**Example test:**
```csharp
public class MyEndpointControllerTests
{
    private readonly Mock<IDalService> _mockDalService;
    private readonly Mock<IErrorStatusMapper> _mockErrorMapper;

    public MyEndpointControllerTests()
    {
        _mockDalService = new Mock<IDalService>();
        _mockErrorMapper = new Mock<IErrorStatusMapper>();
    }

    [Fact]
    public async Task Handle_ValidInput_ReturnsOk()
    {
        // Arrange
        var response = new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("{\"data\": \"test\"}", Encoding.UTF8, "application/json")
        };
        _mockDalService.Setup(s => s.ForwardRequestAsync(It.IsAny<HttpRequestMessage>(), It.IsAny<DalConnection>()))
            .ReturnsAsync(response);
        // ... setup controller

        // Act
        var result = await controller.Handle("param");

        // Assert
        Assert.IsType<OkObjectResult>(result);
    }
}
```

#### Test Task Format in tasks.md

For test tasks, always include explicit scoped test command:
```markdown
- [ ] X.X Write unit test for [feature]
  - Run: `dotnet test DiasRestApi/dotnet_version/tests/DiasRestApi.UnitTests/ --filter "FullyQualifiedName~{TestClassName}"`
  - **Validates: Requirements X.X**
```

For checkpoint tasks, run FULL test suite:
```markdown
- [ ] X. Checkpoint - Ensure all tests pass
  - Run: `dotnet test DiasRestApi/dotnet_version/tests/` (FULL test suite)
  - Run: `dotnet build DiasRestApi/dotnet_version/src/`
  - Verify: All tests pass (0 failures)
  - Report results to user before continuing
```

**Rationale:** Running full test suite after every small change wastes time. Scoped tests during implementation, full suite at checkpoints.

### Step 8: Documentation

Update documentation in the docs/ folder:

- **ENDPOINT_SPEC.md** - Already exists from Phase 2.5, verify it's accurate and update if needed
- **CONVERSION_SUMMARY.md** - Document all conversion decisions in detail (for audit)
- **TEST_INSTRUCTIONS.md** - How to run unit, integration, and manual tests
- **MODELS_USED.md** - All models with field descriptions
- **SERVICES_USED.md** - All services with method signatures
- **README.md** - Overview and links to all documentation and spec files

Also create **specs/** folder with requirements.md, design.md, and tasks.md if SDD was used, or a brief `conversion-notes.md` summarizing the analysis from Steps 0-3 if direct implementation was chosen.

### Step 9: Completion

Final steps before marking conversion as complete:

**9.1 Archive Spec Files**
- If SDD was used: keep spec files in the controller module's `specs/` folder
- If direct implementation: keep `conversion-notes.md` in `specs/` folder
- Do NOT move them to workspace-level specs folder

**9.2 Update Endpoint Inventory**
- Update `endpoints-list.csv` with `conversion_status = "CONVERTED"`
- Verify the `dias_controller_path` is accurate

**9.3 Final Quality Check**
- [ ] Zero build errors (`dotnet build`)
- [ ] Explicit return types on all methods
- [ ] Proper namespaces following project conventions
- [ ] XML documentation on public members
- [ ] Nullable reference types handled correctly
- [ ] All tests passing (`dotnet test`)
- [ ] Documentation complete and accurate

**9.4 Comparison Test Sign-off**
- Verify converted endpoint responds identically to legacy
- Document any intentional differences in CONVERSION_SUMMARY.md

## Important Notes

### DO NOT Change Files Outside Controller Module
- Endpoint discovery is automatic in ASP.NET Core (controller auto-discovery)
- DAL connection is already configured
- No startup registration needed for controllers
- No manual route registration in other source files

### Maintain Living Documentation
- Keep documentation in sync with code changes
- Update `endpoints-list.csv` conversion_status to "CONVERTED" when complete
- Follow Documentation Protocol for all updates

## Documentation Requirements

**Per the Documentation Protocol**:

- All documentation created during conversion MUST be kept in sync with the code
- When the endpoint behavior changes, update ENDPOINT_SPEC.md and related documentation
- When models or services change, update MODELS_USED.md and SERVICES_USED.md
- The specification files (requirements.md, design.md, tasks.md) MUST be archived after completion, never deleted
- If the legacy endpoint is deprecated, mark it clearly in CONVERSION_SUMMARY.md with deprecation date

**Documentation Checklist**:
- [ ] ENDPOINT_SPEC.md verified and updated if needed (already exists from Phase 2.5)
- [ ] CONVERSION_SUMMARY.md documents all conversion decisions
- [ ] TEST_INSTRUCTIONS.md provides clear testing guidance
- [ ] MODELS_USED.md documents all data models
- [ ] SERVICES_USED.md documents all services
- [ ] README.md provides overview and links
- [ ] Spec files (requirements.md, design.md, tasks.md) or conversion-notes.md created
- [ ] All documentation follows markdown standards
- [ ] endpoints-list.csv updated with conversion_status = "CONVERTED"
