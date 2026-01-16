# Repository Guidelines

## Project Structure & Module Organization

- `modules/wif/`: Terraform module for Google Cloud Workload Identity Federation (AWS IAM + GitHub Actions OIDC). Key files: `main.tf` (resources), `variables.tf` (inputs/validation), `outputs.tf`, `provider.tf`, `version.tf`.
- `.github/workflows/ci.yml`: Reusable CI jobs that run Terraform lint/scan and handle dependency PRs (Dependabot/Renovate) against `modules/wif`.
- `README.md`: Setup walkthrough (env vars, `gcloud infra-manager` previews/deployments). Create your own `envs/<env>/terraform.tfvars` locally; the directory is intentionally untracked.

## Build, Test, and Development Commands

- `terraform fmt -recursive`: Standardize HCL formatting (CI enforces). Run at repo root.
- `terraform init` then `terraform validate` inside `modules/wif/`: Prep providers/backends and verify syntax before planning.
- `terraform plan -var-file=envs/<env>/terraform.tfvars -out plan.tfplan`: Produce a plan; keep var files outside version control.
- `terraform apply plan.tfplan`: Apply the reviewed plan.
- CI mirror: `CI/CD` workflow runs lint-and-scan via shared actions (fmt, validate, static analysis) and manages lock-file upgrades for bot PRs.

## Coding Style & Naming Conventions

- HCL style: 2-space indents, block arguments aligned by key, lists trailing commas optional but keep one item per line for clarity.
- Inputs/locals in `snake_case`; resource IDs use interpolated kebab-case patterns such as `${var.system_name}-${var.env_type}-wif-...` to keep names deterministic across clouds.
- Keep variable validations in `variables.tf` and defaults minimal; add comments only where intent is non-obvious.

## Testing Guidelines

- Minimum local checks before PR: `terraform fmt -recursive`, `terraform validate`, and a `terraform plan` against a sample `envs/<env>/terraform.tfvars` matching the change scope (AWS, GitHub, or storage).
- When altering IAM conditions or bucket policies, verify expected attributes appear in the plan (e.g., `attribute.aws_iam_role`, `retention_policy`). Include notable diff snippets in the PR description.

## Commit & Pull Request Guidelines

- Commits: short, imperative subjects; optional scope like `module(wif): ...`; reference issue/PR when applicable (e.g., `(#10)`). Keep logically separate changes in separate commits.
- PRs: explain intent and impact, link related issues, and paste outputs for `terraform validate` and the latest `plan`. Note any manual steps (API enablement, service account creation) required for reviewers.
- CI must be green. Bot PRs (Dependabot/Renovate) auto-upgrade lock files; avoid rebasing them unless necessary.

## Security & Configuration Tips

- Do not commit credentials or `terraform.tfvars`; use environment variables or a secure secrets manager.
- Enable required Google APIs and least-privilege service accounts as shown in `README.md`. Keep bucket policies restrictive (`uniform_bucket_level_access = true`, public access prevention enforced).

## Code Design Principles

Follow Robert C. Martin's SOLID and Clean Code principles:

### SOLID Principles

1. **SRP (Single Responsibility)**: One reason to change per class; separate concerns (e.g., storage vs formatting vs calculation)
2. **OCP (Open/Closed)**: Open for extension, closed for modification; use polymorphism over if/else chains
3. **LSP (Liskov Substitution)**: Subtypes must be substitutable for base types without breaking expectations
4. **ISP (Interface Segregation)**: Many specific interfaces over one general; no forced unused dependencies
5. **DIP (Dependency Inversion)**: Depend on abstractions, not concretions; inject dependencies

### Clean Code Practices

- **Naming**: Intention-revealing, pronounceable, searchable names (`daysSinceLastUpdate` not `d`)
- **Functions**: Small, single-task, verb names, 0-3 args, extract complex logic
- **Classes**: Follow SRP, high cohesion, descriptive names
- **Error Handling**: Exceptions over error codes, no null returns, provide context, try-catch-finally first
- **Testing**: TDD, one assertion/test, FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely), Arrange-Act-Assert pattern
- **Code Organization**: Variables near usage, instance vars at top, public then private functions, conceptual affinity
- **Comments**: Self-documenting code preferred, explain "why" not "what", delete commented code
- **Formatting**: Consistent, vertical separation, 88-char limit, team rules override preferences
- **General**: DRY, KISS, YAGNI, Boy Scout Rule, fail fast

## Development Methodology

Follow Martin Fowler's Refactoring, Kent Beck's Tidy Code, and t_wada's TDD principles:

### Core Philosophy

- **Small, safe changes**: Tiny, reversible, testable modifications
- **Separate concerns**: Never mix features with refactoring
- **Test-driven**: Tests provide safety and drive design
- **Economic**: Only refactor when it aids immediate work

### TDD Cycle

1. **Red** → Write failing test
2. **Green** → Minimum code to pass
3. **Refactor** → Clean without changing behavior
4. **Commit** → Separate commits for features vs refactoring

### Practices

- **Before**: Create TODOs, ensure coverage, identify code smells
- **During**: Test-first, small steps, frequent tests, two hats rule
- **Refactoring**: Extract function/variable, rename, guard clauses, remove dead code, normalize symmetries
- **TDD Strategies**: Fake it, obvious implementation, triangulation

### When to Apply

- Rule of Three (3rd duplication)
- Preparatory (before features)
- Comprehension (as understanding grows)
- Opportunistic (daily improvements)

### Key Rules

- One assertion per test
- Separate refactoring commits
- Delete redundant tests
- Human-readable code first

> "Make the change easy, then make the easy change." - Kent Beck
