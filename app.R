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
doseCalculator <- function(weight, totalDose, solCon, tpd = 0){
  solCon <- eval(parse(text = solCon)) #Evaluate text because solution given in ml/mg
  LBCON <- 2.2 #Conversion factor
  kilo <- weight/LBCON #Convert pounds to kilos
  totalDailyDose <- totalDose*kilo
  overallSolution<- totalDailyDose * solCon
  if(tpd == 0)
  {
    sprintf("Doseage in %.3f (mg/mL)", overallSolution)
    
  }else{
    endDose <- overallSolution/tpd
    sprintf("Doseage with %d times per day calculated is %.3f(mL)", tpd,endDose)
    }
}

# Define UI for dose application
ui <- fluidPage(
   
   # Application title
   titlePanel("Pediatric Dose Calculator"),
   h6('Enter amounts below without days to get total dose.'),
   
   # Split layout with inputs for the function and an action button
   splitLayout(
      wellPanel(
         numericInput("weight",
                     "Weight(lbs)",
                     value = 0),
         numericInput('doseT', 'Total Dose (mg)', value = 0),
         textInput('solCon', 'Solution Concentration (ml/mg)', value = "0"),
         numericInput('tpd', 'Times Per Day', value = 0), 
         actionButton("calc", "Calculate")
      ),
      
      # Print the output of the function
      wellPanel(
         verbatimTextOutput("total")
      )
   )
)

# Define server logic required to use the button and call the function
server <- function(input, output) {
   
  ntext <- eventReactive(input$calc, {
    doseCalculator(input$weight,input$doseT,input$solCon, input$tpd) #Calling dose calculator
  })
   output$total <- renderPrint({
      ntext()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

