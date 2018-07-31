# tic 0.2.13.9002

- The `openssl` package moved from 'Suggests' to 'Imports' because `get_public_key()` and `get_private_key()` were moved from package `travis` to here.

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
- pkgdown documentation is now builded for tags by default (#13).
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

- Technical release to synch master and production branches.


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
- If environment variable `CI` is undefinied, use `LocalCI` with sensible inference of repository and branch.
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
