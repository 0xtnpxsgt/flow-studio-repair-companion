# Repair v1.10.0 - learning from this PC's own fixes

- When a **repaired** prompt then generates, the extension tells the companion (`outcome` message). The companion records it in `repair-history/outcomes.jsonl` (hashes only, no prompt text).
- On a new refusal, up to 3 of those **confirmed** fixes are sent to the model as PAST FIXES - only fixes whose removed words also appear in the new prompt (e.g. "gamot" removed, "pagkain" added, and the dialogue change). Fixes that were never confirmed by a successful generation are never used as lessons.
- Everything stays on the user's PC. Learning starts from the first confirmed fix after this update (older history has no recorded outcome).
- Tests: `node --test tests/learning.test.cjs`.

# Repair v1.10.1 — Retry and Stop safeguards

Retry after a missing or failed companion repairs the unchanged refused prompt before generation. A manual prompt edit bypasses the stale repair flag; disabled repair proceeds normally without a requeue loop. Stop during the busy-helper wait prevents another request. Limit exhaustion and manual-revision responses remain manual stops. Five regression tests cover these paths in `tests/repair-retry-stop.test.cjs`.

Learning records stay on the user's PC. Selected past-fix excerpts are sent to the AI provider through AGY when repairing a later prompt.

# Repair v1.9.0 - the community [Scene] prompt format

The repair now recognises the common `[Scene] / [Duration] / [Style] / [Characters] / [Setting] / [Multi-Camera Shot Sequence] / [Dialogue & Audio] / [Constraints]` format and protects its structure:

- **Locked:** the [Scene] and [Duration] lines; every character line under [Characters] (face, age, wardrobe, voice); every `NAME camera LEFT/RIGHT/CENTER` pairing; every Shot header's number, time window, shot size and lens; every `Line N — t to t, inside Shot K: NAME` number, timecodes, shot and speaker; the Lip-Sync line; all [Section] headers in order; resolution, aspect ratio and render style in [Style]; every timecode anywhere. [Constraints] may only lose a word that is itself a likely trigger.
- **Allowed to change:** the quoted words of each Line (at most four words per line, same language and speaker), the delivery wording inside a Line, the action and camera-move text of each Shot, the [Setting] mood, Background Audio, and the [Style] grade wording.
- The speaker of each Line is read from its name (MIKA, NOAH), not from the voice wording, so softening "bubbly Tagalog voice" is allowed. Quotes inside [Section] label lines (like `"scene_number"`) are not treated as spoken lines.
- The model is told the locked parts of the format it is repairing (this format, DramaFactory's, or a strict general rule set for anything else).
- New refusal suspect `people_on_screen` (faces shown on a phone, screen, poster or photo - heuristic). Prohibition lists such as [Constraints] and EXCLUDE are no longer scanned as scene content.
- General locks for every format: [Section] headers, timecodes, screen sides and character description lines.
- Tests: `node --test tests/scene-format.test.cjs`.

# Repair v1.8.0 - no terminal (Chrome Native Messaging)

- The repair companion is a Chrome/Edge native messaging host. Install it once per PC with **Install Repair.cmd** (per-user registry entry, no admin rights; the installer reads the registration back and runs a self-test). Chrome starts it only when Flow refuses a prompt and closes it afterwards.
- No pairing token: Chrome only lets the extension IDs in `native-host/allowed-origins.json` start the companion. The extension has a fixed development ID (`key` in manifest.json).
- One AGY repair at a time per PC (a lock shared by every companion process); a second refused prompt waits for it.
- Repair problems never resend a refused prompt unchanged: not installed / not allowed / could not start / repair failed each stop the prompt with the reason. A failed repair round does not use up the round budget.
- Repair tab: **Test repair connection** button and this extension's ID. The developer pairing token moved under an optional section.
- **Make Release Zips.cmd** builds the Chrome Web Store package (without the manifest key) and the separate companion download. See PUBLISHING.md.
- Tests: `node --test tests/native-repair.test.cjs`.

# Repair v1.7.0 - stronger validator

A repaired prompt may soften wording; it may not change the scene's structure. The local helper now rejects a revision that:

- changes the number of shots or any SHOT time window (e.g. merging three shots into one);
- changes or removes any `Image N` reference line, reference tag or explicit duration/timestamp;
- changes the OUTFIT LOCK, HEADCOUNT or LANGUAGE block (identity and format locks stay identical);
- deletes the REFERENCE ROLE MAPPING, VOICE LOCK, EXCLUDE or STYLE block (they may be reworded), or drops a speaker from VOICE LOCK;
- changes more than four WORDS in any quoted line (word-by-word, not just the word count), changes the turn count or speaker order;
- turns a Tagalog line into a non-Tagalog line (heuristic language check).

All problems are reported together. When the first AI revision breaks a lock, the helper asks the model ONCE more in the same request with the exact problems, inside the existing 10-minute budget; a second failure falls back to normal handling. The model instructions now say "simplify inside the same shots" instead of "use fewer shots". Tests: `node --test tests/validator.test.cjs`. Restart the helper after upgrading (protocol unchanged).

**Refusal suspects (v1.7.0).** Before asking the model, the helper scans the prompt for wording that has caused this kind of refusal before (medicine/treatment, named diagnoses such as dialysis, visible sickness such as coughing, blood or weapons, locking someone in, taking documents, crime accusations, debts, desperate begging, death next to money, a child in danger) and sends them as SUSPECTS. The model is told to change the subject matter of each suspect (medicine -> food, coughing -> tiredness, blood -> a stain) everywhere it appears - dialogue, ACTION, shots, AUDIO and VOICE LOCK - or to ask for manual revision if it is essential. If a revision still carries a suspect, it gets the same single corrective pass. Suspects are heuristics, not proof: a revision is never rejected only because a suspect remains. Tests: `node --test tests/suspects.test.cjs`.

**Clear stops instead of silent retries (v1.7.0).** When repair is switched on and Flow refuses a prompt, the prompt is never resent unchanged because of a helper problem: if the helper is not running, the pairing token is wrong or an older helper answers, the prompt stops with a message telling you exactly what to do. The queue card now shows only Flow's short warning (e.g. "this generation might violate our policies."); the full result-tile text is written to the activity log. The footer shows the real loaded version from manifest.json.

Prompts without SHOT headings, Image lines or lock blocks are validated exactly as before.

# Repair v1.6.0

The Repair tab now has a **Maximum repair rounds** setting: 1–5, default 3. Each accepted revision gets a generation attempt, separate from ordinary technical retries. A default run can therefore submit the initial prompt plus three repaired revisions. Exhausted policy repairs stop instead of resending the unchanged prompt. A model response requiring manual editing stops immediately.

Later rounds receive the original scene, current revision, full captured Flow warning and previous accepted revisions with their warnings. The model diagnoses both dialogue and staging. It is instructed to make legitimate safety changes, simplify overloaded direction, preserve language and emotional purpose, and request manual editing if reference images need correction.

Mechanical validation checks reference tags, explicit second values, quoted-turn count, recognizable speaker labels/order, and a maximum four-word difference in each quoted line's word count. Quotes used for other purposes are conservatively checked too. Prompts with unquoted speech or unrecognized speaker formats do not get complete dialogue coverage; meaning, language and continuity remain model instructions, not proven facts.

Accepted revisions include before/after dialogue changes and diagnosis in local repair-history. They replace both queue text and the text submitted to Flow. Project source files remain unchanged. Concat groups still require manual repair. No image rebuilding, production watcher, media QA, account rotation or endless rearming is included. DramaFactory and the original Flow extension remain unchanged.

Reload the extension after upgrading. The local helper must also restart; protocol 3 prevents accidentally using an older helper. Normal technical retries keep their existing maximum-attempt setting. Missing helpers still fall back to normal handling.
