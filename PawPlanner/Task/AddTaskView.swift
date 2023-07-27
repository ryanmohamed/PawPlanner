//
//  AddTaskView.swift
//  petminder
//
//  Created by ryan on 7/26/23.
//

import SwiftUI
import UserNotifications

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    // Fetch all pets for task assignment
    @FetchRequest(entity: Pet.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
                  animation: .default)
    private var pets: FetchedResults<Pet>

    // Task details
    @State private var taskName = ""
    @State private var desc = ""
    @State private var taskTime = Date()
    @State private var taskFrequency = TaskFrequency.daily // Default value

    // Selection for associated pets
    @State private var selectedPets: [Pet] = []

    // Alert
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            List {
                Section(header: Text("Task Details")
                    .font(.custom("Poppins", size: 40)) // Custom font
                    .fontWeight(.bold) // Bold
                    .padding(.vertical)
                    .foregroundColor(.candyRed) // Candy red color
                    .frame(maxWidth: .infinity)
                )
                {
                    TextField("Task Name", text: $taskName)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    TextField("Description", text: $desc)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    DatePicker("Date", selection: $taskTime, displayedComponents: .hourAndMinute)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    Picker("Frequency", selection: $taskFrequency) {
                        ForEach(TaskFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue.capitalized).tag(frequency)
                                .font(.custom("Poppins", size: 16)) // Custom font
                        }
                    }

                    ForEach(pets) { pet in
                        HStack {
                            Text("\(pet.name ?? "Unknown") (\(pet.species ?? ""))")
                                .font(.custom("Poppins", size: 16)) // Custom font

                            Spacer()

                            Toggle("", isOn: Binding(
                                get: { self.selectedPets.contains(pet) },
                                set: { (newValue) in
                                    if newValue {
                                        self.selectedPets.append(pet)
                                    } else {
                                        self.selectedPets.removeAll(where: { $0 == pet })
                                    }
                                })
                            )
                            .toggleStyle(CheckboxStyle())
                            .labelsHidden()
                        }
                    }
                }
            }

            Spacer() // Pushes the button to the bottom of the screen

            Button(action: {
                if taskName.isEmpty {
                    showingAlert = true
                    alertTitle = "Missing Information"
                    alertMessage = "Please provide a Task Name."
                } else if desc.isEmpty {
                    showingAlert = true
                    alertTitle = "Missing Information"
                    alertMessage = "Please provide a Task Description."
                } else if selectedPets.isEmpty {
                    showingAlert = true
                    alertTitle = "Missing Information"
                    alertMessage = "Please select a Pet for the Task."
                } else {
                    saveTask()
                    presentationMode.wrappedValue.dismiss()
                }
            })
            {
                Text("Save")
                    .font(.custom("Poppins", size: 16)) // Custom font
                    .foregroundColor(.accentColor)
            }
            .frame(maxWidth: .infinity) // Align button to center horizontally
            .padding()
        }
        .navigationBarTitle("Add Task 🐶", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationViewStyle(.stack)
    }

    private func saveTask() {
        let newTask = Task(context: managedObjectContext)
        newTask.taskName = taskName
        newTask.desc = desc
        newTask.time = taskTime
        newTask.frequency = taskFrequency.rawValue

        for pet in selectedPets {
            let petTask = PetTask(context: managedObjectContext)
            petTask.pet = pet
            petTask.task = newTask
            
            scheduleNotification(for: newTask, with: pet)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving new task: \(error)")
        }
    }
    
    private func scheduleNotification(for task: Task, with pet: Pet) {
        let content = UNMutableNotificationContent()
        content.title = task.taskName ?? ""
        content.body = "It's time for \(pet.name ?? "")'s \(task.taskName ?? "")"
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: task.time ?? Date())
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
}

// Support for multiple selection
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                    .font(.custom("Poppins", size: 16)) // Custom font

                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.accentColor) // You can change the color to fit your app's theme
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}


// Task frequency enumeration
enum TaskFrequency: String, CaseIterable {
    case daily, weekly, biweekly, monthly, oneTime = "one-time"
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
