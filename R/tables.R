
#' Create tables for moose twinning survey report
#'
#' @param dat a data frame containing moose twinning data, returned by [twinning::import_format()]
#'
#' @return a list of flextable objects
#'
#' @import flextable
#' @import dplyr
#' @import lubridate
#' @export
#'
#' @examples
#' \dontrun{
#' tbls <- create_tbls(dat)
#' }
create_tbls <- function(dat) {
  library(flextable)

  ## Table 1
  t1 <- dat |>
    mutate(Year = as.character(year(srvy_day))) |>
    select(-c(srvy_day, leafout, group, latitude, longitude, pilot, observer, nabevw)) |>
    relocate(Year, .before = 1) |>
    rename(Bulls = bull,
           "Yearlings" = yrlcow,
           "No calf" = cow0clf,
           "One calf" = cow1clf,
           "Twins" = cow2clf,
           "Triplets" = cow3clf) |>
    group_by(Year) |>
    summarize_all(sum) |>
    ungroup() %>%
    bind_rows(summarise(.,
                        across(where(is.numeric), sum),
                        across(where(is.character), ~"Total"))) |>
    mutate(Total = rowSums(across(where(is.numeric))))

  tbl1 <- flextable(t1) |>
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
    mutate(yr = case_when(yr == "overall" ~ "Overall multiyear",
                          yr == "eastern" ~ "Eastern multiyear",
                          yr == "western" ~ "Western multiyear",
                          .default = yr)) |>
    mutate(ci = paste0(round(ci_l, 3), "--", round(ci_u, 3))) |>
    select(-c(ci_l, ci_u))

  tbl2 <- flextable(t2) |>
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
