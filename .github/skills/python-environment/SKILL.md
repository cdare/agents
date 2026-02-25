---
name: python-environment
description: "Use when setting up Python virtual environments for Poetry projects. Extracts Python version from Dockerfile (if present) or pyproject.toml. Triggers on: 'use python-environment mode', 'python environment', 'setup python', 'setup virtualenv', 'pyenv setup', 'install poetry', 'python dev environment'. Requires pyproject.toml to exist. Full access mode - runs shell commands to create environments and install packages."
---

# Python Environment Mode

Set up a pyenv virtualenv with the correct Python version for Poetry projects.

## Process

### Step 1: Check for Existing Environment

If there is no `pyproject.toml` file in the project root, **stop here** — this skill only applies to Poetry projects.

Check if a `.python-version` file already exists in the project root.

```bash
cat .python-version
```

- If the file exists and contains a virtualenv name, the environment is already configured — **stop here**.
- If the file does not exist or is empty, proceed to Step 2.

### Step 2: Determine Python Version

Check for a Dockerfile first. If present, extract versions from it. If not, use pyproject.toml.

#### Option A: Dockerfile Exists

Find the Dockerfile in the project and extract the Python and Poetry versions.

**Python version**: Look for patterns like:

- `FROM python:3.x.x`
- `ARG PYTHON_VERSION=3.x.x`
- `ENV PYTHON_VERSION=3.x.x`
- `pyenv install 3.x.x`

**Poetry version**: Look for patterns like:

- `ARG POETRY_VERSION=x.x.x`
- `ENV POETRY_VERSION=x.x.x`
- `pip install poetry==x.x.x`
- `pipx install poetry==x.x.x`
- `POETRY_VERSION=x.x.x`

Extract both values and store them for use in subsequent steps.

#### Option B: No Dockerfile — Use pyproject.toml

Extract the Python version from `pyproject.toml`. Look for patterns like:

```toml
[tool.poetry.dependencies]
python = "^3.11"
python = ">=3.10,<3.13"
python = "~3.12.0"
```

**Version interpretation:**

- `^3.11` → Use `3.11` (latest patch of that minor version)
- `>=3.10,<3.13` → Use `3.12` (latest allowed minor version)
- `~3.12.0` → Use `3.12.0` (respect the patch if specified)
- `3.11.4` → Use `3.11.4` exactly

When no Dockerfile exists, **use system Poetry** — do not install Poetry into the virtualenv. Skip Step 6 and use `poetry` directly.

### Step 3: Create the Virtual Environment

Use `pyenv virtualenv` to create a new virtual environment. The name **must** match the parent folder of the project (i.e., the basename of the project root).

```bash
# Get the project folder name
PROJECT_NAME=$(basename "$PWD")

# Create the virtualenv with the extracted Python version
pyenv virtualenv <PYTHON_VERSION> "$PROJECT_NAME"
```

If the Python version is not installed in pyenv, install it first:

```bash
pyenv install <PYTHON_VERSION>
```

### Step 4: Set as Local Version

```bash
pyenv local "$PROJECT_NAME"
```

This writes the virtualenv name to `.python-version` in the project root.

### Step 5: Activate and Verify

Check that the new environment is active:

```bash
pyenv version
```

If the output does not show the expected virtualenv name, activate it explicitly:

```bash
pyenv activate "$PROJECT_NAME"
```

Verify activation:

```bash
which python
# Should contain the virtualenv name in the path
```

### Step 6: Install Poetry (Dockerfile path only)

**Skip this step if no Dockerfile was found** — use system Poetry instead.

Install the exact Poetry version extracted from the Dockerfile. **Use the pip from the virtual environment** to ensure Poetry is installed into the correct env.

```bash
# Ensure we're using the virtualenv's pip
which pip
# Should point to ~/.pyenv/versions/<PROJECT_NAME>/bin/pip

pip install poetry==<POETRY_VERSION>
```

Verify the installation:

```bash
poetry --version
```

### Step 7: Install Dependencies

```bash
poetry install
```

## Important Notes

- **Dockerfile path**: Use exact versions from Dockerfile — do not upgrade or default to latest. Do not specify a patch version if the Dockerfile does not include one.
- **pyproject.toml path**: Use system Poetry. Interpret version constraints to pick the most recent allowed minor version.
- The virtualenv name must match the **parent folder name** of the project.
- Confirm `which pip` points to the virtualenv before installing Poetry — installing into the wrong environment is the most common mistake.
- If any step fails, stop and report the error rather than continuing with a broken environment.
