#' Create a new directory with the moose twinning survey report template
#'
#' \code{create_quarto_doc} creates a new subdirectory inside the current directory, which will
#' contain the ready-to-use Quarto file and all associated files. The Word and PDF templates are
#' based on the standard template of the Alaska Refuge Report Series.
#'
#' @param dir_name a directory path to save the output
#' @param folder_name the name of the folder in which to save the template files
#'
#' @return A folder containing files required to render a Quarto MS Word doc; including a MS Word template for a refuge report, a skeleton qmd file, bibligraphy bib files, and images needed for the refuge report template.
#'
#' @import cli
#' @import usethis ui_yeah
#' @export
#'
#' @examples
#' \dontrun{
#'  # Create template for Word document
#'  get_report_template(dir_name = "twinning_report")
#' }
get_report_template <- function(dir_name = getwd(),
                                folder_name = "quarto") {

  # Copy all files and subfolders in the skeleton folder into a new folder
  file.copy(from = system.file(file.path("quarto"), package = "moosetwinning"),
            to = dir_name,
            overwrite = TRUE,
            recursive = TRUE)
  # Rename the directory
  file.rename(file.path(dir_name, "quarto"), file.path(dir_name, folder_name))
  # Rename the skeleton.qmd
  file.rename(from = file.path(dir_name, folder_name, "skeleton.qmd"),
              to = file.path(dir_name, folder_name, paste0("report.qmd")))
}


#' Render a moose twinning report using Quarto
#'
#' @param dat_in a directory path to a CSV file containing moose twinning data (see https://iris.fws.gov/APPS/ServCat/Reference/Profile/179584)
#' @param dir_name a directory path to save the output
#' @param folder_name the name of the folder in which to save the template files
#'
#' @return a skeleton moose twinning report rendered from Quarto; including plots, tables and summary statistics. You will need to update this file with any discussion or interpretation of the results.
#'
#' @import quarto
#' @import cli
#' @import usethis
#' @export
#'
#' @examples
#' \dontrun{
#' create_report(dat_in = paste0(system.file("extdata", package = "moosetwinning"), "/dat.csv"))
#' }
create_report <- function(dat_in = paste0(system.file("extdata",
                                                      package = "moosetwinning"),
                                          "/dat.csv"),
                          dir_name = getwd(),
                          folder_name = "quarto") {

  # Copy the Quarto report template files into the working directory
  if (file.exists(file.path(dir_name, folder_name))) {
    cli::cli_alert_warning(paste0("Your working directory already contains a folder called ",
                                  folder_name, "."))
    if (usethis::ui_nope("Do you want to overwrite it?",
                         yes = "Yes, I want it gone!",
                         no = "No, I want to keep it.")) {
      return(cli::cli_alert("Quit"))
    }
  }

  moosetwinning::get_report_template(dir_name, folder_name)

  # Render a report
  quarto::quarto_render(
    input = file.path(dir_name, folder_name, "report.qmd"),
    output_format = "docx",
    output_file = "report.docx",
    execute_params = list(dat_in = dat_in))
}
