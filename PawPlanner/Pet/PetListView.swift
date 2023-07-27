//
//  ContentView.swift
//  petminder
//
//  Created by ryan on 7/25/23.
//

import SwiftUI
import CoreData

struct PetListView: View {
    @FetchRequest(entity: Pet.entity(), sortDescriptors: [])
    var pets: FetchedResults<Pet>

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        NavigationView {
            List {
                ForEach(pets, id: \.self) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet)) {
                        HStack (alignment: .center) {
                            if let petImageData = pet.image, let petImage = UIImage(data: petImageData) {
                                Image(uiImage: petImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }

                            VStack(alignment: .leading) {
                                Text(pet.name ?? "")
                                    .font(.custom("Poppins", size: 20))
                                    .foregroundColor(.accentColor)
                                Text(pet.breed ?? "")
                                    .font(.custom("Poppins", size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 30)
                        }
                        .padding()
                    }
                }
                .onDelete(perform: deletePet)
                .transition(.slide)
            }
            .navigationBarTitle("Pets 🐶", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: AddPetView()) {
                Image(systemName: "plus")
            })
        }
        .navigationViewStyle(.stack)
    }

    private func deletePet(at offsets: IndexSet) {
        for index in offsets {
            let pet = pets[index]
            managedObjectContext.delete(pet)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct PetListView_Previews: PreviewProvider {
    static var previews: some View {
        PetListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
