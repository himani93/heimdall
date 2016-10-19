import Foundation
import HTTP

public class Logger: Middleware {
	let fileManager =  FileManager()
	var fileHandle: FileHandle? = nil

	public init () {

	}

	deinit {
		// close file handle if set
		if let fileHandle = fileHandle {
			fileHandle.closeFile()
		}
	}

	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		let file = "default_logs.txt"
		saveToFile(toFile: file, content: request.description)
		return try next.respond(to: request)
	}

	func saveToFile(toFile: String, content: String) -> Bool {
		do {
			if fileManager.fileExists(atPath: toFile) == false {
				// create new file
				try (content+"\n").write(toFile: toFile, atomically: true, encoding: .utf8)
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
			print("Request cannot be written to file.")
			return false
		}
	}
}
