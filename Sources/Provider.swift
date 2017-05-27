import Vapor

public final class Provider: Vapor.Provider {
    
    public static let repositoryName = "heimdall"
    
    public let logger: Logger
    
    enum ConfigError: Error {
        case configNotFound
        case invalidConfig
    }
    
    public func beforeRun(_: Vapor.Droplet) {}
    
    public init(config: Config) throws {
        guard let heimdallConfig = config["heimdall"]?.object else {
            logger = Logger()
            return
        }
        
        // Both file and format specified
        if let path = heimdallConfig["path"]?.string,
            let formatString = heimdallConfig["format"]?.string,
            let format =  LogType(rawValue: formatString) {
            self.logger = Logger(format: format, path: path)
        } else if let path = heimdallConfig["path"]?.string {
            // Only file specified
            self.logger = Logger(path: path)
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
    
    public init(path: String) {
        logger = Logger(path: path)
    }
    
    public init(format: LogType, path: String) {
        logger = Logger(format: format, path: path)
    }
    
    public func boot(_ drop: Droplet) { }
    
    public func boot(_ config: Config) throws {
        config.addConfigurable(middleware: logger, name: "heimdall")
    }
}
