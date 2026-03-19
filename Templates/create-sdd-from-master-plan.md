Create a new SDD Spec Implementation run for executing the master plan located here:

<link to master plan here>

Before you do, fetch all repos and pull to ensure we are up2date.

Create the SDD specs in the relevant project(s) DiasAdminUI, DiasRestApi, DiasDalApi as requirements.md, design.md and tasks.md. Assume that I auto approve the requirements and design docs and do the tasks.md with ALL tasks required.

Make sure you analyze the code and the current implemetation before you create the specs. 

For bugs make sure first task is always: Root Cause Analysis and Code Review, in which we also need to determine it bug is existing at all and how find out how we can reproduce it locally

Also, for bug only create tests relevant to the issue, and please ensure that we do not log something excessive that will make it impossible to parse the logs.