# ChatGPT + VS Code + Codex workflow

This file explains how to make this discussion and the local repository work together. There is no automatic magical sync between an ordinary ChatGPT chat and an arbitrary local VS Code folder; use Git and canonical Markdown as the bridge.

## Recommended division of work

- **This ChatGPT conversation:** design partner, research, trade-offs, reviewing the game's identity, turning your explanation into explicit rules, and identifying open questions.
- **Game Bible Markdown:** durable project memory and source of truth. Store agreed decisions here; record proposals as proposals until confirmed.
- **Codex IDE extension in VS Code:** reads and edits your local repository, works on code/docs, runs approved commands and tests, and reviews diffs. Sign in with the same ChatGPT account; usage limits still apply.
- **GitHub:** backup/version history and bridge between local files and ChatGPT's GitHub connection when available.
- **Local LLM via Ollama:** optional helper for repetitive data generation, test-case drafts, documentation and low-risk utility work. Do not trust its code or install commands without review.

## Setup sequence on the Mac

1. Clone the private `yashnevase/RTS-Docs` repository locally and commit design changes in small, reviewable steps.
2. Install Git, stable Godot, Blender LTS, and either the ChatGPT desktop app with Codex mode or the Codex IDE extension/CLI. Open the local repository as the workspace.
3. Sign in to Codex with the intended ChatGPT Plus account. If you want a local model inside ChatGPT Desktop's Codex mode, follow Ollama's ChatGPT integration guide and check its required Ollama version. This does not switch ordinary ChatGPT Chat/voice to local inference; only model requests routed through Ollama use the selected Ollama model. Guide: https://docs.ollama.com/integrations/chatgpt. Also test Codex with its native model as a fallback.
4. First make the smallest Godot project import and run a smoke test from the terminal. Then test Blender export/import with one small `.glb` asset and build a basic visual benchmark. Do not install an MCP server before the basic loop works.
5. Keep `AGENTS.md` at repository root so Codex reads project rules. At the start of a task, ask it to read `PROJECT_CONTEXT.md`, the Game Bible README, the relevant system page, open questions and decision log.
6. At the end of a design discussion, ask for a short **design sync summary**: confirmed decisions, proposals still open, assumptions, research to verify and Markdown sections that should change. Review the diff and commit only accepted changes.
7. Optionally configure the OpenAI Developer Docs MCP if you often need current OpenAI/Codex documentation. It is read-only and can be added using `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`; verify with `codex mcp list`. Documentation: https://developers.openai.com/learn/docs-mcp.
8. After the first Godot scene runs reliably, evaluate one Godot MCP only if scene inspection, test execution or debugging improves enough to justify the added dependency. Start with minimum permissions and require approval for destructive operations. More tools do not automatically mean better results.

## DECCAN LORDS one-milestone execution

Once the Godot project exists and the local skills are installed, start an implementation task with `deccan-lords-director` and request only the named milestone. The director should load relevant specialists rather than require the user to invoke each role manually.

Use the model/effort table in `DECCAN_LORDS_GAME_BIBLE/design/18_game_format_and_ai_production_pipeline.md`: strongest available model at High for architecture/hard bugs, balanced coding model at Medium for scoped implementation, efficient/local model at Low/Medium for repetitive support work. Reserve Extra High/xhigh for exceptional cross-system audits rather than routine changes.

Each milestone must end with exact tests/checks, screenshot or log evidence where relevant, diff summary, known gaps and one next step. Passing tests does not mean a feature is automatically visually polished or fun.

## Design sync message template

Copy this into Codex after a design discussion:

> Read `AGENTS.md` and `PROJECT_CONTEXT.md`. Update only the relevant canonical Game Bible Markdown files with the design summary I provide. Do not invent missing rules. Keep all ideas marked PROPOSED or OPEN unless explicitly confirmed. Update `design/12_decision_log.md` and `CHANGELOG.md` when appropriate. Preserve history, repair relative links if needed, show a diff summary, and do not change gameplay code. Then list the remaining decisions.

## Implementation task template

> Read `AGENTS.md`, `PROJECT_CONTEXT.md`, and the relevant Game Bible pages. Implement only this vertical slice: [specific feature]. Acceptance criteria: [observable results]. Do not add unapproved systems. Work on a branch, keep changes small, run the relevant Godot parse/import/headless tests, capture a screenshot if visual behavior changed, inspect your diff, and report exact tests/results plus remaining risks. Do not claim tests passed unless they actually ran.

## Token/usage discipline

- Ask for one well-scoped feature per implementation task, not “build the whole game.”
- Keep current architecture and relevant system specs concise and linked; do not paste the entire bible into every prompt.
- Use local models for low-risk drafts and data. Use Codex for integrated edits and the strongest available model/effort for architecture, systemic bugs, and final reviews.
- Build repeatable scripts/tests once and reuse them. Automate import/parse checks, deterministic simulation tests and screenshot capture before increasing tool complexity.
- ChatGPT Plus/Codex allowances are limited and can vary by plan, model, context and task complexity. Local LLMs help reduce some usage but aren't a guarantee of equivalent code quality.

## Security and asset hygiene

- Never store API keys, passwords or personal secrets in the repository or prompts.
- Review commands that delete files, alter system settings, install packages or access network services.
- Check each asset's licence, attribution, commercial use and redistribution rights; keep a `CREDITS_AND_LICENSES.md` as assets are added.
- Commit before large AI changes and review the diff before accepting it.
