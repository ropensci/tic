# print stages

    i No steps defined in any stage

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps()

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps()
    -- script ------------------------------------------------------------- stage --
    > step_rcmdcheck()

---

    -- deploy ------------------------------------------------------------- stage --
    i No steps defined

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps()
    > step_install_deps(repos = repo_default())
    > step_session_info()
    -- script ------------------------------------------------------------- stage --
    > step_rcmdcheck()
    -- before_deploy ------------------------------------------------------ stage --
    > step_setup_push_deploy(path = "docs", branch = "gh-pages", remote_url = NULL, 
        orphan = FALSE, checkout = TRUE)
    -- deploy ------------------------------------------------------------- stage --
    > step_build_pkgdown()
    > step_run_code(writeLines("", paste0("docs", "/.nojekyll")))
    > step_run_code(dir.create(paste0("docs", "/dev"), showWarnings = FALSE))
    > step_run_code(writeLines("", paste0("docs", "/dev/.nojekyll")))
    > step_do_push_deploy(path = "docs", commit_message = NULL, commit_paths = ".", 
        force = FALSE)

---

    i No steps defined in any stage

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps(repos = repo_default())
    > step_session_info()
    -- before_deploy ------------------------------------------------------ stage --
    > step_setup_ssh(private_key_name = "TIC_DEPLOY_KEY")
    > step_setup_push_deploy(path = "_book", branch = "gh-pages", remote_url = NULL, 
        orphan = FALSE, checkout = TRUE)
    -- deploy ------------------------------------------------------------- stage --
    > step_build_bookdown()
    > step_do_push_deploy(path = "_book", commit_message = NULL, commit_paths = ".", 
        force = FALSE)

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps(repos = repo_default())
    > step_session_info()
    > step_install_deps(repos = "test")
    -- before_deploy ------------------------------------------------------ stage --
    > step_setup_ssh(private_key_name = "TIC_DEPLOY_KEY")
    > step_setup_push_deploy(path = "_book", branch = "gh-pages", remote_url = NULL, 
        orphan = FALSE, checkout = TRUE)
    -- deploy ------------------------------------------------------------- stage --
    > step_build_bookdown()
    > step_do_push_deploy(path = "_book", commit_message = NULL, commit_paths = ".", 
        force = FALSE)

