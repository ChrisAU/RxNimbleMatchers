import Nimble
import RxSwift

/**
 Nimble matcher that matches if passed `Observer` sends expected `Next` event when subscribed
 and `when` closure is triggered.
 - returns: `true` if the `Observer` sends expected `Next` event when subscribed.
 */
public func sendNext<O: ObservableType where O.E: Equatable>(expected expected: O.E, when trigger: () -> ()) -> NonNilMatcherFunc<O> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "send `next` value '\(expected)'"
        guard let observable = try actualExpression.evaluate() else { return false }
        
        var didSendMatchingNext = false
        var receivedValues: [O.E] = []
        _ = observable.subscribeNext { next in
            didSendMatchingNext = didSendMatchingNext || (expected == next)
            receivedValues.append(next)
        }
        trigger()
        
        failureMessage.actualValue = receivedValues.isEmpty ? "no `next` values received" : "sequence: \(receivedValues)"
        
        return didSendMatchingNext
    }
}

/**
 Nimble matcher that matches if passed `Observer` sends expected `Next` event when subscribed.
 - returns: `true` if the `Observer` sends expected `Next` event when subscribed.
 */
public func sendNext<O: ObservableType where O.E: Equatable>(expected expected: O.E) -> NonNilMatcherFunc<O> {
    return sendNext(expected: expected, when: {})
}

/**
 Nimble matcher that matches if passed `Observer` sends any `Next` event when subscribed.
 - returns: `true` if the `Observer` sends any `Next` event when subscribed.
 */
public func sendAnything<O: ObservableType>() -> NonNilMatcherFunc<O> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "send something"
        guard let observable = try actualExpression.evaluate() else { return false }
        
        var receivedValue: O.E?
        _ = observable.subscribeNext { next in
            receivedValue = next
            failureMessage.actualValue = "`next` value received \(receivedValue)"
        }
        
        return receivedValue != nil
    }
}
