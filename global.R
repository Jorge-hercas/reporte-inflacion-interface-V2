
library(shiny)
library(particlesjs)
library(bs4Dash)
library(shinythemes)
library(shiny)
library(readxl)
library(echarts4r)
library(tibble)
library(reactable)
library(globe4r)
library(data.table)
library(dtplyr)
library(dplyr, warn.conflicts = FALSE)
library(dtplyr)
library(forecast)
library(htmltools)
library(shinyWidgets)
library(ggplot2)
library(ggfortify)
library(lubridate)
library(shinymanager)
library(mapboxer)
library(shinymaterial)
library(siebanxicor)


source("body.R")

setToken("ed753930baf67bff05f52150712bb82a155a2978ea1b2c2800bed51a8dba72f1")
subyacente <- 
  getSerieDataFrame(getSeriesData(c("SP74660"), 
                                  as.Date('1950-01-01'),
                                  today() %m+% years(1)), 
                    c("SP74660"))
no_subyacente <- 
  getSerieDataFrame(getSeriesData(c("SP74663"), 
                                  as.Date('1950-01-01'),
                                  today() %m+% years(1)), 
                    c("SP74663"))

datos <- 
  subyacente |> 
  rename(subyacente = value) |> 
  left_join(
    no_subyacente |> 
      rename(
        no_subyacente = value
      )
  )

#source("componentes data.R")

series <- tibble(
  Serie = c("TIIE","TIIE 28 días",
            "TIIE 91 días","TIIE 182 días","Tasa objetivo",
            "Tipo de cambio FIX","Incremento salarial contractual",
            "Salario mínimo","Tasa de desempleo"),
  ID = c("SF331451","SF43783",
         "SF43878","SF111916","SF61745","SF17906","SL138","SL11298",
         "SL1")
)


datos_globo <- data.frame(
  codigo = c("MEX" ),
  pais = c("México"),
  lat =c(23.6345),
  lon =c(-102.5528),
  val = c(1)
)



