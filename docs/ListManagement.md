# List Management: Adding Prompt Entries Safely

## Goals
- Preserve the generic template exactly as provided
- Append new entries after the template without altering it
- Validate additions to prevent template corruption

## Steps to Add Items
1. Locate the designated insertion point  
   - The insertion point is immediately after the template block:
     - `# Prompt: [Name of Prompt]`
     - `**Author:** [@ContributorName](link-to-github-profile)`
     - `**Status:** Verified by TechGuards ✅`
2. Copy the template structure for new entries  
   - New entries must use the same 3-line structure plus the link line:
     - `# Prompt: <Title>`
     - `**Author:** [@<Handle>](<URL>)`
     - `**Status:** <Status>`
     - `**Link to Prompt:** [View](<relative-path>)`
3. Populate the new entry with required data  
   - Title, Author handle, Author URL, Status, and a valid repo-relative link to the prompt
4. Verify the addition maintains list integrity  
   - Confirm the original template remains unchanged
   - Ensure formatting (headings, bold markers, brackets) matches the template
   - Check for duplicate prompt titles

## Validation Checks
- Template presence and exact-match verification before insertion
- Non-empty parameters for title, author handle/URL, status, and link path
- Author handle format: `@Username`
- Author URL format: starts with `http(s)://`
- Link path must exist in the repository
- Duplicate prompt title detection
- Post-insertion recheck that the template block is intact

## Using the Automation Script
- Script: `scripts/add-prompt.ps1`
- Example:
  - `pwsh scripts/add-prompt.ps1 -PromptTitle "My Prompt" -AuthorHandle "@MyUser" -AuthorUrl "https://github.com/MyUser" -Status "Pending Verification" -LinkPath "./04_Structured_Outputs/NoteBookLM/my-prompt.md"`
- Behavior:
  - Inserts the new entry directly after the template
  - Validates inputs and prevents duplicates
  - Aborts on any template mismatch to keep the template intact
