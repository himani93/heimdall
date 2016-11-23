import Foundation
import HTTP

public enum LogType {
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
    
    var file: String
    var format: LogType
    
    public init(format: LogType = .combined, file: String = "logs.txt") {
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
            try saveToFile(path: file, content: content.data(using: String.Encoding.utf8))
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
    
    func convertDateToCLF(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MMM/y:H:m:s Z"
        return dateFormatter.string(from: date)
    }
    
    func saveToFile(path: String, content: Data?) throws {
        
        guard let data = content else {
            throw FileError.contentUnavailable
        }
        
        let toFile = NSString(string: path).expandingTildeInPath
        let fileManager = FileManager()
        
        if fileManager.fileExists(atPath: toFile) == false {
            guard fileManager.createFile(atPath: toFile, contents: data) == true else {
                throw FileError.notCreated
            }
        } else {
            // check user permissions
            guard fileManager.isWritableFile(atPath: toFile) == true else {
                throw FileError.notWritable
            }
            // append to file
            guard let fileHandle = FileHandle(forWritingAtPath: toFile) else {
                throw FileError.invalidFile
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        }
    }
}
