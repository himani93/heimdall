import Foundation
import HTTP

public class Logger: Middleware {
	var file = "logs.txt"
	let fileManager =  FileManager()
	var fileHandle: FileHandle? = nil
	var format: String

	public init(format: String) {
		self.format = format
	}

	public convenience init() {
		self.init(format: "combined")
	}

	deinit {
		// close file handle if set
		if let fileHandle = fileHandle {
			fileHandle.closeFile()
		}
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

		let content: String = {
			switch format {
				case "combined":
					return "\(remoteAddr)\t-\t\(remoteUser)\t[\(convertDateToCLF(date: requestInTime))]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\(responseContentLength)\t\"\(referer)\"\t\"\(userAgent)\""
				case "common":
					return "\(remoteAddr)\t-\t\(remoteUser)\t[\(convertDateToCLF(date: requestInTime))]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\\(responseContentLength)"
				case "dev":
					return "\(method)\t\(url)\t\(status)\t\(responseTime) ms\t\(responseContentLength)"
				case "short":
					return "\(remoteAddr)\t\(remoteUser)\t\(method)\t\(url)\t\(httpVersion)\t\(status)\t\(responseContentLength)\t\(responseTime) ms"
				case "tiny":
					return "\(method)\t\(url)\t\(status)\t\(responseContentLength)\t\(responseTime) ms"
				default:
					return "\(remoteAddr)\t\(remoteUser)\t[\(convertDateToCLF(date: requestInTime))]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\\(responseContentLength)\t\"\(referer)\"\t\"(userAgent)\""
			}
		}()

		saveToFile(toFile: file, content: content)
		return response
	}

	func convertDateToCLF(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d/MMM/y:H:m:s Z"
		return dateFormatter.string(from: date)
	}

	func saveToFile(toFile: String, content: String) -> Bool {
		do {
			if fileManager.fileExists(atPath: toFile) == false {
				// create new file
				try (content + "\n").write(toFile: toFile, atomically: true, encoding: .utf8)
			} else {
				// append to file
				if fileHandle == nil {
					fileHandle = try FileHandle(forWritingAtPath: toFile)
				}
				if let fileHandle = fileHandle {
					let _ = fileHandle.seekToEndOfFile()
					if let data = (content + "\n").data(using: String.Encoding.utf8) {
						fileHandle.write(data)
					}
				}
			}
			return true
		} catch {
			print("Heimdall cannot write to file.")
			return false
		}
	}
}
