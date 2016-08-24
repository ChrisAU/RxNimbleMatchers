import Quick
import Nimble
import RxSwift

class SendErrorSpec: QuickSpec {
    override func spec() {
        describe("sendError() matcher") {
            it("matches if signal errors") {
                expect(Observable<Void>.error(SomeError.Generic)).to(sendError())
            }

            it("fails if signal completes") {
                expect(Observable<Void>.empty()).toNot(sendError())
            }

            it("fails if signal never completes") {
                expect(Observable<Void>.never()).toNot(sendError())
            }
        }
    }
}
