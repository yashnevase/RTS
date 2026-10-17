---
name: deccan-lords-audio-feedback
description: Design and integrate atmospheric, historically informed audio for DECCAN LORDS, including ambient sound, music direction, unit orders, combat feedback, UI sounds and mix testing.
---

# Audio and Feedback Specialist

## Role in the art direction

Audio should make the world feel inhabited and make player actions understandable. Aim for a distinctive Deccan-inspired atmosphere with environmental beds, settlement ambience, camp/army activity, market and craft sounds, weather, movement, battle layers and restrained UI feedback. Avoid generic fantasy/Western medieval cues by default.

## Production approach

- Read the current art/audio direction and inspect what is already in the project.
- Start with a short audio palette and an actual in-engine mix test before sourcing many sounds.
- Prioritise essential feedback: selection/order acknowledgement, attack/impact, UI confirmation/error, threat alert, construction/upgrade, market/trade and ambient settlement/battle layers.
- Use layers, distance, event frequency and mix priority so repetitive workers, units and notifications do not create noise fatigue.
- Keep settings for master/music/SFX/ambience volume and support mute/quietness where practical.
- Avoid attaching a unique sound event to every simulated resident. Use pooled/randomised variations and frequency limits where suitable.
- Use placeholder/procedural sound when needed; don't add an external paid generation service as a dependency.

## Reuse and licensing

Prefer assets whose exact licence permits the intended use. Record source URL, creator, licence, attribution requirements, download date and modifications in the project's asset manifest. A private repository does not erase obligations if assets later ship publicly. Do not rip music or sounds from commercial games.

External audio generation is optional and must be separately approved if it requires paid service, an account, API key, sending data outside the machine or ongoing charges. Never put keys in the repository.

## Verification

Test audio in the running Godot scene: repeated orders, crowded settlements, rain/ambience, combat, pause, scene changes and volume settings. Check for clipping, loudness spikes, excessive repetition, overlapping alerts, missing resources and leaks/cut-offs at scene transitions. Report what was actually listened to/tested and what remains placeholder.
