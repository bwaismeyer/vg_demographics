#' Distribute long dataframe into a list of subset dataframes.
#'
#' @export
break_long_df <- function(df, subset_column) {
    subset_names <- df %>%
        select_(subset_column) %>%
        unique() %>%
        unlist()

    type_functions <- list(
        "character" = as.character,
        "logical" = as.logical,
        "integer" = as.integer,
        "double" = as.double,
        "NULL" = identity
    )

    subset_list <- list()

    for(i in 1:length(subset_names)) {
        subset_filter <- lazyeval::interp(quote(subset_column == current_name),
                                         subset_column = as.name(subset_column),
                                         current_name = subset_names[[i]])

        subset_df <- df %>%
            filter_(subset_filter) %>%
            data.frame()

        common_type_test <- length(unique(subset_df$type)) == 1

        subset_df <- subset_df %>%
            mutate(clean_type = ifelse(common_type_test,
                                       type,
                                       "character"))

        common_type <- unique(subset_df$clean_type)

        type_function <- ifelse(is.na(common_type),
                                identity,
                                type_functions[[common_type]])

        subset_df <- subset_df %>%
            mutate(clean_value = type_function(value))

        subset_list[[subset_names[[i]]]] <- subset_df
    }

    return(subset_list)
}
