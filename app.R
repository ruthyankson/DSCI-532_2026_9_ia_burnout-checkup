library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

features <- read_csv(
    "data/ai_productivity_features.csv",
    show_col_types = FALSE
)
targets <- read_csv("data/ai_productivity_targets.csv", show_col_types = FALSE)

df <- left_join(features, targets, by = "Employee_ID")

ui <- fluidPage(
    tags$head(
        tags$link(
            rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600;700;800&display=swap"
        ),
        tags$style(HTML(
            "
            :root {
            --bg-main: #FFFFFF;
            --bg-sidebar: #F4C9A7;
            --text-dark: #4A2C18;
            --accent-1: #C45A1A;
            --accent-2: #E38D53;
            --border-soft: #E6E6E6;
        }

        html, body {
            background-color: var(--bg-main) !important;
            color: var(--text-dark);
            font-family: 'Quicksand', sans-serif;
        }

        .well {
            background-color: var(--bg-sidebar) !important;
            border: 1px solid #fff !important;
            border-radius: 12px !important;
            font-size: 1.15rem;
        }

        .panel-card {
            background: #fff;
            border: 1px solid var(--border-soft);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .panel-card h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        .summary-card {
            background: linear-gradient(135deg, #fff7f1 0%, #ffffff 100%);
            border: 1px solid #f0dccd;
        }

        .summary-text {
            font-size: 1.5rem;
            line-height: 1.7;
            color: var(--text-dark);
        }

        .summary-text strong {
            color: var(--accent-1);
            font-weight: 800;
        }

        .summary-pill {
            display: inline-block;
            margin: 0.2rem 0.35rem 0.2rem 0;
            padding: 0.35rem 0.7rem;
            border-radius: 999px;
            background: #f9e5d6;
            color: #8a4317;
            font-weight: 700;
            font-size: 1.3rem;
        }

        h2, h3, label {
            color: var(--text-dark);
        }

        .card {
            max-width: 100%;
        }

        .card-body {
            overflow: hidden; /* prevents child overflow shadows */
        }

        .table-wrap {
            width: 100%;
            overflow-x: auto;  /* horizontal scroll if needed */
            overflow-y: hidden;
        }

        .table {
            width: 100%;
            table-layout: fixed; /* prevents expanding past container */
            border-collapse: collapse;
        }

        .table th,
        .table td {
            word-wrap: break-word;
            word-break: break-word;
            white-space: normal; /* allow wrapping (or 'pre-wrap' if needed) */
            min-width: 0;
        }
    "))
    ),

    titlePanel("AI Usage and Burnout Checkup"),

    sidebarLayout(
        sidebarPanel(
            h3("Filters"),
            selectInput(
                "job_role",
                "Select Job Role:",
                choices = c("All", sort(unique(df$job_role))),
                selected = "All"
            )
        ),

        mainPanel(
            div(
                class = "panel-card summary-card",
                h3("Summary"),
                htmlOutput("summary_text")
            ),

            div(
                class = "panel-card",
                h3("AI Usage vs Burnout  Risk Score"),
                plotOutput("burnout_scatter")
            ),

            div(
                class = "panel-card",
                h3("Distribution of Burnout Risk Scores"),
                plotOutput("burnout_hist")
            ),

            div(
                class = "panel-card",
                h3("Filtered Employee Records"),
                tableOutput("employee_table")
            )
        )
    )
)

server <- function(input, output, session) {
    filtered_data <- reactive({
        if (input$job_role == "All") {
            df
        } else {
            df %>% filter(job_role == input$job_role)
        }
    })

    output$burnout_scatter <- renderPlot({
        req(nrow(filtered_data()) > 0)

        ggplot(
            filtered_data(),
            aes(
                x = ai_tool_usage_hours_per_week,
                y = burnout_risk_score
            )
        ) +
            geom_point(size = 3, alpha = 0.8, color = "#b15318") +
            labs(
                x = "AI Tool Usage Hours per Week",
                y = "Burnout Risk Score"
            ) +
            theme_minimal(base_family = "Quicksand") +
            theme(
                axis.title = element_text(size = 16, face = "bold"),
                axis.text = element_text(size = 13),
                text = element_text(color = "#4A2C18")
            )
    })

    output$burnout_hist <- renderPlot({
        req(nrow(filtered_data()) > 0)

        ggplot(
            filtered_data(),
            aes(x = burnout_risk_score)
        ) +
            geom_histogram(
                binwidth = 0.5,
                fill = "#E38D53",
                color = "#4A2C18"
            ) +
            labs(
                x = "Burnout Risk Score",
                y = "Count"
            ) +
            theme_minimal(base_family = "Quicksand") +
            theme(
                axis.title = element_text(size = 16, face = "bold"),
                axis.text = element_text(size = 13),
                text = element_text(color = "#4A2C18")
            )
    })

    output$employee_table <- renderTable({
        filtered_data() %>%
            select(
                Employee_ID,
                job_role,
                experience_years,
                ai_tool_usage_hours_per_week,
                burnout_risk_score,
                productivity_score,
                burnout_risk_level
            ) %>%
            head(10)
    })

    output$summary_text <- renderUI({
        fd <- filtered_data()

        avg_burnout <- round(mean(fd$burnout_risk_score, na.rm = TRUE), 2)
        pct_at_10 <- round(
            mean(fd$burnout_risk_score == 10, na.rm = TRUE) * 100,
            1
        )
        avg_ai <- round(mean(fd$ai_tool_usage_hours_per_week, na.rm = TRUE), 1)

        HTML(paste0(
            "<div class='summary-text'>",
            "<p>This filtered group contains <strong>",
            nrow(fd),
            "</strong> employees.</p>",
            "<div>",
            "<span class='summary-pill'>Avg burnout: ",
            avg_burnout,
            "</span>",
            "<span class='summary-pill'>At score 10: ",
            pct_at_10,
            "%</span>",
            "<span class='summary-pill'>Avg AI usage: ",
            avg_ai,
            " hrs/week</span>",
            "</div>",
            "<p>A substantial share of employees reach the maximum burnout score in this view, suggesting a possible ceiling effect in the burnout measure.</p>",
            "</div>"
        ))
    })
}

shinyApp(ui = ui, server = server)
