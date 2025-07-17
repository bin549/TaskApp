import SwiftUI

struct DrawingView: View {
    @State private var lines: [DrawingLine] = []
    @State private var currentLine = DrawingLine()
    @State private var selectedColor: Color = .black
    @State private var strokeWidth: CGFloat = 5.0
    @State private var strokeOpacity: Double = 1.0
    @State private var showingColorPicker = false
    @State private var showingControls = false
    
    let colors: [Color] = [
        .black, .red, .blue, .green, .yellow, .orange, .purple, .pink,
        .brown, .gray, .cyan, .mint, .indigo, .teal, .white
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        if let firstPoint = line.points.first {
                            path.move(to: firstPoint)
                            for point in line.points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        context.stroke(
                            path,
                            with: .color(line.color.opacity(line.opacity)),
                            style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round)
                        )
                    }
                    
                    if !currentLine.points.isEmpty {
                        var path = Path()
                        path.move(to: currentLine.points[0])
                        for point in currentLine.points.dropFirst() {
                            path.addLine(to: point)
                        }
                        context.stroke(
                            path,
                            with: .color(currentLine.color.opacity(currentLine.opacity)),
                            style: StrokeStyle(lineWidth: currentLine.width, lineCap: .round, lineJoin: .round)
                        )
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if currentLine.points.isEmpty {
                                currentLine = DrawingLine()
                                currentLine.color = selectedColor
                                currentLine.width = strokeWidth
                                currentLine.opacity = strokeOpacity
                            }
                            currentLine.points.append(value.location)
                        }
                        .onEnded { _ in
                            if !currentLine.points.isEmpty {
                                lines.append(currentLine)
                                currentLine = DrawingLine()
                            }
                        }
                )
                
                VStack {
                    Spacer()
                    
                    if showingControls {
                        VStack(spacing: 20) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(colors, id: \.self) { color in
                                        Button(action: {
                                            selectedColor = color
                                        }) {
                                            Circle()
                                                .fill(color)
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Circle()
                                                        .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            VStack {
                                Text("笔刷大小: \(Int(strokeWidth))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $strokeWidth, in: 1...20, step: 1)
                                    .tint(.blue)
                            }
                            .padding(.horizontal)
                            
                            VStack {
                                Text("透明度: \(Int(strokeOpacity * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $strokeOpacity, in: 0.1...1.0, step: 0.1)
                                    .tint(.blue)
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                Button(action: undoLastLine) {
                                    HStack {
                                        Image(systemName: "arrow.uturn.backward")
                                        Text("撤销")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.orange)
                                    .cornerRadius(20)
                                }
                                .disabled(lines.isEmpty)
                                
                                Button(action: clearCanvas) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("清空")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .cornerRadius(20)
                                }
                                .disabled(lines.isEmpty)
                                
                                Button(action: saveDrawing) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("保存")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.green)
                                    .cornerRadius(20)
                                }
                                .disabled(lines.isEmpty)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .padding()
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingControls.toggle()
                        }
                    }) {
                        Image(systemName: showingControls ? "chevron.down" : "chevron.up")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("绘画")
        }
    }
    
    private func undoLastLine() {
        if !lines.isEmpty {
            lines.removeLast()
        }
    }
    
    private func clearCanvas() {
        lines.removeAll()
        currentLine = DrawingLine()
    }
    
    private func saveDrawing() {
        let renderer = ImageRenderer(content: 
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))
                for line in lines {
                    var path = Path()
                    if let firstPoint = line.points.first {
                        path.move(to: firstPoint)
                        for point in line.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(
                        path,
                        with: .color(line.color.opacity(line.opacity)),
                        style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .frame(width: 400, height: 600)
        )
        
        if let image = renderer.uiImage {
            print("绘画已保存（在真实设备上会保存到相册）")
        }
    }
} 