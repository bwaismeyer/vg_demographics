# code style link: http://r-pkgs.had.co.nz/r.html#style

library(dplyr)
library(tidyr)
library(jsonlite)
library(stringr)

steamspy_data <- fromJSON("http://steamspy.com/api.php?request=all")
sp_df <- do.call(rbind, lapply(steamspy_data, as.data.frame, stringsAsFactors = FALSE))

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

# reload as needed
load("raw_app_data.rda")

# key targets in the raw app data
# data$type
# data$name
# data$steam_appid
# data$required_age
# data$is_free
# data$detailed_description
# data$about_the_game
# data$website
# data$developers
# data$publishers
# data$price_overview$currency
# data$price_overview$initial
# data$price_overview$final
# data$platforms$windwos
# data$platforms$mac
# data$platforms$linux
# data$metacritic$score
# data$metacritic$url
# data$categories (df: id, description)
# data$genres (df: id, description)
# data$recommendations$total
# data$achievements$total
# data$release_date$date
list_to_df <- function(app_list) {
    current_id <- names(app_list)
    contents <- app_list[[current_id]]

    if("data" %in% names(contents)) {
        target <- contents$data

        values <- list(
            "type" = target[["type"]],
            "name" = target[["name"]],
            "steam_appid" = target[["steam_appid"]],
            "required_age" = target[["required_age"]],
            "is_free" = target[["is_free"]],
            "detailed_description" = target[["detailed_description"]],
            "about_the_game" = target[["about_the_game"]],
            "website" = target[["website"]],
            "developers" = paste(target[["developers"]],
                                 collapse = "---"),
            "publishers" = paste(target[["publishers"]],
                                 collapse = "---"),
            "price_currency" = target[["price_overview"]][["currency"]],
            "price_initial" = target[["price_overview"]][["initial"]],
            "price_final" = target[["price_overview"]][["final"]],
            "platform_windows" = target[["platforms"]][["windows"]],
            "platform_mac" = target[["platforms"]][["mac"]],
            "platform_linux" = target[["platforms"]][["linux"]],
            "metacritic_score" = target[["metacritic"]][["score"]],
            "metacritic_url" =  target[["metacritic"]][["url"]],
            "recommendations" = target[["recommendations"]][["total"]],
            "achievements" = target[["achievements"]][["total"]],
            "release_date" = target[["release_date"]][["date"]],
            "categories" = paste(target[["categories"]][["description"]],
                                 collapse = "---"),
            "genres" = paste(target[["genres"]][["description"]],
                             collapse = "---")
        )

        values <- data.frame(do.call(cbind, values), stringsAsFactors = FALSE)
    } else {
        values <- data.frame("steamapp_id" = current_id)
    }

    return(values)
}

raw_to_df <- function(raw_app_data) {
    df_collection <- list()

    for(i in 1:length(raw_app_data)) {
        current_id <- names(raw_app_data)[i]
        df_collection[current_id] <- list(list_to_df[i])
    }

    df <- dplyr::rbind_all(df_collection)

    return(df)
}

list_to_df <- function(target) {

        values <- list(
            "type" = target[["type"]],
            "name" = target[["name"]],
            "steam_appid" = target[["steam_appid"]],
            "required_age" = target[["required_age"]],
            "is_free" = target[["is_free"]],
            "detailed_description" = target[["detailed_description"]],
            "about_the_game" = target[["about_the_game"]],
            "website" = target[["website"]],
            "developers" = paste(target[["developers"]],
                                 collapse = "---"),
            "publishers" = paste(target[["publishers"]],
                                 collapse = "---"),
            "price_currency" = target[["price_overview"]][["currency"]],
            "price_initial" = target[["price_overview"]][["initial"]],
            "price_final" = target[["price_overview"]][["final"]],
            "platform_windows" = target[["platforms"]][["windows"]],
            "platform_mac" = target[["platforms"]][["mac"]],
            "platform_linux" = target[["platforms"]][["linux"]],
            "metacritic_score" = target[["metacritic"]][["score"]],
            "metacritic_url" =  target[["metacritic"]][["url"]],
            "recommendations" = target[["recommendations"]][["total"]],
            "achievements" = target[["achievements"]][["total"]],
            "release_date" = target[["release_date"]][["date"]],
            "categories" = paste(target[["categories"]][["description"]],
                                 collapse = "---"),
            "genres" = paste(target[["genres"]][["description"]],
                             collapse = "---")
        )

        values <- data.frame(do.call(cbind, values), stringsAsFactors = FALSE)

    return(values)
}

raw_to_df <- function(raw_app_data) {

    df_collection <- lapply(raw_app_data, function(x) list_to_df(x$data))

    lapply(seq_along(df_collection), function(i) {
        if("steamapp_id" %in% names(df_collection[[i]])) {
            return(df_collection[i])
        } else {
            return(data.frame("steam_appid" = names(df_collection)[i]))
        }
    })

    #df <- dplyr::rbind_all(df_collection)

    return(df_collection)
}

app_df <- raw_to_df(raw_app_data)

# example code for grabbing basic features
head(sort(table(app_df$genres), decreasing = TRUE), 20)

# a few of our variables are complex, representing multiple values together
# (e.g., Action---Indie); we want to unpack these variables so that we can
# look at the combination or the single values

# we'll do this by identifying all of the unique types that can occur for
# these variables and creating flags for each... then we'll set the flags
# appropriately for each game

# we could assume that all the unique types occur alone at least once and so
# just grab the unique values without our separator (--) from the current
# data... but it is unclear if this assumption is merited or not (e.g., perhaps
# "Indie" never occurs alone)... alternatively, we could split all the values
# in a column, gather these into a single vector, and then use that as our
# list of flags...

# a function that will read down a column, splitting each value as it goes but
# pairing it with its app id
split_column <- function(column, split_by, id_col = NULL) {
    collected_splits <- c()

    if(is.null(id_col)) {
        for(i in 1:length(column)) {
            current_value <- column[i]
            value_vector <- unlist(str_split(current_value, split_by))

            collected_splits <- c(collected_splits, value_vector)
        }
    } else {
        collected_ids <- c()

        for(i in 1:length(column)) {
            current_value <- column[i]
            value_vector <- unlist(str_split(current_value, split_by))

            collected_splits <- c(collected_splits, value_vector)

            current_id <- id_col[i]
            id_vector <- rep(current_id, length(value_vector))

            collected_ids <- c(collected_ids, id_vector)
        }

        collected_splits <- data.frame(collected_ids, collected_splits,
                                       stringsAsFactors = FALSE)
    }

    return(collected_splits)
}

# complex cols: developers, publishers, categories, genres
cols_to_split <- c("developers", "publishers", "categories", "genres")

# I AM HERE:
# cols_to_split seems to work... but there is something wrong with the
# functions creating app_df... they are creating repeat records (e.g.,
# steam_appid == 80) in the end data frame - which means some records are
# getting missed and some are getting double counted

# TO TRY:
# no custom list... just keep unlisting until you hit values and paste the
# names on the way down together... apply paste to all... then can
# test later to see which cols need splitting...

# NOT unlist... for each, test... if typeof == list, then for each, test...
# if typeof != list, then paste all values (sep = "---") and pass the result
# out with the name of the path to the current item
extract_values <- function(nested_list, collapse_string = "---") {
    browser()
    # define vector
    value_bucket <- c()
    # grab item names
    item_names <- names(nested_list)
    # loop over each item in the raw_app list
    for(i in 1:length(nested_list)) {
        current_item <- nested_list[[i]]
        current_name <- item_names[[i]]
        # test if list... if not, grab the values and pass it to the
        # collection object, named after the current item
        if(typeof(current_item) != "list") {
            values <- paste(current_item, collapse = collapse_string)
            value_bucket <- c(value_bucket, current_name = values)
        } else {
            # if list, then loop over the elements of each list recursively,
            # passing out values when reached
            values <- extract_values(current_item)
            value_bucket <- c(value_bucket, values)
        }
    }

    # return the values extracted from the nested list - really the values
    # passed from the current nested list mode or the final product of
    # hybrid of grabs from direct nodes or recursive calls to the extract
    # function
    return(value_bucket)
}

## IF LIST IS 0, PASS NULL AND WALK AWAY BECAUSE IT'S FUCKED UP

test <- list()
for(i in 1:length(cols_to_split)) {
    current_var <- cols_to_split[[i]]
    current_col <- app_df[[current_var]]
    id_col <- app_df$steam_appid

    current_split <- split_column(current_col, "---", id_col)
    names(current_split) <- c("steam_appid", paste0("split_", current_var))

    test[current_var] <- list(current_split)
}

join_test <- app_df %>%
    left_join(test$developers) %>%
    left_join(test$publishers) %>%
    left_join(test$categories) %>%
    left_join(test$genres)

app_df %>%
    filter(steam_appid == 80) %>%
    data.frame()

app_df %>%
    group_by(steam_appid) %>%
    summarise(count = n()) %>%
    filter(count > 1) %>%
    data.frame()

names(raw_app_data)[!(names(raw_app_data) %in% app_df$steam_appid)]

join_test %>%
    filter(steam_appid == 80) %>%
    data.frame() %>%
    select(steam_appid, split_publishers, split_developers, split_categories, split_genres)
