import Foundation
import Combine

protocol MainStateModifier {
    func updateReport(report: DualSenseReport)
    func switchObserving()
}

class MainStore: MainStateModifier {
    private let stateSubject: CurrentValueSubject<MainViewState, Never>

    init(stateSubject: CurrentValueSubject<MainViewState, Never>) {
        self.stateSubject = stateSubject
    }

    func updateReport(report: DualSenseReport) {
        var state = stateSubject.value
        state.report = report
        stateSubject.send(state)
    }

    func switchObserving() {
        var state = stateSubject.value
        state.isObserving = !state.isObserving
        stateSubject.send(state)
    }
}
