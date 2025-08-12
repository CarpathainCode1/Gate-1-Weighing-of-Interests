# Gate 1: Assessment of instrumental indispensability — Interactive Shiny App
# Save this file as and run with: shiny::runApp()
# --- C. Berce 2025 --------------------------------------------------------

library(shiny)
library(bslib)
library(glue)

# --- Helpers --------------------------------------------------------------

anchor_choices <- c(
  "Absent / not justified = 0" = 0,
  "Minimal / weak = 1"         = 1,
  "Moderate / partial = 2"     = 2,
  "Strong / robust = 3"        = 3
)

yn_choices <- c("No" = 0, "Yes" = 1)

sev_choices <- c(
  "0 (none)"     = 0,
  "1 (mild)"     = 1,
  "2 (moderate)" = 2,
  "3 (severe)"   = 3
)

interest_choices <- c(
  "Preservation/Protection of life & health (humans/animals)" = "life_health",
  "New knowledge on fundamental biological processes"         = "fundamental",
  "Protection of the natural environment"                     = "environment",
  "Advances in 3R methods (Replace/Reduce/Refine)"            = "3r_methods"
)

nonpath_choices <- c(
  "Excessive instrumentalisation"           = "instrumentalisation",
  "Humiliation / substantial loss of control" = "humiliation",
  "Major interference with appearance/abilities" = "appearance"
)

scale_badge <- function(val) {
  # small badge for the 0–3 scales
  color <- c("#6b7280","#ef4444","#f59e0b","#10b981")[as.integer(val)+1]
  as.character(tags$span(style = glue("display:inline-block;min-width:1.7rem;text-align:center;
                                      border-radius:999px;padding:0.1rem 0.45rem;
                                      font-weight:600;color:white;background:{color};"),
                         val))
}

# READ THIS IF YOU LOOK IN THE SCRIPT:
# Simple scoring rubric:
# - Suitability score = mean of construct/internal/external (0-3)
# - Necessity guardrails: if Replacement available == Yes → auto “Not Justifiable”
# - Strain score = severity (0-3) + 0.5 * (# non-pathocentric)
# - Interest score = (anticipated gain 0-3) * (likelihood 0-3)/3
#   + 0.25 * (# interest categories selected)
# Decision suggestion:
#   If replacement available → "Not Justifiable"
#   else if interest score >= strain score → "FAVOURS approval (proportionate)"
#   else → "DOES NOT favour approval (disproportionate)"

compute_summary <- function(input) {
  suitability <- mean(c(
    as.numeric(input$construct),
    as.numeric(input$internal),
    as.numeric(input$external)
  ), na.rm = TRUE)

  replacement_available <- as.numeric(input$replacement) == 1
  reduction_ok          <- as.numeric(input$reduction) == 1
  refinement_ok         <- as.numeric(input$refinement) == 1

  sev <- as.numeric(input$severity)
  nonpath_n <- length(input$nonpath)
  strain_score <- sev + 0.5 * nonpath_n

  gain <- as.numeric(input$gain)
  likelihood <- as.numeric(input$likelihood)
  interest_n <- length(input$interests)
  interest_score <- (gain * likelihood) / 3 + 0.25 * interest_n

  # decision
  decision <- if (replacement_available) {
    "NOT JUSTIFIABLE — a fit-for-purpose non-animal alternative was indicated (Replace)."
  } else if (interest_score >= strain_score && suitability >= 1.5 && reduction_ok && refinement_ok) {
    "FAVOURS APPROVAL — anticipated gain appears proportionate to strain, with acceptable suitability and application of 3Rs."
  } else if (interest_score >= strain_score) {
    "FAVOURS APPROVAL (conditional) — proportionate on balance; strengthen suitability and 3R implementation."
  } else {
    "DOES NOT FAVOUR APPROVAL — anticipated gain does not outweigh expected strain."
  }

  list(
    suitability      = suitability,
    strain_score     = strain_score,
    interest_score   = interest_score,
    decision         = decision
  )
}

build_narrative <- function(input, summary) {
  title <- if (nzchar(input$title)) input$title else "Untitled project"
  obj   <- if (nzchar(input$objective)) input$objective else "Objective not provided"
  qs    <- if (nzchar(input$questions)) input$questions else "—"

  ints  <- if (length(input$interests)) paste0("• ", paste( interest_choices[names(interest_choices) %in% input$interests], collapse = "\n• "))
  else "—"

  nonp  <- if (length(input$nonpath)) paste0("• ", paste( nonpath_choices[names(nonpath_choices) %in% input$nonpath], collapse = "\n• "))
  else "—"

  glue("
# Weighing of Interests — Summary

**Project:** {title}

1) Experimental objective
- **Objective:** {obj}
- **Questions/Hypotheses:** {qs}

2) Instrumental indispensability
**Suitability (0–3 anchors)**
- Construct validity: {scale_badge(input$construct)}
- Internal validity:  {scale_badge(input$internal)}
- External validity:  {scale_badge(input$external)}
- **Suitability score (mean): {sprintf('%.2f', summary$suitability)}**

**Necessity (3Rs)**
- Replacement available? **{ifelse(as.numeric(input$replacement)==1, 'Yes', 'No')}**
- Reduction measures justified? **{ifelse(as.numeric(input$reduction)==1, 'Yes', 'No')}**
- Refinement measures implemented? **{ifelse(as.numeric(input$refinement)==1, 'Yes', 'No')}**

3) Strain imposed on animals
- **Severity grade:** {sev_choices[as.character(input$severity)]}
- Non-pathocentric elements:\n{nonp}
- **Strain score:** {sprintf('%.2f', summary$strain_score)}

4) Legitimate societal interests & anticipated gain
- Interests served:\n{ints}
- Anticipated gain (0–3): {scale_badge(input$gain)}
- Likelihood of achieving objectives (0–3): {scale_badge(input$likelihood)}
- **Interest score:** {sprintf('%.2f', summary$interest_score)}

5) Overall suggestion
**{summary$decision}**

> Notes:
> - If a validated non-animal alternative exists, the project is not justifiable under Replace.
> - Proportionality reflects whether anticipated knowledge outweighs total strain, assuming sound design and full 3R application.
")
}

# --- UI --------------------------------------------------------------------

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#2563eb",
  base_font = font_google("Inter"),
  heading_font = font_google("Inter Tight")
)

ui <- page_navbar(
  title = "Weighing of Interests — Instrumental Indispensability Checker v0.6",
  theme = app_theme,
  sidebar = NULL,
  nav_panel(
    "Project",
    layout_columns(
      col_widths = c(6,6),
      card(
        card_header("Project info"),
        textInput("title", "Project title", placeholder = "e.g., Targeted therapy response in murine model"),
        textAreaInput("objective", "Objective (Section 20)", placeholder = "Summarise aim, background, anticipated knowledge", rows = 4),
        textAreaInput("questions", "Questions/Hypotheses (Section 22)", placeholder = "List key research questions or hypotheses", rows = 4)
      ),
      card(
        card_header("Quick tips"),
        HTML("<ul style='margin-left:-1rem'>
<li>State a clear research question and hypothesis.</li>
<li>Plan for randomisation, blinding, and pre-specifying analyses.</li>
<li>Document Replace/Reduce/Refine choices.</li>
</ul>")
      )
    )
  ),
  nav_panel(
    "Instrumental indispensability",
    layout_columns(
      col_widths = c(6,6),
      card(
        card_header("Suitability (validity anchors 0–3)"),
        radioButtons("construct", "Construct validity (model-match & measures)", choices = anchor_choices, selected = 2),
        radioButtons("internal",  "Internal validity (bias control, design)",    choices = anchor_choices, selected = 2),
        radioButtons("external",  "External validity (generalisation/replication)", choices = anchor_choices, selected = 1)
      ),
      card(
        card_header("Necessity (3Rs)"),
        radioButtons("replacement", "Is a validated, fit-for-purpose non-animal alternative available (Replace)?", choices = yn_choices, selected = 0),
        radioButtons("reduction",   "Is the sample size and design justified to avoid under/over-use (Reduce)?", choices = yn_choices, selected = 1),
        radioButtons("refinement",  "Have strain-minimising measures been built in (Refine)?", choices = yn_choices, selected = 1),
        helpText("If 'Yes' to Replacement, the app will flag the project as not justifiable.")
      )
    )
  ),
  nav_panel(
    "Strain & severity",
    layout_columns(
      col_widths = c(6,6),
      card(
        card_header("Pathocentric strain"),
        radioButtons("severity", "Prospective severity grade", choices = sev_choices, selected = 2),
        helpText("Severity relates to pain, suffering, harm, anxiety (0–3).")
      ),
      card(
        card_header("Non‑pathocentric strain"),
        checkboxGroupInput("nonpath", "Select any which apply", choices = nonpath_choices),
        helpText("These affect dignity (e.g., excessive instrumentalisation) even when not experienced as pain.")
      )
    )
  ),
  nav_panel(
    "Societal interests & gain",
    layout_columns(
      col_widths = c(6,6),
      card(
        card_header("Legitimate societal interests"),
        checkboxGroupInput("interests", "Select relevant interests served", choices = interest_choices)
      ),
      card(
        card_header("Anticipated knowledge"),
        radioButtons("gain", "Anticipated gain (0–3)", choices = anchor_choices, selected = 2),
        radioButtons("likelihood", "Likelihood objectives will be achieved (0–3)", choices = anchor_choices, selected = 2)
      )
    )
  ),
  nav_panel(
    "Summary",
    layout_columns(
      col_widths = c(7,5),
      card(
        card_header("Auto‑generated narrative"),
        htmlOutput("narrative", container = div, style = "max-width: 900px;")
      ),
      card(
        card_header("Scores"),
        uiOutput("scores"),
        br(),
        downloadButton("dl_report", "Download summary (.txt)", class = "btn btn-primary")
      )
    )
  ),
  footer = div(
    class = "text-center text-muted small py-3",
    HTML("© Cristian Berce 2025 <br>"),
    HTML("This app helps determining instrumental indispensability. It does not replace subject matter expert knowledge")
  )
)

# --- Server ---------------------------------------------------------------

server <- function(input, output, session) {

  summary_vals <- reactive({
    req(input$construct, input$internal, input$external,
        input$replacement, input$reduction, input$refinement,
        input$severity, input$gain, input$likelihood)
    compute_summary(input)
  })

  output$scores <- renderUI({
    s <- summary_vals()
    tags$div(
      tags$p(HTML(glue("<b>Suitability score (0–3):</b> {sprintf('%.2f', s$suitability)}"))),
      tags$p(HTML(glue("<b>Strain score:</b> {sprintf('%.2f', s$strain_score)}"))),
      tags$p(HTML(glue("<b>Interest score:</b> {sprintf('%.2f', s$interest_score)}"))),
      tags$hr(),
      tags$p(HTML(glue("<b>Decision suggestion:</b><br>{s$decision}")))
    )
  })

  output$narrative <- renderUI({
    s <- summary_vals()
    md <- build_narrative(input, s)
    # simple markdown-ish rendering: bold/headers
    HTML(
      md |>
        gsub("^# (.*)$", "<h3>\\1</h3>", x = _, perl = TRUE) |>
        gsub("^## (.*)$", "<h4>\\1</h4>", x = _, perl = TRUE) |>
        gsub("\\*\\*(.*?)\\*\\*", "<b>\\1</b>", x = _, perl = TRUE) |>
        gsub("\\n> (.*)", "<blockquote>\\1</blockquote>", x = _, perl = TRUE) |>
        gsub("\\n\\- ", "<br>&bull; ", x = _, perl = TRUE) |>
        gsub("\\n", "<br>", x = _, perl = TRUE)
    )
  })

  output$dl_report <- downloadHandler(
    filename = function() {
      paste0("weighing_of_interests_", gsub("\\W+", "_", tolower(input$title %||% "project")), ".txt")
    },
    content = function(file) {
      s  <- summary_vals()
      tx <- build_narrative(input, s)
      writeLines(tx, con = file, useBytes = TRUE)
    }
  )
}

shinyApp(ui, server)

