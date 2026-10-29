---
name: review-loop
description: Review the current changes in a loop and fix what matters for a clean merge request.
disable-model-invocation: true
---

Repeat this loop:

1. Spawn two agents that run `/code-review medium` on the current changes.
2. Pick the findings that should be fixed for a clean merge request: caused by our changes, or small and easy to fix. Skip anything out of scope.
3. Fix only those findings.
4. Start again with two "fresh context" review agents.

Stop when you think nothing left is worth fixing. Then show a short summary of what you fixed and what you skipped, and why.
