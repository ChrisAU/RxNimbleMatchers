import Nimble
import RxSwift

/**
 Nimble matcher that matches if passed `Observer` sends any `Error` event when subscribed.
 - returns: `true` if the `Observer` errors event when subscribed.
 */
public func sendError<T: ObservableType>() -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "error signal"
        guard let observable = try actualExpression.evaluate() else { return false }
        
        var didError = false
        failureMessage.actualValue = "no error"
        _ = observable.subscribeError { _ in
            didError = true
        }
        
        return didError
    }
}
