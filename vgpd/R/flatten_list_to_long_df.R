#' A wrapper to flatten an unpredictably nested list into a long dataframe.
#'
#' \code{flatten_list_to_long_df} uses \code{extract_names_values} to flatten an
#' unpredictably nested list into a predictable collection of
#' path-order-type-value lists.
#'
#' It then collapses these commonly structured sublists into a long dataframe
#' with each sublist becoming a row.
#'
#' This dataframe is attached to a dataframe containing the nested list name
#' (required) to insure that the rows are associated correctly with their
#' source list.
#'
#' @param nested_list A nested list to be flattened into a long dataframe.
#' @param nested_list_name The name of the list that should be associated with
#'   all the path-order-type-value rows making up the long dataframe.
#'
#' @return Returns a long-format dataframe with one row for each
#'   path-order-type-value observed in a nested list.
#'
#' @examples
#' # Load the nested Steam API data.
#' data(steam_app_list)
#'
#' # The Steam API data is a list of nested lists, with each nested list
#' # representing a Steam app (e.g., PC game).
#'
#' # First we run the function on a nested list with minimal nesting/content.
#' simple_demo <- flatten_list_to_long_df(steam_app_list["5"])
#'
#' # Compare that to a more complex nested list.
#' complex_demo <- flatten_list_to_long_df(steam_app_list["50"])
#'
#' # Process multiple nested lists at once (but see flatten_list_to_df for
#' # the behavior you probably want).
#' multi_demo <- lapply(steam_app_list[1:5], flatten_list_to_long_df)
#'
#' # This is probably not what we want.
#' bad_demo <- flatten_list_to_long_df(steam_app_list[1:5])
#'
#' @export
flatten_list_to_long_df <- function(nested_list, nested_list_name) {
    # Flatten the list to list of path-order-type-value lists.
    flat_list <- extract_names_values(nested_list)

    # Convert the list of lists into a list of single-row dataframes.
    df_list <- lapply(flat_list, function(x) {
        data.frame("path" = x$path,
                   "order" = x$order,
                   "type" = x$type,
                   "value" = x$value,
                   stringsAsFactors = FALSE)
    })

    # Merge the dataframes.
    long_df <- dplyr::rbind_all(df_list)

    # Create a single column dataframe for the nested_list_name with an
    # appropriate number of rows.
    name_df <- data.frame("source" = rep(nested_list_name, nrow(long_df)),
                          stringsAsFactors = FALSE)

    # Join the dataframes.
    long_df <- cbind(name_df, long_df)

    # Return the long dataframe.
    return(long_df)
}
