import Vapor

public final class Provider: Vapor.Provider {
    public let logger: Logger
    enum ConfigError: Error {
        case configNotFound
    }
    
    public func beforeRun(_: Vapor.Droplet) {
    }
    
    public init(config: Config) throws {
        guard let heimdallConfig = config["heimdall"]?.object else {
            throw ConfigError.configNotFound
        }

        guard
            let file = heimdallConfig["file"]?.string,
            let format = heimdallConfig["format"]?.string else {
                self.logger = Logger()
                return
        }

        let formatType: LogType = {
            switch format {
            case "common":
                return .common
            case "dev":
                return .dev
            case "short":
                return .short
            case "tiny":
                return .tiny
            default:
                return .combined
            }
        }()

        // TODO: call initializer based on existence of file and format
        self.logger = Logger(format: formatType)
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
    }
}
