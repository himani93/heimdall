import Foundation
import HTTP

public enum LogType: String {
    case complete
    case combined
    case common
    case dev
    case short
    case tiny
}

enum FileError: Error {
    case notWritable
    case notCreated
    case contentUnavailable
    case invalidFile
}

public class Logger: Middleware {
    
    var path: String
    var format: LogType
    
    public init(format: LogType = .complete, path: String = "./") {
        self.format = format
        self.path = path
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
        
        // TODO: Set remoteUser if user authenticated
        let remoteUser = "-"
        
        let responseContentLength = response.body.bytes != nil ? String(describing: response.body.bytes!.count) : "-"
        
        let referer = request.headers["referer"] ?? "-"
        
        let userAgent = request.headers["User-Agent"] ?? "-"
        
        var content: String = {
            switch format {
            case .complete:
                return "\(remoteAddr)\t\(remoteUser)\t[\(requestInTime.clfString())]\t\(responseTime) ms\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\(responseContentLength)\t\"\(referer)\"\t\"\(userAgent)\""
            case .combined:
                return "\(remoteAddr)\t\(remoteUser)\t[\(requestInTime.clfString())]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\(responseContentLength)\t\"\(referer)\"\t\"\(userAgent)\""
            case .common:
                return "\(remoteAddr)\t\(remoteUser)\t[\(requestInTime.clfString())]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\(responseContentLength)"
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
            try saveToFile(path: path + "\(Date().logFormat()).txt", content: content.data(using: String.Encoding.utf8))
        } catch let error as FileError {
            switch error {
            case .notWritable:
                print("Heimdall failed to write to file. Make sure you have write permission.")
            case .invalidFile:
                print("Heimdall was unable to read the file.")
            case .contentUnavailable:
                print("Heimdall failed to write the data.")
            case .notCreated:
                print("Heimdall failed to create the log file. Please check the path is valid and you have right permissiosns.")
            }
        }
        return response
    }
    
    func saveToFile(path: String, content: Data?) throws {
        
        guard let data = content else {
            throw FileError.contentUnavailable
        }
        
        let toFile = NSString(string: path).expandingTildeInPath
        let fileManager = FileManager()
        
        if self.path.characters.last != "/" {
            self.path += "/"
        }
        
        if !fileManager.fileExists(atPath: toFile) {
            guard fileManager.createFile(atPath: toFile, contents: data) else {
                throw FileError.notCreated
            }
        } else {
            // Check user permissions
            guard fileManager.isWritableFile(atPath: toFile) else {
                throw FileError.notWritable
            }
            // Append to file
            guard let fileHandle = FileHandle(forWritingAtPath: toFile) else {
                throw FileError.invalidFile
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        }
    }
}

public extension Date {
    func clfString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MMM/y:H:m:s Z"
        return dateFormatter.string(from: self)
    }
    
    func logFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
