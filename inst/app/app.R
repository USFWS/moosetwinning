## Trying to put together a shiny UI for generating a Quarto report.
## Still needs some work... creates a file without the docx extension.
## Saves it without giving the user the ability to specify the location...


library(shiny)
library(quarto)

ui <- fluidPage(

  titlePanel("Moose Twinning Report"),

  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "refuge", label = "Refuge:"),
      br(),
      downloadButton(outputId = "report", label = "Generate Report:")
    ),
    mainPanel(

    )
  )
)


server <- function(input, output) {
  output$report <- downloadHandler(
    filename = function() {
      paste0("doc_", Sys.Date(), ".docx")
    },

    content = function(file) {
      # temp_file <- tempfile(fileext = ".docx")

      quarto_render(input = "report.qmd",
                    output_file = "report",
                    output_format = "all")

      # quarto::quarto_render("report.qmd",
                            # execute_params = list(refuge = input$refuge),
                            # output_file = temp_file)

      # file.copy(temp_file, file)

    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
