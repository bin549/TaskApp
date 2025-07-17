// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "task",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "task",
            targets: ["task"]
        )
    ],
    targets: [
        .executableTarget(
            name: "task",
            path: ".",
            exclude: ["README.md", "ContentView.swift"],
            sources: ["MyApp.swift", "LoginView.swift", "TodoListView.swift", "PomodoroView.swift", "DrawingView.swift", "MainTabView.swift", "Models.swift", "Utils.swift"]
        )
    ]
)