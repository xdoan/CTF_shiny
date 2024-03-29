library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(
    title = "CTF Summary Dashboard",
    titleWidth = 350 #,
    # header=list(tags$head(includeScript("www/readCookie.js"))),
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("CTF at a Glance", tabName = "kp_overview", 
               icon = icon("dashboard")),
      menuItem("CTF Details", tabName = "consortium_summaries", 
               icon = icon("bar-chart")),
      menuItem("CTF Over Time", tabName = "kp_trends",
               icon = icon("line-chart")),
      menuItem("Study Summaries", tabName = "center_summaries",
               icon = icon("list"))
    )
  ),
  dashboardBody(
    tags$head(
      singleton(
        includeScript("~/ShinyApps/CTF_shiny/www/readCookie.js")
      ),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "kp_overview",
              fluidRow(
                infoBoxOutput("centersBox", width = 3) %>%  ### changed to studies
                  shinycssloaders::withSpinner(proxy.height = "125px"),
                infoBoxOutput("filesBox", width = 3),
                infoBoxOutput("samplesBox", width = 3),
                infoBoxOutput("pubsBox", width = 3)
              ),
              fluidRow(
                box(
                  title = "Study Content by Consortium", width = 12, height = 250,
                  solidHeader = FALSE, status = "warning",
                  fluidRow(
                    column(width = 2, #offset = 8,
                           div(class = "orange-square"),
                           span(style = "font-size:12px", p("CTF Biobank"))
                    ),
                    column(width = 2,
                           div(class = "lblue-square"),
                           span(style = "font-size:12px", p("NF-OSI"))
                    ),
                    column(width = 2,
                           div(class = "green-square"),
                           span(style = "font-size:12px", p("Synodos"))
                    ),
                    column(width = 2,
                           div(class = "gray-square"),
                           span(style = "font-size:12px", p("NA"))
                    )
                  ),
                  column(width = 3, pierOutput("consortium_files")),
                  column(width = 3, pierOutput("consortium_studies")),
                  column(width = 3, pierOutput("consortium_cancers")),
                  column(width = 3, pierOutput("consortium_data"))
                )
              ),
              fluidRow(
                box(
                  title = "Study Activity", width = 12, height = 675,
                  solidHeader = FALSE, status = "warning",
                  plotly::plotlyOutput("kp_activity", 
                                       height = "600px")
                )
              )
      ),
      tabItem(tabName = "consortium_summaries",
              fluidRow(
                box(
                  title = "Summary Snapshot", width = 12,
                  status = "primary", height = 400,
                  div(style = 'overflow-x: scroll', 
                      plotly::plotlyOutput('consortium_summary') %>% 
                        shinycssloaders::withSpinner()
                  )
                )
              ),
              fluidRow(
                box(
                  width = 3, status = "primary",
                  radioButtons("sample_type",
                               label = "Sample Type",
                               choices = config$sampletype_display,
                               selected = "individualID"),
                  selectInput("sample_group_select", 
                              label = "Annotation Key 1\n(y-axis split)",
                              choices = config$annotationkey_display,
                              selected = "tumorType"),
                  selectInput("sample_fill_select", 
                              label = "Annotation Key 2\n(fill color)",
                              choices = config$annotationkey_display,
                              selected = "assay")
                ),
                box(
                  title = "Sample Breakdown", width = 9,
                  status = "warning",
                  plotly::plotlyOutput("annotationkey_counts", height = "100%") %>% 
                    shinycssloaders::withSpinner()
                  
                )
              )
      ),
      tabItem(tabName = "kp_trends",
              fluidRow(
                box(
                  width = 3, status = "primary",
                  selectInput("sg_facet", label = "Group files by:",
                              choices = config$annotationkey_display, 
                              selected = "projectId"),
                  radioButtons("sg_cumulative", 
                               label = "Aggregation:",
                               choiceNames = c(
                                 "Month-by-month", 
                                 "Cumulative"
                               ),
                               choiceValues = c(FALSE, TRUE),
                               selected = TRUE)
                ),
                box(
                  title = "Files Added", width = 9, height = 500,
                  status = "warning",
                  plotly::plotlyOutput("files_per_month") %>% 
                    shinycssloaders::withSpinner()
                  
                )
              )
      ),
      tabItem(tabName = "center_summaries",
              fluidRow(
                box(
                  title = "Study Snapshot", width = 12,
                  status = "primary",
                  div(style = 'overflow-x: scroll', 
                      DT::dataTableOutput('center_summary')
                  )
                )
              ),
              fluidRow(
                box(
                  title = "Study Details", width = 4, height = 500,
                  solidHeader = FALSE, status = "info",
                  textOutput("center_name_msg"),
                  h4(strong(textOutput("center_name"))),
                  tableOutput("center_metadata")
                ),
                box(
                  title = "Study Data", width = 8, height = 500,
                  solidHeader = FALSE, status = "warning",
                  plotly::plotlyOutput("center_details")
                )
              ),
              fluidRow(
                box(
                  width = 4, status = "primary",
                  selectInput("sb_facet", label = "Group files by:",
                              choices = config$annotationkey_display2, 
                              selected = "projectId"),
                  radioButtons("sb_cumulative", 
                               label = "Aggregation:",
                               choiceNames = c(
                                 "Month-by-month", 
                                 "Cumulative"
                               ),
                               choiceValues = c(FALSE, TRUE),
                               selected = TRUE)
                ),
                box(
                  title = "Files Added", width = 8, height = 500,
                  status = "warning",
                  plotly::plotlyOutput("center_files_per_month") %>% 
                    shinycssloaders::withSpinner()
                  
                )
            )
      )
    )
  )
))
