import Quick
import Nimble
import RxSwift

enum SomeError: ErrorType { case Generic }

class SendCompletedSpec: QuickSpec {
    override func spec() {
        describe("sendCompleted() matcher") {
            it("matches if signal completes") {
                expect(Observable<Void>.empty()).to(sendCompleted())
            }
            
            it("matches if signal sends and completes") {
                expect(Observable<Int>.just(1)).to(sendCompleted())
            }

            it("fails if signal errors") {
                expect(Observable<Void>.error(SomeError.Generic)).toNot(sendCompleted())
            }
            
            it("fails if signal does not complete") {
                expect(Observable<Void>.never()).toNot(sendCompleted())
            }
        }
    }
}
