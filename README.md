Logger for [Vapor](http://github.com/vapor/vapor)
--

Logs all request to ```default_logs.txt``` file created in current working directory

To use VaporLogger with Vapor ```import VaporLogger``` and append
VaporLoggerProvider to list of avaiable providers.

```
import Vapor
import HTTP
import VaporLogger

let drop = Droplet(providers: [VaporLogger.Provider.self])

drop.run()
```
