import Foundation
import Combine

protocol MainController {
    func didTapStartButton()
    func didTapStopButton()
}

class MainControllerImpl: MainController {
    private let reportSubject: DualSenseReportSubject
    private var reportSubjectCanceler: AnyCancellable?
    private let stateModifier: MainStateModifier

    init(reportSubject: PassthroughSubject<DualSenseReport, Never>, stateModifier: MainStateModifier) {
        self.reportSubject = reportSubject
        self.stateModifier = stateModifier
    }

    func didTapStartButton() {
        reportSubjectCanceler = reportSubject.sink(receiveValue: stateModifier.updateReport(report:))
        stateModifier.switchObserving()
    }

    func didTapStopButton() {
        reportSubjectCanceler?.cancel()
        stateModifier.switchObserving()
    }
}
