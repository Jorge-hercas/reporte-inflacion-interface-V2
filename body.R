
body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "particular",
      box(width = 12,maximizable = T,
          echarts4rOutput("barras_general", height = 290, width = "100%")
          ),
      fluidRow(
        box(width = 5,maximizable = T,echarts4rOutput("bar_lin")),
        box(width = 5,maximizable = T,echarts4rOutput("historico_texto_gr")),
        box(width = 2,maximizable = T,echarts4rOutput("liquid", width = 200))
        
      )
    ),
    tabItem(
      tabName = "forecast",
      box(width = 12, maximizable = T,
          echarts4rOutput("pronostico")
          )
    ),
    tabItem(
      tabName = "other_data",
      box(width = 12, maximizable = T,
          echarts4rOutput("nueva_serie")
      )
    )
  )
)