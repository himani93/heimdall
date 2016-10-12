import Vapor

public final class VaporLoggerProvider: Vapor.Provider {
    public let provided: Providable

    public func beforeRun(_: Vapor.Droplet) {
        // drop.console.info("message from beforeRun")
    }
     public init(config: Config) throws {
        provided = Providable(middleware: ["logger": VaporLogger()])
    }

    public init() {
        provided = Providable(middleware: ["logger": VaporLogger()])
    }
    public func afterInit(_ drop: Droplet) {
        // drop.console.info("message from afterInit")
    }

    public func boot(_ drop: Droplet) {
        // drop.console.info("message from boot")
    }


}

/**
To use
let drop = Droplet(initializedProviders: [VaporLoggerProvider()])
let drop = Droplet(providers: [VaporLoggerProvider.self])

**/