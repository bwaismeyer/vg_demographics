#' Acquire the raw data for a single Steam app.
#'
#' This function interacts with the Steam API to acquire the list of features
#' available for the app.
#'
#' \code{get_app} can be used on its own but was primarily designed as a helper
#' function for \code{get_steam_apps}. That function iterates over a list of
#' Steam app IDs and uses \code{get_app} to get the features for each app.
#'
#' @param appid A steam app ID. If integer or numeric, it will be converted
#'  to character.
#'
#' @return The function will return a nested list of app features, converted
#'  from the JSON returned by the API.
#'
#' @examples
#' \dontrun{
#' # grab the IDs and names for all apps currently listed on the Steam API
#' current_apps <- get_steam_app_ids()
#'
#' # grab the data for one of the apps
#' single_app <- get_steam_app(current_apps[500])
#' }
get_steam_app <- function(appid) {
    # if the input isn't character, convert it
    if(!is.character(appid)) {
        appid <- as.character(appid)
    }

    # define the Steam API query, inserting the target appid
    app_detail_call <- paste0("http://store.steampowered.com/api/appdetails/?appids=",
                              appid)

    # complete the query - this converts the returned JSON to a list
    call_result <- jsonlite::fromJSON(app_detail_call)

    # return the resulting list
    return(call_result)
}
