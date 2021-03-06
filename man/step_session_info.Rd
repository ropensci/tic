% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/steps-session-info.R
\name{step_session_info}
\alias{step_session_info}
\title{Step: Print the current Session Info}
\usage{
step_session_info()
}
\description{
Prints out the package information of the current session via
\code{\link[sessioninfo:session_info]{sessioninfo::session_info()}}.
}
\examples{
dsl_init()

get_stage("install") \%>\%
  add_step(step_session_info())

dsl_get()
}
\seealso{
Other steps: 
\code{\link{step_add_to_drat}()},
\code{\link{step_add_to_known_hosts}()},
\code{\link{step_build_pkgdown}()},
\code{\link{step_do_push_deploy}()},
\code{\link{step_hello_world}()},
\code{\link{step_install_pkg}},
\code{\link{step_install_ssh_keys}()},
\code{\link{step_push_deploy}()},
\code{\link{step_run_code}()},
\code{\link{step_setup_push_deploy}()},
\code{\link{step_setup_ssh}()},
\code{\link{step_test_ssh}()},
\code{\link{step_write_text_file}()}
}
\concept{steps}
