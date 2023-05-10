import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let applicationLifeCycleController: ApplicationLifeCycleController = ApplicationLifeCycleControllerImpl(
        reportObservingUseCase: DualSenseReportObservingUseCaseImpl(
            alertPresenter: AlertPresenterImpl(
                alertDialogService: AlertDialogServiceImpl()
            )
        ),
        reportSubscriber: DualSenseReportSubscriber(
            reportController: DualSenseReportControllerImpl(
                eventInspectionUseCase: DualSenseEventInspectionUseCaseImpl(),
                eventStreamingUseCase: DualSenseEventStreamingUseCaseImpl()
            )
        ),
        reportSubject: SubjectContainer.shared.retrieve()
    )


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        applicationLifeCycleController.didFinishLaunch()
        NSApplication.shared.windows.first?.level = .floating
        NSApplication.shared.windows.first?.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .stationary]
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        applicationLifeCycleController.willTerminate()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

