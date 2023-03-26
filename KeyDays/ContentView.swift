//
//  ContentView.swift
//  KeyDays
//
//  Created by Кирилл Сутырь on 15.02.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
        
    @FetchRequest(entity: KeyDay.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \KeyDay.keyDate, ascending: true)],
                  animation: .default)
    private var items: FetchedResults<KeyDay>
    
    @State private var showingAddView = false
    
    var body: some View {
        let _ = print(items)
        NavigationStack {
            VStack{
                if items.isEmpty {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                } else {
                    ScrollView {
                        ForEach(items) { item in
                            
                            
                            NavigationLink {
                                
                            } label: {
                                
                                MyCell(name: item.dateName!, date: item.keyDate!.formatted(), imageData: item.imageData ?? Data())
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
            }
            .navigationTitle("Your Key Days")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddKeyDateView()
            }
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = KeyDay(context: viewContext)
            newItem.keyDate = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

struct MyCell: View {
    let name: String
    let date: String
    let imageData: Data
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            } else {
                Color.gray.frame(height: 150)
            }
            
            HStack {
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(name)
                    .font(.headline)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}



//            if items.isEmpty {
//                Button {
//                    showingAddView.toggle()
//                } label: {
//                    Label("Add Item", systemImage: "plus")
//                }
//            } else {
//                List {
//                    ForEach(items) { item in
//
//                        NavigationLink {
//
//                        } label: {
//                            ZStack{
//                                if let data = item.imageData, let newImage = UIImage(data: data) {
//                                    Image(uiImage: newImage)
//                                        .resizable()
//
//
//                                    Text(item.dateName ?? "no data here")
//                                } else {
//                                    // logic with no image
//                                }
//                            }
//                            .scaledToFill()
//                            .frame(height: 150)
//                        }
//
//                    }
//                    .onDelete(perform: deleteItems)
//                }
//            }



//                .navigationTitle("Key Days")


