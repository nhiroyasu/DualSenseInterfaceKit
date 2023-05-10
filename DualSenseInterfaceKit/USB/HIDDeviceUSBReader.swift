import Foundation

enum HIDDeviceUSBReaderError: LocalizedError {
    case failedInit
    case failedReading
    case alreadyRegistered

    var errorDescription: String? {
        switch self {
        case .failedInit:
            return "Not found a device. Please connect Dual Sense Controller."
        case .failedReading:
            return "Failed reading usb signal."
        case .alreadyRegistered:
            return "Already registered other handler."
        }
    }
}

protocol HIDDeviceUSBReader {
    func registerReading(handler: @escaping (Result<DualSenseReport, HIDDeviceUSBReaderError>) -> Void)
    func unregisterReadingHandler()
}

class HIDDeviceUSBReaderImpl: HIDDeviceUSBReader {
    private let connectionInfo: USBDeviceConnectionInfo
    private var timer: Timer?
    private var isRegistered: Bool = false

    init(connectionInfo: USBDeviceConnectionInfo) {
        self.connectionInfo = connectionInfo
    }

    deinit {
        if timer?.isValid == true {
            unregisterReadingHandler()
        }
    }

    func registerReading(handler: @escaping (Result<DualSenseReport, HIDDeviceUSBReaderError>) -> Void) {
        let idVendor = connectionInfo.idVendor
        let idProduct = connectionInfo.idProduct
        let interfaceNum = connectionInfo.interfaceNum
        let endpointAddress = connectionInfo.endpointAddress

        guard isRegistered == false else {
            handler(.failure(.alreadyRegistered))
            return
        }
        guard DSSigReader_init(idVendor, idProduct) == 0 else {
            handler(.failure(.failedInit))
            return
        }

        self.isRegistered = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { timer in
            var report: DualSenseReport = .init()

            if DSSigReader_read(interfaceNum, endpointAddress, &report) != 0 {
                handler(.failure(.failedReading))
            }

            handler(.success(report))
        }
    }

    func unregisterReadingHandler() {
        self.isRegistered = false
        timer?.invalidate()
        DSSigReader_release(connectionInfo.interfaceNum)
        DSSigReader_deinit()
    }
}
