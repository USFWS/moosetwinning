#' Moose twinning data for Tetlin National Wildlife Refuge
#'
#' A dataset containing observations of moose during moose twinning surveys at
#' National Wildlife Refuge (https://iris.fws.gov/APPS/ServCat/Reference/Profile/179584).
#' The variables are as follows:
#'
#' @format A data frame with 501 rows and 14 variables:
#' \describe{
#'   \item{srvy_day}{date of the survey (2021-05-29--2024-05-31)}
#'   \item{leafout}{percent emergence of leaves for deciduous shrubs and trees (60--75)}
#'   \item{group}{group number or waypoint from field form}
#'   \item{latitude}{Y coordinate: Decimal degrees to 6 decimal places; WGS84}
#'   \item{longitude}{X coordinate: Decimal degrees to 6 decimal places; WGS84}
#'   \item{bull}{number of bulls observed in group (0--5)}
#'   \item{yrlcow}{number of yearling cows observed in group (0--3)}
#'   \item{cow0clf}{number of cows with no calves observed in group (0--5)}
#'   \item{cow1clf}{number of cows with a single calf observed in group (0--2)}
#'   \item{cow2clf}{number of cows with twins observed in group (0--1)}
#'   \item{cow3clf}{number of cows with three calves observed in group (0--0)}
#'   \item{pilot}{first and last name of the pilot}
#'   \item{observer}{first and last name of the observer}
#'   \item{nabevw}{name of the survey sub-unit (East, West)}
#' }
"moose_twinning"
