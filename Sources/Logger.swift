import Foundation
import HTTP

public class Logger: Middleware {
	let file = "logs.txt"
	let fileManager =  FileManager()
	var fileHandle: FileHandle? = nil

	public init() {

	}

	public init(logFile: String) {
		self.file = logFile
	}

	deinit {
		// close file handle if set
		if let fileHandle = fileHandle {
			fileHandle.closeFile()
		}
	}

	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		var content = "\(request.peerAddress!.address())\t\(Date().rfc1123)\t\(request.method)\t\(request.uri)\t\(request.headers)"
		saveToFile(toFile: file, content: content)
		return try next.respond(to: request)
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
			// Print to console that logger unable to write to file with reason
			print("Request cannot be written to file.")
			return false
		}
	}
}
