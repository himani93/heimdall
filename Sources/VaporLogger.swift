import Foundation
import HTTP

public class VaporLogger: Middleware {
	// public init () {

	// }
	// public func defaultLogger(a: String) -> ((Request) -> String) {
	// 	print("I am default Logger \(a)")
	// 	func requestLogger(request: Request) -> String {
	// 		print("\(request)")
	// 		// middleware should not return string instead a dict see Middleware class
	// 		//  does not conform to expected dictionary value type 'Middleware'
	// 		return "request logged!"

	// 	}
	// 	return requestLogger
	// }
	// public func middlewareLogger() -> ((Request, Responder) throws -> Response) {
	// 	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
	//     	print("\(request)")
	// 	    return try next.respond(to: request)
	// 	}
	// 	return respond
	// }
	public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    	print("\(request)")
	    return try next.respond(to: request)
	}
}
