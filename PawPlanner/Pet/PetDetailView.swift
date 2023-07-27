//
//  PetDetailView.swift
//  petminder
//
//  Created by ryan on 7/25/23.
//

import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    
    var body: some View {
        VStack {
            if let petImageData = pet.image, let petImage = UIImage(data: petImageData) {
                Image(uiImage: petImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
            }

            Text(pet.name ?? "")
                .font(.custom("Poppins", size: 32)) // Custom font
                .fontWeight(.bold)
                .foregroundColor(.accentColor) // Candy red color
            
            HStack (alignment: .center) {
                Text(pet.species ?? "")
                    .font(.custom("Poppins", size: 24)) // Custom font
                    .fontWeight(.bold)

                Text(pet.breed ?? "")
                    .font(.custom("Poppins", size: 24)) // Custom font
                    .foregroundColor(.gray)
            }

            VStack(alignment: .center, spacing: 10) {
                
                Text("Age: \(pet.age)")
                    .font(.custom("Poppins", size: 20)) // Custom font

                Text("Weight: \(Int(pet.weight)) lbs")
                    .font(.custom("Poppins", size: 20)) // Custom font
                
                Text("Dietary Restrictions: \(pet.dietaryRestrictions ?? "None")")
                    .font(.custom("Poppins", size: 20)) // Custom font
                
                Text("Medication: \(pet.medication ?? "None")")
                    .font(.custom("Poppins", size: 20)) // Custom font
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationBarTitle(pet.name ?? "", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: EditPetView(pet: pet)) {
            Text("Edit")
                .font(.custom("Poppins", size: 16)) // Custom font
                .padding()
                .foregroundColor(.accentColor)
        })
        .navigationViewStyle(.stack)
    }
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PetDetailView(pet: Pet())
    }
}
