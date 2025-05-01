
#' Format Tetlin moose twinning survey for ServCat
#'
#' @param dat_in a file path to a csv containing moose survey data
#' @param boms whether to add required BOMS event observation identifiers https://iris.fws.gov/APPS/ServCat/Reference/Profile/153885
#'
#' @param dat_in a file directory path to a CSV file containing moose twinning observation data
#' @param boms TRUE or FALSE, indicating whether to add required Biological Observation Minimum Specifications fields to the dataframe
#'
#' @return a data frame
#'
#' @import dplyr
#' @import lubridate
#'
#' @export
#'
#' @examples
#' \dontrun{
#' dat <- import_format(dat_in = "./data/dat.csv", boms = T)
#' }
import_format <- function(dat_in,
                          boms = FALSE,
                          replace_nas = FALSE) {
  ## Import the data
  dat <- read.csv(file = dat_in)

  ## Format the data
  dat <- dat |>
    mutate(srvy_day = as.Date(srvy_day, format = "%m/%d/%Y"),
           group = as.factor(group)) |>
    mutate(latitude = case_when(latitude == "." ~ NA,
                                .default = latitude),
           longitude = case_when(longitude == "." ~ NA,
                                 .default = longitude)) |>
    mutate(latitude = as.numeric(latitude),
           longitude = as.numeric(longitude)) |>
    mutate(pilot = as.factor(pilot),
           observer = as.factor(observer),
           nabevw = as.factor(nabevw))

  # Remove derived fields
  dat <- dat |>
    select(-c(TARGET_FID, srvy_yr, obs_id, adyrtot, calftot, adcowtot, all_cows))

  dat <- dat |>
    rename(bull = bulls)

  if (boms) {
    # Add required BOMS identifiers
    dat <- dat |>
      mutate(institutionCode = "USFWS",
             institutionID = "FF07RTET00",
             datasetName = "Moose Twinning Survey Data at Tetlin National Wildlife Refuge",
             datasetID = "https://iris.fws.gov/APPS/ServCat/Reference/Profile/179584",
             collectionCode = "FF07RTET00-101",
             collectionID = "https://iris.fws.gov/APPS/ServCat/Reference/Profile/145850",
             accessRights = "public",
             informationWithheld = "none",
             year = year(srvy_day),
             samplingProtocol = "Site-Specific Protocol for Monitoring Moose Twinning, Tetlin National Wildlife Refuge",
             basisOfRecord = "Visual Report (Seen)",
             eventID = paste0("TET-MOOSETWINNING-", gsub("-", "", format_ISO8601(srvy_day))),
             eventDate = paste0(year(srvy_day),"-", format.Date(srvy_day, "%m"), "-", format.Date(srvy_day, "%d")),
             recordedBy = observer,
             identifiedBy = observer,
             occurrenceID = paste0("TET-MOOSETWINNING-", gsub("-", "", format_ISO8601(srvy_day)), "-", group),
             occurrenceStatus = "present",
             taxonID = "tsn:898198",
             fwsTaxonCode = 180703,
             scientificName = "Alces americanus (Clinton, 1822)",
             vernacularName = "Moose",
             locationID = nabevw,
             locality = "Tetlin National Wildlife Refuge",
             decimalLatitude = latitude,
             decimalLongitude = longitude,
             geodeticDatum = "WGS84",
             georeferenceSources = "GPS receiver") |>
      select(-group, -observer, -srvy_day, -latitude, -longitude) |>  # Remove duplicative fields
      relocate(leafout, pilot, nabevw, bull, yrlcow, cow0clf,
              cow1clf, cow2clf, cow3clf, .after = last_col())
  }

  if (replace_nas) {
    # Replace NAs with blanks
    dat <- replace(dat, is.na(dat), "")
  }

  dat
}

