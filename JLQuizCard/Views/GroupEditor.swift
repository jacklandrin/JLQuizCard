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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var cardPile:CardPileViewModel
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    @State var newGroupName:String = ""
    @State var isShowAlert = false
    @State var alertContent = ""

    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(named: "Bg3")!
        UITableView.appearance().backgroundColor = UIColor(named: "Bg3")!
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            Spacer().frame(height:20)
            HStack{
                Spacer()
                TextField("", text: $newGroupName)
                    .foregroundColor(.black)
                    .frame(height:44)
                    .placeholder("group name", when: newGroupName.isEmpty)
                    .padding(.horizontal, 10)
                    .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(UIColor.darkGray).opacity(0.9),
                                        style: StrokeStyle(lineWidth: 4, dash: [10])))
                
                Button(action: addGroup) {
                    Text("Add")
                        .muyaoFont(size: 26)
                }
                Spacer()
            }.padding(.horizontal, 10)
            
            Text("All Groups:")
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            List {
                ForEach(groups.indices, id:\.self) { index in
                    Text(groups[index].groupname ?? "")
                        .foregroundColor(.black)
                }.onDelete(perform: delete)
                    .listRowBackground(Color("Bg3"))
            }.defaultListStyle()
            .overlay(RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(UIColor.darkGray).opacity(0.9),
                                style: StrokeStyle(lineWidth: 4, dash: [10])))
            .padding(.horizontal, 20)
            .padding(.bottom, safeAreaInsets.bottom)
        }
        .background(Color("Bg3"))
        .ignoresSafeArea()
        .alert(isPresented: self.$isShowAlert) {
            Alert(title: Text("Warning"),
                  message: Text(alertContent),
                  dismissButton: .default(Text("Got it!")))
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
