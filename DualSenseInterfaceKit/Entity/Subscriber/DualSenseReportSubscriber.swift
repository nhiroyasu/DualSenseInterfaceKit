import Foundation
import Combine

final class DualSenseReportSubscriber: Subscriber {
    private let reportController: DualSenseReportController

    init(reportController: DualSenseReportController) {
        self.reportController = reportController
    }

    typealias Input = DualSenseReport
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }

    func receive(_ input: DualSenseReport) -> Subscribers.Demand {
        reportController.receive(report: input)
        return .max(1)
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}
