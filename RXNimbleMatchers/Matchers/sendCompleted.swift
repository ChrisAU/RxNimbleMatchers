import Nimble
import RxSwift

/**
 Nimble matcher that matches if passed `Observer` completes when subscribed.
 - returns: `true` if the `Observer` completes when subscribed.
 */
public func sendCompleted<T: ObservableType>() -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "complete signal"
        guard let observable = try actualExpression.evaluate() else { return false }
        
        var didComplete = false
        failureMessage.actualValue = "no Completed event"
        _ = observable.subscribeCompleted {
            didComplete = true
        }
        
        return didComplete
    }
}
