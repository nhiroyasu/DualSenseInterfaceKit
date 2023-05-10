import Foundation
import Combine

protocol DualSenseReportController {
    func receive(report: DualSenseReport)
}

class DualSenseReportControllerImpl: DualSenseReportController {
    private let eventInspectionUseCase: DualSenseEventInspectionUseCase
    private let eventStreamingUseCase: DualSenseEventStreamingUseCase
    private var previousReport: DualSenseReport?

    init(
        eventInspectionUseCase: DualSenseEventInspectionUseCase,
        eventStreamingUseCase: DualSenseEventStreamingUseCase
    ) {
        self.eventInspectionUseCase = eventInspectionUseCase
        self.eventStreamingUseCase = eventStreamingUseCase
    }

    func receive(report: DualSenseReport) {
        if let previousReport {
            let events = eventInspectionUseCase.inspect(currentReport: report, preReport: previousReport)
            _ = events
                .publisher
                .sink(receiveValue: eventStreamingUseCase.eventHandler(_:))
        }
        self.previousReport = report
    }
}
