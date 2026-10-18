import SwiftUI

public struct FocusTimerView: View {
    @StateObject private var viewModel = FocusTimerViewModel()
    @State private var isShowingSettings = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Session Mode Picker
                HStack(spacing: 8) {
                    ForEach(FocusSessionType.allCases, id: \.self) { type in
                        Button {
                            viewModel.selectSessionType(type)
                        } label: {
                            Text(type.rawValue)
                                .font(.subheadline.weight(.medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.currentSessionType == type ? Color.green : Color(uiColor: .secondarySystemGroupedBackground))
                                .foregroundColor(viewModel.currentSessionType == type ? .white : .primary)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Circular Timer Display
                ZStack {
                    CircularProgressView(
                        progress: viewModel.progress,
                        lineWidth: 20,
                        primaryColor: viewModel.isRunning ? .green : .blue,
                        secondaryColor: Color.gray.opacity(0.15)
                    )
                    .frame(width: 260, height: 260)
                    
                    VStack(spacing: 8) {
                        Text(viewModel.formattedTime)
                            .font(.system(size: 54, weight: .bold, design: .rounded))
                        
                        Text(viewModel.currentSessionType.rawValue.uppercased())
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .tracking(2)
                    }
                }
                
                Spacer()
                
                // Controls: Start, Pause, Stop
                HStack(spacing: 24) {
                    if !viewModel.isRunning && !viewModel.isPaused {
                        Button {
                            viewModel.startTimer()
                        } label: {
                            Text("Start Focus")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    } else if viewModel.isRunning {
                        Button {
                            viewModel.pauseTimer()
                        } label: {
                            Text("Pause")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Button {
                            viewModel.stopTimer()
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.title3)
                                .padding(16)
                                .background(Color.red.opacity(0.15))
                                .foregroundColor(.red)
                                .clipShape(Circle())
                        }
                    } else if viewModel.isPaused {
                        Button {
                            viewModel.resumeTimer()
                        } label: {
                            Text("Resume")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Button {
                            viewModel.stopTimer()
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.title3)
                                .padding(16)
                                .background(Color.red.opacity(0.15))
                                .foregroundColor(.red)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Strict Mode Indicator
                HStack {
                    Image(systemName: "shield.checkerboard")
                        .foregroundColor(.blue)
                    Text("Strict Mode: Distractions automatically blocked")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Focus Timer")
            .background(Color(uiColor: .systemGroupedBackground))
            .sheet(isPresented: $isShowingSettings) {
                PomodoroSettingsView()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}
