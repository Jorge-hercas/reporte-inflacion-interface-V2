
dashboardPage(
  dark = F,
  fullscreen = T,
  scrollToTop = T,
  header = dashboardHeader(
    compact = T,
    sidebarIcon = icon("house"),
    controlbarIcon = icon("wrench"),
    skin = "dark",
    status = "navy"
  ),
  body = body,
  sidebar = dashboardSidebar(
    status = "navy",
    collapsed = F,
    minified = T,
    elevation = 4,
    fixed = T,
    skin = "dark",
    bs4SidebarUserPanel("Reporte de inflación",
                        image = "https://images.ctfassets.net/ta4ffdi8h2om/5f606e1AVaoQvr1CHAKdoR/af9632c2950504d0287c88fb9010ded7/AdvancedAnalytics-Accordion.png?w=1200&h=1000&fm=webp&q=75"),
    sidebarMenu(
      id = "current_tab",
      sidebarHeader("Menú"),
      menuItem(
        "Panel general",
        tabName = "particular",
        icon = icon("database")
      ),
      menuItem(
        startExpanded = T,
        "Otra información",
        tabName = "vend",
        icon = icon("bars"),
        menuSubItem(
          "Pronósticos",
          tabName = "forecast",
          icon = icon("chart-line")
        ),
        menuSubItem(
          "Otras variables",
          tabName = "other_data",
          icon = icon("chart-pie")
        )
      )
    )
  ),
  controlbar = dashboardControlbar(
    skin = "light",
    collapsed = TRUE,
    width = 350,
    id = "controlbar",
    controlbarMenu(
      id = "menu",
      controlbarItem(
        "Filtros",
        "Filtros generales:",
        br(),br(),
        column(width = 12, align = "center",
               airDatepickerInput(
                 view = "years",
                 minView = "years",
                 inputId = "fechas", label = "Rango de fechas a visualizar",
                 range = T, multiple = T,
                 value = c(min(datos$date),max(datos$date))
               ),pickerInput(
                 "red_fechas","¿Quieres redondear fechas?",
                 choices = c(
                   "Mensual" = "months",
                   "Bimestral" = "bimonth",
                   "Cuatrimestre" = "quarter",
                   "Medio año" = "halfyear",
                   "Anual" = "year"
                 ),
                 selected = "months"
               ),pickerInput(
                 "dif_perc","Tipo de dif perc. a visualizar",
                 choices = c(
                   "Mensuales anualizados",
                   "Quincenales anualizados",
                   "Mensuales con respecto al último dato anterior",
                   "Quincenales con respecto al último dato anterior"
                 ),
                 selected = "months"
               ),
               br(),
               actionButton("in_plot", "Generar gráfico", icon = icon("chart-line")),
               br(),br(),
               prettyRadioButtons(
                 inputId = "boton_sub",
                 label = "Tipo de inflación:",
                 status = "success",
                 inline = TRUE,
                 choices = c("Subyacente", "No subyacente")
               ))
      ),controlbarItem(
        "Pronóstico",
        "Selectores para pronóstico:",
        br(),br(),
        column(width = 12, align = "center",
               pickerInput("inf_tipo", "Tipo de inflación a pronosticar", choices = c("Subyacente", "No subyacente")
               ),
               sliderInput("periodos", "Periodos a pronosticar", value = 12,
                           min = 1, max = 40
               ),
               awesomeRadio("modelo", "Modelo a utilizar", choices = c("ARIMA", "BATS"), inline = T)
               )
      ),
      controlbarItem(
        "Otras variables",
        "Otros datos:",
        br(),br(),
        column(width = 12, align = "center",
               pickerInput("otraserie", "Otras series disponibles", choices = series$Serie),
               br(),br(),
               actionButton("graficar_otras", "Graficar", icon = icon("line-chart") )
        )
      )
    )
  ),
  footer = dashboardFooter()
)













