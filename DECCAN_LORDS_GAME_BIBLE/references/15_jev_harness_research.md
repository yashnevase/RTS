# 15 — Research note: Jev decision models and agent harnesses

**Reviewed:** 2026-10-16  
**Status:** RESEARCH — useful candidate, not adopted  
**Purpose:** Decide whether Jev should be used in DECCAN LORDS development or runtime gameplay.

## Executive recommendation

**Do not add Jev to the game engine or the current Codex/Godot setup yet.** Keep it as an option for a later, measured experiment in the AI-assisted development pipeline. Do not make any feature, safety gate or coding workflow depend on it before we have evidence that it improves our actual tasks.

This is a research note, not an adoption decision.

## What Jev is

Jev is TypeSafe AI's "System One" decision model. It is designed for bounded, structured judgments rather than open-ended text generation. The official LangChain integration exposes three decision primitives:

- **Noul:** a yes/no answer represented by a probability.
- **Choice:** select from a specified set of options, with probabilities/confidence.
- **Score:** assign a result to a defined scale or set of levels.

LangChain's experimental agent middleware demonstrates two control points:
- **ModelRouterMiddleware:** selects among configured models for a run.
- **AutoModeMiddleware:** classifies whether a tool call appears too risky and may block it.

The broad pattern is: use a decision model for a narrow judgment, and let ordinary code enforce the resulting workflow. Jev does not write GDScript, design a game, replace a planning algorithm, or automatically improve an agent merely by being installed.

## Performance claims and evidence limits

TypeSafe and LangChain public materials advertise maxima of approximately 200x faster and 400x cheaper than comparable LLMs on certain classification/decision tasks. These are vendor-reported task-specific comparisons, not a prediction that complete game development or a coding agent will become 200–400x faster or cheaper.

A Jev decision adds a service call, integration work, prompt/question design, thresholds, error handling and evaluation. Any real saving depends on what it replaces. It is most plausible when many repeated bounded decisions would otherwise call a general LLM.

The official LangChain middleware package is marked experimental and its APIs may change. At the time of this review, the official integration requires a TypeSafe API key and uses a hosted API. It is not automatically included in a ChatGPT Plus subscription, and it is not a drop-in switch for Codex in VS Code. Using it in our coding workflow would require a separate adapter/harness or a compatible tool integration.

## Is it appropriate for the shipped game?

**Not as the core CPU-lord or battle AI.**

DECCAN LORDS needs CPU decisions to be grounded in explicit game state: resources, army strength, supply, terrain, goals, relationships, information, treaties and political consequences. These decisions must be explainable, testable, tunable, and reproducible for debugging and any future competitive multiplayer.

The core runtime should therefore use normal game algorithms and code: valid-action filtering, utility scoring, state machines/behavior trees, planning where useful, game-rule checks and controlled/seeded randomness. This is the right fit for the reusable simulation engine the user wants.

Calling a hosted Jev API for a lord's runtime action would create an external service dependency, latency, possible outages, recurring usage cost and an online requirement. It would also complicate deterministic replay and fair multiplayer. We should not introduce this merely because the tool is trending.

A decision model could be revisited for offline development tooling—for example, categorizing playtest traces, triaging logs, routing a task to a more suitable model, or screening large volumes of test results. It should only be used where those are genuine repeated classification tasks, and should not replace exact assertions or permission checks.

## Is it useful for Codex/Godot development?

**Possibly, but not yet.** Jev's LangChain code examples build a LangChain agent; our intended workflow is Codex in VS Code, Godot, Git, and an optional local model (such as one served by Ollama). These are different integration surfaces.

Potential candidates for a future experiment:
- Route repetitive, well-defined support tasks to an inexpensive/local model and complex tasks to the stronger coding agent.
- Classify test/playtest results into known categories before a human or stronger model reviews them.
- Prioritize logs or reports for triage.
- Use a relevance classifier to filter very large tool outputs only if we retain access to the raw outputs and prove it does not hide needed evidence.

Do not use a probabilistic classifier as the sole security authority. Explicit command allowlists, file/path restrictions, approvals for destructive actions, secret isolation, audit logs and tests must remain deterministic. A classifier can assist; it cannot prove an action is safe.

## Independent warning against adopting by hype

One public community experiment that filtered coding-agent tool output through Jev reported an earlier small 30-task experiment with promising results, but its later 49-pair Terminal-Bench follow-up did not justify default adoption: its Jev-enabled arm passed fewer tasks and used more cumulative input tokens and estimated model cost. This is one particular implementation and benchmark, not proof that Jev generally fails. It is, however, evidence that savings must be measured end-to-end rather than inferred from classifier latency alone.

Another community coding-agent Jev harness explicitly labels itself early-stage and says it has not measured live classification accuracy; its offline tests validate plumbing and thresholds, not the Jev judgment. Treat such projects as experiments, not hardened safety infrastructure.

## Our adoption gate if we revisit it

Before adding Jev:
1. Identify a real repeated decision in our workflow and define the expected benefit.
2. Build a fixed, representative sample of at least 20–30 tasks or decisions, with expected outcomes.
3. Run an A/B comparison: existing workflow versus Jev-assisted workflow.
4. Measure total completion time, total model/API cost (including Jev), task acceptance/test pass rate, incorrect routing/filtering, human corrections and regressions.
5. Inspect failure cases, keep original evidence accessible, and retain a simple off switch/fallback.
6. Adopt only if there is a repeatable net improvement without lowering quality or weakening safety.

## Decision for now

- **Game runtime:** not adopted; use explicit simulation algorithms.
- **Current Codex workflow:** not adopted; first establish the basic Git/Godot/test pipeline.
- **Future development tooling:** keep as a research candidate and run an A/B benchmark only if repeated classification/routing overhead becomes a measured bottleneck.

## Sources

- [LangChain — Building a Harness with Jev (17 Sep 2026)](https://www.langchain.com/blog/building-a-harness-with-jev)
- [LangChain — TypeSafe integration documentation](https://docs.langchain.com/oss/python/integrations/providers/typesafe)
- [TypeSafe — Introducing System One Models & Jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev)
- [TypeSafe API documentation](https://api.typesafe.ai/docs)
- [LangChain — Building Production Agents with Jev and LangGraph (25 Sep 2026)](https://www.langchain.com/blog/building-prod-with-jev-and-langgraph)
- [Community Jev coding-agent filter experiment and follow-up results](https://github.com/Astro-Han/jev-harness)
- [Early community Jev decision-gate harness (discloses lack of measured live accuracy)](https://github.com/yfe404/jev-harness)
