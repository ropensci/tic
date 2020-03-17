get_stage("install") %>%
  add_step(step_install_deps()) %>%
  add_code_step(blogdown::install_hugo())

get_stage("deploy") %>%
  add_code_step(blogdown::build_site())
