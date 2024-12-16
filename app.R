library(shiny)
library(leaflet)
library(shinydashboard)
library(anytime)
library(DT)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
ui <- dashboardPage(
  dashboardHeader(
    title = "Bancos Comunitários"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Seleção de Filtros", tabName = "my_selection"),
      menuItem("Mapa", tabName = "my_maps"),
      menuItem("Formulário", tabName = "my_forms"),
      menuItem("Saiba como utilizar", tabName = "my_manual")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "my_maps",
              ui <- bootstrapPage(
                shiny::tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                tabsetPanel(
                  tabPanel(
                    title = "My Maps",
                    shiny::tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                    leafletOutput("map", width = "100%", height = "100%"),
                    absolutePanel(
                      bottom = "50%", right = 20,
                      sliderInput("year_range_slider", "Tempo", min = 1994, max = 2024,  # Substitua com os valores apropriados
                                  value = c(1994, 2024), step = 1, sep = ""
                      ),
                      selectInput("select_state_2", "Estados",choices = c("Todos","Acre","Alagoas","Amapá","Amazonas","Bahia","Ceará","Espírito Santo","Goiás","Maranhão","Mato Grosso","Mato Grosso do Sul","Minas Gerais","Pará","Paraíba","Paraná","Pernambuco","Piauí","Rio de Janeiro","Rio Grande do Norte","Rio Grande do Sul","Rondônia","Roraima","Santa Catarina","São Paulo","Sergipe","Tocantins") ),  # Lista de cores exemplo
                      DT::dataTableOutput("table")
                    )
                  )
                )
              )
      ),
      tabItem(tabName = "my_forms",
              titlePanel("Formulário"),
              p("Se você deseja adicionar alguma informação a respeito de um banco comunitário, preencha o formulário abaixo."),
              fluidRow(
                box(
                  title = "Formulário de Cadastro", 
                  status = "primary", 
                  solidHeader = TRUE, # Cabeçalho sólido
                  width = 12, # Largura total (em 12 colunas do grid do Shiny)
                  
                  # Conteúdo do formulário
                  textInput("name", label = "Remetente", placeholder = "Digite o seu nome completo"),
                  textInput("email", label = "Email", placeholder = "Digite o seu endereço de email"),
                  textInput("bank", label = "Banco Comunitário", placeholder = "Digite o nome do seu Banco"),
                  textInput("bank_local", label = "Localização do Banco Comunitário", placeholder = "Digite a localização do seu Banco"),
                  selectInput("bank_space", label = "O espaço do Banco", choices =  c("" ,"Próprio", "Alugado", "Concedido") ),
                  textInput("bank_born", label = "Fundação do Banco", placeholder = "Digite em que ano o banco foi fundado"),
                  selectInput("bank_area", label = "Área de abrangência do banco", choices =  c("" ,"Bairro", "Municipal", "Estadual") ),
                  
                  selectInput("bank_material", label = "Instrumentos de trabalho do banco", choices =  c("", "Telefone", "Computador", "Impressora", "Outros") ),
                  conditionalPanel(condition = "input.bank_material == 'Outros'",textInput("bank_material", "Digite quais instrumentos de trabalho o banco possui")),
                  
                  
                  radioButtons("bank_cadastro", label = "Os cadastros são digitalizados?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  radioButtons("bank_cofre", label = "O banco possui um cofre?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  radioButtons("confirmação",label = "O seu banco utiliza a plataforma E-Dinheiro?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  textInput("bank_workers", label = "Número de funcionários", placeholder = "Digite o número de funcionários do seu Banco"),
                  
                  radioButtons("bank_coin",label = "O banco usa a moeda social/local de papel?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  conditionalPanel(condition = "input.bank_coin == 'Sim'",textInput("bank_coin_imp", "Digite quem a imprime.")),
                  
                  
                  selectInput("bank_origin", label = "O origem do dinheiro do banco comunitário", choices = c("" ,"Banco Central", "Banco do Brasil", "ONGS", "Outros")),
                  conditionalPanel(condition = "input.bank_origin == 'Outros'",textInput("bank_origin", "Digite a origem do dinheiro do Banco Comunitário?")),
                  
                  
                  radioButtons("bank_corresponde",label = "O banco é um correspondente bancário?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  conditionalPanel(condition = "input.bank_corresponde == 'Sim'",textInput("bank_link", "A qual banco é ligada a correspondência bancária?")),
                  conditionalPanel(condition = "input.bank_corresponde == 'Não'",textInput("bank_link", "Qual ou quais bancos fiscalizam suas atividades?")),
                  
                  textInput("bank_clientes", label = "Qual o número de clientes ativos cadastrados na plataforma E-Dinheiro? Se o banco utilizar moeda em papel, qual o número de clientes ativos que usam a moeda?", placeholder = "Digite o número de clientes do seu Banco"),
                  textInput("bank_empreendimentos", label = "Qual o número de empreendimentos cadastrados?", placeholder = "Digite o número de empreendimentos cadastrados"),
                  
                  selectInput("bank_linha_credito", label = "Quais tipos de linha de crédito são oferecidas?", choices =  c("", "Produtivo", "Consumo", "Outros") ),
                  conditionalPanel(condition = "input.bank_linha_credito == 'Outros'",textInput("linha_credito_details", "Descreva o tipo da linha de crédito oferecida:")),
                  
                  textInput("bank_valor_credito", label = "Qual o valor de crédito já concedido pelo banco?", placeholder = "Digite o valor de crédito"),
                  selectInput("bank_tedence", label = "Qual a tendência do número de clientes?", choices =  c("", "Crescente", "Decrescente", "Estável")),
                  selectInput("bank_maior_cliente", label = "A maior parte dos clientes são:", choices =  c("", "Comércios", "Pessoas físicas")),
                  
                  radioButtons("bank_propaganda",label = "O banco utiliza de alguma estratégia de “propaganda”?",choices = c("Sim" = "sim", "Não" = "não"),selected = NA),
                  conditionalPanel(condition = "input.bank_propaganda == 'sim'",textInput("propaganda_details", "Descreva a estratégia de propaganda utilizada:")),
                  
                  textInput("bank_acesso_dados", label = "Com qual facilidade o banco tem acesso aos dados pedidos por esse formulário?", placeholder = "Explique onde e se os dados gerais são guardados."),
                  actionButton("submit_button", "Enviar", icon = icon("paper-plane"), class = "btn-primary")
                  
                ) 
              )
      ),
      tabItem(tabName = "my_manual",
              titlePanel("Seções"),
              p("No site, há três seções no mapa. Se você estiver usando um computador, clique com o botão esquerdo do mouse em um dos três botões na barra à esquerda: Seleção de Filtros, Mapa e Saiba como utilizar."),
              p("Para ver a lista de bancos comunitários novamente, clique em 'Seleção de Filtros'. Para abrir o mapa com os bancos comunitários, clique em 'Mapa'."),
              p("O botão com três linhas faz a barra lateral à esquerda aparecer ou desaparecer. Se os botões das seções sumirem, clique no botão com três linhas para trazê-los de volta."),
              img(src="manual_section.png",height = 150,width=150,align="center",style="display: block; margin-left: auto; margin-right: auto;"),
              titlePanel("Mapa"),
              p("Na seção 'Mapa', você pode:",
                shiny::tags$ul(
                  shiny::tags$li("Segurar o botão esquerdo do mouse e arrastar para mover o mapa."),
                  shiny::tags$li("Usar os símbolos '+' e '-' para aproximar ou afastar."),
                  shiny::tags$li("Clicar nas setas verdes para ver mais informações sobre as localizações marcadas."),
                ),
              ),
              img(src="manual_map.png",height = 500,width=500,align="center",style="display: block; margin-left: auto; margin-right: auto;"),
              titlePanel("Seleção de filtros"),
              p("A seção 'Seleção de filtros' permite encontrar Bancos Comunitários por localização, estado e ano de fundação, além de fazer uma pesquisa direta. No campo 'Banco Comunitário', você pode escrever livremente o nome do banco que procura no espaço 'Digite o nome do Banco' no exemplo. No campo 'Estado', clique na seta para baixo e escolha um estado da lista (no exemplo, 'Rio de Janeiro'). Para o 'Ano de fundação', escreva um ano no campo à esquerda e outro no campo à direita para definir um intervalo, como '1993' a '2019', para mostrar bancos fundados nesse período. Para buscar outros intervalos, insira anos diferentes."),
              p("Além dos filtros convencionais, há uma barra de busca, marcada como 'Search', acima da tabela. Esse campo é livre, e o programa irá procurar por qualquer informação relacionada ao que você escrever, em qualquer um dos campos disponíveis. Ou seja, ele buscará qualquer banco que tenha esse dado."),
              p("O indicador de contagem acima da tabela serve para sinalizar quantos resultados são retornados para esta busca."),
              p("Abaixo da tabela é possível selecionar “Next” para ir para a próxima página de resultados ou “Previous” para voltar, caso haja mais de uma página."),
              p("Por fim, os botões “Copy”, “Excel” e “PDF” servem para exportar os dados da tabela, em texto, tabela ou imagem, respectivamente."),
              img(src="manual_selection.png",height = 500,width=500,style="display: block; margin-left: auto; margin-right: auto;")
      ),
      tabItem(tabName = "my_selection",
              fluidRow(
                box(textInput("bank", label = "Banco Comunitário", placeholder = "Digite o nome do Banco"), width = 4),
                box(selectInput("select_state_1", label = "Estado", choices = c(
                  "Todos",
                  "Acre",
                  "Alagoas",
                  "Amapá",
                  "Amazonas",
                  "Bahia",
                  "Ceará",
                  "Espírito Santo",
                  "Goiás",
                  "Maranhão",
                  "Mato Grosso",
                  "Mato Grosso do Sul",
                  "Minas Gerais",
                  "Pará",
                  "Paraíba",
                  "Paraná",
                  "Pernambuco",
                  "Piauí",
                  "Rio de Janeiro",
                  "Rio Grande do Norte",
                  "Rio Grande do Sul",
                  "Rondônia",
                  "Roraima",
                  "Santa Catarina",
                  "São Paulo",
                  "Sergipe",
                  "Tocantins"
                ),selected="Todos"), width = 4),
                box(dateRangeInput("daterange", label = "Ano de Fundação",format = "yyyy",startview = "year",language = "pt-BR", start = Sys.Date() - 365*30, end = Sys.Date() + 365,
                                   min = Sys.Date() - 365*50, max = Sys.Date() + 365), width = 4)
                # box(dateRangeInput("daterange", label = "Ano de Fundação",format = "yyyy",startview = "year",language = "pt-BR", start = Sys.Date() - 365*30, end = Sys.Date() + 365,
                #      min = Sys.Date() - 365*50, max = Sys.Date() + 365), width = 4)
              ),
              verbatimTextOutput("text1"),
              DT::dataTableOutput("table")
      )
    )
    
    
  )
)


server <- function(input, output, session) {
  my_table <- read.csv("https://raw.githubusercontent.com/GabrielPonte/CompSoc/main/bancos_python.csv")
  #my_table <-  read_sheet('https://docs.google.com/spreadsheets/d/1W8XYVrhcLSCMMp3HHF8zi5kM3gPA8K-nEvi7Xy7tKNY/edit?usp=sharing')
  #my_table <- read.csv("C:\\Users\\Cliente\\Documents\\CompSoc\\meu_banco.csv",sep =";")
  
  observeEvent(list(input$select_state_1, input$daterange, input$bank), {
    # Filtra os dados de acordo com os inputs
    selected_state <- input$select_state_1
    date_range <- input$daterange
    bank_name <- input$bank
    
    filtered_data <- my_table
    
    if (selected_state != "Todos") {
      filtered_data <- filtered_data[filtered_data$Estado == selected_state, ]
    }
    
    if (!is.null(date_range)) {
      start_year <- as.numeric(format(date_range[1], "%Y"))
      end_year <- as.numeric(format(date_range[2], "%Y"))
      filtered_data <- filtered_data[
        filtered_data$Ano.de.Fundação >= start_year &
          filtered_data$Ano.de.Fundação <= end_year, ]
    }
    
    if (bank_name != "") {
      filtered_data <- filtered_data[grepl(bank_name, filtered_data$Banco, ignore.case = TRUE), ]
    }
    
    # Atualiza o mapa com os dados filtrados
    if (nrow(filtered_data) > 0) {
      leafletProxy("map") %>%
        clearMarkers() %>%
        addMarkers(
          lng = filtered_data$Longitude,
          lat = filtered_data$Latitude,
          popup = paste("<b>", "Banco ", filtered_data$Banco, "</b><br>")
        ) %>%
        flyTo(
          lng = mean(filtered_data$Longitude, na.rm = TRUE),
          lat = mean(filtered_data$Latitude, na.rm = TRUE),
          zoom = 6
        )
    } else {
      # Caso não haja dados, limpa os marcadores do mapa
      leafletProxy("map") %>%
        clearMarkers()
    }
  })
  
  observeEvent(input$select_state_2, {
    selected_state <- input$select_state_2
    
    if (selected_state == "Todos") {
      # Exibe todos os pontos
      leafletProxy("map") %>%
        clearMarkers() %>%
        addMarkers(
          lng = my_table$Longitude, lat = my_table$Latitude,
          popup = paste("<b>", "Banco ", my_table$Banco, "</b><br>")
        )
    } else {
      # Filtra os pontos para o estado selecionado
      filtered_data <- my_table[my_table$Estado == selected_state, ]
      
      if (nrow(filtered_data) > 0) {
        leafletProxy("map") %>%
          clearMarkers() %>%
          addMarkers(
            lng = filtered_data$Longitude, lat = filtered_data$Latitude,
            popup = paste("<b>", "Banco ", filtered_data$Banco, "</b><br>")
          ) %>%
          flyTo(
            lng = mean(filtered_data$Longitude, na.rm = TRUE),
            lat = mean(filtered_data$Latitude, na.rm = TRUE),
            zoom = 6
          )
      } else {
        # Caso não haja dados, limpa os marcadores do mapa
        leafletProxy("map") %>%
          clearMarkers()
      }
    }
  })
  
  #sincronizar a seleção de filtro com mapa
  observeEvent(input$select_state_1, {
    updateSelectInput(session, "select_state_2", selected = input$select_state_1)
  })
  
  observeEvent(input$select_state_2, {
    updateSelectInput(session, "select_state_1", selected = input$select_state_2)
  })
  
  observeEvent(input$year_range_slider, {
    updateDateRangeInput(session, "daterange", 
                         start = as.Date(paste0(input$year_range_slider[1], "-01-01")),
                         end = as.Date(paste0(input$year_range_slider[2], "-12-31")))
    
  })
  
  observeEvent(input$daterange, {
    new_start <- as.numeric(format(input$daterange[1], "%Y"))
    new_end <- as.numeric(format(input$daterange[2], "%Y"))
    updateSliderInput(session, "year_range_slider",
                      value = c(new_start, new_end))
  })
  
  #botão de enviar
  observeEvent(input$submit_button, {
    
    system('git config --global user.name "MapaBancos"')
    system('git config --global user.email "mapacomunitarios@outlook.com"')
    system('git config --global init.defaultBranch main')
    
    # Inicializa o repositório se necessário
    if (!dir.exists("MapaBancos/.git")) {
      system("git init")  # Inicializa o repositório se não existir
      system("git remote add origin https://MapaBancos:(token)@github.com/MapaBancos/MapaBancos.git")
    }
    
    # Remove qualquer arquivo existente e clona o repositório
    system("rm -rf MapaBancos")  # Remover diretório anterior, se necessário
    system("git clone https://MapaBancos:(token)@github.com/MapaBancos/MapaBancos.git")
    
    # Navega para o diretório do repositório clonado
    setwd("MapaBancos")
    
    # Valida se todos os campos obrigatórios estão preenchidos
    req(input$name, input$email, input$bank, input$bank_local, input$bank_space, input$bank_born,
        input$bank_area, input$bank_material, input$bank_cadastro, input$bank_cofre, input$confirmação,
        input$bank_workers, input$bank_coin, input$bank_origin, input$bank_corresponde, input$bank_clientes,
        input$bank_empreendimentos, input$bank_linha_credito, input$bank_valor_credito, input$bank_tedence,
        input$bank_maior_cliente, input$bank_propaganda, input$bank_acesso_dados)
    
    # Cria uma nova linha com os dados do formulário
    new_entry <- data.frame(
      Nome = input$name,
      Email = input$email,
      Banco = input$bank,
      Localizacao_Banco = input$bank_local,
      Espaco_Banco = input$bank_space,
      Fundacao_Banco = input$bank_born,
      Area_Abrangencia = input$bank_area,
      Instrumentos_Trabalho = input$bank_material,
      Cadastros_Digitalizados = input$bank_cadastro,
      Banco_Cofre = input$bank_cofre,
      Plataforma_EDinheiro = input$confirmação,
      Numero_Funcionarios = input$bank_workers,
      Moeda_Social_Papel = input$bank_coin,
      Impressao_Moeda = ifelse(input$bank_coin == "Sim", input$bank_coin_imp, NA),
      Origem_Dinheiro = input$bank_origin,
      Origem_Outros = ifelse(input$bank_origin == "Outros", input$bank_origin, NA),
      Correspondente_Bancario = input$bank_corresponde,
      Banco_Ligado = ifelse(input$bank_corresponde == "Sim", input$bank_link, NA),
      Fiscalizacao_Bancos = ifelse(input$bank_corresponde == "Não", input$bank_link, NA),
      Numero_Clientes_Ativos = input$bank_clientes,
      Numero_Empreendimentos = input$bank_empreendimentos,
      Tipos_Linha_Credito = input$bank_linha_credito,
      Linha_Credito_Outros = ifelse(input$bank_linha_credito == "Outros", input$linha_credito_details, NA),
      Valor_Credito = input$bank_valor_credito,
      Tendencia_Clientes = input$bank_tedence,
      Maior_Parte_Clientes = input$bank_maior_cliente,
      Estrategia_Propaganda = input$bank_propaganda,
      Detalhes_Propaganda = ifelse(input$bank_propaganda == "sim", input$propaganda_details, NA),
      Acesso_Dados = input$bank_acesso_dados,
      stringsAsFactors = FALSE
    )
    
    # Caminho do arquivo CSV
    csv_path <- "dados.csv"
    
    # Salva os dados no arquivo CSV
    if (file.exists(csv_path)) {
      write.table(new_entry, csv_path, append = TRUE, sep = ",", row.names = FALSE, col.names = FALSE)
    } else {
      write.table(new_entry, csv_path, sep = ",", row.names = FALSE, col.names = TRUE)
    }
    
    # Adiciona e comita as alterações no arquivo dados.csv
    system("git add dados.csv")
    system('git commit -m "Atualizando dados do formulário"')
    
    # Faz o push para o repositório remoto
    system('git push origin main')
    
    
    showNotification("Obrigado! Dados enviados com sucesso!", type = "message")
    
    # Limpa os campos do formulário
    updateTextInput(session, "name", value = "")
    updateTextInput(session, "email", value = "")
    updateTextInput(session, "bank", value = "")
    updateTextInput(session, "bank_local", value = "")
    updateTextInput(session, "bank_born", value = "")
    updateTextInput(session, "bank_workers", value = "")
    updateTextInput(session, "bank_coin_imp", value = "")
    updateTextInput(session, "bank_link", value = "")
    updateTextInput(session, "bank_clientes", value = "")
    updateTextInput(session, "bank_empreendimentos", value = "")
    updateTextInput(session, "linha_credito_details", value = "")
    updateTextInput(session, "bank_valor_credito", value = "")
    updateTextInput(session, "propaganda_details", value = "")
    updateTextInput(session, "bank_acesso_dados", value = "")
    
    # Limpa campos de seleção
    updateSelectInput(session, "bank_space", selected = NULL)
    updateSelectInput(session, "bank_area", selected = NULL)
    updateSelectInput(session, "bank_material", selected = NULL)
    updateSelectInput(session, "bank_origin", selected = NULL)
    updateSelectInput(session, "bank_linha_credito", selected = NULL)
    updateSelectInput(session, "bank_tedence", selected = NULL)
    updateSelectInput(session, "bank_maior_cliente", selected = NULL)
    
    # Limpa botões de rádio
    updateRadioButtons(session, "bank_cadastro", selected = NULL)
    updateRadioButtons(session, "bank_cofre", selected = NULL)
    updateRadioButtons(session, "confirmação", selected = NULL)
    updateRadioButtons(session, "bank_coin", selected = NULL)
    updateRadioButtons(session, "bank_corresponde", selected = NULL)
    updateRadioButtons(session, "bank_propaganda", selected = NULL)
  })
  
  
  
  tot_rows <- nrow(my_table)
  col_ano <-my_table$Ano.de.Fundação
  col_banco <- my_table$Banco
  div_name <- reactive({input$bank})
  div_state <- reactive({input$select_state_2})
  div_year <- reactive({input$daterange})
  x <- rep(TRUE,tot_rows)
  output$table <- renderDataTable({
    # name_cols_table <- list()
    # for col_name in my_colnames
    #   name_cols_table <- append(name_cols_table,list())
    if (div_name() != ""){
      for (i in 1:tot_rows){
        if (startsWith(col_banco[i],div_name())==FALSE){
          x[i] <- FALSE
        }
      }
    }
    if (div_state() != "Todos"){
      x2 <- (my_table$Estado)==div_state()
      for (i in 1:tot_rows){
        if (x2[i] == FALSE){
          x[i] = FALSE
        }
      }
    }
    if ((div_year()[1] == Sys.Date() - 365*30 &&  div_year()[2] ==Sys.Date() + 365) == FALSE){
      init_year <- strtoi(substr(anydate(div_year()[1]),1,4))
      end_year <- strtoi(substr(anydate(div_year()[2]),1,4))
      for (i in 1:tot_rows){
        year_i = (col_ano[i])
        if (is.na(year_i)){
          x[i] = FALSE  
        }else if ((year_i>= init_year && year_i <= end_year) == FALSE){
          x[i] = FALSE
        }
      }
    }
    output$text1 <- renderText(paste("Contagem:",sum(x)))
    output$map <- renderLeaflet({
      zoom_level <- 10
      icon_size <- zoom_level * 2
      new_table <- my_table[x, ]  # Filtra os dados
      
      # Constrói o conteúdo do popup com todas as informações disponíveis
      my_popup <- paste0(
        "<b>", "Banco: ", new_table$Banco, "</b><br>",
        "Estado: ", new_table$Estado, "<br>",
        "Ano de Fundação: ", new_table$Ano.de.Fundação, "<br>",
        "Endereço: ", new_table$Endereço, "<br>",
        "Cidade: ", new_table$Cidade
      )
      
      dynamicIcon <- makeIcon(
        iconUrl = "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-blue.png", # URL do ícone
        iconWidth = 25,  # Largura do ícone
        iconHeight = 41, # Altura do ícone
        iconAnchorX = 12, # Posição horizontal do ponto de ancoragem
        iconAnchorY = 41  # Posição vertical do ponto de ancoragem
      )
      
      leaflet(options = leafletOptions(minZoom = 5, maxZoom = 15)) %>%
        addTiles(group = "OSM (default)") %>%
        addProviderTiles(providers$OpenStreetMap, options = providerTileOptions()) %>%
        addProviderTiles(providers$CartoDB.Positron, group = "Positron (minimal)") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery (satellite)") %>%
        addLayersControl(
          baseGroups = c(
            "OSM (default)",
            "Positron (minimal)",
            "World Imagery (satellite)"
          ),
          options = layersControlOptions(collapsed = FALSE)
        ) %>%
        addMarkers(
          lng = new_table$Longitude, lat = new_table$Latitude,
          popup = my_popup,
          icon = dynamicIcon
        )
    })
    
    datatable(my_table[x,], 
              extensions = 'Buttons',
              options = list(
                scrollX = TRUE,
                dom = 'Bfrtip',
                buttons = c('copy', 'excel', 'pdf'),
                pageLength=tot_rows, 
                lengthMenu=c(3,5,10)
              )
    ) %>% 
      formatRound(c(2,3),3) # casas decimais pra lat/long
  })
}
shinyApp(ui, server)