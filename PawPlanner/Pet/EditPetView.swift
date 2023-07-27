//
//  EditPetView.swift
//  petminder
//
//  Created by ryan on 7/26/23.
//

import SwiftUI

struct EditPetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    let pet: Pet
    @State private var name: String
    @State private var species: String
    @State private var breed: String
    @State private var age: String
    @State private var weight: String
    @State private var dietaryRestrictions: String
    @State private var medication: String
    
    init(pet: Pet) {
        self.pet = pet
        _name = State(initialValue: pet.name ?? "")
        _species = State(initialValue: pet.species ?? "")
        _breed = State(initialValue: pet.breed ?? "")
        _age = State(initialValue: String(pet.age))
        _weight = State(initialValue: String(pet.weight))
        _dietaryRestrictions = State(initialValue: pet.dietaryRestrictions ?? "")
        _medication = State(initialValue: pet.medication ?? "")
        if let petImageData = pet.image, let petImage = UIImage(data: petImageData) {
            _inputImage = State(initialValue: petImage)
        }
    }
    
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
                    
                    TextField("Dietary Restrictions", text: $dietaryRestrictions)
                        .font(.custom("Poppins", size: 16)) // Custom font
                    
                    TextField("Medication", text: $medication)
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
                if !name.isEmpty, !species.isEmpty, !breed.isEmpty, !age.isEmpty, !weight.isEmpty, !dietaryRestrictions.isEmpty, !medication.isEmpty {
                    pet.name = name
                    pet.species = species
                    pet.breed = breed
                    pet.age = Int16(age) ?? 1
                    pet.weight = Float(weight) ?? 8
                    pet.dietaryRestrictions = dietaryRestrictions
                    pet.medication = medication
                    if let inputImage = inputImage {
                        pet.image = inputImage.pngData()
                    }
                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()  // dismiss the current view
                    } catch {
                        // Handle the error
                    }
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
        .navigationBarTitle("Edit Pet 🐶", displayMode: .inline)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .navigationViewStyle(.stack)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.inputImage = inputImage
    }
}


struct EditPetView_Previews: PreviewProvider {
    static var previews: some View {
        EditPetView(pet: Pet())
    }
}
