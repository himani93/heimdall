Heimdall
---
A logger for [Vapor: Web framework for swift](http://github.com/vapor/vapor)


## :books: Documentation

Heimdall writes the logs to a tab separated file which can easily be opened in spread sheet software. By default, it logs all requests in ```combined``` format to ```./logs.txt``` file created in the project root. 

Log format can be chosen from [Supported Formats](https://github.com/himani93/heimdall/blob/master/README.md#ledger-supported-formats)

Requests can be logged in a custom file given the file path exists.

## :notebook: How to Use

To use Heimdall with Vapor ```import Heimdall``` and append
HeimdallProvider to list of avaiable providers.

```swift
import Vapor
import HTTP
import Heimdall

let drop = Droplet(providers: [Heimdall.Provider.self])

drop.run()
```

Uses `combined` as logging format and logs are saved to file `./logs.txt`.


:triangular_flag_on_post: **Heimdall Provider can be initialized in following ways**

```swift
  let dop = Droplet(providers: [Heimdall.Provider.self])
```
Default `combined` format and default logging file `./logs.txt` are used.

===

```swift
  let heimdall = Heimdall.Provider(format: .tiny)
  let drop = Droplet(initializedProviders: [heimdall])
```

Uses `tiny` as logging format and logs are saved to default logging file `./logs.txt`.

===

```swift
  let heimdall = Heimdall.Provider(file: "/Users/blob/Desktop/Logs/log.txt")
  let drop = Droplet(initializedProviders: [heimdall])
```

Uses default logging format `combined` and logged are saved at `/Users/blob/Desktop/Logs/log.txt`

===

```swift
  let heimdall = Heimdall.Provider(format: .tiny, file: "/Users/blob/Desktop/Logs/log.txt")
  let drop = Droplet(initializedProviders: [heimdall])
```

Uses `tiny` as logging format and `/Users/blob/Desktop/Logs/log.txt` as log file.

===

## :ledger: Supported Formats

  :small_blue_diamond: combined
  
  Standard Apache combined log output

| | | | | | | | | |
|---|---|---|---|---|---|---|---|---|
|remote address|-|remote user|date(clf format)|"method url HTTP/http-version"|status|res[content-length]|"referrer"|"user-agent"|
      
  :small_blue_diamond: common
  
  Standard Apache common log output

| | | | | | | |
|---|---|---|---|---|---|---|
|remote address|-|remote user|date(clf format)|"method url HTTP/http-version"|status|res[content-length]|

  :small_blue_diamond: dev
  
| | | | | | |
|---|---|---|---|---|---|
|method|url|status|response time ms|-|res[content-length]|


  :small_blue_diamond: short
  
| | | | | | | | | |
|---|---|---|---|---|---|---|---|---|
|remote address|remote user|method|url|HTTP/http-version|status|res[content-length]|-|response time ms|


  :small_blue_diamond: tiny
  
| | | | | | |
|---|---|---|---|---|---|
|method|url|status|res[content-length]|-|response time ms|

## 🔧 Compatibility

  This has been successfully tested on macOS and Ubuntu

## :pencil: License

  [MIT](http://github.com/himani93/heimdall/blob/master/LICENSE.txt)
  
## :busts_in_silhouette: Contributors

[Santosh Rajan](https://github.com/santoshrajan)

[Himani Agrawal](https://github.com/himani93)

[Ankit Goel](https://github.com/ankit1ank)
