import AppKit

protocol AlertDialogService {
    func showWarning(title: String)
}

class AlertDialogServiceImpl: AlertDialogService {
    func showWarning(title: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = title
        alert.runModal()
    }
}
