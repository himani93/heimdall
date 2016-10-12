import Foundation
import HTTP

public class VaporLogger: Middleware {
	public init () {

	}
	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    	print("\(request)")
	    return try next.respond(to: request)
	}
}
