# Zhentao Shi, 4/11/2020
# this is my first shiny app
# it demonstrates the Newton's method to look for
# local optimizer


library(shiny)

#####################################################


f <- function(x) 0.1 * (x - 5)^2 + cos(x) # criterion
s <- function(x) 0.2 * (x - 5) - sin(x) # gradient
h <- function(x) 0.2 - cos(x) # Hessian


######################################################
ui <- fluidPage(

  # App title ----
  titlePanel("Newton's method"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      sliderInput(
        inputId = "init",
        label = "initial_value",
        min = 1,
        max = 10,
        value = 50
      ),
      tableOutput(outputId = "distSeq")
    ),

    # Main panel for displaying outputs ----
    mainPanel(
      plotOutput(outputId = "distPlot") # ,
    )
  )
)


server <- function(input, output) {


  genSeq <- function(x) {# generate the sequence of in the update
    # x: initial value

    x_seq <- numeric()
    i <- 1
    gap <- 1
    epsilon <- 0.0001 # tolerance

    while (gap > epsilon) {
      x_new <- x - s(x) / h(x)
      x_seq[i] <- x_new

      gap <- abs(x - x_new)
      x <- x_new
      i <- i + 1
      if (i > 50) break
    }
    return(x_seq)
  }


  output$distSeq <- renderTable({ # the values of the sequence
    x_seq <- genSeq(input$init)
    tibble::tibble(no = 1:length(x_seq), seq = x_seq)
  })


  output$distPlot <- renderPlot({ # the graphic demo

    x_seq <- genSeq(input$init)

    x_base <- seq(0.1, 10, by = 0.1)

    par(mfrow = c(2, 1))
    par(mar = c(2, 4, 1, 2))

    plot(y = f(x_base), x = x_base, type = "l", lwd = 2, ylab = "f", xlab = "")

    points(x = x_seq, y = f(x_seq), col = "red", pch = 4, lwd = 3)
    points(x = input$init, y = f(input$init), col = "blue", pch = 22, lwd = 3)

    plot(y = s(x_base), x = x_base, type = "l", ylab = "score", xlab = "")
    abline(h = 0, lty = 2)
    points(x = x_seq, y = s(x_seq), col = "red", pch = 4, lwd = 3)
    points(x = input$init, y = s(input$init), col = "blue", pch = 22, lwd = 3)
  })
}

###########################################

shinyApp(ui = ui, server = server)
