# Quick script to load all 9 Sample Data tabs 
# into a list of data frames.

filepath <- "/data/" 	# Change to filepath where data is contained
files <- dir(filepath) 	# Grab list of .tsv files
alldata <- lapply(files, function(x) read.csv(paste0(filepath, x), sep = "\t", header = TRUE, stringsAsFactors = FALSE)
