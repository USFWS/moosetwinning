
#' Create tables for moose twinning survey reports
#'
#' @param dat data frame containing moose twinning data, returned by [moosetwinning::import_format()]
#'
#' @return a list of flextable objects
#'
#' @import flextable
#' @import dplyr
#' @importFrom magrittr %>%
#' @import lubridate
#' @export
#'
#' @examples
#' \dontrun{
#' tbls <- create_tbls(dat)
#' }
create_tbls <- function(dat) {

  ## Table 1
  t1 <- dat |>
    dplyr::mutate(Year = as.character(lubridate::year(srvy_day))) |>
    dplyr::select(-c(srvy_day, leafout, group, latitude, longitude, pilot, observer, nabevw)) |>
    dplyr::relocate(Year, .before = 1) |>
    dplyr::rename(Bulls = bull,
                  "Yearlings" = yrlcow,
                  "No calf" = cow0clf,
                  "One calf" = cow1clf,
                  "Twins" = cow2clf,
                  "Triplets" = cow3clf) |>
    dplyr::group_by(Year) |>
    dplyr::summarize_all(sum) |>
    dplyr::ungroup() %>%
    dplyr::bind_rows(summarise(.,
                               across(where(is.numeric), sum),
                               across(where(is.character), ~"Total"))) |>
    dplyr::mutate(Total = rowSums(across(where(is.numeric))))

  tbl1 <- flextable::flextable(t1) |>
    add_header_row(values = c(
      "Year",
      "Bulls",
      rep("Cow moose", ncol(t1) - 3),
      "Total")) |>
    merge_h(part = "header") |>
    merge_v(part = "header") |>
    valign(valign = "bottom", part = "header") |>
    align(align = "center", part = "all") |>
    footnote(i = 1, j = 8,
             value = as_paragraph("Total adults and yearlings; does not include calves"),
             ref_symbols = c("a"),
             part = "header",
             inline = T)

  # Table 2
  t2 <- twinning_rates(dat) |>
    dplyr::mutate(yr = dplyr::case_when(yr == "overall" ~ "Overall multiyear",
                                        yr == "eastern" ~ "Eastern multiyear",
                                        yr == "western" ~ "Western multiyear",
                                        .default = yr)) |>
    dplyr::mutate(ci = paste0(round(ci_l, 3), "--", round(ci_u, 3))) |>
    dplyr::select(-c(ci_l, ci_u))

  tbl2 <- flextable::flextable(t2) |>
    set_header_labels(values = c("Year", "n", "Twinning rate", "SE", "90% CI")) |>
    autofit() |>
    align(align = "center", part = "all") |>
    colformat_double(j = "se",
                     digits = 3) |>
    colformat_double(j = "t",
                     digits = 2) |>
    italic(j = "n", part = "header")

  tbls <- list(tbl1 = tbl1,
               tbl2 = tbl2)

  return(tbls)
}
