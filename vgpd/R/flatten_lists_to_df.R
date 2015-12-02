#' A wrapper to flatten a list of unpredictably nested lists into a single
#' long dataframe.
#'
#' \code{flatten_lists_to_df} uses \code{flatten_list_to_long_df} to flatten
#' each unpredictably nested sublist into a long dataframe associated with
#' the sublist name (or order, if names are not provided).
#'
#' It then combines these lists into a single long list.
#'
#' @param list A list of nested lists.
#'
#' @return Returns a long-format dataframe with each row being a
#'   source-path-order-type-value observation derived from the list of nested
#'   lists.
#'
#' @examples
#' #' # Load the nested Steam API data.
#' data(steam_app_list)
#'
#' # The Steam API data is a list of nested lists, with each nested list
#' # representing a Steam app (e.g., PC game).
#' df_demo <- flatten_lists_to_df(steam_app_list[1:5])
#'
#' @export
flatten_lists_to_df <- function(list) {
    # Check if the list elements are named...
    if(is.null(names(list))) {
        # If no names, then use the element order as names.
        element_names <- as.character(1:length(list))
    } else {
        # Otherwise use the given names.
        element_names <- as.character(names(list))
    }

    # Flatten the nested lists into long dataframes.
    df_list <- lapply(1:length(list), function(i) {
        current_element_name <- element_names[[i]]
        current_element <- list[[i]]

        return(flatten_list_to_long_df(current_element,
                                       current_element_name))
    })

    # Merge into a common dataframe.
    df <- dplyr::rbind_all(df_list)

    # Return the flattened dataframe.
    return(df)
}
