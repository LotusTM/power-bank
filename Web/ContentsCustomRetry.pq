/*
  This is an example of how one can use custom handling of a web response based on the request's response status.

  Require: Value.WaitFor

  Usage:
  Web.ContentsCustomRetry = Load("Web/ContentsCustomRetry"),
  Web.ContentsCustomRetry("http://api.worldbank.org/v2/countries?region=ECS&format=json")

  Result: 'curl "http://api.worldbank.org/v2/countries?region=ECS&format=json" -v'
*/

(url as text, optional options as record) => let
	Value.WaitFor = Load("Value/WaitFor")
in

Value.WaitFor(
	(i) =>
		let
			options2 = if options = null then [] else options,
			options3 = options2 & (if i=0 then [] else [IsRetry=true]),
			result = Web.Contents(url, options3 & [ManualStatusHandling={429}]),
			buffered = Binary.Buffer(result), // avoid risk of double request
			status = if buffered = null then 0 else Value.Metadata(result)[Response.Status],
			actualResult = if status = 429 then null else buffered
		in
			actualResult,
	(i) => #duration(0, 0, 0, i*0.1)
)
