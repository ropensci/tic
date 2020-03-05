get_stage("install") %>%
  add_step(step_install_deps())

get_stage("deploy") %>%
  add_code_step(rmarkdown::render_site())

if (ci_on_ghactions()) {
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_push_deploy(path = "_site", branch = "gh-pages"))
}
