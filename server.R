

function(input, output, session){
  
  output$main_page <- renderUI({
    if (shinybrowser::get_device() == "Mobile"){
    }else{
    }
  })
  
  
  
  output$barras_general <- renderEcharts4r({
    
    subyacente |> 
      rename(subyacente = value) |> 
      left_join(no_subyacente |> 
                  rename(no_subyacente = value), by = c("date" = "date")) |> 
      e_charts(date) |> 
      e_line(subyacente, symbol = "none") |> 
      e_line(no_subyacente, symbol = "none") |> 
      e_theme("auritus") |> 
      e_legend(bottom = 0) |> 
      e_tooltip(trigger = "axis") |> 
      e_title(left = "center", text = "Evolución de la inflación en MX",
              textStyle = list(
                color = "gray",
                fontFamily = "Roboto Condensed"
              )
      ) |> 
      e_y_axis(show = F) |> 
      e_legend(bottom = 20, textStyle = list(fontFamily = "Roboto Condensed", 
                                             color = "gray",
                                             fontSize = 12)) 
    
  })
  
  
  
  
  
  
  
  output$liquid <- renderEcharts4r({
    
    if (input$boton_sub == "Subyacente"){
      val <- tibble(
        var = c(tail(subyacente$value,1), tail(subyacente$value,1)/1.3)
      )
    }else{
      val <- tibble(
        var = c(tail(no_subyacente$value,1), tail(no_subyacente$value,1)/1.3)
      )
    }
    
    val |> 
      e_charts(dispose = FALSE) |> 
      e_liquid(var,
               backgroundStyle = list(color = "#c5c9c6"),
               amplitude = 20,
               radius = "90%",
               outline = FALSE)
    
  })
  
  
  output$mapa <- renderGlobe({
    
    create_globe(height = "100vh") |> 
      globe_choropleth(
        coords(
          country = codigo,
          altitude = val,
          cap_color = val
        ), 
        data = datos_globo
      ) |> 
      scale_choropleth_cap_color(palette = RColorBrewer::brewer.pal(9,"Reds" )) |> 
      scale_choropleth_altitude(0.03, 0.03) |> 
      globe_background(color = "#ffff") |> 
      globe_img_url(image_url("blue-marble")) |> 
      globe_pov(
        altitude = 1.5,
        20.6345,
        -99.5528
      )
    
    
  })
  
  
  
  output$historico_texto_gr <- renderEcharts4r({
    
    dates <- as.Date(input$fechas)
    
    x <- 
      datos |>
      filter(between(date,min(dates), max( dates ))) |> 
      mutate(date = floor_date(date, input$red_fechas)) |> 
      group_by(date) |> 
      summarise(
        subyacente = mean(subyacente),
        no_subyacente = mean(no_subyacente)
      ) |> 
      mutate(
        subyacente_difs = (subyacente-lag(subyacente))/lag(subyacente),
        no_subyacente_difs = (no_subyacente - lag(no_subyacente))/lag(no_subyacente),
        subyacente_difs_an = (1 + (subyacente_difs) / 12)^12 - 1,
        no_subyacente_difs_an = (1 + (no_subyacente_difs) / 12)^12 - 1
      ) |> 
      mutate_all(function(x) ifelse(is.infinite(x), 0, x)) |> 
      mutate(date = as_date(date))
    
    
    if (input$dif_perc == "Mensuales con respecto al último dato anterior"){
      
      x |> 
        e_charts(date) |> 
        e_bar(subyacente_difs, name = "Inf. subyacente") |> 
        e_bar(no_subyacente_difs, name = "Inf. no subyacente") |> 
        e_theme("auritus") |> 
        e_title("Inflación en México", 
                "Diferencias porcentuales respecto al periodo anterior", 
                left = "center",
                textStyle = list(
                  color = "#34548a",
                  fontFamily = "Roboto Condensed"
                )
        ) |> 
        e_tooltip(trigger = "axis",
                  textStyle = list(
                    fontFamily = "Roboto Condensed"
                  )
        ) |> 
        e_legend(orient = "horizontal", bottom = 0,
                 textStyle = list(
                   color = "#34548a",
                   fontFamily = "Roboto Condensed"
                 )
        ) |> 
        e_text_style(color = "gray", font = "Roboto Condensed") |> 
        e_color(color = c( "#8a3b3d", "#263b78")) |> 
        e_toolbox_feature(
          feature = "dataZoom"
        ) 
      
    }else if (input$dif_perc == "Mensuales anualizados"){
      
      x |> 
        e_charts(date) |> 
        e_bar(subyacente_difs_an, name = "Inf. subyacente") |> 
        e_bar(no_subyacente_difs_an, name = "Inf. no subyacente") |> 
        e_theme("auritus") |> 
        e_title("Inflación en México", 
                "Diferencias porcentuales en términos anualizados", left = "center",
                textStyle = list(
                  color = "#34548a",
                  fontFamily = "Roboto Condensed"
                )
        ) |> 
        e_tooltip(trigger = "axis",
                  textStyle = list(
                    fontFamily = "Roboto Condensed"
                  )
        ) |> 
        e_legend(orient = "horizontal", bottom = 0,
                 textStyle = list(
                   color = "#34548a",
                   fontFamily = "Roboto Condensed"
                 )
        ) |> 
        e_text_style(color = "gray", font = "Roboto Condensed") |> 
        e_color(color = c( "#8a3b3d", "#263b78")) |> 
        e_toolbox_feature(
          feature = "dataZoom"
        ) 
      
    }
    
  }) |> 
    bindEvent(input$in_plot)
  
  
  
  output$bar_lin <- renderEcharts4r({
    
    x <- datos |>
      filter(between(date,min( input$fechas), max( input$fechas))) |> 
      mutate(date = floor_date(date, input$red_fechas)) |> 
      group_by(date) |> 
      summarise(
        subyacente = mean(subyacente),
        no_subyacente = mean(no_subyacente)
      ) 
    
    
    x |> 
      e_charts(date) |> 
      e_bar(subyacente, name = "Inf. subyacente") |> 
      e_bar(no_subyacente, name = "Inf. no subyacente") |> 
      e_theme("auritus") |> 
      e_title("Inflación en México", 
              "Variaciones porcentuales", left = "center",
              textStyle = list(
                color = "#34548a"#,
                  #fontFamily = "Roboto Condensed"
              )
      ) |> 
      e_tooltip(trigger = "axis",
                textStyle = list(
                  fontFamily = "Roboto Condensed"
                )
      ) |> 
      e_legend(orient = "horizontal", bottom = 0,
               textStyle = list(
                 color = "#34548a"#,
                   # fontFamily = "Roboto Condensed"
               )
      ) |> 
      e_text_style(color = "gray", font = "Roboto Condensed") |> 
      e_color(color = c( "#8a3b3d", "#263b78")) |> 
      e_toolbox_feature(
        feature = "dataZoom"
      )
    
    
  }) |> 
    bindEvent(input$in_plot)
  
  
  data_model <- reactive({
    
    data <- if(input$inf_tipo == "Subyacente"){subyacente |> 
        filter(between(date,min( input$fechas), max(input$fechas))) }else{no_subyacente |> 
            filter(between(date,min( input$fechas), max(input$fechas)))}
    date <- c(year(min(data$date)), month(min(data$date)), 1)
    
    x <- 
      if (input$modelo == "ARIMA"){
        fortify(
          forecast(h = input$periodos, auto.arima(
            ts(data$value, start = date, frequency = 12 )
          ))
        )
      }else{
        fortify(
          forecast(h = input$periodos, bats(
            ts(data$value, start = date, frequency = 12 )
          ))
        )
      }
    
    x
    
  })
  
  
  output$pronostico <- renderEcharts4r({
    
    data_model() |> 
      mutate(fecha = as.Date(Index) ) |> 
      e_charts(fecha, dispose = FALSE) |> 
      e_line(Data, symbol = "none", name = "Valor observado") |> 
      e_line(`Point Forecast`, symbol = "none", name = "Valor pronosticado") |> 
      e_theme("auritus") |> 
      e_legend(FALSE) |> 
      e_y_axis(show = FALSE) |> 
      e_tooltip(trigger = "axis",
                confine = TRUE,
                textStyle = list(fontFamily = "Roboto Condensed", 
                                 fontSize = 12)) |> 
      e_toolbox_feature(
        feature = c("dataZoom", "restore")
      ) |> 
      e_color(color = c("#003049", "#d62828")) |> 
      e_title(
        paste0("Pronóstico de la variable ", "'", input$fred, "' ", "de la FRED"
               
        ),
        paste0("Periodos pronosticados: ", input$periodos), 
        left = "center",
        textStyle = list(
          color = "gray",
          fontFamily = "Roboto Condensed"
        )
      )
    
  }) |> 
    bindEvent(input$in_plot)
  
  
  output$nueva_serie <- renderEcharts4r({
    
    serie <- 
      getSerieDataFrame(getSeriesData(c( series$ID[series$Serie == input$otraserie] ), 
                                      as.Date('1950-01-01'),
                                      today() %m+% years(1)), 
                        c( series$ID[series$Serie == input$otraserie] ))
    
    
    serie |> 
      filter(
        between(date, input$fechas[1],input$fechas[2])
      ) |> 
      mutate(
        date = floor_date(date, input$red_fechas)
      ) |> 
      group_by(date) |> 
      summarise(
        value = mean(value)
      ) |> 
      e_charts(date) |> 
      e_line(value, symbol = "none", name = "Evolución") |> 
      e_theme("auritus") |> 
      e_tooltip(trigger = "axis") |> 
      e_color(color = "#913939") |> 
      e_legend(bottom = 0,
               textStyle = list(fontFamily = "Roboto Condensed", 
                                color = "gray",
                                fontSize = 12)) |> 
      e_title(input$otraserie , 
              left = "center",
              textStyle = list(
                color = "gray",
                fontFamily = "Roboto Condensed"
              )
      ) |> 
      e_toolbox_feature(
        feature = c("dataZoom", "restore")
      )
    
    
    
  }) |> 
    bindEvent(input$graficar_otras)
  
  
  
}


