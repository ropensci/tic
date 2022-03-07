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
    -- deploy ------------------------------------------------------------- stage --
    > step_build_pkgdown()
    > step_run_code(writeLines("", paste0("docs", "/.nojekyll")))
    > step_run_code(dir.create(paste0("docs", "/dev"), showWarnings = FALSE))
    > step_run_code(writeLines("", paste0("docs", "/dev/.nojekyll")))

---

    i No steps defined in any stage

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps(repos = repo_default())
    > step_session_info()
    -- deploy ------------------------------------------------------------- stage --
    > step_build_bookdown()

---

    -- install ------------------------------------------------------------ stage --
    > step_install_deps(repos = repo_default())
    > step_session_info()
    > step_install_deps(repos = "test")
    -- deploy ------------------------------------------------------------- stage --
    > step_build_bookdown()

