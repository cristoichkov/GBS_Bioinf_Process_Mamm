## This function extracts the tables of stats.txt file of ipyrad output folder ##

## stats.txt contains five tables:
## 1 - The number of loci caught by each filter
## 2 - The number of loci recovered for each Sample
## 3 - The number of loci for which N taxa have data
## 4 - The distribution of SNPs
## 5 - Final Sample stats summary

## First you have to put the path of your file, for table 1 only put this
## Then you have to choose the table that you want to extract
## For tables 2, 3 and 5 you have to insert the samples number
## For table 4 you have to see your file and put the number of rows that appear in the table
## This table starts with a cero
## for example if the numbres of rows is 40 you have to sum 1 so the correct number is 41

## Defines the name of the function, which accepts as parameters: 
## file = "../file.txt", table = 1,2,3,4 or 5, n_sambles = # samples, n_row_tab_4 = example 40 + 1 = 41
ipyrad_extract_table <- function(file, table, n_samples, n_row_tab_4){ 

  ##  The pattern to search the table
   tables_stats <- c("## The number of loci caught by each filter",
   "## The number of loci recovered for each Sample",
   "## The number of loci for which N taxa have data",
   "## The distribution of SNPs",
   "## Final Sample stats summary") 
   
   lines <- readLines(file) ## Returns a list containing the lines in "file"
   
   p.start <- grep(tables_stats[table], lines) ##Creates a variable which value is the line in "file" that contains the pattern of interest
   
  if (table == 1){ ## if you select the table 1  
    
    ## Always this table contains 8 rows
    df <- read.table(file, skip = p.start, nrows = 8, row.names = NULL) 
    
  } else if (table == 4){ ## if you select the table 4
    
    ## This table changes the number of rows and you have to see your file to choose the correct number 
    ## Remember that this table starts with cero and you have to sum 1
    df <- read.table(file, skip = p.start, nrows = n_row_tab_4, row.names = NULL) 
    
  } else { ## if you select the table 2, 3, or 5
    
    ## These tables match with the number of samples 
    df <- read.table(file, skip = p.start, nrows = n_samples, row.names = NULL)
    
  }
   
   return(df)
}


