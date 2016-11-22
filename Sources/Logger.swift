import Foundation
import HTTP

public enum logType {
    case combined
    case common
    case dev
    case short
    case tiny
}

public class Logger: Middleware {
    
    enum fileError: Error {
        case notWritable
        case notCreated(atPath: String)
        case contentUnavailable
        case invalidFile(path: String)
    }
    
    var file: String
    var format: logType
    
    public init(format: logType = .combined, file: String = "logs.txt") {
        self.format = format
        self.file = file
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let requestInTime: Date = Date()
        let remoteAddr = request.peerAddress!.address()
        let method = request.method
        let url = request.uri
        
        let response = try next.respond(to: request)
        
        let responseTime = Date().timeIntervalSince(requestInTime)
        let status = response.status.statusCode
        let httpVersion = "HTTP/\(response.version.major).\(response.version.minor)"
        
        // TODO: set remoteUser if user authenticated
        let remoteUser = "-"
        // TODO: check how to get reponse[content-length]
        let responseContentLength = "-"
        
        var referer = "-"
        if request.headers["referer"] != nil {
            referer = (request.headers["referer"])!
        }
        
        var userAgent = "-"
        if request.headers["User-Agent"] != nil {
            userAgent = (request.headers["User-Agent"])!
        }
        
        var content: String = {
            switch format {
            case .combined:
                return "\(remoteAddr)\t-\t\(remoteUser)\t[\(convertDateToCLF(date: requestInTime))]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\(responseContentLength)\t\"\(referer)\"\t\"\(userAgent)\""
            case .common:
                return "\(remoteAddr)\t-\t\(remoteUser)\t[\(convertDateToCLF(date: requestInTime))]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\\(responseContentLength)"
            case .dev:
                return "\(method)\t\(url)\t\(status)\t\(responseTime) ms\t\(responseContentLength)"
            case .short:
                return "\(remoteAddr)\t\(remoteUser)\t\(method)\t\(url)\t\(httpVersion)\t\(status)\t\(responseContentLength)\t\(responseTime) ms"
            case .tiny:
                return "\(method)\t\(url)\t\(status)\t\(responseContentLength)\t\(responseTime) ms"
            }
        }()
        content = content + "\n"
        
        do {
            try saveToFile(path: file, content: convertStringToData(content: content))
        } catch let error as Error {
            print(error.localizedDescription)
            print("Heimdall could not write to file")
        }
        return response
    }
    
    func convertDateToCLF(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MMM/y:H:m:s Z"
        return dateFormatter.string(from: date)
    }
    
    func convertStringToData(content: String) -> Data? {
        return content.data(using: String.Encoding.utf8)
    }
    
    func saveToFile(path: String, content: Data?) throws -> Bool {
        
        guard let data = content else {
            throw fileError.contentUnavailable
        }
        
        let toFile = NSString(string: path).expandingTildeInPath
        let fileManager = FileManager()
        
        if fileManager.fileExists(atPath: toFile) == false {
            guard fileManager.createFile(atPath: toFile, contents: data) == true else {
                throw fileError.notCreated(atPath: toFile)
            }
            return true
        } else {
            // check user permissions
            guard fileManager.isWritableFile(atPath: toFile) == true else {
                throw fileError.notWritable
            }
            // append to file
            guard let fileHandle = FileHandle(forWritingAtPath: toFile) else {
                throw fileError.invalidFile(path: toFile)
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
            return true
        }
    }
}
