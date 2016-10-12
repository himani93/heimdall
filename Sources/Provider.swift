import Vapor

public final class Provider: Vapor.Provider {
    public let provided: Providable

    public func beforeRun(_: Vapor.Droplet) {
        // drop.console.info("message from beforeRun")
    }
     public init(config: Config) throws {
        provided = Providable(middleware: ["logger": Logger()])
    }

    public init() {
        provided = Providable(middleware: ["logger": Logger()])
    }
    public func afterInit(_ drop: Droplet) {
        // drop.console.info("message from afterInit")
    }

    public func boot(_ drop: Droplet) {
        // drop.console.info("message from boot")
    }


}