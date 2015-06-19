#' Get or set IFTTT_KEY value
#'
#' The API wrapper functions in this package all rely on an IFTTT API
#' key residing in the environment variable \code{IFTTT_API_KEY}. The
#' easiest way to accomplish this is to set it in the `\code{.Renviron}` file in your
#' home directory.
#'
#' @param force force setting a new IFTTT API key for the current environment?
#' @return atomic character vector containing the IFTTT API key
#' @export
ifttt_api_key <- function(force = FALSE) {

  env <- Sys.getenv('IFTTT_API_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var IFTTT_API_KEY to your IFTTT API key",
      call. = FALSE)
  }

  message("Couldn't find env var IFTTT_API_KEY See ?ifttt_api_key for more details.")
  message("Please enter your API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("IFTTT API key entry failed", call. = FALSE)
  }

  message("Updating IFTTT_API_KEY env var")
  Sys.setenv(IFTTT_KEY = pat)

  pat

}

#' Issue IFTTT maker channel POST event
#'
#' @param event event name to trigger in IFTTT recipe
#' @param value1 event parameter (optional)
#' @param value3 event parameter (optional)
#' @param value2 event parameter (optional)
#' @export
maker <- function(event=NULL, value1=NULL, value2=NULL, value3=NULL) {

  if (is.null(event)) stop("'event' must be non-NULL", call. = FALSE)

  url <- sprintf("https://maker.ifttt.com/trigger/%s/with/key/%s/", event, ifttt_api_key())

  resp <- POST(url, body=list(value1=value1, value2=value2, value3=value3))

  warn_for_status(resp)

}
