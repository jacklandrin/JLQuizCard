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
    @StateObject var viewModel = GroupEditorViewModel()
    @Binding var groups:[CardGroup]
    
    init(groups:Binding<[CardGroup]>) {
        UITableViewCell.appearance().backgroundColor = UIColor(named: "Bg3")!
        UITableView.appearance().backgroundColor = UIColor(named: "Bg3")!
        self._groups = groups
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            Spacer().frame(height:20)
            HStack{
                Spacer()
                TextField("", text: $viewModel.newGroupName)
                    .foregroundColor(.black)
                    .frame(height:44)
                    .placeholder("group name", when: viewModel.newGroupName.isEmpty)
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
            }.listBackgroundHidden()
                .defaultListStyle()
                .overlay(RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(UIColor.darkGray).opacity(0.9),
                            style: StrokeStyle(lineWidth: 4, dash: [10])))
                .padding(.horizontal, 20)
                .padding(.bottom, safeAreaInsets.bottom)
        }
        .background(Color("Bg3"))
        .ignoresSafeArea()
        .alert(isPresented: self.$viewModel.isShowAlert) {
            Alert(title: Text("Warning"),
                  message: Text(viewModel.alertContent),
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
            self.refreshGroups()
        }
    }
    
    func addGroup() {
        guard viewModel.newGroupName != "" else {
            self.viewModel.isShowAlert = true
            self.viewModel.alertContent = "Write something"
            return
        }
        viewModel.newGroupName = viewModel.newGroupName.trimmingCharacters(in: .whitespacesAndNewlines)
        let request: NSFetchRequest<CardGroup> = CardGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardGroup.groupname, ascending: true)]
        request.predicate = NSPredicate(format: "groupname = %@", viewModel.newGroupName)
        do {
            let fetchResults = try managedObjectContext.fetch(request)
            if  fetchResults.count > 0 {
                self.viewModel.isShowAlert = true
                self.viewModel.alertContent = "The group name is repeated"
                viewModel.newGroupName = ""
                return
            }
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        withAnimation{
            let newGroup = CardGroup(context: managedObjectContext)
            newGroup.groupname = viewModel.newGroupName
            saveContext()
            viewModel.newGroupName = ""
            refreshGroups()
        }
        
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func refreshGroups() {
        self.groups = CardGroup.fetchResult
    }
}

struct GroupEditor_Previews: PreviewProvider {
    static var previews: some View {
        GroupEditor(groups: .constant([CardGroup]()))
    }
}
