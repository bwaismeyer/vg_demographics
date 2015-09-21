library(jsonlite)
steamspy_data <- fromJSON("http://steamspy.com/api.php?request=all")
sp_df <- do.call(rbind, lapply(steamspy_data, as.data.frame, stringsAsFactors = FALSE))

steam_app_names <- fromJSON("http://api.steampowered.com/ISteamApps/GetAppList/v2")
app_name_df <- do.call(rbind, lapply(steam_app_names, as.data.frame, stringsAsFactors = FALSE))
names(app_name_df) <- c("appid", "name")

ant <- paste0(head(app_name_df$appid), collapse = ",")
adc <- paste0("http://store.steampowered.com/api/appdetails/?appids=",
              ant)
ad1 <- paste0("http://store.steampowered.com/api/appdetails/?appids=",
              "570")

app_name_csv <- paste0(app_name_df$appid, collapse = ",")
app_detail_call <- paste0("http://store.steampowered.com/api/appdetails/?appids=",
                          app_name_csv)

test <- fromJSON(ad1)

# get vector and/or df of all app names
steam_app_names <- fromJSON("http://api.steampowered.com/ISteamApps/GetAppList/v2")
app_name_df <- do.call(rbind, lapply(steam_app_names, as.data.frame, stringsAsFactors = FALSE))
names(app_name_df) <- c("appid", "name")

# total query limit per 24 hours is 100,000: http://steamcommunity.com/dev/apiterms
# possible 200 queries per 5 minutes throttling limit: https://www.reddit.com/r/Steam/comments/304dft/steam_store_api_is_there_a_throttling_limit_on/

# need to run the appdetails query for each appid, but may need to space this
# out to respect the throttling limits

# 200 queries / 5 minutes * 60 minutes / 1 hour = 2400 per hour
(200 / 5) * (60 / 1)
# 19808 queries * 1 hour / 2400 queries ~ 8.25 hours
19808 / 2400

# quick test to see if this restriction applies
get_app <- function(appid) {
    if(!is.character(appid)) {
        appid <- as.character(appid)
    }
    app_detail_call <- paste0("http://store.steampowered.com/api/appdetails/?appids=",
                              appid)
    call_result <- fromJSON(app_detail_call)
    
    return(call_result)
}

get_all_apps <- function(appids, start_delay = 240) {
    total_ids <- length(appids)
    current_delay <- start_delay
    app_list <- list()
    
    for(i in 1:total_ids) {
        call_result <- try(get_app(appids[i]))
        
        call_fail <- typeof(call_result) != "list"
        if(call_fail) {
            message("Delay required...")
            added_secs <- 0
            Sys.sleep(current_delay)
            
            call_result <- try(get_app(appids[i]))
            call_fail <- typeof(call_result) != "list"
            
            while(call_fail) {
                Sys.sleep(1)
                added_secs <- added_secs + 1
            
                call_result <- try(get_app(appids[i]))
                call_fail <- typeof(call_result) != "list"
            }
            
            current_delay <- current_delay + added_secs
            message(paste0("Target delay seconds = ", current_delay))
        }
        
        app_list[names(call_result)] <- call_result
        message(paste0(i, " of ", total_ids))
    }
    
    message("Final delay seconds = ", current_delay)
    return(app_list)
}

raw_app_data <- get_all_apps(app_name_df$appid)

save(raw_app_data, file = "raw_app_data.rda")

