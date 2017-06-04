## tic 0.2-6 (2017-06-04)

- Technical release to synch master and production branches.


## tic 0.2-5 (2016-11-27)

- Fix `after_success()` and `deploy()`.
- Step names are now printed again.


## tic 0.2-4 (2016-11-27)

- Use new DSL with the notion of stages with arbitrary names.
    - New `load_from_file()` replaces `get_xxx_steps()`
    - `task_...()` has been renamed to `step_...()`
    - A task is now something like an ad-hoc step
    - `before_script()` is now `prepare_all_stages()`
    - `TravisTask` is now `TicStep`
    - `ci()` is now exported
- If environment variable `CI` is undefinied, use `LocalCI` with sensible inference of repository and branch.
- Stop if `git` exits with nonzero status.


## tic 0.2-3 (2016-11-06)

- Install package for `task_build_pkgdown` task.


## tic 0.2-2 (2016-11-05)

- DSL to define steps via `step()`, which are tasks with a branch and/or env var filter (#6).


## tic 0.2-1 (2016-11-05)

- Support environment variables from both Travis and AppVeyor (#6).
- Add tests.
- Rudimentary support for multiple CI systems.
- Clean up dependencies.


# tic 0.2 (2016-11-05)

Initial release.

- Rudimentary configuration based on task objects. A task object is a list/environment which contains at least the members `check()`, `prepare()` and `run()` -- functions without arguments, only `check()` needs to return a `logical` scalar. These can be subclasses of the new `TravisTask` R6 class, the package now contains six subclasses: `HelloWorld`, `RunCovr`, `BuildPkgdown`, `InstallSSHKeys`, `TestSSH`, and `PushDeploy`. The `new` methods of theses subclasses are exported as `task_hello_world()`, `task_run_covr()`, `task_build_pkgdown()` `task_install_ssh_keys()`, `task_test_ssh()`, and `task_push_deploy()`, respectively. The three functions `before_script()`, `after_success()` and `deploy()` accept a semicolon-separated list of task objects, which is by default taken from the `TIC_AFTER_SUCCESS_TASKS` and `TIC_DEPLOY_TASKS` environment variables. These functions call the `prepare()` and `run()` methods of the task objects if and only if the `check()` method returns `TRUE` (#42).
