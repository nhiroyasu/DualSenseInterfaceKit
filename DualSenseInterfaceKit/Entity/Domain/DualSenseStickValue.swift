import Foundation

/// The value of DualSense Stick.
///
/// When neutral status, this value is 0.
/// This value is reduced to -128 when the stick is tipped to the left and 127 to right.
struct DualSenseStickValue {
    private let rawValue: UInt8
    private static let neutralThreshold = 0x80

    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    var value: Int {
        Int(rawValue) - Self.neutralThreshold
    }
}
