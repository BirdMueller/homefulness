# Quick script to load all 9 Sample Data tabs 
# into a list of data frames.

filepath <- "C:/Users/songo/Documents/GH6/data/" 	# Change to filepath where data is contained
files <- dir(filepath) 	# Grab list of .tsv files
alldata <- lapply(files, function(x) read.csv(paste0(filepath, x), sep = "\t", header = TRUE, stringsAsFactors = FALSE))

# Name list items
names(alldata) <- sub('[.]tsv', '', files)

# Some data cleansing

lapply(alldata, function(x) gsub('_', '', names(x)))