Heimdall
---
A logger for [Vapor: Web framework for swift](http://github.com/vapor/vapor)

Heimdall writes the logs to file in the following format. It generates a tab separated file which can easily be opened in spread sheet software.

Logs all request to ```logs.txt``` file created in the project root

To use Heimdall with Vapor ```import Heimdall``` and append
HeimdallProvider to list of avaiable providers.

```swift
import Vapor
import HTTP
import Heimdall

let drop = Droplet(providers: [Heimdall.Provider.self])

drop.run()
```

or

```swift
import Vapor
import HTTP
import Heimdall

let heimdall = Heimdall.Provider(format: "dev")
let drop = Droplet(initializedProviders: [heimdall])

drop.run()
```

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
  
| | | | | |
|---|---|---|---|---|
|method|url|status|response time ms|res[content-length]|


  :small_blue_diamond: short
  
| | | | | | | | |
|---|---|---|---|---|---|---|---|
|remote address|remote user|method|url|HTTP/http-version|status|res[content-length]|-|response time ms|


  :small_blue_diamond: tiny
  
| | | | | | |
|---|---|---|---|---|---|
|method|url|status|res[content-length]|-|response time ms|


## 🔧 Compatibility

  This has been successfully tested on macOS and Ubuntu

## 🏫 Example Project
  Link to ankit goel project

## :pencil: License

  [MIT](http://github.com/himani93/heimdall/blob/master/LICENSE.txt)
