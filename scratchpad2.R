bt_ext <- lapply(steam_app_list, extract_names_values)
bt_df <- make_name_value_df(bt_ext)

sum(ad_names$`data-name` %in% game_names$`data-name`)

ad_names <- bt_df %>%
    filter(`data-type` == "advertising") %>%
    select(`data-name`)

game_names <- bt_df %>%
    filter(`data-type` == "game") %>%
    select(`data-name`)

test <- bt_df[grepl("Neverwinter", bt_df$`data-name`), ]

test <- bt_df %>%
    filter(success == "TRUE") %>%
    apply(2, function(x) {sum(is.na(x))})

sort(test)

table(bt_df$success)

content_object <- steam_app_list[[5]]$data$categories$id

test <- list()

for(i in 1:length(content_object)) {
    test[[i]] <- list("name" = "puppy",
         "row" = i,
         "type" = typeof(content_object[[i]]),
         "value" = content_object[[i]])
}

test <- extract_names_values(steam_app_list[[5]])

test2 <- lapply(test, function(x) {
  data.frame(x$name, x$row, x$type, x$value,
             stringsAsFactors = FALSE)
})


test <- flatten_list_to_long_df(steam_app_list[[5]], "5")
test2 <- flatten_lists_to_df(steam_app_list[1:5])
test2 %>%
    group_by(path, type) %>%
    summarise() %>%
    ungroup() %>%
    group_by(path) %>%
    summarise(count = n()) %>%
    filter(count > 1)

btest <- flatten_lists_to_df(steam_app_list)
