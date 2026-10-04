# Privacy Policy — 0xtnp Flow Studio

Last updated: October 4, 2026

0xtnp Flow Studio helps users operate Google Flow generation queues, manage reference images, save results, and optionally repair flagged prompts.

## Information handled

The extension processes prompts, uploaded images, Google Flow page content and generation status, generated media, filenames, and the folders selected by the user. It stores extension preferences, repair configuration, and automation tab identifiers locally in Chrome. The optional developer helper can use a locally stored pairing token; this is separate from Google or AGY account credentials.

Prompt and image drafts are session data. The extension does not intentionally read passwords or Google/AGY sign-in credentials, or collect general browsing history, personal communications, health records, payment records, or location for analytics. Users should avoid submitting sensitive personal information in their prompts or images unless they intend to share it with the services used for generation or repair.

## Where information goes

When generation is started, prompts and selected reference images are submitted to Google Flow. Google Flow processes those inputs and produces results under its own terms and privacy policies.

If automatic repair is enabled, the extension sends the refused prompt, warning, and repair context to the user's installed Windows companion. The companion uses AGY to send that content to its configured AI provider. Selected excerpts from previously successful repairs may also be sent as repair hints. AI responses return as prompt text and are not executed as extension code. Provider processing is subject to the user's account and the provider's terms and privacy policy. AI repair is not entirely offline.

The extension developer does not operate a server that receives these prompts, reference images, generated results, or local repair records. No developer analytics or advertising tracking is included in the extension.

## Local records and retention

The companion saves original and revised prompts, warnings, diagnoses, dialogue changes, and repair history in its local repair-history folder. Outcome records contain prompt fingerprints and metadata rather than full prompt text; the separate repair-history records contain text. Operational diagnostics may be saved in native-host/host.log. These files remain until the user removes them.

Generated files are saved through Chrome Downloads or to a folder chosen by the user. When a downloaded result is successfully copied and verified in the chosen output folder, the extension may remove its temporary download copy. The user's saved output remains.

## User control

Automatic repair is optional and can be disabled in the Repair tab. The extension can be removed through Chrome's Extensions page. The companion's Uninstall Repair.cmd removes its browser registration; it does not erase local history or generated files. Users may delete the companion's repair-history and log files themselves, and clear extension storage by removing the extension. Do not share local repair-history folders if they contain private prompts.

## Use and sharing

User data is used to provide the extension's generation, saving, and optional repair features. The developer does not sell user data, use it for advertising or unrelated purposes, or use it to determine creditworthiness or for lending. Transfers to Google Flow and the configured AI provider support user-requested functionality.

Use of information received from Google APIs will adhere to the Chrome Web Store User Data Policy, including its Limited Use requirements.

## External links

The extension provides links to companion downloads, installation documentation, and the developer's Facebook page. Clicking these opens third-party sites governed by their own privacy policies.

## Contact

For privacy questions, open an issue at https://github.com/0xtnpxsgt/flow-studio-repair-companion/issues. Do not include private prompts or account credentials in a public issue.
