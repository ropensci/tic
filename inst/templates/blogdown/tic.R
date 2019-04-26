get_stage("install") %>%
  add_step(step_install_deps()) %>%
  add_code_step(blogdown::install_hugo())

get_stage("deploy") %>%
  add_code_step(blogdown::build_site())

if (ci_can_push() && !ci_is_tag()) {
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_push_deploy())
}
