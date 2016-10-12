import Foundation
import HTTP

public class Logger: Middleware {
	public init () {

	}
	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    	print("\(request)")
	    return try next.respond(to: request)
	}
}
