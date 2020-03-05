get_stage("install") %>%
  add_step(step_install_deps())

get_stage("deploy") %>%
  add_code_step(rmarkdown::render_site())
