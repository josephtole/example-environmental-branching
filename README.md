# example-environmental-branching

This repo is designed to demonstrate how to use environmental branching in a continuous delivery pipeline.

This repo demonstrates several things:
- The current branch that matches an environment represents the currently deployed code
- Ensures the same code is deployed to all environments
  - Any changes required to an environment must be parameterized
- The latest build for an environment is deployed but in a way that pins the version for future reference
- PR's can be used to ensure all requirements are met (testing, approvals, etc)
- More to come...

## Configuration

- This repo is meant to be portable and requires minimal configuration
- You will need to change the default branch to branch you want to use for prod / stable / final
- You will need to create branch protections for all environments branches
- All protected branches are built (regardless of name)
- The default branch is used to deploy to the prod / stable / final environment (regardless of branch name)
- There is a ordering check done to ensure that branches are not deployed out of order
  - This is defined in `scripts/cd/branch-ordering.txt`
  - Each line is a branch / environment name
  - They should be placed in the order that they should be PR'd to.
    - As an example, if the file contains 3 lines, in order, that read `dev`, `staging`, and `prod` and someone tries to do a PR from `dev` to `prod` than it will fail. If they try to do a PR from `dev` to `staging` or `staging` to `prod` than it will succeed.
- Under `Actions` -> `General` you will need to enable `Read and write permissions` under **Workflow permissions**
- You may get a `Error: buildx failed with: ERROR: denied: permission_denied: write_package` error when running the **CD** pipeline
  1. Go to the user / org home page and click on `packages`
  2. Click on the pache for which you are getting the error
  3. On the bottom pr ricght sidebar, click on the `Package settings` option
  4. Om the `Maanage Actions access` section, click on `Add Repository`
  5. Select the repository and select `Add Repository`
  6. Once added, next to the repo name, change the role to `Write`
