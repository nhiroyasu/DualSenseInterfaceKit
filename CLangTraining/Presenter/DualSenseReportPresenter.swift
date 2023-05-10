import Foundation

protocol DualSenseReportPresenter {
    func formatReport(_ report: DualSenseReport) -> String
}

class DualSenseReportPresenterImpl: DualSenseReportPresenter {
    func formatReport(_ report: DualSenseReport) -> String {
        """
        L Stick(X): \(String(format: "%03d", report.left_stick_x_axis)) | L Stick(Y): \(String(format: "%03d", report.left_stick_y_axis))
        R Stick(X): \(report.right_stick_x_axis) | R Stick(Y): \(report.right_stick_y_axis)
        L2 Trigger Axis: \(report.l2_trigger_axis)
        R2 Trigger Axis: \(report.r2_trigger_axis)
        DirectionalButton: \(convertDirectionalButton(report.directional_button))
        Square: \(report.square_button)
        Cross: \(report.cross_button)
        Circle: \(report.circle_button)
        Triangle: \(report.triangle_button)
        L1: \(report.l1_button)
        R1: \(report.r1_button)
        L2: \(report.l2_button)
        R2: \(report.r2_button)
        Create Button: \(report.create_button)
        Options Button: \(report.options_button)
        L3 Button: \(report.l3_button)
        R3 Button: \(report.r3_button)
        PS Button: \(report.ps_button)
        Touchpad Button: \(report.touchpad_button)
        """
    }

    private func convertDirectionalButton(_ directionalButton: UInt8
    ) -> String {
        switch directionalButton {
        case 0:
            return "↑"
        case 2:
            return "→"
        case 4:
            return "↓"
        case 6:
            return "←"
        case 8:
            return "neutral"
        default:
            return String(directionalButton)
        }
    }
}
