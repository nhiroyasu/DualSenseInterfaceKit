import Foundation
import Combine

protocol ApplicationLifeCycleController {
    func didFinishLaunch()
    func willTerminate()
}

class ApplicationLifeCycleControllerImpl: ApplicationLifeCycleController {
    private let reportObservingUseCase: DualSenseReportObservingUseCase
    private let reportSubscriber: DualSenseReportSubscriber
    private let reportSubject: DualSenseReportSubject

    init(reportObservingUseCase: DualSenseReportObservingUseCase, reportSubscriber: DualSenseReportSubscriber, reportSubject: DualSenseReportSubject) {
        self.reportObservingUseCase = reportObservingUseCase
        self.reportSubscriber = reportSubscriber
        self.reportSubject = reportSubject
    }

    func didFinishLaunch() {
        setupDualSenseReportPublisher()
        setupDualSenseReportObserver()
    }

    func willTerminate() {
        reportObservingUseCase.dispose()
        print("will Terminate")
    }

    private func setupDualSenseReportPublisher() {
        reportObservingUseCase.observe(reportHandler: reportSubject.send(_:))
    }

    private func setupDualSenseReportObserver() {
        reportSubject.receive(subscriber: reportSubscriber)
    }
}
