import SwiftUI
import Combine

struct MainView: View {
    let controller: MainController
    let reportPresenter: DualSenseReportPresenter
    let publisher: CurrentValueSubject<MainViewState, Never>

    @State var report: DualSenseReport
    @State var isObserving: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 32) {
                HStack(alignment: .center, spacing: 8) {
                    if isObserving {
                        Button {
                            controller.didTapStopButton()
                        } label: {
                            Label("Stop", systemImage: "pause.fill")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    } else {
                        Button {
                            controller.didTapStartButton()
                        } label: {
                            Label("Start", systemImage: "play.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
                Text(reportPresenter.formatReport(report))
                    .font(.custom("Menlo", size: 36))
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onReceive(publisher) { newState in
            self.report = newState.report
            self.isObserving = newState.isObserving
        }
    }
}
