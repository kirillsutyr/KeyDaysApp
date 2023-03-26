//
//  AddKeyDateView.swift
//  KeyDays
//
//  Created by Кирилл Сутырь on 15.02.2023.
//

import SwiftUI
import PhotosUI

struct AddKeyDateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var date = Date()
    @State private var isFavourite = false
    @State private var notificationsEnabled = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
    
    var body: some View {
        VStack {
            Form {
                Section("Event", content: {
                    TextField("Enter Key Date name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Toggle(isOn: $isFavourite, label: {Text("Favourite")})
                })
                Section("Notofications", content: {
                    Toggle(isOn: $notificationsEnabled, label: {Text("Enable notifications")})
                })
                Section("Image", content: {
                    PhotosPicker(selection: $selectedItem,matching: .images, photoLibrary: .shared()) {
                        if let selectedImageData, let image = UIImage(data: selectedImageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                            
                        } else {
                            Image("2img")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                })
                .onChange(of: selectedItem) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
            Button {
                PersistenceController.shared.addKeyDate(name: name, date: date, imageData: selectedImageData ?? Data(), isFavourite: isFavourite, notificationsEnabled: notificationsEnabled)
                dismiss()
            } label: {
                Text("Submit")
            }

        }
    }
}

struct AddKeyDateView_Previews: PreviewProvider {
    static var previews: some View {
        AddKeyDateView()
    }
}
