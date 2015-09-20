library(jsonlite)
steamspy_data <- fromJSON("http://steamspy.com/api.php?request=all")
sp_df <- do.call(rbind, lapply(test, as.data.frame, stringsAsFactors = FALSE))