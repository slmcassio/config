# Knowledge Base

A living knowledge base that evolves through conversations. It captures business domain understanding, technical architecture, and operational knowledge — specific to your environment.

**This file lives in `config-private/`** — it is never committed to the public repo. Only the example structure is public.

**Start here**: [Glossary — Master Index](domain/glossary/index.md) — the first place to look when you encounter an unknown term. Links to all internal docs, repos, and tools.

## Structure

### `domain/` — Business Domain (the "what" and "why")
- **glossary/** — **Master Index** — look up any term and find links to knowledge docs, repos, and tools
- **processes/** — Business flows, rules, and workflows
- **decisions/** — Business decisions and their rationale (BD-NNN)
- **context-maps/** — Bounded contexts and domain relationships

### `architecture/` — Technical (the "how")
- **services/** — Service catalog, ownership, and responsibilities
- **patterns/** — Design patterns and conventions in use
- **decisions/** — Architecture Decision Records (ADR-NNN)
- **data-flows/** — Integrations, data pipelines, and system interactions

### `operations/` — Operational Knowledge
- **runbooks/** — Incident response procedures
- **infrastructure/** — Infrastructure topology and configurations

## Conventions

- All content in **English**
- Files use **kebab-case** naming (e.g., `payment-service.md`)
- Decision records are numbered sequentially (BD-001, ADR-001)
- Cross-references use relative links between documents
- Each file should have a clear title and a "Last updated" date
- Keep files focused — one concept per file, link to related docs

## Domains

| Domain | Status | Entry Point |
|--------|--------|-------------|
| _(add your domains here)_ | — | — |
