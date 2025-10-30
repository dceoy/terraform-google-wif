# Repository Guidelines

## Project Structure & Module Organization

Terraform modules live under `modules/<module-name>`; keep each module self-contained with its own `main.tf`, `variables.tf`, `outputs.tf`, and `README.md`. End-to-end integration samples belong in `examples/`, mirroring real workloads to validate Workload Identity Federation (WIF) setups. Store reusable Terratest helpers and fixtures in `test/` to keep module directories Terraform-only. Automation and release workflows reside in `.github/workflows`, so update YAML there when pipelines need new checks.

## Build, Test, and Development Commands

Run `terraform fmt -recursive` before every commit to keep HCL formatting consistent. Use `terraform validate modules/<module-name>` to catch schema or reference issues early. Run `terraform plan -var-file=env/dev.tfvars` from the relevant example to confirm behavioral changes. Execute `go test ./test/...` to run Terratest suites; set `TF_VAR_project_id` and other Google Cloud settings via your environment before invoking the tests.

## Coding Style & Naming Conventions

Follow Terraform's two-space indentation and sorted block attribute style enforced by `terraform fmt`. Name resources with concise snake_case (`google_iam_workload_identity_pool.pool`) and align module outputs with the Google Cloud concept they expose. Keep variables lower_snake_case with descriptive names such as `provider_sa_email`. Default values should stay in `variables.tf`, and avoid hard-coding project IDs inside modules.

## Testing Guidelines

Add Terratest cases for every new module path under `test/`, mirroring the example name (`TestPoolWorkload` for `examples/pool`). Prefer table-driven tests when checking multiple parameter combinations. Provide fixture-specific cleanup to delete pools and providers after assertions complete. Record test evidence in the PR by pasting the `go test` summary and `terraform plan` diff for the examples that changed.

## Commit & Pull Request Guidelines

Write commit subjects in the imperative mood with an optional scope, e.g. `module(pool): add oidc provider output`. Group related Terraform and Terratest changes in the same commit to keep history reviewable. Pull requests should describe the motivation, link any tracking issue, and list affected modules or examples. Always attach the latest `terraform plan` output and `go test` results in the PR description. Request at least one review from a maintainer familiar with Google Cloud IAM before merging.

## Security & Configuration Tips

Never commit service account keys or JSON credentials; rely on ADC or Vault-backed providers instead. When updating examples, scope identities to minimal roles and document required IAM bindings. Review `.github/workflows` for secrets usage whenever changing test or release automation to avoid leaking sensitive values.

## Serena MCP Usage (Prioritize When Available)

- **If Serena MCP is available, use it first.** Treat Serena MCP tools as the primary interface over local commands or ad-hoc scripts.
- **Glance at the Serena MCP docs/help before calling a tool** to confirm tool names, required args, and limits.
- **Use the MCP-exposed tools for supported actions** (e.g., reading/writing files, running tasks, fetching data) instead of re-implementing workflows.
- **Never hardcode secrets.** Reference environment variables or the MCP’s configured credential store; avoid printing tokens or sensitive paths.
- **If Serena MCP isn’t enabled or lacks a needed capability, say so and propose a safe fallback.** Mention enabling it via `.mcp.json` when relevant.
- **Be explicit and reproducible.** Name the exact MCP tool and arguments you intend to use in your steps.

## Web Search Instructions

For tasks requiring web search, always use Gemini CLI (`gemini` command) instead of the built-in web search tools.
Gemini CLI is an AI workflow tool that provides reliable web search capabilities.

### Usage

```sh
# Basic search query
gemini --sandbox --prompt "WebSearch: <query>"

# Example: Search for latest news
gemini --sandbox --prompt "WebSearch: What are the latest developments in AI?"
```

### Policy

When users request information that requires web search:

1. Use `gemini --sandbox --prompt` command via terminal
2. Parse and present the Gemini response appropriately

This ensures consistent and reliable web search results through the Gemini API.

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
