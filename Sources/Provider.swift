import Vapor

public final class Provider: Vapor.Provider {
    
    public let logger: Logger
    
    enum ConfigError: Error {
        case configNotFound
        case invalidConfig
    }
    
    public func beforeRun(_: Vapor.Droplet) {
    }
    
    public init(config: Config) throws {
        guard let heimdallConfig = config["heimdall"]?.object else {
            throw ConfigError.configNotFound
        }

        // Both file and format specified
        if let file = heimdallConfig["file"]?.string,
        let formatString = heimdallConfig["format"]?.string,
        let format =  LogType(rawValue: formatString) {
            self.logger = Logger(format: format, file: file)
        } else if let file = heimdallConfig["file"]?.string {
            //Only file specified
            self.logger = Logger(file: file)
        } else if let formatString = heimdallConfig["format"]?.string,
            let format = LogType(rawValue: formatString) {
            // Only format specified
            self.logger = Logger(format: format)
        } else {
            throw ConfigError.invalidConfig
        }
    }
    
    public init() {
        logger = Logger()
    }
    
    public init(format: LogType) {
        logger = Logger(format: format)
    }
    
    public init(file: String) {
        logger = Logger(file: file)
    }
    
    public init(format: LogType, file: String) {
        logger = Logger(format: format, file: file)
    }
    
    public func afterInit(_ drop: Droplet) {
    }
    
    public func boot(_ drop: Droplet) {
        drop.middleware.append(logger)
        drop.middleware.append(AbortMiddleware())
    }
}
