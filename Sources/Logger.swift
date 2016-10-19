import Foundation
import HTTP

public class Logger: Middleware {
	public init () {

	}
	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		try request.description.write(toFile: "default_logs.txt", atomically: true, encoding: String.Encoding.utf8)
		return try next.respond(to: request)
	}
}
