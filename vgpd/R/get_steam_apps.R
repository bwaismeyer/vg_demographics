#' Acquire raw Steam app list and features.
#'
#' This function interacts with the Steam API to acquire a list of Steam apps
#' and the features the API naturally associates with each app.
#'
#' When cleaned, this list will provide the sample of video game names we will
#' attach protagonist variables to. The list will also provide several other
#' game-specific variables of interest (e.g., release date, developer).
#'
#' In its raw format, the list has a number of non-game apps (e.g., Steam
#' server apps, collections of games, game videos). It is also based on a
#' JSON query, and so has nesting that is problematic for clean conversion
#' to a dataframe. In other words, it will require cleaning (handled by
#' other functions) to make it a useful dataframe to work with and build on.
#'
#' @section Run with caution:
#' This function is included in large part for documentation purposes - so that
#' it is clear how our data were sampled and processed.
#'
#' You are advised \strong{not to run} the function unless you are certain
#' you want to build the most current version of the Steam API data. Remember
#' that the vgpd package comes with dated versions of the raw and processed
#' Steam data for your use.
#'
#' Additional warnings:
#' \itemize{
#'  \item This function requires an active and stable internet connection.
#'  \item Due to the nature of the Steam API, the function deals with thresholds
#'      on queries-per-five-minutes (200) and how many games can be grabbed
#'      per query (1). As a result, the function takes a very long time to
#'      complete (e.g., the initial run took 8 hours).
#' }
#'
#' @param appids A character vector of Steam app ids. This is most easily
#'  obtained from the dataframe produced by \code{get_steam_app_ids}.
#' @param start_delay The function will attempt to measure how long it needs
#'  to wait between calls to the Steam API to avoid timeout requests. This
#'  tells the function what value to start with (in seconds). Too small and
#'  early tests will have a number of denied connections. Too large and the
#'  function will wait longer than it has to between requests.
#'
#' @return The function will return a nested list, converted from the JSON
#'  the Steam API initially provides.
#'
#' @examples
#' \dontrun{
#' # extract the app IDs from the id-name dataframe produced here
#' current_apps <- get_steam_app_ids()
#'
#' # get app data for all the app IDs using the default delay as a good
#' # starting point
#' raw_app_data <- get_steam_apps(current_apps$appid)
#' }
get_steam_apps <- function(appids, start_delay = 240) {
    # determine how many times the function will have to loop
    total_ids <- length(appids)

    # set the initial delay
    current_delay <- start_delay

    # define the bucket that app data will be tossed into
    app_list <- list()

    # loop over the appid vector
    for(i in 1:total_ids) {
        # attempt to get data for the current id from the Steam API
        call_result <- try(get_steam_app(appids[i]))

        # test if the attempt succeeded (it should produce a list)
        call_fail <- typeof(call_result) != "list"

        # if the attempt failed...
        if(call_fail) {
            # send a notice to the user that the call failed - this is usually
            # because the request-per-five-minute threshold has been reached
            # and a delay will be attempted
            message("Delay required...")

            # we will wait based on the current delay value but we create
            # a variable to track if additional time was needed before
            # requests succeeded
            added_secs <- 0
            Sys.sleep(current_delay)

            # after the delay, repeat the attempt to retrieve the app data
            # and retest the results
            call_result <- try(get_steam_app(appids[i]))
            call_fail <- typeof(call_result) != "list"

            # continue the grab-test pattern at 1 second intervals, tracking
            # how many times a second is added before success
            while(call_fail) {
                Sys.sleep(1)
                added_secs <- added_secs + 1

                # safety catch based on personal experience with the API:
                # if a delay of 1000 seconds is not resolving the issue,
                # it is likely something is wrong with the app id list
                # or the user connection
                if(added_secs > 1000) {
                    stop("Attempts to query the Steam API appear to be ",
                         "failing even with a 1000 second delay.")
                }

                call_result <- try(get_steam_app(appids[i]))
                call_fail <- typeof(call_result) != "list"
            }

            # update the delay with the amount of time observed before
            # requests started succeeding again
            current_delay <- current_delay + added_secs

            # let the use know what the current delay between queries will
            # be
            message(paste0("Target delay seconds = ", current_delay))
        }

        app_list[names(call_result)] <- call_result
        message(paste0(i, " of ", total_ids))
    }

    # pass on some details about the exchange with the Steam API to the user
    # and return the raw app data
    message("Final delay seconds = ", current_delay)
    return(app_list)
}
