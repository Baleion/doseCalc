#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#Utility function for serverside calculation
doseCalculator <- function(weight, totalDose, solCon, tpd = NULL){
  LBCON <- 2.2 #Conversion factor
  kilo <- weight/LBCON #Convert pounds to kilos
  totalDailyDose <- totalDose*kilo
  overallSolution<- totalDailyDose * solCon
  if(is.null(tpd))
  {
    print(overallSolution)
    
  }else{
    endDose <- overallSolution/tpd
    print(endDose)}
}

# Define UI for dose application
ui <- fluidPage(
   
   # Application title
   titlePanel("DoseCalculator"),
   
   # Split layout with inputs for the function and an action button
   splitLayout(
      wellPanel(
         numericInput("weight",
                     "Weight(lbs)",
                     value = 0),
         numericInput('doseT', 'Total Dose (mg)', value = 0),
         numericInput('solCon', 'Solution Concentration (mg/ml)', value = 0),
         numericInput('tpd', 'Times Per Day', value = NULL), 
         actionButton("calc", "Calculate")
      ),
      
      # Print the output of the function
      wellPanel(
         h2(verbatimTextOutput("total"))
      )
   )
)

# Define server logic required to use the button and call the function
server <- function(input, output) {
   
  ntext <- eventReactive(input$calc, {
    doseCalculator(input$weight,input$doseT,input$solCon, input$tpd) #Actual application logic
  })
   output$total <- renderPrint({
      ntext()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

