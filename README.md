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

If you want to save logs to a different location, just initialise the provider with a path.

```
import Vapor
import HTTP
import Heimdall

let loggerProvider = Heimdall.Provider(logFile: "/path/to/logfile.text")
let drop = Droplet(providers: [loggerProvider])

drop.run()
```
