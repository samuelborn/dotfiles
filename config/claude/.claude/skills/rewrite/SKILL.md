---
name: rewrite
description: Rewrite a Teams message or email so the recipient gets what matters first.
disable-model-invocation: true
argument-hint: <message text>
---

Rewrite this Teams message or email:

$ARGUMENTS

If no message is given above, use the one the user pasted most recently.

## Steps

1. **Extract.** List every piece of information in the message as short bullets: facts, requests, decisions, deadlines, open questions, names, links. Drop nothing. If something is ambiguous, say so in the list.
2. **What the recipient needs.** From that list, mark what matters to the recipient: what they must do, decide, or know, and by when. Work out who the recipient is from the message. Put the rest under "background".
3. **Rewrite.** Write the message from scratch, don't edit the original:
   - Lead with what the recipient needs, then reasons and background.
   - Reorder, merge, and cut freely so it reads well.
   - Match the original's tone, formality, and language.
   - Match the medium. A Teams message is short and direct, with no subject line and no formal sign-off. An email gets a subject line, a greeting, and a closing that fit the original.
   - Write plainly, with no jargon or filler. Keep the length the content needs.

## Output

The rewritten message. Nothing else.
