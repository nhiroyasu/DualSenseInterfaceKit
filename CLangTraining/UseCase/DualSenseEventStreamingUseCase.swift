import AppKit
import AudioToolbox

// NOTE: 時間無いので適当に書く

protocol DualSenseEventStreamingUseCase {
    func eventHandler(_ event: DualSenseEvent)
}

class DualSenseEventStreamingUseCaseImpl: DualSenseEventStreamingUseCase {
    private var buffer: CGPoint = .zero

    func eventHandler(_ event: DualSenseEvent) {
        switch event {
        case .leftStick(let x, let y):
            let moveX: CGFloat = CGFloat(x.value) / 20.0
            let moveY: CGFloat = CGFloat(y.value) / 20.0

            buffer = .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0)))
            if abs(moveX) > 1 || abs(moveY) > 1 {
                let point = CGPoint(
                    x: buffer.x + moveX,
                    y: buffer.y + moveY
                )
                self.buffer = point
                let event = CGEvent(
                    mouseEventSource: nil,
                    mouseType: CGEventType.mouseMoved,
                    mouseCursorPosition: point,
                    mouseButton: CGMouseButton(rawValue: UInt32(3))!
                )
                event?.flags = []
                event?.post(tap: CGEventTapLocation.cghidEventTap)
            } else {
                buffer = .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0)))
            }
        case .rightStick(let x, let y):
            let scrollX: CGFloat = -CGFloat(x.value) / 20.0
            let scrollY: CGFloat = -CGFloat(y.value) / 20.0

            if abs(scrollX) > 1 || abs(scrollY) > 1 {
                let event = CGEvent(scrollWheelEvent2Source: nil,
                                    units: CGScrollEventUnit.pixel,
                                    wheelCount: CGWheelCount(2),
                                    wheel1: Int32(scrollY),
                                    wheel2: Int32(scrollX),
                                    wheel3: Int32(0))
                event?.flags = []
                if let e = event {
                    e.post(tap: CGEventTapLocation.cghidEventTap)
                } else {
                    print("failed creating event")
                }
            }
        case .triggerL2(let value):
            let zoomOutValue: CGFloat = CGFloat(value) / 20.0
            if zoomOutValue > 1 {
                let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: UInt32(2), wheel1: -Int32(zoomOutValue), wheel2: Int32(0), wheel3: Int32(0))
                event?.flags = [.maskCommand]
                event?.post(tap: .cghidEventTap)
            }
        case .triggerR2(let value):
            let zoomInValue: CGFloat = CGFloat(value) / 20.0
            if zoomInValue > 1 {
                let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: UInt32(2), wheel1: Int32(zoomInValue), wheel2: Int32(0), wheel3: Int32(0))
                event?.flags = [.maskCommand]
                event?.post(tap: .cghidEventTap)
            }
        case .tapTopDirectionButton:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x7E, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x7E, keyDown: false)
            event?.flags = [.maskControl, .maskSecondaryFn]
            event2?.flags = [.maskControl, .maskSecondaryFn]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
            //            var outputDeviceID: AudioDeviceID = kAudioObjectUnknown
            //            var audioDeviceIOSize: UInt32 = UInt32(MemoryLayout<AudioDeviceID>.size)
            //
            //            // デフォルトの出力デバイスを取得
            //            var propertyAddress = AudioObjectPropertyAddress(
            //                mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            //                mScope: kAudioObjectPropertyScopeGlobal,
            //                mElement: kAudioObjectPropertyElementMain
            //            )
            //
            //            AudioObjectGetPropertyData(
            //                AudioObjectID(kAudioObjectSystemObject),
            //                &propertyAddress,
            //                0,
            //                nil,
            //                &audioDeviceIOSize,
            //                &outputDeviceID
            //            )
            //
            //            // 音量を設定
            //            var volumeAddress = AudioObjectPropertyAddress(
            //                mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            //                mScope: kAudioDevicePropertyScopeOutput,
            //                mElement: kAudioObjectPropertyElementMain
            //            )
            //
            //            var nowVolume: Float = 0
            //            var floatSize: UInt32 = UInt32(MemoryLayout<Float>.size)
            //            AudioObjectGetPropertyData(outputDeviceID, &volumeAddress, 0, nil, &floatSize, &nowVolume)
            //            var nextVolume: Float = min(nowVolume + 0.05, 1)
            //            AudioObjectSetPropertyData(
            //                outputDeviceID,
            //                &volumeAddress,
            //                0,
            //                nil,
            //                UInt32(MemoryLayout<Float>.size),
            //                &nextVolume
            //            )
        case .tapRightDirectionButton:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x30, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x30, keyDown: false)
            event?.flags = [.maskCommand]
            event2?.flags = [.maskCommand]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
        case .tapBottomDirectionButton:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x7D, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x7D, keyDown: false)
            event?.flags = [.maskControl, .maskSecondaryFn]
            event2?.flags = [.maskControl, .maskSecondaryFn]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
            //            var outputDeviceID: AudioDeviceID = kAudioObjectUnknown
            //            var audioDeviceIOSize: UInt32 = UInt32(MemoryLayout<AudioDeviceID>.size)
            //
            //            // デフォルトの出力デバイスを取得
            //            var propertyAddress = AudioObjectPropertyAddress(
            //                mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            //                mScope: kAudioObjectPropertyScopeGlobal,
            //                mElement: kAudioObjectPropertyElementMain
            //            )
            //
            //            AudioObjectGetPropertyData(
            //                AudioObjectID(kAudioObjectSystemObject),
            //                &propertyAddress,
            //                0,
            //                nil,
            //                &audioDeviceIOSize,
            //                &outputDeviceID
            //            )
            //
            //            // 音量を設定
            //            var volumeAddress = AudioObjectPropertyAddress(
            //                mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            //                mScope: kAudioDevicePropertyScopeOutput,
            //                mElement: kAudioObjectPropertyElementMain
            //            )
            //
            //            var nowVolume: Float = 0
            //            var floatSize: UInt32 = UInt32(MemoryLayout<Float>.size)
            //            AudioObjectGetPropertyData(outputDeviceID, &volumeAddress, 0, nil, &floatSize, &nowVolume)
            //            var nextVolume: Float = max(nowVolume - 0.05, 0)
            //            AudioObjectSetPropertyData(
            //                outputDeviceID,
            //                &volumeAddress,
            //                0,
            //                nil,
            //                UInt32(MemoryLayout<Float>.size),
            //                &nextVolume
            //            )
        case .tapLeftDirectionButton:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x30, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x30, keyDown: false)
            event?.flags = [.maskCommand, .maskShift]
            event2?.flags = [.maskCommand, .maskShift]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
        case .tapSquareButton:
            let process = Process()
            process.launchPath = "/usr/bin/open"
            process.arguments = ["/Applications/Slack.app"]
            process.launch()
        case .tapCrossButton:
            break
        case .tapCircleButton:
            let event = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0))), mouseButton: CGMouseButton.left)
            let event2 = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0))), mouseButton: CGMouseButton.left)
            event?.flags = []
            event2?.flags = []
            if let e = event, let e2 = event2 {
                e.post(tap: .cghidEventTap)
                e2.post(tap: .cghidEventTap)
            } else {
                print("failed creating event")
            }
        case .tapTriangleButton:
            NSWorkspace.shared.open(URL(string: "https://www.yahoo.co.jp/")!)
        case .tapL1Button:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x7B, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x7B, keyDown: false)
            event?.flags = [.maskControl, .maskSecondaryFn]
            event2?.flags = [.maskControl, .maskSecondaryFn]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
        case .tapL2Button:
            break
        case .tapL3Button:
            let event = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0))), mouseButton: CGMouseButton.left)
            let event2 = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: .init(x: NSEvent.mouseLocation.x, y: abs(NSEvent.mouseLocation.y - (NSScreen.main?.frame.height ?? 0))), mouseButton: CGMouseButton.left)
            event?.flags = []
            event2?.flags = []
            if let e = event, let e2 = event2 {
                e.post(tap: .cghidEventTap)
                e2.post(tap: .cghidEventTap)
            } else {
                print("failed creating event")
            }
        case .tapR1Button:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x7C, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x7C, keyDown: false)
            event?.flags = [.maskControl, .maskSecondaryFn]
            event2?.flags = [.maskControl, .maskSecondaryFn]
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
        case .tapR2Button:
            break
        case .tapR3Button:
            break
        case .tapCreateButton:
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0x24, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x24, keyDown: false)
            event?.flags = []
            event2?.flags = []
            event?.post(tap: .cghidEventTap)
            event2?.post(tap: .cghidEventTap)
        case .tapOptionsButton:
            break
        case .tapTouchpadButton:
            break
        case .tapPSButton:
            if NSApplication.shared.isHidden {
                NSApplication.shared.activate(ignoringOtherApps: true)
            } else {
                NSApplication.shared.hide(nil)
            }
        }
    }
}
