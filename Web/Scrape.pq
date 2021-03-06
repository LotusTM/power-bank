/*
  Get a curl command string for a given url and options (as used in Web.Contents()) for debugging purposes.

  Require: Web.Curl

  Usage:
  Web.Scrape = Load("Web/Scrape"),
  Web.Scrape("http://google.com", [#"Referer"="http://google.com"])

  Result: a binary representation of the Google front-page
*/

(url as text, optional options as record) as binary =>

let
  Web.Curl = Load("Web/Curl"),
  Response = Web.Contents(url, options),
  Buffered = Binary.Buffer(Response),
  Meta = try Value.Metadata(Response) otherwise null,
  Status = if Buffered = null then 0 else Meta[Response.Status],
  Return = if Status = 0 or Status >= 400  // Binary.Length(Buffered) = 0
    then error Error.Record("ScrapeFailed", Web.Curl(url, options), Meta)
    else Buffered
in
  Return
