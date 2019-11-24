//
//  ContentView.swift
//  OrderedList
//
//  Created by SchwiftyUI on 9/2/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ListItem.getListItemFetchRequest()) var listItems: FetchedResults<ListItem>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listItems, id: \.self) { item in
                        NavigationLink(destination: ListItemView(listItem: item)) {
                            Text("\(item.name) - \(item.order)")
                        }
                    }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: moveItem)
                }
                Button(action: addItem) {
                    Text("Add Item")
                }
            }
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func moveItem(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = listItems[source].order
            while startIndex <= endIndex {
                listItems[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            
            listItems[source].order = startOrder
            
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = listItems[destination].order + 1
            let newOrder = listItems[destination].order
            while startIndex <= endIndex {
                listItems[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            listItems[source].order = newOrder
        }
        
        saveItems()
    }
    
    func deleteItem(indexSet: IndexSet) {
        let source = indexSet.first!
        let listItem = listItems[source]
        managedObjectContext.delete(listItem)
        saveItems()
    }
    
    func addItem() {
        let newItem = ListItem(context: managedObjectContext)
        newItem.name = "New Item"
        newItem.order = (listItems.last?.order ?? 0) + 1
        
        saveItems()
    }
    
    func saveItems() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
