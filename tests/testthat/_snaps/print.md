# print stages

    -- tic configuration -----------------------------------------------------------
    i No steps defined in any stage

---

    -- tic configuration -----------------------------------------------------------
    -- Stage: install --------------------------------------------------------------
    > step_install_deps()

---

    -- tic configuration -----------------------------------------------------------
    -- Stage: install --------------------------------------------------------------
    > step_install_deps()
    -- Stage: script ---------------------------------------------------------------
    > step_rcmdcheck()

---

    -- Stage: deploy ---------------------------------------------------------------
    i No steps defined

---

    -- tic configuration -----------------------------------------------------------
    -- Stage: install --------------------------------------------------------------
    > step_install_deps()
    > step_install_deps(repos=repo_default())
    > step_session_info()
    -- Stage: script ---------------------------------------------------------------
    > step_rcmdcheck()
    -- Stage: deploy ---------------------------------------------------------------
    > step_build_pkgdown()
    > step_run_code(writeLines("", paste0("docs", "/.nojekyll")))
    > step_run_code(dir.create(paste0("docs", "/dev"), showWarnings=FALSE))
    > step_run_code(writeLines("", paste0("docs", "/dev/.nojekyll")))

---

    -- tic configuration -----------------------------------------------------------
    i No steps defined in any stage

---

    -- tic configuration -----------------------------------------------------------
    -- Stage: install --------------------------------------------------------------
    > step_install_deps(repos=repo_default())
    > step_session_info()
    -- Stage: deploy ---------------------------------------------------------------
    > step_build_bookdown()

---

    -- tic configuration -----------------------------------------------------------
    -- Stage: install --------------------------------------------------------------
    > step_install_deps(repos=repo_default())
    > step_session_info()
    > step_install_deps(repos="test")
    -- Stage: deploy ---------------------------------------------------------------
    > step_build_bookdown()

