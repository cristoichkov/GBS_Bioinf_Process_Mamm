## This function extracts the statistical summary table from ipyrad.txt files

ipyrad_extract_table <- function(file, pattern){  ##Defines the name of the function, which accepts as parameters: file = "../file.txt", and a pattern = "Header of the table of interest"

lines <- readLines(file) ## Returns a list containing the lines in "file"

p.start <- grep(pattern, lines) ##Creates a variable which value is the line in "file" that contains the pattern of interest

df <- read.table(file, skip = p.start) ##Prints the table of interest. This step omits all the lines before the pattern in p.start 

return(df)

}
