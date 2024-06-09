#' Create a Project with Standard Directories and Initialize Git
#'
#' @param name The name of the main folder to create.
#' @param root.dir The root directory where the project will be created.
#' @param gh Logical indicating whether to set up a GitHub repository.
#' @export
kick_project <- function(name,
                         root.dir = rstudioapi::readRStudioPreference("initial_working_directory", FALSE),
                         gh = TRUE) {

  usethis::create_project(file.path(root.dir, name), open = FALSE)
  usethis::local_project(file.path(root.dir, name), force = FALSE)
  usethis::use_readme_md(open = FALSE)

  fs::dir_create("data/data-raw")
  fs::dir_create("data/data-processed")
  fs::dir_create("data/db")
  fs::dir_create("code/functions")
  fs::dir_create("code/data-processing")
  fs::dir_create("code/eda")
  fs::dir_create("code/analysis")
  fs::dir_create("output/figs")
  fs::dir_create("output/html")
  fs::dir_create("output/pdf")
  fs::dir_create("assets")
  fs::dir_delete("R")

  usethis::use_git_ignore(c(".Rproj.user", ".Rhistory", ".Rdata",
                            ".httr-oauth", ".DS_Store", ".quarto"))

  gert::git_init(usethis::proj_get())
  gert::git_add(dplyr::pull(gert::git_status(), file))
  gert::git_commit_all("initial commit")

  usethis::use_git("initial commit")

  if (isTRUE(gh)) {
    usethis::use_github()
  }

  rstudioapi::openProject(paste0(name, ".Rproj"), newSession = TRUE)
}

#' Create a Tidy Project Directory Structure
#'
#' @param name The name of the main folder to create.
#' @export
kick_tidy <- function(name) {
  main_folder <- name
  fs::dir_create(glue::glue('{main_folder}/data/'))
  fs::dir_create(glue::glue('{main_folder}/code/'))
}
