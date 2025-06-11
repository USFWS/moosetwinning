#' Create a new directory with the moose twinning survey report template
#'
#' \code{create_quarto_doc} creates a new subdirectory inside the current directory, which will
#' contain the ready-to-use Quarto file and all associated files. The Word and PDF templates are
#' based on the standard template of the Alaska Refuge Report Series.
#'
#' @param dirname character; the name of the directory to create.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  # Create template for Word document
#'  get_report_template(dirname = "twinning_report")
#' }
get_report_template <- function(dirname = "quarto") {

  tmp_dir <- paste(dirname, "_tmp", sep = "")
  if (file.exists(dirname) || file.exists(tmp_dir)) {
    stop(paste("Cannot run get_report_template() from a directory already containing",
               dirname, "or", tmp_dir))
  }
  dir.create(tmp_dir)

  # Get all file names in the template folder
  list_of_files <- list.files(
    system.file(file.path("quarto"),
                package = "moosetwinning"))

  # Copy all files and subfolders in the skeleton folder into a new folder
  for (i in seq_along(list_of_files)) {
    file.copy(system.file(file.path("quarto", list_of_files[i]), package = "moosetwinning"),
              file.path(tmp_dir),
              recursive = TRUE)
  }

  file.rename(tmp_dir, dirname)
  file.rename(file.path(dirname, "skeleton.qmd"), file.path(dirname, paste0("report.qmd")))
  unlink(tmp_dir, recursive = TRUE)

}


#' Render a moose twinning report using Quarto
#'
#' @param dat_in a directory path to a CSV file containing moose twinning data (see https://iris.fws.gov/APPS/ServCat/Reference/Profile/179584)
#' @param dirname the name of a project directory in which to save the quarto report
#'
#' @return a Word doc
#'
#' @import quarto
#' @export
#'
#' @examples
#' \dontrun{
#' create_report(dat_in = paste0(system.file("extdata", package = "moosetwinning"), "/dat.csv"))
#' }
create_report <- function(dat_in = paste0(system.file("extdata", package = "moosetwinning"), "/dat.csv"),
                          dirname = "quarto"
) {

  # Copy the Quarto report template files into the working directory
  moosetwinning::get_report_template(dirname)

  # Render a report
  quarto::quarto_render(
    input = paste0("./", dirname, "/", "report.qmd"),
    output_format = "docx",
    output_file = "report.docx",
    execute_params = list(dat_in = dat_in))
}
