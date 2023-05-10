import Foundation

enum DualSenseEvent {
    case leftStick(x: DualSenseStickValue, y: DualSenseStickValue)
    case rightStick(x: DualSenseStickValue, y: DualSenseStickValue)
    case triggerL2(value: UInt8)
    case triggerR2(value: UInt8)
    case tapTopDirectionButton
    case tapRightDirectionButton
    case tapBottomDirectionButton
    case tapLeftDirectionButton
    case tapSquareButton
    case tapCrossButton
    case tapCircleButton
    case tapTriangleButton
    case tapL1Button
    case tapL2Button
    case tapL3Button
    case tapR1Button
    case tapR2Button
    case tapR3Button
    case tapCreateButton
    case tapOptionsButton
    case tapTouchpadButton
    case tapPSButton
}
