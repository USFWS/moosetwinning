
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
    mutate(yr = year(srvy_day)) |>
    group_by(yr) |>
    summarize(mc = sum(cow1clf, na.rm = T),
              mt = sum(cow2clf, na.rm = T)) |>
    ungroup() |>
    mutate(t = mt/(mc+mt)) |>
    rowwise() |>
    mutate(n = sum(mt + mc),
           se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    mutate(ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
           ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    mutate(yr = as.character(yr)) |>
    select(yr, n, t, se, ci_l, ci_u)


  ## Overall multiyear
  multiyear <- dat |>
    summarize(mc = sum(cow1clf, na.rm = T),
              mt = sum(cow2clf, na.rm = T)) |>
    rowwise() |>
    mutate(n = sum(mt + mc),
           se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    mutate(t = mt/(mc+mt),
           ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
           ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    mutate(yr = "overall") |>
    select(yr, n, t, se, ci_l, ci_u)

  ## Eastern and western multiyears
  multiyear_ew <- dat |>
    group_by(nabevw) |>
    rename(yr = nabevw) |>
    summarize(mc = sum(cow1clf, na.rm = T),
              mt = sum(cow2clf, na.rm = T)) |>
    ungroup() |>
    rowwise() |>
    mutate(n = sum(mt + mc),
           se = sd(c(rep(0, times = mc), rep(1, times = mt))) / sqrt(n)) |>
    mutate(t = mt/(mc+mt),
           ci_l = t - 1.645*sqrt((t*(1-t)) / (mc+mt)),
           ci_u = t + 1.645*sqrt((t*(1-t)) / (mc+mt))) |>
    mutate(yr = case_when(yr == "East" ~ "eastern",
                          yr == "West" ~ "western")) |>
    select(yr, n, t, se, ci_l, ci_u)

  ## Join them  (rbind causes R to crash)
  dat_sum <- bind_rows(annual, multiyear, multiyear_ew) |>
    ungroup() |>
    mutate(ci_l = case_when(ci_l <= 0 ~ 0,  # Make lower CIs that are <0 -> 0
                            .default = ci_l))
}
