# Install the bundled VizModules agent skills into a project

Copies the skills that ship with VizModules into a project's skills
directory, where GitHub Copilot, OpenAI Codex, Claude Code, and other
tools following the [Agent Skills](https://agentskills.io) convention
will discover them.

## Usage

``` r
use_vizmodules_skills(
  path = ".",
  client = c("agents", "copilot", "claude"),
  overwrite = FALSE
)
```

## Arguments

- path:

  Directory of the project to install into. The skills are written under
  this directory, in the subdirectory determined by `client` (for
  example `.agents/skills`), which is created if needed.

- client:

  Which client convention to install the skills for. `"agents"` (the
  default) writes to `.agents/skills`, discovered by OpenAI Codex and by
  GitHub Copilot's project skill locations. `"copilot"` writes to
  `.github/skills`, GitHub Copilot's repository-native location.
  `"claude"` writes to `.claude/skills`, discovered by Claude Code. All
  three are equivalent copies of the same skills; choose whichever your
  tooling expects, or call this function more than once with different
  `client` values to install into several locations at once.

- overwrite:

  Logical; if `FALSE` (the default) a skill whose directory already
  exists is skipped rather than replaced.

## Value

Invisibly, a character vector of the skill directories written.

## Details

Three skills are provided:

- `vizmodules-app`:

  Wiring plot modules into a Shiny app: `defaults`,
  `hide.inputs`/`hide.tabs`, the Stats tab,
  [`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md),
  the data filter table, the figure builder, and source-data export.
  Ships a generated inventory of every module's column-mapping keys,
  colour key, and tab names.

- `vizmodules-custom-module`:

  Building a wrapper module on top of a base module: the namespace
  contract, reactive `defaults`, avoiding double renders, manual-edit
  persistence, and model-line backends.

- `vizmodules-new-module`:

  Authoring a module inside this package: the file trio, the required
  roxygen sections, the uniform input helpers, and file templates to
  copy.

## Author

Jared Andrews

## Examples

``` r
# Install into a temporary project rather than the current one:
use_vizmodules_skills(tempdir())
#> Installed 'vizmodules-app'.
#> Installed 'vizmodules-custom-module'.
#> Installed 'vizmodules-new-module'.
#> 
#> 3 skill(s) written to '/tmp/Rtmpmepuj2/.agents/skills'.
#> Restart your agent session if it was already running, so the new directory is picked up.

if (FALSE) { # \dontrun{
# Install into the current project, refreshing any that already exist:
use_vizmodules_skills(".", overwrite = TRUE)

# Install for Claude Code specifically:
use_vizmodules_skills(".", client = "claude")
} # }
```
