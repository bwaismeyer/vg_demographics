#' Get a dataframe of current Steam app ids and names.
#'
#' The Steam API restricts how much detailed app data you can grab at once and
#' in a given window of time. However, you are allowed to grab the index of app
#' ids and names in a single query.
#'
#' This is a convenience function to handle the index query and to process the
#' results into a dataframe for easy manipulation in R.
#'
#' The dataframe is useful for constructing the richer dataset of Steam app
#' data and assessing for differences between a working dataset and the
#' data now available on the API.
#'
#' @return The function returns a dataframe of the appids and names for all
#'  current Steam apps (as reported to the Steam API).
#'
#' @examples
#' \dontrun{
#' # grab the IDs and names for all apps currently listed on the Steam API
#' current_apps <- get_steam_app_ids()
#' }
get_steam_app_ids <- function() {
    # define the query that needs to be passed to the Steam API
    app_id_query <- "http://api.steampowered.com/ISteamApps/GetAppList/v2"

    # perform the query
    steam_app_ids <- jsonlite::fromJSON(app_id_query)

    # the query returns a list of lists - each app has its own list containing
    # an ID and a name; we convert each of those lists into a dataframe, giving
    # us a list of dataframes (which will be much easier to bind together)
    steam_app_ids <- lapply(steam_app_ids,
                            as.data.frame,
                            stringsAsFactors = FALSE)

    # bind the list of dataframes into a single dataframe
    app_id_df <- do.call(rbind,
                         # args to pass to rbind
                         c(steam_app_ids,
                         # skip the row names so we just get row numbers
                         make.row.names = FALSE)
    )

    # give the dataframe columns clear/concise names
    names(app_id_df) <- c("appid", "name")

    # return the df
    return(app_id_df)
}
