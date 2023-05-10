import Foundation

protocol DualSenseReportObservingUseCase {
    func observe(reportHandler: @escaping (DualSenseReport) -> Void)
    func dispose()
}

class DualSenseReportObservingUseCaseImpl: DualSenseReportObservingUseCase {
    private let alertPresenter: AlertPresenter
    private let usbReader: HIDDeviceUSBReader
    private let dualSenseConnectionInfo: USBDeviceConnectionInfo = .init(
        idVendor: 0x054c,
        idProduct: 0x0ce6,
        interfaceNum: 3,
        endpointAddress: 0x0084
    )

    init(alertPresenter: AlertPresenter) {
        self.alertPresenter = alertPresenter
        self.usbReader = HIDDeviceUSBReaderImpl(connectionInfo: dualSenseConnectionInfo)
    }

    func observe(reportHandler: @escaping (DualSenseReport) -> Void) {
        usbReader.registerReading { [weak self] result in
            self?.dualSenseReadingHandler(result: result, reportHandler: reportHandler)
        }
    }

    func dispose() {
        usbReader.unregisterReadingHandler()
    }

    private func dualSenseReadingHandler(result: Result<DualSenseReport, HIDDeviceUSBReaderError>, reportHandler: (DualSenseReport) -> Void) {
        switch result {
        case .success(let report):
            reportHandler(report)
        case .failure(let error):
            alertPresenter.report(error: error)
            usbReader.unregisterReadingHandler()
        }
    }
}
