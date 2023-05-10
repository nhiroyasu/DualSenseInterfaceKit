import Foundation

protocol AlertPresenter {
    func report(error: Error)
}

class AlertPresenterImpl: AlertPresenter {
    private let alertDialogService: AlertDialogService

    init(alertDialogService: AlertDialogService) {
        self.alertDialogService = alertDialogService
    }

    func report(error: Error) {
        alertDialogService.showWarning(title: error.localizedDescription)
    }
}
