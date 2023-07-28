//
//  AddPetView.swift
//  petminder
//
//  Created by ryan on 7/25/23.
//

import SwiftUI

struct AddPetView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var species = ""
    @State private var breed = ""
    @State private var age = ""
    @State private var weight = ""
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Pet Details")
                    .font(.custom("Poppins", size: 40)) // Custom font
                    .fontWeight(.bold) // Bold
                    .padding(.vertical)
                    .foregroundColor(.accentColor) // Candy red color
                ) {
                    TextField("Name", text: $name)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    TextField("Species", text: $species)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    TextField("Breed", text: $breed)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    TextField("Age", text: $age)
                        .font(.custom("Poppins", size: 16)) // Custom font

                    TextField("Weight", text: $weight)
                        .font(.custom("Poppins", size: 16)) // Custom font
                }
                VStack {
                    if inputImage != nil {
                        Image(uiImage: inputImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .padding()
                    }

                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Text(inputImage != nil ? "Change Image" : "Select Image")
                            .font(.custom("Poppins", size: 16)) // Custom font
                            .foregroundColor(.accentColor) // Candy red color
                    }
                    .frame(maxWidth: .infinity) // Align button to center horizontally
                    .padding()
                }
            }
            Spacer() // Pushes the button to the bottom of the screen
            Button(action: {
                let pet = Pet(context: self.managedObjectContext)
                pet.name = self.name
                pet.species = self.species
                pet.breed = self.breed
                pet.age = Int16(self.age) ?? 0
                pet.weight = Double(self.weight) ?? 0.0
                pet.image = inputImage?.pngData()

                do {
                    try self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
            })
            {
                Text("Save")
                    .font(.custom("Poppins", size: 16)) // Custom font
                    .foregroundColor(.accentColor)
            }
            .frame(maxWidth: .infinity) // Align button to center horizontally
            .padding()
            .disabled(name.isEmpty || species.isEmpty || breed.isEmpty || age.isEmpty || weight.isEmpty)
        }
        .navigationTitle("Add A Pet 🐶")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    

    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.inputImage = inputImage
    }
}


struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView()
    }
}
