- Never at Claude as git author.
- Never commit or push anything.
- After touching rust code in the end always make a /polish-rustdoc pass.
- Only boot/run tests when told to.

## Fenix OS repo (~/os): reference code for conventions

The repo has no single agreed convention yet. When looking for code to copy style from, use these:

- `dev/imager`: new, follows most conventions. Written entirely by Claude Code, so don't treat it as an example of how a human on the team would write it.
- `sdk/`: good model for documentation style.
- `BSW/fefs`: covers many conventions, but parts of the code are poor quality. Copy its structure, not its implementation.
