//
//  GroupEditor.swift
//  JLQuizCard
//
//  Created by jack on 2021/3/27.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI
import CoreData

struct GroupEditor: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var cardPile:CardPileViewModel
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    @State var newGroupName:String = ""
    @State var isShowAlert = false
    @State var alertContent = ""

    var body: some View {
        VStack(alignment:.leading) {
            HStack{
                TextField("Write a new group name", text: $newGroupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addGroup) {
                    Text("Add")
                }
            }
            Text("All Groups:")
            List {
                ForEach(groups.indices, id:\.self) { index in
                    Text(groups[index].groupname ?? "")
                }.onDelete(perform: delete)
            }
        }.alert(isPresented: self.$isShowAlert) {
            Alert(title: Text("Warning"), message: Text(alertContent), dismissButton: .default(Text("Got it!")))
            }
    }
    
    func delete(at offset:IndexSet) {
        offset.forEach{ index in
            let group = self.groups[index]
            for card in group.cardArray {
                self.managedObjectContext.delete(card)
            }
            self.managedObjectContext.delete(group)
            cardPile.currentGroupIndex = 0
        }
    }
    
    func addGroup() {
        guard newGroupName != "" else {
            self.isShowAlert = true
            self.alertContent = "Write something"
            return
        }
        newGroupName = newGroupName.trimmingCharacters(in: .whitespacesAndNewlines)
        let request: NSFetchRequest<CardGroup> = CardGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardGroup.groupname, ascending: true)]
        request.predicate = NSPredicate(format: "groupname = %@", newGroupName)
        do {
            let fetchResults = try managedObjectContext.fetch(request)
            if  fetchResults.count > 0 {
                self.isShowAlert = true
                self.alertContent = "The group name is repeated"
                newGroupName = ""
                return
            }
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        withAnimation{
            let newGroup = CardGroup(context: managedObjectContext)
            newGroup.groupname = newGroupName
            saveContext()
            newGroupName = ""
        }
        
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

struct GroupEditor_Previews: PreviewProvider {
    static var previews: some View {
        GroupEditor()
    }
}
