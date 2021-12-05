<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# tic 0.11.2 (2021-12-05)

- `do_pkgdown()` now always create a `.nojekyll` file for both release and developement deployments.
  Otherwise custom fonts starting with an underscore will not be loaded as Jekyll ignores this pattern.
  A `.nojekyll` file tells GitHub pages to not use Jekyll for serving the web page. (#307)


# tic 0.11.1 (2021-06-27)

- Templates: install required system libs for {pkgdown} conditionally (accidentally removed in the previous template revision on 2021-06-26)
- Templates: restore installation of `libcurl4-openssl-dev` and `libgit2-dev`


# tic 0.11.0 (2021-06-26)

- Templates: On Linux, system libraries are now installed via `remotes::system_requirements()` (#300)
- Instead of using an exact version tag, the core GHA actions are now referenced using a dynamic major version tag (e.g. v2 instead of v2.3.4).
  This includes an update of the templates to the latest revision date 2021-06-26.
- `do_pkgdown()` macro now also builds the site on on branches containing the word `cran`.
  This adds support for the {fledge} release mechanism when using both a development and release site (#303)
- `update-tic.yml`: Remove hardcoded reference to master branch
- `update_yaml()` is not in beta state anymore


# tic 0.10.0 (2020-12-11)

- Drop Travis support (#295)
- Drop Appveyor support (#296)
- Bump templates: install required `libgit2` required by usethis v2.0.0 (tic dep)


# tic 0.9.0.9008 (2020-11-18)

- update peter-evans/create-pull-request action in `update-tic.yml` template to v3.5.0


# tic 0.9.0.9007 (2020-11-14)

- update GitHub Actions templates
  - update actions/checkout to v2.3.4
  - update actions/upload-artifacts to v2.2.1
  - update pat-s/always-upload-cache to v2.1.3
- conditionally install pkgdown required system libs on both Linux and macOS

# tic 0.9.0.9006 (2020-09-19)

- Replace hardcoded references to "master" by a dynamic query of the default repo branch


# tic 0.9.0.9005 (2020-09-04)

- `use_tic()`: use GitHub Actions as the default provider for all platforms
- Copy over GitHub authentication and SSH helpers from {travis}


# tic 0.9.0.9004 (2020-08-27)

- `update_yml()`: Support updating multiple YAML files


# tic 0.9.0.9003 (2020-08-06)

- GHA: add `workflow_dispatch` event trigger to templates
- update instructions for spatial libs on macOS for GHA
- improve heuristic for updating header parts of "custom" and "custom-deploy" templates


# tic 0.9.0.9002

- DSL: Don't add steps twice, if present in a previous macro (#272)
- `update-tic.yml`: use peter-evans/create-pull-request@v3 and actions/checkout v2.3.1. Run on ubuntu instead of macOS
- run r-devel on ubuntu instead of macOS
- pin actions/upload-artifact to v2.1.1
- update actions/checkout to v2.3.1
- update pat-s/always-upload-cache to v2.1.0
- `step_setup_ssh()` now verifies that {git2r} is installed. This prevents build failures for {rsconnect} deployments
- `update-tic.yml`: install libs via `apt` on Linux instead of `brew`


# tic 0.9.0.9001

- gha_add_secret(): Add new upstream parameters and fix endpoint


# tic 0.9.0.9000

- Same as previous version.


# tic 0.9.0

## Features

- `update_yaml()`: Account for duplicated env vars when a custom env var masks a template env var
- `use_tic_badge()`: Update tic badge and default action name (#269)
- Installing and using `ccache` for faster source package installation is now optional.
  While using `ccache` can help a lot for installing large dependency chains of certain packages, it also adds substantial overhead to builds for small packages.
  It is now optional and needs to be added as a custom block to builds. (#264)
- Add `step_session_info()`.
  This step prints the session info after having installed all dependencies in the "install" stage. (#259)
- `step_install_deps()` and `do_package_checks()` gain `dependencies = TRUE` argument.
- New `use_update_tic()`: Adds GitHub Actions workflow `update-tic.yml` to automatically update tic YAML templates
- Support fully custom runner matrices on GitHub Actions via template types `"custom"` and ´"custom-deploy"`
- New `gha_add_secret()` to automate the process of adding a GitHub PAT to a repo as a secret.
  This function will probably be move to {ghactions} in the future.

## Bugfixes

- Temporarily enforce {covr} dev version to account for timeouts on GHA, see https://github.com/r-lib/covr/issues/435
- Remove alert in steps-install.R (#263)
- Pass arg `remote` to all printing instances. Previously using a different remote than "origin" caused an error..

## CI Provider specific

### GitHub Actions

- Update versions of "tinytex" and "always-upload-cache" actions (#267)
- Install LaTeX on only one runner (#257)
- Switch from `main.yml` to `tic.yml` (#260)
- Set env var GITHUB_PAT from secret GITHUB_TOKEN to work around rate limits in {remotes}
- Update `actions/checkout` to v2.1.1
- Update `pat-s/always-upload-cache` to v2.0.0
- Remove old clang7 compiler setup for R <= 3.6.3

# tic 0.8.0.9009

- Temporarily enforce {covr} dev version to account for timeouts on GHA, see https://github.com/r-lib/covr/issues/435
- `use_tic_badge()`: Update tic badge and default action name (#269)
- GHA: Update versions of "tinytex" and "always-upload-cache" actions (#267)


# tic 0.8.0.9008

- Make ccache optional (and more) (#264)
- Remove alert in steps-install.R (#263)


# tic 0.8.0.9007

- Add `step_session_info()` (#259)
- GHA: Install LaTeX on only one runner (#257)
- GHA: Switch from main.yml to tic.yml (#260)


# tic 0.8.0.9006

- `step_install_deps()` and `do_package_checks()` gain `dependencies = TRUE` argument.


# tic 0.8.0.9005

- GHA: Set env var GITHUB_PAT from secret GITHUB_TOKEN to work around rate limits in {remotes}


# tic 0.8.0.9004

- New `use_update_tic()`: Adds GitHub Actions workflow `update-tic.yml` to automatically update tic YAML templates


# tic 0.8.0.9003

- Support fully custom runner matrices on GitHub Actions via template types `"custom"` and ´"custom-deploy"`
- bugfix: Pass arg `remote` to all printing instances. Previously using a different remote than "origin" errored.


# tic 0.8.0.9002

- New `gha_add_secret()` to automate the process of adding a GitHub PAT to a repo as a secret.
  This function will probably be move to {ghactions} in the future.


# tic 0.8.0.9001

### GitHub Actions

- Update actions/checkout to v2.1.1
- Update pat-s/always-upload-cache to v1.2.0
- Remove old clang7 compiler setup for R <= 3.6.3


# tic 0.8.0.9000

- Same as previous version.


# tic 0.8.0

## Features

- New `update_yml()`: Update your {tic} yaml templates to the latest upstream version in {tic}.
  User changes are preserved if these are marked correctly.
  See vignette ["Updating Templates"](https://docs.ropensci.org/tic/articles/updating.html) for instructions.
  This process can also be fully automated via a [custom CI job](https://docs.ropensci.org/tic/articles/updating.html#automating-the-update-process).
- Add argument `force` to `step_do_push_deploy()` for adding the `--force` flag to git calls
- Add solutions to {rgl} installation issues to FAQ
- Update `.R/Makevars`

## CI Provider specific

### GitHub Actions

- Set CRON time to 4 am to avoid download issues with mirror updates
- Added `-I/usr/local/include` to CPPFLAGS for macOS runners to mirror CRAN setup

### Circle CI

- Update r-oldrelease to R 3.6.3

# tic 0.7.0.9000

- GHA: added `-I/usr/local/include` to CPPFLAGS for macOS runners to mirror CRAN
- Add solutions to installation issues for package {rgl} to FAQ
- Add argument `force` to `step_do_push_deploy()` for adding the `--force` flag to git calls

# tic 0.7.0

## Macros

- Add `do_blogdown()` macro (#242)

## CI Provider specific

### GitHub Actions

- `use_tic()`: Move `cli::tree()` calls to `use_*_yml()` functions to avoid printing of false-positive trees.
- `use_*_yml()`: Set defaults for argument `type`.
- Fix GHA build URL and prettify deploy message (#247)
- Adjust GH Actions templates to use the `use_*_yml()` logic (#246)
- Bugfix: Packages on R-devel macOS are being installed in parallel again.

**R 4.0 toolchain**

- GitHub Actions: R-devel on macOS now uses Apples default clang compiler and the 10.13 SDK (High Sierra) to mimic the CRAN toolchain behavior.
  (The 10.15 SKD causes various issues when installing packages from source.)
- Env var `SDKROOT` is now set to `/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk` to prevent linking issues on macOS >= 10.15.4

# tic 0.6.0.9002

- `do_blogdown()` and `do_bookdown()` gain argument `cname`, making it possible to pass a CNAME URL for deployments. This is useful when setting one sets `orphan = TRUE` and relies on a custom URL of the published content (otherwise the redirect would not work)
- Add a better general intro about CI and explain some general CI terms (fixes #234)

# tic 0.6.0.9001

- Add `do_blogdown()` macro (#242)

# tic 0.6.0.9000

- Same as previous version.

# tic 0.6.0

## General

- `use_badge`: Refactor to use default badges from the respective providers rather than from shields.io (too slow and sometimes badges did not render at all) (#240)
- Condition deployment templates on a single runner for deployment. This avoids race conditions during deployment. This applies to all CI providers and templates (blogdown, bookdown, package) (#241)
- Files specified for deployment via `step_push_deploy(commit_paths = )` are now force added to the index by `git`.
  This enables to add directories like `docs/` (e.g. created by a local pkgdown build) to `.gitignore` and still deploy it during CI (#237).

## CI Provider specific

### GitHub Actions

- GitHub Actions: Always use option '--no-manual' on Windows because LaTeX is not available (because it takes ages to install)
- `step_rcmdcheck()`: Test in directory "check" to simplify upload of artifacts
- Set cron job to 4am to avoid potential download issues with R-devel on macOS
- Github Actions: Only deploy on R-release on macOS by default.

## Bugfixes

- `use_tic()` fails with descriptive error message if the badges start/end sections are missing in README
- `step_install_ssh_keys()`: Do not use `git2r::config()` when deploying on Windows to prevent build freezes

## Documentation

- `faq.Rmd`: Add info how to avoid git race conditions during pkgdown deployment (#238)

# tic 0.5.0.9005

- `use_tic()` fails with descriptive error message if the badges start/end sections are missing in README

# tic 0.5.0.9004

- `faq.Rmd`: Add info how to avoid git race conditions during pkgdown deployment (#238)
- `step_install_ssh_keys()`: Do not use `git2r::config()` when deploying on Windows to prevent build freezes
- update blogdown templates
- GitHub Actions: Always use option '--no-manual' on Windows because LaTeX is not available

# tic 0.5.0.9003

- Files specified for deployment via `step_push_deploy(commit_paths = )` are now force added to the index by `git`.
  This enables to add directories like `docs/` (e.g. created by a local pkgdown build) to `.gitignore` and still deploy it during CI (#237).
- `step_rcmdcheck()`: Test in dir "check" to simplify upload of artifacts

## Github Actions

- Set cron job to 4am to avoid potential download issues with R-devel on macOS
- Github Actions: Use actions/checkout v2
- Github Actions: Only deploy on R-release on macOS by default.
  This avoids git race conditions between runners.

# tic 0.5.0.9002

- Github Actions: {covr} now supports automatic upload of codecov results via their own CODECOV_TOKEN
- `use_tic_r()`: Add support for conditional tic.R templates via argument `deploy_on`.
- export `use_tic_r()` so that a manual workflow is possible (besides `use_tic()`)
- GitHub Actions: use actions "pat-s/always-upload-cache" instead of "actions/cache"

# tic 0.5.0.9001

- Add `use_tic_badge()`: Creation of pretty CI status badges

# tic 0.5.0.9000

- Same as previous version.

# tic 0.5.0

## Enhancements

- New function `tic::use_ghactions_deploy()` (status "experimental") to set up a SSH key for deployment.
- New function `use_ghactions_yml()` with `deploy = TRUE/FALSE` (FALSE by default).
- New Vignette "FAQ".
- Added GH Actions support to `use_tic()`
- new macro `do_readme_rmd()` (#223)
- new function `list_macros()`

## Maintenance

- Change for the default of the private SSH deploy key name from `TRAVIS_DEPLOY_KEY` to `TIC_DEPLOY_KEY` to have a generic name.
- Change argument `travis_private_key_name` to `private_key_name`
- Renamed `yaml-templates.R` to `yaml_templates.R` because the former caused troubles when previewing the dev version of the docs.
- Beautified the CLI output of `use_tic()`
- Replaced all instances of `_tic_` in the docs by `{tic}`

# tic 0.4.0.9000

- add macro `do_readme_rmd()` (#223)
- new function `list_macros()`

# tic 0.4.0

- add macro `do_drat()`
- start vignette "troubleshooting"
- add {desc} to suggests
- `ci_can_push()` never fails.
- templates: always upgrade dep packages during {tic} installation

# tic 0.3.0.9005

- Make it possible to pass the endpoint arg from {travis} funs to `use_tic()`
- mention the difference between .com and .org -> new vignette "org-vs-com"
- move package to ropensci org

* `error_on = "note"` also fails on warnings.

# tic 0.3.0.9004

- `ci_can_Push()`: Error with descriptive error message if deployment is not possible
- `ci_can_push()`: Fix for Travis CI
- optimize templates (especially matrix builds) by specifying which job is used for the pkgdown build

# tic 0.3.0.9003

- `use_tic()`: add key_name_private and key_name_public args from `travis::use_travis_deploy()`
- `ci_can_push()`: Change default from `"id_rsa""` to `"TRAVIS_DEPLOY_KEY"` and also support backward comp
- `use_tic()`: Travis as default for Linux and macOS

# tic 0.3.0.9002

- `use_tic()` supports running both Linux and macOS on Travis (#202).
- Skip `TicStep$prepare` if `prepare_call` is given in `add_code_step()` (#211).
- Fix preparation of `step_add_to_drat()`.
- `use_tic()` gains arguments that allow non-interactive use and re-running with the same settings if setup fails (#203).
- Removed artificial sleeps with interactive setup.

# tic 0.3.0.9001

- Move `use_travis_deploy()` back to {travis}.

# tic 0.3.0

- add argument "check_dir" to step_rcmdcheck (#179)
- use `remotes::install_cran(upgrade = TRUE)` to install packages (#186)
- added support for Circle CI (#177)
- All packages installed for custom steps use binary packages if possible on Windows and macOS (#178).
- Use `TRAVIS_BUILD_WEB_URL` for the commit message.
- `do_package_checks()` gains `type` argument.
- Tweak documentation.
- export `use_travis_yml()`, `use_circle_yml()` and `use_appveyor_yml()` and add overview table of available options

# tic 0.2.13.9020

- Avoid building packages when installing dependencies.
- Remove vignettes from package if checking with `--no-build-vignettes` to avoid warning from `R CMD check`.
- Fix `R CMD build` and `R CMD check` switches on AppVeyor.

# tic 0.2.13.9019

- Building pkgdown site succeeds if `docs/` directory is missing (#173, r-lib/pkgdown#1050).

# tic 0.2.13.9018

- Move `use_travis_deploy()` from the travis package to here.
- Unexport `get_public_key()` and `encode_private_key()`.

# tic 0.2.13.9017

- Test utils and printing.
- Exclude code that can only run interactively or in a CI from coverage.
- Add comment regarding integration test.
- Strip long source code lines.
- Add review badge.
- Add `tic.R` to `.Rbuildignore` for internal tests.
- Update wordlist.
- Fix typos.
- Condition example on presence of Git repository.

# tic 0.2.13.9016

- Fix compatibility with git 2.21 and above for race conditions (#160).
- `step_build_pkgdown()` clean site before building.
- AppVeyor template makes sure packages are always installed from binary during bootstrapping.
- CI templates install from GitHub if the version number indicates that the package is not on CRAN yet.
- AppVeyor doesn't cache R packages, because this leads to update problems. Binary installation is fast enough.
- Don't perform CRAN incoming checks, in particular the checks for large version components (#168).
- The `step_install_deps()`, `step_install_cran()` and `step_install_github()` steps install binary packages by default, even if the CRAN version is ahead.
- All files created by `use_tic()` are added to `.Rbuildignore`.
- Package template for `tic.R` runs pkgdown only on Travis (#167).
- Update vignettes (#156).

# tic 0.2.13.9015

- `detect_repo_type()` now prompts the user for unknown repository types (#161).
- `use_tic()` loses `path` argument, now taken from `usethis::proj_get()` .
- `step_rcmdcheck()` and `do_package_checks()` now avoid building the vignette by default on AppVeyor (#150).
- `use_tic()` now uses boxes from {cli} for better structured output (#153).

# tic 0.2.13.9014

- Configuration storage modeled after `usethis::proj_get()`.
- New `dsl_load()`, renamed from `load_from_file()`.
- New `dsl_get()` and `dsl_init()`.
- Added examples to help for `get_stage()` and macros (#77).

# tic 0.2.13.9013

- Using tidy evaluation for simpler code, more control and better printing of steps (#77).
- Fix AppVeyor builds.
- The README is now explicit about suggesting that each repo should contain only one project (#152).
- Documentation uses the {rotemplate} package (#121).
- Only install {remotes} and {curl} if not yet installed (#97).
- New `use_tic()`, moved from {travis} (#138).
- Updated templates (#81).
- A failing step displays a traceback generated by `rlang::trace_back()` (#105).
- `do_pkgdown()` and `do_bookdown()` now have a `deploy` argument and are documented on separate help pages. The new `?macro` help page provides an overview.
- Implement `print()` methods for DSL and stages (#77).
- New `do_bookdown()` (#137).

# tic 0.2.13.9012

- New `repo_*()` functions to simplify specification of the `repos` argument to installer functions (#101).
- Add Appveyor checks (#147, @pat-s).
- New pkgdown macro via `do_pkgdown()` (#126, @pat-s)
- New example: covrpage, cc @yonicd
- `step_rcmdcheck(error_on = "note")` works again (#119).
- New `do_package_checks()` with `codecov = TRUE` argument (#146), replaces `add_package_checks()` which stays around for compatibility (#128).
- `add_step()` now evaluates the `step` argument in a `tryCatch()` block and gives a bit of context if this fails (#73).
- New `run_all_stages()`, previously `tic()` (#66).
- New `ci_get_env()`, `ci_has_env()` and `ci_is_env()` functions to avoid verbose `Sys.getenv()` calls in `tic.R` (#124, @pat-s).
- New `ci_*()` functions to avoid R6 notation in `tic.R` (#125, @pat-s).

# tic 0.2.13.9011

- New `step_install_deps()`, reorganizing help pages so that installer steps are on the same page.
- `step_rcmdcheck()` no longer installs dependencies. Instead, `add_package_checks()` includes `step_install_deps()` (#74).
- Fix two links in README (#115, @Rekyt).
- Vignette update (#80, @pat-s).
- Support `build_args` argument in `step_rcmdcheck()` (#64, @pat-s).

# tic 0.2.13.9011

## step_rcmdcheck()

- deprecate `warnings_are_errors` and `notes_are_errors` in favor of the new `error_on` argument
- add args `timeout` and `repos`
- call `rcmdcheck()` internally with `error_on = "never"` so that we can trigger the message on found warnings and notes
- remote outdated doc about `step_rcmdcheck()` using a dedicated lib for the check

# tic 0.2.13.9010

- No longer using a separate library for package checks, because it causes a lot of problems with various steps which are not aware of this (#86, #88).
- Packages coming with the R-installation are not updated anymore when preparing `step_rcmdcheck()`.
  See `?step_rcmdcheck()` for detailed info. (#103)

# tic 0.2.13.9009

- The `step_build_pkgdown()` step now uses the same dedicated library as `step_rcmdcheck()`.
- Using the development version of _rcmdcheck_ to work around problems finding the vignette builder (#84).
- Draft for new "Get started" vignette (#63, @pat-s).

# tic 0.2.13.9008

- The `step_rcmdcheck()` step now uses a dedicated library for installing the packages and checking, it also updates the packages after installing dependencies. The `add_package_checks()` macro no longer includes an `update.packages()` call (#35).
- The `step_rcmdcheck()` step now installs all dependencies during preparation. The `add_package_checks()` macro no longer adds the code step that installs dependencies.

# tic 0.2.13.9007

- The `step_do_push_deploy()` and `step_push_deploy()` steps are not executed for builds on a tag, because this would create a branch of the same name as the tag (#27).

# tic 0.2.13.9006

- Support creating variables in `tic.R` by sourcing `tic.R` in a modifiable environment (#33).
- Replaced `private` arguments with an environment that keeps track of internal state, now the code from `add_package_checks()` can be copied to a `tic.R` file (#74).

# tic 0.2.13.9005

- A failing step immediately fails the entire stage, subsequent steps are not run (#59).

# tic 0.2.13.9004

- New `get_public_key()` and `encode_private_key()` moved from _travis_ (#71, @pat-s).
- Add `step_install_cran()` and `step_install_github()` (#65, @pat-s).

# tic 0.2.13.9003

- Added integration tests for package checks and deployment, covering various common cases (#62).
- Add integration test for deploying from a subdirectory.
- Remove `orphan` argument from `step_push_deploy()`, because there's no easy way to implement it reliably. If only a subdirectory is deployed to a separate branch (i.e., the `path` argument is set), `orphan = TRUE` is required.

# tic 0.2.13.9002

- Better strategy for handling race conditions during deployment, new changes are no longer silently overwritten with `step_push_deploy()` (#45).
- Add integration test for package checks and race conditions (#62).
- Clarify error message upon step failure.
- `add_package_checks()` adds coverage checks only for non-interactive CIs.
- Add reference to `use_tic()` (#55).
- Document purpose of testing steps (#49).
- Allow only predefined stage names (#48).

# tic 0.2.13.9001

- The _pkgdown_ package is installed from CRAN.

# tic 0.2.13.9000

- New `subdir` argument to `step_push_deploy()` and `step_do_push_deploy()`, allows restricting the set of files to be committed to Git (#42).

# tic 0.2-13 (2018-02-01)

- New `base64serialize()` and `base64unserialize()` (#37).
- `add_code_step()` detects required packages also for complex expressions. Packages that need to be installed from GitHub still need to be installed manually (#36).
- `step_rcmdcheck()` now prints a summary, which also shows e.g. details on installation failures.
- New `prepare_call` argument to `step_run_code()` and `add_code_step()`.

# tic 0.2-12 (2017-06-29)

- Fix `add_package_checks()`.

# tic 0.2-11 (2017-06-29)

- `add_package_checks()` gains arguments that are passed to `step_rcmdcheck()`.
- New `step_setup_ssh()` (#24).
- New `add_code_step()` (#21).
- New `tic()` to run all steps locally (#23).
- New `add_package_checks()` (#25).

# tic 0.2-10 (2017-06-29)

- Document all exported functions and many classes (#8).
- `step_add_to_drat()` will also update the overview page if it exists.

# tic 0.2-9 (2017-06-28)

- Fix `get_slug()` on AppVeyor to use `APPVEYOR_REPO_NAME`.
- New `step_add_to_drat()`.
- Split `step_push_deploy()` into `step_setup_push_deploy()` and `step_do_push_deploy()`.
- Better traceback output.
- Use "remotes" instead of "devtools".
- Reduce output after preparation (#5).
- New `step_rcmdcheck()`.
- The deparsed code is used as step name (#5).

# tic 0.2-8 (2017-06-17)

- An error occurring when running a step is printed in red (#5).

# tic 0.2-7 (2017-06-13)

- New `step_write_text_file()` for creating arbitrary text files, including `~/.R/Makevars` (#14).
- pkgdown documentation is now built for tags by default (#13).
- The "openssl" package is now only suggested, not imported.
- Removed `step_run_covr()` in favor of the new `step_run_code()` (#18).
- `load_from_file()` reloads the file from disk if its mtime changes (#11).
- All steps of a stage are run even in case of previous errors, but the stage still fails if at least one of its steps failed (#10).
- Adding to known hosts or installing a SSH keys now requires a non-interactive CI.
- New `step_run_code()` to run arbitrary code. If the code is a call with the `pkg::fun()`, notation, pkg is installed if missing (#1, #3). `step_run_covr()` remains for compatibility but is scheduled for removal.
- Color the start of each step in the log (#5).
- New `step_add_to_known_hosts()` to work around configuration problems on OS X (#16).
- Export runner methods for all stages defined in Travis CI and AppVeyor (#17).

# tic 0.2-6 (2017-06-04)

- Technical release to sync default and production branches.

# tic 0.2-5 (2016-11-27)

- Fix `after_success()` and `deploy()`.
- Step names are now printed again.

# tic 0.2-4 (2016-11-27)

- Use new DSL with the notion of stages with arbitrary names.
  - New `load_from_file()` replaces `get_xxx_steps()`
  - `task_...()` has been renamed to `step_...()`
  - A task is now something like an ad-hoc step
  - `before_script()` is now `prepare_all_stages()`
  - `TravisTask` is now `TicStep`
  - `ci()` is now exported
- If environment variable `CI` is undefined, use `LocalCI` with sensible inference of repository and branch.
- Stop if `git` exits with nonzero status.

# tic 0.2-3 (2016-11-06)

- Install package for `task_build_pkgdown` task.

# tic 0.2-2 (2016-11-05)

- DSL to define steps via `step()`, which are tasks with a branch and/or env var filter (#6).

# tic 0.2-1 (2016-11-05)

- Support environment variables from both Travis and AppVeyor (#6).
- Add tests.
- Rudimentary support for multiple CI systems.
- Clean up dependencies.

# tic 0.2 (2016-11-05)

Initial release.

- Rudimentary configuration based on task objects. A task object is a list/environment which contains at least the members `check()`, `prepare()` and `run()` -- functions without arguments, only `check()` needs to return a `logical` scalar. These can be subclasses of the new `TravisTask` R6 class, the package now contains six subclasses: `HelloWorld`, `RunCovr`, `BuildPkgdown`, `InstallSSHKeys`, `TestSSH`, and `PushDeploy`. The `new` methods of theses subclasses are exported as `task_hello_world()`, `task_run_covr()`, `task_build_pkgdown()` `task_install_ssh_keys()`, `task_test_ssh()`, and `task_push_deploy()`, respectively. The three functions `before_script()`, `after_success()` and `deploy()` accept a semicolon-separated list of task objects, which is by default taken from the `TIC_AFTER_SUCCESS_TASKS` and `TIC_DEPLOY_TASKS` environment variables. These functions call the `prepare()` and `run()` methods of the task objects if and only if the `check()` method returns `TRUE` (#42).
