# Bannerlord reference review

Reviewed 7 November 2026.

## Resources and implications

- [BUTR](https://github.com/BUTR) collects tooling and mods. Its ecosystem is useful for studying command boundaries, diagnostics and configuration.
- [Bannerlord.GABS](https://github.com/BUTR/Bannerlord.GABS) is MIT licensed. Its [getting started guide](https://github.com/BUTR/Bannerlord.GABS/blob/master/docs/gameplay/getting-started.md) documents travel completion, interruptions, dialogue state and explicit trade confirmation. Its [setup guide](https://github.com/BUTR/Bannerlord.GABS/blob/master/docs/setup-guide.md) requires Bannerlord and a bridge. Our commands and acceptance tests can follow similar observable workflows.
- [GABS UI notes](https://github.com/BUTR/Bannerlord.GABS/blob/master/docs/gauntlet-ui.md) describe screen, layer and view-model responsibilities. Our map, modal panels and authoritative commands already have corresponding boundaries. A later polish pass should centralize panel focus and command availability.
- [GABS barter notes](https://github.com/BUTR/Bannerlord.GABS/blob/master/docs/barter-system.md) describe offers with explicit accept and cancel. Our existing draft trade system fits this principle.
- [BannerlordSage](https://github.com/hby7921/BannerlordSage) is MIT licensed. Its README describes a local-installation index, including SQLite and decompiled binaries. SQLite serves retrieval there. It is not evidence that SQL is necessary for campaign simulation.
- [YellToInspire](https://github.com/BUTR/Bannerlord.YellToInspire/blob/dev/README.md) explains shared state with separate AI and player interactions. Its repository metadata did not identify a licence. We used the architectural discussion only.
- [The linked video](https://youtu.be/knc0Y78hh6c) is titled “Decompiling Binaries and Viewing Source Code”. Only metadata was accessible. Full playback and transcript were unavailable.
- [Nexus mod 688](https://www.nexusmods.com/mountandblade2bannerlord/mods/688) returned HTTP 403. Search references identify Improved Garrisons, but the current primary description and reuse permissions remain unverified.

No external implementation code or assets were copied.

## Changes shipped

Companion parties now buy provisions when stopped in markets. They reconsider a destination at most every 12 game hours. The pure planner prioritizes reachable and affordable food during shortage. Otherwise it scores patrol destinations from home preference, ambition, local relations and travel duration. The Clan screen displays the decision reason.

Party troops are paid from the party purse. The clan pays its companions and transfers their monthly party allowance. Party wage debt remains visible. This corrects the earlier duplication where the clan paid troop wages while parties also deducted them. Recall still overrides autonomous destination selection.

The initial planner is a bounded campaign feature. Aggression, generosity and personality-driven combat or diplomacy remain future work. Next priorities are contextual encounter options, escort contracts and garrison staffing limits.

Build and 54 tests passed. Data validation reported zero errors and two existing Panhala warnings. Chrome verified clan display, detachment creation/rendering, recall/merge, troop refunds and save restore.
