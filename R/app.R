#' Listen and react to IFTTT Maker web calls
#'
#' @param listem IP address to listen on. \code{127.0.0.1} for localhost,
#'        \code{0.0.0.0} (default) for all interfaces.
#' @param port TCP port to listen on. Defaults to \code{9999}
#' @param handler R function to call with the results of the Maker web call
#' @export
receiver <- function(listen="0.0.0.0", port=9999, handler=NULL) {

  if (is.null(handler) | class(handler) != "function") {
    stop("'handler' must be present and must be a function.")
  }

  require(Rook)

  status <- .Call(tools:::startHTTPD, listen, port)

  unlockBinding("httpdPort", environment(tools:::startDynamicHelp))
  assign("httpdPort", port, environment(tools:::startDynamicHelp))

  s <- Rhttpd$new()

  s$listenAddr <- listen
  s$listenPort <- port

  s$add(name="nifffty", app=function(env) {

    req <- Request$new(env)

    handler(req)

    resp <- Response$new()

    resp$finish()

  })

  return(s)

}
