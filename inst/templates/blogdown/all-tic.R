get_stage("install") %>%
  add_step(step_install_deps()) %>%
  add_code_step(blogdown::install_hugo())

get_stage("deploy") %>%
  add_code_step(blogdown::build_site())

# deploys site to gh-pages branch, wiping all previous commits
if (ci_has_env("BUILD_BLOGDOWN")) {
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh()) %>%
    add_step(step_setup_push_deploy(
      path = "public", branch = "gh-pages",
      orphan = TRUE
    ))

  if (ci_get_branch() == "main") {
    get_stage("deploy") %>%
      add_step(step_do_push_deploy(path = "public"))
  }
}
