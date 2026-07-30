# roboshop-github-actions

We are going to create reusable workflow templates in this repository, which will be sourced by the application repositories.

# Keeping Workflow Code DRY

## Problem

As the number of pipelines grows, teams end up **copy-pasting the same jobs** (checkout, SAST scan, build, test, publish, deploy) into every workflow file. This leads to:

- Duplicated YAML across repositories
- Inconsistent behavior when one copy is updated but others are forgotten
- Harder maintenance and onboarding

## Solution: Reusable Workflows

GitHub Actions supports **Reusable Workflows**, which let you declare a workflow **once** and call it from as many other workflows as needed — in the same repo or across repositories.

> Declare the workflow once in a (optionally separate) repository, and source it into the workflows that need it.

### How it works

| Concept | Keyword | Purpose |
|---|---|---|
| Make a workflow callable | `on: workflow_call` | Marks a workflow as reusable so other workflows can invoke it |
| Call a reusable workflow | `uses:` | References the reusable workflow from a caller workflow |
| Pass data in | `inputs:` | Custom parameters the caller supplies |
| Pass secrets in | `secrets:` / `secrets: inherit` | Securely forwards secrets to the called workflow |
| Get data out | `outputs:` | Values the reusable workflow returns to the caller |

### Benefits

- ✅ Prevents copy-pasting the same job logic everywhere
- ✅ Single source of truth — fix or improve the pipeline in one place
- ✅ Accepts custom inputs per caller
- ✅ Securely inherits secrets without hardcoding them
- ✅ Can be shared across multiple repositories

---

## Example

### 1. The reusable workflow (callee)

`.github/workflows/reusable-build.yaml`

```yaml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      ARTIFACTORY_TOKEN:
        required: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build for ${{ inputs.environment }}
        run: echo "Building for ${{ inputs.environment }}"
      - name: Publish
        run: echo "Publishing using token"
        env:
          TOKEN: ${{ secrets.ARTIFACTORY_TOKEN }}
```

### 2. The caller workflow

```yaml
jobs:
  call-build:
    uses: my-org/shared-workflows/.github/workflows/reusable-build.yaml@main
    with:
      environment: dev
    secrets: inherit
```

---

## Workflow

```text
Caller Workflow
    │
    ▼
uses: reusable-build.yaml
    │
    ▼
Reusable Workflow Triggered
(workflow_call)
    │
    ▼
Inputs Received
    │
    ▼
Secrets Inherited
    │
    ▼
Jobs Executed
    │
    ▼
Outputs Returned to Caller
```

---

## Reference

For the official syntax and patterns, see GitHub's documentation on [Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
