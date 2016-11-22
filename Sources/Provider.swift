import Vapor

public final class Provider: Vapor.Provider {
    public let logger: Logger
    
    public func beforeRun(_: Vapor.Droplet) {
    }
    
    public init(config: Config) throws {
        logger = Logger()
    }
    
    public init() {
        logger = Logger()
    }
    
    public init(format: logType) {
        logger = Logger(format: format)
    }
    
    public init(file: String) {
        logger = Logger(file: file)
    }
    
    public init(format: logType, file: String) {
        logger = Logger(format: format, file: file)
    }
    
    public func afterInit(_ drop: Droplet) {
    }
    
    public func boot(_ drop: Droplet) {
        drop.middleware.append(logger)
    }
}
