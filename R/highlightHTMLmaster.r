#' Master highlight HTML function
#' 
#' This function inputs a markdown or rmarkdown document and exports an HTML file. 
#' The HTML file is then processed to search for tags that inject CSS automatically 
#' into the HTML file.
#' 
#' A function that allows the alteration of HTML using CSS. This may be helpful
#' coming from a markdown or R markdown file to alter aspects of the page based on 
#' a specific criteria. This function handles both tables as well as normal text.  
#' The options are only limited based on your knowledge of CSS.
#' 
#' @param input File name of markdown or rmarkdown file to highlight the cells of the table or text. 
#'    Alternatively, if render = FALSE, a HTML file can be specified as the input.
#' @param output Output file name of highlighted HTML file
#' @param tags character vector with CSS tags to be added
#' @param browse logical, If TRUE (default) output file opens in default browser, if FALSE, 
#'    file is written, but not opened in browser. 
#' @param print logical, if TRUE print output to R console, if false (default) output is 
#'    filtered to other methods (see browse or output).
#' @param render logical, if TRUE (default) will call the rmarkdown::render() function to 
#'    convert Rmd or md files to html prior to injecting CSS.
#' @examples
#' # Setting path for example html files 
#' # To see path where these are saved, type file or file1 in the 
#' # r console.
#' \dontrun{
#' file <- system.file('examples', 'bgtable.html', package = 'highlightHTML')
#' 
#' # Creating CSS tags to inject into HTML document
#' tags <- c("#bgred {background-color: #FF0000;}", 
#'   "#bgblue {background-color: #0000FF;}")
#'   
#' # Command to post-process HTML file - Writes to temporary file
#' highlight_html(input = file, output = tempfile(fileext = ".html"),  
#'   tags = tags, browse = FALSE)
#' }
#' @export
highlight_html <- function(input, output, tags, browse = TRUE, print = FALSE,
                           render = TRUE) {
  if(missing(output)) {
    output <- gsub("\\.md$|\\.Rmd", "_out\\.html", input)
    message("output file path not specified, file saved to ", output)
  }
  
  if(render) {
    rmarkdown::render(input = input, output_format = 'html_document',
                      output_file = output)
    text_output <- readLines(output)
  } else {
    text_output <- readLines(input)
  }
  
  text_output <- highlight_html_cells(input = text_output, output = output, tags,
                               update_css = FALSE, 
                             browse = FALSE, print = TRUE)
  highlight_html_text(input = text_output, output, tags, update_css = TRUE, 
                      browse, print)
  
}
  