#' Flattens an unpredictably nested list to a list with predictable structure.
#'
#' Nested hierarchies - such as a JSON object or an R list mimicking a JSON
#' object - can be thought of as lists of lists. R has many solutions for
#' efficiently operating over and extracting contents from lists. However, most
#' of these solutions - especially those which seek to flatten a nested list
#' into a dataframe - anticipate consistency across the elements of a list.
#'
#' These solutions break down when the content of elements is unpredictable -
#' such as when the number of sublists, their depth, and their contents vary
#' inconsistently.
#'
#' \code{extract_names_values} recursively travels down all possible paths of a
#' nested lest - all collections of nodes that lead to content - and returns a
#' predictably structured list.
#'
#' Specifically, the function tests whether the current element is a list. If
#' the element is a list, it adds it to a path description. If the element is
#' not a list, it is assumed to be content and all individual values present are
#' associated with the the path traveled to reach them, their order, and their
#' type.
#'
#' The end result is a list of lists, where each element list now has identical
#' contents: a character string describing the path traversed to reach content
#' ("path"), an integer describing the order in which a value was collected from
#' a piece of content ("order"), a character string describing the original type
#' of the collected value ("type"), and the value itself as a character string
#' ("value").
#'
#' Put another way, \code{extact_names_values} takes a hierarchy with uncertain
#' nesting and simplifies it to a three level hiearchy:
#'
#' - the top node (the name of the full nested list itself)
#' -- the path-order-type-value nodes (one numbered node per path ending in a
#'    value in the original list)
#' --- path (string), order (integer), type (string), value (string)
#'
#' Converting the value itself to character insures that the type will be
#' consistent so that the nodes can be collapsed into a long dataframe.
#'
#' @param nested_list The the nested list that should be flattened to a list of
#'   path-order-type-value nodes.
#' @param layer_name A character string that will be added to the front of
#'   current element names. This is primarily used to allow the function to
#'   build a path description as it traverses into deeper nodes.
#'
#' @return The function will return a list of lists. Each element list will
#'   consist of path (string), order (integer), type (string), and value
#'   (string) single element vectors.
#'
#' @examples
#' # Load the nested Steam API data.
#' data(steam_app_list)
#'
#' # The Steam API data is a list of nested lists, with each nested list
#' # representing a Steam app (e.g., PC game).
#'
#' # First we run the function on a nested list with minimal nesting/content.
#' simple_demo <- extract_names_values(steam_app_list["5"])
#'
#' # Compare that to a more complex nested list.
#' complex_demo <- extract_names_values(steam_app_list["50"])
#'
#' # Process multiple nested lists at once.
#' multi_demo <- lapply(steam_app_list[1:5], extract_names_values)
#'
#' # This is probably not what we want.
#' bad_demo <- extract_names_values(steam_app_list[1:5])
#'
#' @export
extract_names_values <- function(nested_list,
                                 layer_name = "") {
    # Create a bucket to catch the path-order-type-value lists we will be
    # generating.
    value_bucket <- list()

    # Get the names of the current list elements.
    element_names <- names(nested_list)

    # Update the element names with the current layer name to record the full
    # path to any returned values - this is handled differently if the list
    # has explicit names or not.

    # Check if the current list elements have explicit names...
    if(is.null(element_names)) {
        # If not, use the order of the elements as the names.
        path_names <- paste0(layer_name, 1:length(nested_list))
    } else {
        # If names are provided, use those.
        path_names <- paste0(layer_name, element_names)
    }

    # Loop over each list element...
    for(i in 1:length(nested_list)) {
        # For readability, get the current element and path to that element.
        current_element <- nested_list[[i]]
        current_path <- path_names[[i]]

        # Test if the element is a list and has content...
        if(typeof(current_element) == "list" &
           length(current_element) > 0) {
            # If a list with content, then loop over the elements of each list
            # recursively, flattening the list to lists of name--value pairs.
            # Pass the path observed thus far so that it is added to the next
            # layers.
            value_lists <- extract_names_values(current_element,
                                                paste0(current_path, "-")
            )

            # Add the results to the value bucket.
            value_bucket <- c(value_bucket, value_lists)
        } else if(typeof(current_element) == "list" &
                  length(current_element) == 0) {
            # If an empty list, then pass NAs to the collection object.
            value_bucket[[i]] <- list(
                "path" = current_path,
                "order" = 1,
                "type" = NA,
                "value" = NA
            )
        } else {
            # If not a list, assume we have arrived at content. Grab the values
            # and pass them individually to the collection object.
            for(value_index in 1:length(current_element)) {
                # First extract the value and record its type.
                raw_value <- current_element[[value_index]]
                raw_type <- typeof(raw_value)
                # Then convert the value to NA or a string as appropriate.
                clean_value <- ifelse(is.null(raw_value),
                                      NA,
                                      as.character(raw_value))

                # Then gather the key value list pieces and add them to the
                # bucket.
                value_bucket[[length(value_bucket) + 1]] <- list(
                    "path" = current_path,
                    "order" = value_index,
                    "type" = raw_type,
                    "value" = clean_value
                )
            }
        }
    }

    # Return the values extracted from the current nested list.
    return(value_bucket)
}
