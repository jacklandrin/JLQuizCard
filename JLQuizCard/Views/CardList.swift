//
//  CardList.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct CardList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var cardPile:CardPileViewModel
    @ObservedObject var CSVFileReader:CSVFileReaderModel = CSVFileReaderModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    
    
    @State var isShowEditor = false
    @State var isDocumentPickerPresented = false
    @State var showEditGroup = false
    @State var searchText = ""
    @State var showSearchbar = true
    
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(named: "Bg3")!
        UITableView.appearance().backgroundColor = UIColor(named: "Bg3")!
        UITextField.appearance().backgroundColor = UIColor(named: "Bg3")!
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: safeAreaInsets.top + 44)
            buttons
            
            NavigationLink(destination: CardEditor(isNewOne: true,
                                                   card: nil,
                                                   finishEditCard: { c in
                 self.addCard(card: c)
            }).ignoresSafeArea(),
                           isActive: $isShowEditor) {
                EmptyView()
            }
            ZStack {
                TextField("", text: $searchText.animation())
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height:showSearchbar ? 44 : 0)
                    .placeholder("  Search", when: searchText.isEmpty)
                    .padding(.horizontal, 15)
                    .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(UIColor.darkGray).opacity(0.9),
                                        style: StrokeStyle(lineWidth: 4, dash: [10])))
                    
                
                HStack {
                    Spacer()
                    if searchText != "" {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }.padding(10)
                        .foregroundColor(.gray)
                        .transition(.opacity)
                    }
                }
            }
            .hidden(!showSearchbar)
            .padding(.horizontal,10)
            
            List {
                if searchText == "" {
                    ForEach(groups.indices, id:\.self) { section in
                        Section(header: Text(groups[section].wrappedName).foregroundColor(.black)) {
                            ForEach(groups[section].cardArray.indices, id:\.self) { i in
                                NavigationLink(destination: CardEditor(isNewOne: false, card: groups[section].cardArray[i], finishEditCard: { c in
                                        withAnimation{
                                            self.modifyCard(card: c, index: i, in: section)
                                        }
                                }).ignoresSafeArea()
                                ){
                                    HStack{
                                        Text(cellText(card: groups[section].cardArray[i]))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(String(groups[section].cardArray[i].weight))
                                            .foregroundColor(.black)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }.onDelete{delete(at: $0, in: section)}
                        }.background(Color("Bg3"))
                    }
                } else {
                    ForEach(searchedCards.indices,id:\.self) { index in
                        NavigationLink(destination: CardEditor(isNewOne: false, card: searchedCards[index], finishEditCard: { c in
                                withAnimation{
                                    self.modifyCard(card: c, index: index, in: -1)
                                }
                        }).ignoresSafeArea()
                        ){
                            HStack{
                                Text(cellText(card: searchedCards[index]))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(searchedCards[index].weight))
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }.defaultListStyle()
            .onAppear{
                for index in groups.indices {
                   let _ = groups[index].cardArray.map{print("appear group:\(groups[index].wrappedName) card:\($0.question!)")}
                }
            }
            
        
        }
        .background(Color("Bg3"))
        .navigationBarTitle(Text("Card List"))
        .toolbar{
            ToolbarItem(placement:.navigationBarTrailing) {
                    Button(action:{
                        self.isShowEditor = true
                    }){
                        Image("btn_add")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("qzblue"))
                            .frame(width: 40, height: 40)
                    }
            }
        }
        .alert(isPresented: self.$CSVFileReader.isShowAlert) {
            Alert(title: Text("Error"), message: Text(self.CSVFileReader.errorMessage), dismissButton: .default(Text("Got it!")))
        }
    }
    
    var buttons: some View {
        HStack {
            Button(action:importFromCSV){
                Text("Import from csv")
                    .muyaoFont(size: 20)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color("qzcyan"))
            .frame(maxWidth:150, minHeight: 44)
            
            
            Spacer().frame(width:20)
            
            Button(action: {
                showEditGroup = true
            }) {
                Text("Edit Group")
                    .muyaoFont(size: 20)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color("qzcyan"))
            .frame(maxWidth:150, minHeight: 44)
            .sheet(isPresented: $showEditGroup) {
                GroupEditor().environmentObject(cardPile).environment(\.managedObjectContext, managedObjectContext).padding(20)
            }
        }.padding(15)
    }
    
    func importFromCSV() -> Void {
        let picker = DocumentPickerViewController(
            supportedTypes: ["public.comma-separated-values-text"],
            onPick: { url in
                print("file url : \(url)")
                let fileUrlAuthozied = url.startAccessingSecurityScopedResource()
                if fileUrlAuthozied {
                    CSVFileReader.readFileFromUrl(url: url) { cards in
                        for card in cards {
                            self.addCard(card: card)
                        }
                    }
                    url.stopAccessingSecurityScopedResource()
                    print("if show alert \(CSVFileReader.isShowAlert)")
                }
            },
            onDismiss: {
                print("dismiss")
            }
        )
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
    
    func cellText(card: CardInfo) -> String {
        let prefix = (card.type == CardType.speech.rawValue) ? "🗣:" : "Text:"
        return prefix + card.question!
    }
    
    func delete(at offset: IndexSet, in section: Int) {
        offset.forEach{ index in
            let card = self.groups[section].cardArray[index]
            self.managedObjectContext.delete(card)
        }
        saveContext()
    }
    
    func addCard(card: Card) {
        withAnimation{
            let newCard = CardInfo(context:managedObjectContext)
            newCard.question = card.question
            newCard.answer = card.answer
            newCard.languageCode = card.languageCode
            newCard.example = card.example
            newCard.type = card.type.rawValue
            newCard.weight = 0
            addCardIntoGroup(card: newCard, groupName: card.group)
        }
        
    }
    
    func addCardIntoGroup(card:CardInfo, groupName:String) {
        let request: NSFetchRequest<CardGroup> = CardGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardGroup.groupname, ascending: true)]
        request.predicate = NSPredicate(format: "groupname = %@", groupName)
        do {
            let fetchResults = try managedObjectContext.fetch(request)
            if  fetchResults.count > 0 {
                fetchResults[0].addToCards(card)
            } else {
                card.ofGroup = CardGroup(context: managedObjectContext)
                card.ofGroup?.groupname = groupName
            }
        } catch {
            print("Error saving managed object context: \(error)")
        }
        saveContext()
    }
    
    /// modify card information
    /// - Parameters:
    ///   - card: modified card model
    ///   - index: index of different lists
    ///   - section: if section is negetive, the list is search list
    func modifyCard(card: Card, index: Int, in section:Int) {
        
        var newCard:CardInfo
        if section >= 0 {
            newCard = groups[section].cardArray[index]
        } else {
            newCard = searchedCards[index]
        }
 
        newCard.question = card.question
        newCard.answer = card.answer
        newCard.languageCode = card.languageCode
        newCard.example = card.example
        newCard.type = card.type.rawValue
        if newCard.ofGroup?.wrappedName == card.group {
            saveContext()
            return
        }
        if (newCard.ofGroup != nil) {
            newCard.ofGroup?.removeFromCards(newCard)
            saveContext()
            addCardIntoGroup(card: newCard, groupName: card.group)
        } else {
            addCardIntoGroup(card: newCard, groupName: card.group)
        }
        
        saveContext()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    var searchedCards:[CardInfo] {
        CardInfo.searchedResult(question: searchText)
    }
}


//struct CardList_Previews: PreviewProvider {
//    static var previews: some View {
//        CardList().environmentObject(CardsPileViewModel())
//    }
//}
