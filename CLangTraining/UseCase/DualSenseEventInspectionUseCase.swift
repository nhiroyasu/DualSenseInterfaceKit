import Foundation

protocol DualSenseEventInspectionUseCase {
    func inspect(currentReport: DualSenseReport, preReport: DualSenseReport) -> [DualSenseEvent]
}

class DualSenseEventInspectionUseCaseImpl: DualSenseEventInspectionUseCase {
    func inspect(currentReport: DualSenseReport, preReport: DualSenseReport) -> [DualSenseEvent] {
        var events: [DualSenseEvent] = []

        let leftStickEvent: DualSenseEvent = .leftStick(
            x: DualSenseStickValue(rawValue: currentReport.left_stick_x_axis),
            y: DualSenseStickValue(rawValue: currentReport.left_stick_y_axis)
        )
        let rightStickEvent: DualSenseEvent = .rightStick(
            x: DualSenseStickValue(rawValue: currentReport.right_stick_x_axis),
            y: DualSenseStickValue(rawValue: currentReport.right_stick_y_axis)
        )
        events.append(contentsOf: [leftStickEvent, rightStickEvent])

        let l2TriggerEvent: DualSenseEvent = .triggerL2(value: currentReport.l2_trigger_axis)
        let r2TriggerEvent: DualSenseEvent = .triggerR2(value: currentReport.r2_trigger_axis)
        events.append(contentsOf: [l2TriggerEvent, r2TriggerEvent])

        if currentReport.directional_button != preReport.directional_button {
            switch DualSenseDirectionalButton(rawValue: currentReport.directional_button) {
            case .top:
                events.append(.tapTopDirectionButton)
            case .topRight:
                events.append(contentsOf: [.tapTopDirectionButton, .tapRightDirectionButton])
            case .right:
                events.append(.tapRightDirectionButton)
            case .bottomRight:
                events.append(contentsOf: [.tapRightDirectionButton, .tapBottomDirectionButton])
            case .bottom:
                events.append(.tapBottomDirectionButton)
            case .bottomLeft:
                events.append(contentsOf: [.tapBottomDirectionButton, .tapLeftDirectionButton])
            case .left:
                events.append(.tapLeftDirectionButton)
            case .topLeft:
                events.append(contentsOf: [.tapTopDirectionButton, .tapLeftDirectionButton])
            case .none:
                break
            }
        }

        if currentReport.square_button != preReport.square_button && currentReport.square_button == 0x01 {
            events.append(.tapSquareButton)
        }
        if currentReport.cross_button != preReport.cross_button && currentReport.cross_button == 0x01 {
            events.append(.tapCrossButton)
        }
        if currentReport.circle_button != preReport.circle_button && currentReport.circle_button == 0x01 {
            events.append(.tapCircleButton)
        }
        if currentReport.triangle_button != preReport.triangle_button && currentReport.triangle_button == 0x01 {
            events.append(.tapTriangleButton)
        }
        if currentReport.l1_button != preReport.l1_button && currentReport.l1_button == 0x01 {
            events.append(.tapL1Button)
        }
        if currentReport.l2_button != preReport.l2_button && currentReport.l2_button == 0x01 {
            events.append(.tapL2Button)
        }
        if currentReport.l3_button != preReport.l3_button && currentReport.l3_button == 0x01 {
            events.append(.tapL3Button)
        }
        if currentReport.r1_button != preReport.r1_button && currentReport.r1_button == 0x01 {
            events.append(.tapR1Button)
        }
        if currentReport.r2_button != preReport.r2_button && currentReport.r2_button == 0x01 {
            events.append(.tapR2Button)
        }
        if currentReport.r3_button != preReport.r3_button && currentReport.r3_button == 0x01 {
            events.append(.tapL3Button)
        }
        if currentReport.create_button != preReport.create_button && currentReport.create_button == 0x01 {
            events.append(.tapCreateButton)
        }
        if currentReport.options_button != preReport.options_button && currentReport.options_button == 0x01 {
            events.append(.tapOptionsButton)
        }
        if currentReport.touchpad_button != preReport.touchpad_button && currentReport.touchpad_button == 0x01 {
            events.append(.tapTouchpadButton)
        }
        if currentReport.ps_button != preReport.ps_button && currentReport.ps_button == 0x01 {
            events.append(.tapPSButton)
        }

        return events
    }
}
