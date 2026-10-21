---
name: clean-comments
description: Prune and simplify the code comments added in this session.
disable-model-invocation: true
---

Go through every code comment you added or changed in this session. Use your edits in this conversation and the working-tree diff to find them. Leave comments that were already there alone.

Only keep a comment if it is essential or enforced:

- Enforced: doc comments the language, linter, or project requires (e.g. function or public API docs).
- Essential: it explains something the code cannot show, such as a non-obvious reason, a constraint, or a workaround.

Delete the rest, especially comments that restate what the code does.

For the comments that stay, simplify and shorten them. Stop using jargon and write coherently. State each one more simply and concisely, like one human talking to another.

Then show a short summary of what you removed and what you rewrote.
