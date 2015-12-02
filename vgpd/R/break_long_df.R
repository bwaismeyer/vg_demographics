#' Distribute long dataframe into a list of subset dataframes.
#'
#' @export
break_long_df <- function(df, subset_column) {
    subset_names <- df %>%
        select_(subset_column) %>%
        unique() %>%
        unlist()

    subset_list <- list()

    for(i in 1:length(subset_names)) {
        conn <- RSQLite::dbConnect(RSQLite::SQLite(), dbname = db_path)

        subset_filter <- lazyeval::interp(quote(subset_column == current_name),
                                         subset_column = as.name(subset_column),
                                         current_name = subset_names[[i]])

        subset_list[[subset_names[[i]]]] df %>%
            filter_(subset_filter) %>%
            data.frame()
    }

    return(subset_list)
}
