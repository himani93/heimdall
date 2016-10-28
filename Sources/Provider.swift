import Vapor

public final class Provider: Vapor.Provider {
    public let provided: Providable

    public func beforeRun(_: Vapor.Droplet) {
    }

    public init(config: Config) throws {
        provided = Providable(middleware: ["logger": Logger()])
    }

    public init() {
        provided = Providable(middleware: ["logger": Logger()])
    }

    public func afterInit(_ drop: Droplet) {
    }

    public func boot(_ drop: Droplet) {
        drop.middleware.append(Logger())
    }
}
