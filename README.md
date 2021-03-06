Heimdall
---
An easy to use HTTP request logger for [Vapor: Web framework for swift](http://github.com/vapor/vapor).

Read a brief explanation about Heimdall's source code [here](https://medium.com/@ankitank/heimdall-writing-http-request-logger-for-vapor-6007d608b4fb).

## 📚 Documentation

Heimdall writes the logs to a tab separated file which can easily be opened in spread sheet software. By default, it logs all requests in ```combined``` format to ```~/``` path (user's home directory). The log file is named as Heimdall_YYYY-MM-DD.txt

Log format can be chosen from [Supported Formats](https://github.com/himani93/heimdall/blob/master/README.md#-supported-formats)

Requests can be logged in a custom file given the file path exists.

## 📓 How to Use

Add the following line to your Package.swift file:
```swift
.Package(url: "https://github.com/himani93/heimdall.git", majorVersion: 1)
```

In App/Config+Setup.swift ```import Heimdall``` and append
HeimdallProvider to list of avaiable providers.

```swift
import Heimdall

private func setupProviders() throws {
    try addProvider(Heimdall.Provider.self)
}
```

This default initialization uses `combined` as logging format and logs are saved to path `~/` i.e. the user's home directory.
To use a different logging format read below.

### Don't forget to add middleware in Config/droplet.json.
In the Config/droplet.json file, add "heimdall" to the appropriate middleware array.

```
{
    ...
    "middleware": [
            "heimdall", // Add heimdall as the first middleware
            ...
    ],
    ...
}
```

Note: Add heimdall as the first middleware so it correctly measures request response times.

:triangular_flag_on_post: **Heimdall Provider can be initialized in following ways**

```swift
private func setupProviders() throws {
    try addProvider(Heimdall.Provider(format: .tiny))
}
```

Uses `tiny` as logging format and logs are saved to default logging path `~/`(User's home directory).

---

```swift
private func setupProviders() throws {
    try addProvider(Heimdall.Provider(path: "/Users/blob/Desktop/Logs/"))
}
```

Uses default logging format `combined` and logged are saved at `/Users/blob/Desktop/Logs/` path. Please make sure that the path provided for the file exists.

---

```swift
private func setupProviders() throws {
    try addProvider(Heimdall.Provider(format: .tiny, path: "/Users/blob/Desktop/Logs/"))
}
```

Uses `tiny` as logging format and `/Users/blob/Desktop/Logs/` as log path. Please make sure that the path provided for the file exists.

---

:triangular_flag_on_post: **Heimdall Provider can also be initialized using a config file**

```swift
import Heimdall

private func setupProviders() throws {
    try addProvider(Heimdall.Provider.self)
}
```

```format``` and ```path``` location can be set in configuration file at ```Config/heimdall.json```.

Here's an example:

```json
{
  "format": "tiny",
  "path": "/Users/blob/Desktop/Logs/"
}
```
If you specify only one parameter in config file other will be set to default.

## 📒 Supported Formats

  :small_blue_diamond: complete

  Complete log output

| | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|
|remote address|-|remote user|date(clf format)|response time ms|"method url HTTP/http-version"|status|res[content-length]|"referrer"|"user-agent"|

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

## 📝 License

  [MIT](http://github.com/himani93/heimdall/blob/master/LICENSE.txt)

### 👤 Mentor

  This project was suggested by and completed under the mentorship of [Santosh Rajan](https://github.com/santoshrajan)

## 👥 Contributors

  [Himani Agrawal](https://github.com/himani93)

  [Ankit Goel](https://github.com/ankit1ank)
