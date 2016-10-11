import Foundation
import HTTP

public class VaporLogger {
	public init () {

	}
	public func defaultLogger(a: String) -> ((Request) -> String) {
		print("I am default Logger \(a)")
		func requestLogger(request: Request) -> String {
			print("\(request)")
			return "request logged!"
		}
		return requestLogger
	}
	public func middlewareLogger() -> ((Request, Responder) throws -> Response) {
		func respond(to request: Request, chainingTo next: Responder) throws -> Response {
	    	print("\(request)")
		    return try next.respond(to: request)
		}
		return respond
	}
	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    	print("\(request)")
	    return try next.respond(to: request)
	}
}
