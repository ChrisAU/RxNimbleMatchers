import Quick
import Nimble
import RxSwift

class SendNextSpec: QuickSpec {
    override func spec() {
        describe("sendAnything() matcher") {
            it("matches if signal sends something") {
                expect(Observable<Int>.just(1)).to(sendAnything())
            }

            it("fails if signal errors") {
                expect(Observable<Void>.error(SomeError.Generic)).toNot(sendAnything())
            }

            it("fails if signal does not complete") {
                expect(Observable<Void>.never()).toNot(sendAnything())
            }
        }

        describe("sendNext(expected:) matcher") {
            it("matches if signal sends expected value") {
                expect(Observable<Int>.just(1)).to(sendNext(expected: 1))
            }

            it("matches if signal sends expected value in some Next event") {
                expect(Observable<Int>.of(2, 1)).to(sendNext(expected: 1))
            }

            it("fails if signal sends different value") {
                expect(Observable<Int>.just(2)).toNot(sendNext(expected: 1))
            }

            it("fails if signal does not complete") {
                expect(Observable<Int>.never()).toNot(sendNext(expected: 1))
            }

            it("fails if signal errors") {
                expect(Observable<Int>.error(SomeError.Generic)).toNot(sendNext(expected: 1))
            }
        }

        describe("sendNext(expected:when:) matcher") {
            var observer: AnyObserver<Int>!
            var observable: Observable<Int>!

            beforeEach {
                observable = Observable<Int>.create { o in
                    observer = o
                    return NopDisposable.instance
                }
            }

            it("matches if signal sends expected value from `when` trigger") {
                expect(observable).to(sendNext(expected: 1, when: { observer.onNext(1) }))
            }

            it("matches if signal sends expected value in some Next event from `when` trigger") {
                expect(observable).to(sendNext(expected: 1, when: {
                    observer.onNext(2)
                    observer.onNext(1)
                }))
            }

            it("fails if signal sends different value from `when` trigger") {
                expect(observable).toNot(sendNext(expected: 1, when: { observer.onNext(2) }))
            }

            it("fails if signal does not complete") {
                expect(Observable<Int>.never()).toNot(sendNext(expected: 1, when: {}))
            }

            it("fails if signal errors") {
                expect(Observable<Int>.error(SomeError.Generic)).toNot(sendNext(expected: 1, when: {}))
            }
        }
    }
}
