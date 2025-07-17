import SwiftUI

struct PomodoroView: View {
    @State private var timeRemaining = 1500 
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var progress: Double = 0.0
    
    let totalTime = 1500 
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.red.opacity(0.1), Color.orange.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Text("番茄钟")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                            .frame(width: 300, height: 300)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.orange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 300, height: 300)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)
                        
                        VStack(spacing: 10) {
                            Text(timeString)
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                            
                            Text(isTimerRunning ? "专注中..." : "准备开始")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 30) {
                        Button(action: toggleTimer) {
                            HStack {
                                Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                Text(isTimerRunning ? "暂停" : (timeRemaining == totalTime ? "开始" : "继续"))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                        }
                        
                        Button(action: resetTimer) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("重置")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                        }
                        .disabled(timeRemaining == totalTime && !isTimerRunning)
                        .opacity(timeRemaining == totalTime && !isTimerRunning ? 0.5 : 1.0)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            if isTimerRunning {
                startTimer()
            }
        }
    }
    
    private func toggleTimer() {
        isTimerRunning.toggle()
        
        if isTimerRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = Double(totalTime - timeRemaining) / Double(totalTime)
                if timeRemaining == 0 {
                    timerCompleted()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        isTimerRunning = false
        stopTimer()
        timeRemaining = totalTime
        progress = 0.0
    }
    
    private func timerCompleted() {
        isTimerRunning = false
        stopTimer()
        print("番茄钟完成！")
    }
} 