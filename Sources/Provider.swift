import Vapor

public final class Provider: Vapor.Provider {
    public let logger: Logger

    public func beforeRun(_: Vapor.Droplet) {
    }

    public init(config: Config) throws {
        logger = Logger()
    }

    public init () {
        logger = Logger()
    }

    public init (format: String) {
        logger = Logger(format: format)
    }

    public func afterInit(_ drop: Droplet) {
    }

    public func boot(_ drop: Droplet) {
        drop.middleware.append(logger)
    }
}
