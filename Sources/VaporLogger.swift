import Foundation
import HTTP

public class VaporLogger {
	public init () {

	}
	public func defaultLogger() -> ((Request) -> Void) {
		print("I am default Logger")
		func requestLogger(req: Request) {
			print(req)
		}
		return requestLogger
	}

}
