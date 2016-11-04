Heimdall
---
A logger for [Vapor: Web framework for swift](http://github.com/vapor/vapor)


Logs all request to ```logs.txt``` file created in the project root

To use Heimdall with Vapor ```import Heimdall``` and append
HeimdallProvider to list of avaiable providers.

```
import Vapor
import HTTP
import Heimdall

let drop = Droplet(providers: [Heimdall.Provider.self])

drop.run()
```

or

```
import Vapor
import HTTP
import Heimdall

let heimdall = Heimdall.Provider(format: "dev")
let drop = Droplet(initializedProviders: [heimdall])

drop.run()
```
Heimdall writes the logs to file in the following format. It generates a tab separated file which can easily be opened in spread sheet software.

| REMOTE IP ADDRESS |	DATETIME |	REQUEST METHOD |	REQUEST URI |	REQUEST HEADERS |
|----------|:-------------:|:-------------:|:-------------:|------:|
|127.0.0.1:55166 |	Thu, 27 Oct 2016 17:01:27 GMT |	GET |	http://localhost:8080/index.html |	[Accept-Encoding: ... ] |
