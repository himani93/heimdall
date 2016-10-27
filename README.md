Logger for [Vapor: Web framework for swift](http://github.com/vapor/vapor)
--

Logs all request to ```logs.txt``` file created in the project root

To use VaporLogger with Vapor ```import VaporLogger``` and append
VaporLoggerProvider to list of avaiable providers.

```
import Vapor
import HTTP
import VaporLogger

let drop = Droplet(providers: [VaporLogger.Provider.self])

drop.run()
```

If you want to save logs to a different location, just initialise the provider with a path.

```
import Vapor
import HTTP
import VaporLogger

let loggerProvider = VaporLogger.Provider(logFile: "/path/to/logfile.text")
let drop = Droplet(providers: [loggerProvider])

drop.run()
```
