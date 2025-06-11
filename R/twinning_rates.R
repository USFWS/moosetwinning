
#' Calculate moose twinning rates
#'
#' @description Creates a data frame containing the number of moose groups (n), twinning rates (t), standard errors (se) and 90% CIs (ci_l and ci_u) for each survey year, overall, and overall at each sub-unit.
#'
#' @param dat a data frame containing moose twinning data, returned by [moosetwinning::import_format()]
#'
#' @return a data frame containing annual and multiyear twinning rates
#'
#' @import dplyr
#' @export
#'
#' @examples
#' \dontrun{
#' dat_sum <- twinning_rates(dat)
#' }
twinning_rates <- function(dat) {

  # Calculate annual moose twinning rates
  ## Annual
  annual <- dat |>
    dplyr::mutate(yr = year(srvy_day)) |>
    dplyr::group_by(yr) |>
    dplyr::summarize(mc = sum(cow1clf, na.rm = T),
                     mt = sum(cow2clf, na.rm = T)) |>
    dplyr::ungroup() |>
    dplyr::mutate(t = mt/(mc+mt)) |>
    dplyr::rowwise() |>
    dplyr::mutate(n = sum(mt + mc),
                  se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    dplyr::mutate(ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
                  ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    dplyr::mutate(yr = as.character(yr)) |>
    dplyr::select(yr, n, t, se, ci_l, ci_u)


  ## Overall multiyear
  multiyear <- dat |>
    dplyr::summarize(mc = sum(cow1clf, na.rm = T),
                     mt = sum(cow2clf, na.rm = T)) |>
    dplyr::rowwise() |>
    dplyr::mutate(n = sum(mt + mc),
                  se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    dplyr::mutate(t = mt/(mc+mt),
                  ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
                  ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    dplyr::mutate(yr = "overall") |>
    dplyr::select(yr, n, t, se, ci_l, ci_u)

  ## Eastern and western multiyears
  multiyear_ew <- dat |>
    dplyr::group_by(nabevw) |>
    dplyr::rename(yr = nabevw) |>
    dplyr::summarize(mc = sum(cow1clf, na.rm = T),
                     mt = sum(cow2clf, na.rm = T)) |>
    dplyr::ungroup() |>
    dplyr::rowwise() |>
    dplyr::mutate(n = sum(mt + mc),
                  se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    dplyr::mutate(t = mt/(mc+mt),
                  ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
                  ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    dplyr::mutate(yr = dplyr::case_when(yr == "East" ~ "eastern",
                                        yr == "West" ~ "western")) |>
    dplyr::select(yr, n, t, se, ci_l, ci_u)

  ## Join them  (rbind causes R to crash)
  dat_sum <- bind_rows(annual, multiyear, multiyear_ew) |>
    dplyr::ungroup() |>
    dplyr::mutate(ci_l = case_when(ci_l <= 0 ~ 0,  # Make lower CIs that are <0 -> 0
                                   .default = ci_l))
}
