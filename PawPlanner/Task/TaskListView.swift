//
//  TaskListView.swift
//  petminder
//
//  Created by ryan on 7/26/23.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    
    @Namespace private var animation
    
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch all pets and tasks
    @FetchRequest(
        entity: Pet.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        animation: .default)
    private var pets: FetchedResults<Pet>

    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.taskName, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    var body: some View {
        NavigationView {
            if pets.isEmpty {
                Text("Add a pet to get started")
                    .font(.custom("Poppins", size: 14))
                    .opacity(0.7)
                Spacer()
            }
            else {
                List {
                    ForEach(pets) { pet in
                        Section(header: Text(pet.name ?? "")
                            .font(.custom("Poppins", size: 40)) // Custom font and size
                            .fontWeight(.bold) // Bold
                            .padding(.vertical)
                            .foregroundColor(.accentColor)
                        )
                        {
                            if let petTasks = pet.petTasks, petTasks.count > 0 {
                                ForEach(petTasks.allObjects as! [PetTask]) { petTask in
                                    DisclosureGroup(
                                        content: {
                                            Text(petTask.task?.desc ?? "")
                                                .opacity(0.8)
                                                .matchedGeometryEffect(id: petTask.id, in: animation)
                                        },
                                        label: {
                                            VStack(alignment: .leading) {
                                                Text(petTask.task?.taskName ?? "")
                                                    .font(.title2)
                                                    .bold()
                                                Text("Time: \(formatDate(for: petTask.task))")
                                                      .font(.subheadline)
                                                Text("Frequency: \(petTask.task?.frequency ?? "")")
                                                    .font(.subheadline)
                                            }
                                            .padding(10)
                                        }
                                    )
                                }
                                .onDelete(perform: { indexSet in
                                    deletePetTasks(at: indexSet, from: pet)
                                })
                                .transition(.slide)
                            } else {
                                Text("No tasks yet")
                                    .italic()
                                    .opacity(0.7)
                            }
                        }
                    }
                    
                }
                .navigationBarTitle("Tasks 🐶", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: AddTaskView()) {
                    Image(systemName: "plus")
                })
            }
            
        }
        .navigationViewStyle(.stack)
    }

    private func deletePetTasks(at offsets: IndexSet, from pet: Pet) {
        withAnimation {
            // Get the tasks for the pet
            guard let petTasksSet = pet.petTasks as? Set<PetTask> else { return }
            let petTasks = Array(petTasksSet)
            
            // Delete selected tasks
            offsets.forEach { index in
                let petTask = petTasks[index]
                self.viewContext.delete(petTask)
            }
            
            // Save the context
            do {
                try self.viewContext.save()
            } catch {
                // Handle the error appropriately
                print("Could not save viewContext: \(error)")
            }
        }
    }

    private func formatDate(for task: Task?) -> String {
         guard let task = task else { return "" }
         
         let formatter = DateFormatter()
         formatter.dateStyle = task.frequency == "one-time" ? .short : .none
         formatter.timeStyle = .short
         return formatter.string(from: task.time ?? Date())
     }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
