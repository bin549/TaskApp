import SwiftUI

struct TodoListView: View {
    @State private var todos: [ToDo] = []
    @State private var newTodoText = ""
    @State private var showingAddTodo = false
    
    var completedCount: Int {
        todos.filter { $0.status }.count
    }
    
    var remainingCount: Int {
        todos.filter { !$0.status }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 10) {
                        Text("待办事项")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("剩下 \(remainingCount) 项")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    if todos.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "checklist")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("暂无待办事项")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("点击下方按钮添加新任务")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                showingAddTodo = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("添加新任务")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(25)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ZStack {
                            List {
                                ForEach(todos) { todo in
                                    TodoRowView(todo: todo) { updatedTodo in
                                        updateTodo(updatedTodo)
                                    }
                                }
                                .onDelete(perform: deleteTodos)
                            }
                            .listStyle(PlainListStyle())
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showingAddTodo = true
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 56, height: 56)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .shadow(radius: 4)
                                    }
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddTodo) {
            AddTodoView { todoText in
                addTodo(todoText)
            }
        }
    }
    
    private func addTodo(_ text: String) {
        let newTodo = ToDo(id: todos.count, title: text, status: false)
        todos.append(newTodo)
    }
    
    private func updateTodo(_ updatedTodo: ToDo) {
        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            todos[index] = updatedTodo
        }
    }
    
    private func deleteTodos(offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

struct TodoRowView: View {
    let todo: ToDo
    let onUpdate: (ToDo) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                var updatedTodo = todo
                updatedTodo.status.toggle()
                onUpdate(updatedTodo)
            }) {
                Image(systemName: todo.status ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(todo.status ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(todo.title)
                .font(.body)
                .strikethrough(todo.status)
                .foregroundColor(todo.status ? .secondary : .primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var todoText = ""
    let onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("添加新任务")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                TextField("输入任务内容", text: $todoText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    if !todoText.isEmpty {
                        onAdd(todoText)
                        dismiss()
                    }
                }) {
                    Text("添加")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(todoText.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(todoText.isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
} 