stage("after_success") %>%
  add_step(task_hello_world) %>%
  add_step(task_run_covr)

stage("deploy") %>%
  add_step(task_install_ssh_keys) %>%
  add_step(task_test_ssh)

if (ci()$get_branch() == "production" && Sys.getenv("BUID_PKGDOWN") != "") {
  stage("deploy") %>%
    add_step(task_build_pkgdown) %>%
    add_step(task_push_deploy, path = "docs", branch = "gh-pages")
}
