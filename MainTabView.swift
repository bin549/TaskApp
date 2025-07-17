import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodoListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("待办事项")
                }
                .tag(0)
            
            PomodoroView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("番茄钟")
                }
                .tag(1)
            
            DrawingView()
                .tabItem {
                    Image(systemName: "pencil.tip")
                    Text("绘画")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
} 