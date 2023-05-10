import Foundation
import Combine

typealias DualSenseReportSubject = PassthroughSubject<DualSenseReport, Never>

class SubjectContainer {
    static let shared = SubjectContainer()

    private let dualSenseReportSubject: DualSenseReportSubject = .init()
    
    func retrieve<T: Subject>() -> T {
        if T.self is DualSenseReportSubject.Type {
            return dualSenseReportSubject as! T
        }
        fatalError()
    }
}
