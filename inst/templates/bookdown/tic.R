get_stage("install") %>%
  add_step(step_install_deps())

get_stage("deploy") %>%
  add_code_step(bookdown::render_book('index.Rmd', 'bookdown::gitbook'))

if (ci_can_push() && !ci_is_tag()) {

    get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_push_deploy(path = "_book", branch = "gh-pages"))
}
