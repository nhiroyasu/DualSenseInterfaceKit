import Cocoa
import SwiftUI
import Combine

class ViewController: NSViewController {

    private let stateSubject = CurrentValueSubject<MainViewState, Never>(.init(report: defaultReportValue(), isObserving: false))

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = NSHostingController(rootView: MainView(
            controller: MainControllerImpl(
                reportSubject: SubjectContainer.shared.retrieve(),
                stateModifier: MainStore(stateSubject: stateSubject)
            ),
            reportPresenter: DualSenseReportPresenterImpl(),
            publisher: stateSubject,
            report: defaultReportValue(),
            isObserving: false
        ))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.autoresizingMask = [.height, .width]
        hostingController.view.frame = view.frame
    }
}

