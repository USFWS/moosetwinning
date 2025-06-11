
#' Create figures for moose twinning survey report
#'
#' @param dat a data frame containing moose twinning data, returned by [moosetwinning::import_format()]
#'
#' @return a list of ggplot objects summarizing moose twinning rates by year and across survey areas
#'
#' @import stringr
#' @import ggplot2
#' @import dplyr
#' @export
#'
#' @examples
#' \dontrun{
#' figs <- create_figs(dat)
#' }
create_figs <- function(dat) {

  # Figure 2
  fig2 <- twinning_rates(dat) |>
    dplyr::filter(!yr %in% c("overall", "eastern", "western")) |>  # remove multiyear data
    ggplot2::ggplot(aes(yr, t)) +
    geom_point(size = 2.5) +
    geom_text(aes(y = ci_u, label = n), nudge_y = 0.03) +
    geom_errorbar(aes(ymin = ci_l, ymax = ci_u),
                  width = 0.2) +
    labs(x = "Year", y = "Twinning rate") +
    theme_classic()

  # Figure 3
  fig3 <- twinning_rates(dat) |>
    dplyr::filter(yr %in% c("overall", "eastern", "western")) |>  # keep only multiyear data
    dplyr::mutate(yr = stringr::str_to_title(yr)) |>
    ggplot2::ggplot(aes(yr, t)) +
    geom_point(size = 2.5) +
    geom_text(aes(y = ci_u, label = n), nudge_y = 0.03) +
    geom_errorbar(aes(ymin = ci_l, ymax = ci_u),
                  width = 0.2) +
    labs(x = "Study area", y = "Twinning rate") +
    theme_classic()

  figs <- list(fig2 = fig2,
               fig3 = fig3)

  return(figs)

}
