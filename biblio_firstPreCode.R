install.packages("bibliometrix")
library(bibliometrix)


install.packages("dplyr")
install.packages("stringr")
install.packages("bibliometrix")
library(dplyr)
library(stringr)
library(bibliometrix)

data <- read.csv("Data_Lit/scopus.txt")
biblio_data <- convert2df(data, dbsource = "scopus", format = "csv")


data <- read.csv("Data_Lit/Backwards2.csv", stringsAsFactors = FALSE)

##################

data_processed <- data %>%
  rename(AU = Author,
         TI = Title,
         SO = Publication.Title,
         PY = Publication.Year,
         DI = DOI,
         DT = Item.Type,
         PU = Extra) %>%
  mutate( # Publisher not available
         TC = "NA", # Document Type not available
         ID = "NA",  # Keywords not available
         DE = "NA",
         DB = "generic")  # Author Keywords not available

# Ensure that all required fields are present, filling with NA if necessary
required_columns <- c("AU", "TI", "SO", "PY", "DI", "TC", "PU", "DT", "ID", "DE", "DB")
data_processed <- data_processed %>% select(all_of(required_columns))

biblio_data <- convert2df(data_processed, dbsource = "generic", format = "csv")
######################

# Create a bibliometric dataframe manually
biblio_data <- data_processed

# Convert authors' names to the required format
biblio_data$AU <- sapply(strsplit(biblio_data$AU, ";"), function(x) paste(x, collapse = "; "))

# Inspect the resulting bibliometric dataframe
str(biblio_data)
head(biblio_data)

results <- biblioAnalysis(biblio_data)
########################

biblio_data <- convert2df(data, dbsource = "scopus", format = "bib")

file <- "Data_Lit/scopus.bib"
M <- convert2df(file, dbsource = "scopus", format = "bibtex") 

results <- biblioAnalysis(biblio_data)
results <- biblioAnalysis(M)
summary(results)

