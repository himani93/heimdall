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
		let requestInTime = Date()
		let remoteAddr = request.peerAddress!.address()
		let method = request.method
		let url = request.uri
		// let headers = request.headers
		let userAgent = request.headers["User-Agent"]
		var response = try next.respond(to: request)

		let responseTime = Date().timeIntervalSince(requestInTime)
		let status = response.status.statusCode
		let httpVersion = "HTTP/\(response.version.major).\(response.version.minor)"

		let content: String = {
			switch format {
				case "combined":
					return "\(remoteAddr)\tremote-user\t[date-clf]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\tresponse-content-length\t\"referrer\"\t\"\(userAgent)\""
				case "common":
					return "\(remoteAddr)\tremore-user\t[date-clf]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\response-content-length"
				case "dev":
					return "\(method)\t\(url)\t\(status)\t\(responseTime) ms\tresponse-content-length"
				case "short":
					return "\(remoteAddr)\tremote-user\t\(method)\t\(url)\t\(httpVersion)\t\(status)\tresponse-content-length\t\(responseTime) ms"
				case "tiny":
					return "\(method)\t\(url)\t\(status)\tresponse-content-length\t\(responseTime) ms"
				default:
					return "\(remoteAddr)\tremote-user\t[date-clf]\t\"\(method)\t\(url)\t\(httpVersion)\"\t\(status)\t\response-content-length\t\"referrer\"\t\"(userAgent)\""
			}
		}()

		saveToFile(toFile: file, content: content)
		return response
	}

	func saveToFile(toFile: String, content: String) -> Bool {
		do {
			if fileManager.fileExists(atPath: toFile) == false {
				// create new file
				let header = "REMOTE IP ADDRESS\tDATETIME\tREQUEST METHOD\tREQUEST URI\tREQUEST HEADERS"
				try (header + "\n" + content + "\n").write(toFile: toFile, atomically: true, encoding: .utf8)
			} else {
				// append to file
				if fileHandle == nil {
					fileHandle = try FileHandle(forWritingAtPath: toFile)
				}
				if let fileHandle = fileHandle {
					let _ = fileHandle.seekToEndOfFile()
					if let data = (content+"\n").data(using: String.Encoding.utf8) {
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
