get_head_commit <- function(branch) {
  if (git2r::is_commit(branch)) {
    return(branch)
  }
  git2r::lookup(branch@repo, git2r::branch_target(branch))
}
