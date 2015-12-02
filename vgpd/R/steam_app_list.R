#' Raw list of Steam apps returned by the Steam API.
#'
#' A list containing raw Steam app data. The list elements are inconsistent in
#' their content and many are nested.
#'
#' This object is considered a building block for creating the clean video
#' game / protagonist data. It is included with the \code{vgpd} package
#' for documentation and illustration purposes.
#'
#' @format
#' A list with as many elements as there were Steam app IDs at the time the
#' Steam API was queried.
#'
#' The app nodes vary in their content. Sometimes they appear to be simple
#' placeholders and will have nearly no content, but usually the will have
#' at least some features describing a Steam app (e.g., a PC game).
#'
#' @source
#' https://steamcommunity.com/dev
"steam_app_list"
