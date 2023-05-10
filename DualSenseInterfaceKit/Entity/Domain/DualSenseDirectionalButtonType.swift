import Foundation

enum DualSenseDirectionalButton: UInt8 {
    case top = 0b0000
    case topRight = 0b0001
    case right = 0b0010
    case bottomRight = 0b0011
    case bottom = 0b0100
    case bottomLeft = 0b0101
    case left = 0b0110
    case topLeft = 0b0111
}
