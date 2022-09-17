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
    @StateObject var viewModel = CardListViewModel()
    
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
                           isActive: self.$viewModel.isShowEditor) {
                EmptyView()
            }
            ZStack {
                TextField("", text: $viewModel.searchText.animation())
                    .foregroundColor(.black)
                    .frame(height:44)
                    .frame(height:viewModel.showSearchbar ? 44 : 0)
                    .placeholder("  Search", when: viewModel.searchText.isEmpty)
                    .padding(.horizontal, 15)
                    .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(UIColor.darkGray).opacity(0.9),
                                        style: StrokeStyle(lineWidth: 4, dash: [10])))
                    
                HStack {
                    Spacer()
                    if viewModel.searchText != "" {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }.padding(10)
                        .foregroundColor(.gray)
                        .transition(.opacity)
                    }
                }
            }
            .hidden(!viewModel.showSearchbar)
            .padding(.horizontal,10)
            
            if viewModel.groups.isEmpty {
                VStack {
                    ProgressView().progressViewStyle(.circular)
                    Spacer()
                }
            } else {
                List {
                    if viewModel.searchText == "" {
                        ForEach(viewModel.groups.indices, id:\.self) { section in
                            Section(header: Text(viewModel.groups[section].wrappedName).foregroundColor(.black)) {
                                ForEach(viewModel.groups[section].cardArray.indices, id:\.self) { i in
                                    NavigationLink(destination: CardEditor(isNewOne: false, card:viewModel.groups[section].cardArray[i], finishEditCard: { c in
                                            withAnimation{
                                                self.modifyCard(card: c, index: i, in: section)
                                            }
                                    }).ignoresSafeArea()
                                    ){
                                        HStack{
                                            Text(cellText(card: viewModel.groups[section].cardArray[i]))
                                                .foregroundColor(.black)
                                            Spacer()
                                            Text(String(viewModel.groups[section].cardArray[i].weight))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }.onDelete{delete(at: $0, in: section)}
                            }
                        }.listRowBackground(Color("Bg3"))
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
                        }.listRowBackground(Color("Bg3"))
                    }
                }.listBackgroundHidden()
                .defaultListStyle()
                    .background(Color("Bg3"))
                
            }
        }
        .background(Color("Bg3"))
        .navigationBarTitle(Text("Card List"))
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.viewModel.groups.isEmpty {
                    self.viewModel.groups = CardGroup.fetchResult
                }
                
                for index in viewModel.groups.indices {
                    let _ = viewModel.groups[index].cardArray.map{print("appear group:\(viewModel.groups[index].wrappedName) card:\($0.question!)")}
                }
            }
        }
        .toolbar{
            ToolbarItem(placement:.navigationBarTrailing) {
               
            Button(action:{
                self.viewModel.isShowEditor = true
                }){
                    Image("btn_add")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }.traillingToolbar()
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
                viewModel.showEditGroup = true
            }) {
                Text("Edit Group")
                    .muyaoFont(size: 20)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color("qzcyan"))
            .frame(maxWidth:150, minHeight: 44)
            .sheet(isPresented: $viewModel.showEditGroup) {
                GroupEditor(groups: $viewModel.groups)
                    .environmentObject(cardPile)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .ignoresSafeArea()
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
                    self.viewModel.groups = CardGroup.fetchResult
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
            let card = self.viewModel.groups[section].cardArray[index]
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
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
        }
        
    }
    
    /// modify card information
    /// - Parameters:
    ///   - card: modified card model
    ///   - index: index of different lists
    ///   - section: if section is negetive, the list is search list
    func modifyCard(card: Card, index: Int, in section:Int) {
        
        var newCard:CardInfo
        if section >= 0 {
            newCard = viewModel.groups[section].cardArray[index]
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
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
        } else {
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
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
        CardInfo.searchedResult(question: viewModel.searchText)
    }
}


//struct CardList_Previews: PreviewProvider {
//    static var previews: some View {
//        CardList().environmentObject(CardsPileViewModel())
//    }
//}
