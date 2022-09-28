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
            Spacer().frame(height:safeAreaInsets.top + 44)
            buttons
            
            NavigationLink(destination:
                            CardEditor(isNewOne: true,
                                       cardInfo: nil,
                                       finishEditCard: { c in
                self.viewModel.addCard(card: c)
            })
                                .ignoresSafeArea(),
                           isActive: self.$viewModel.isShowEditor) {
                EmptyView()
            }
            
            searchBar
            
            cardlist
            
            if #unavailable(iOS 16) {
                Spacer()
            }
        }
        .background(Color("Bg3"))
        .navigationBarTitle(Text("Card List"))
        .onAppear{
            viewModel.onActionAppear()
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
            Alert(title: Text("Error"),
                  message: Text(self.CSVFileReader.errorMessage),
                  dismissButton: .default(Text("Got it!")))
        }
        .alert(isPresented: self.$viewModel.isShowImportTips) {
            Alert(title: Text("Tips"),
                  message: Text("The CSV file's heads are \"question, answer, example, group, langcode\""),
                  dismissButton: .default(Text("Got it!")))
        }
    }
    
    @ViewBuilder
    var cardlist: some View {
        if viewModel.groups.isEmpty {
            VStack {
                ProgressView().progressViewStyle(.circular)
                Spacer()
            }
        } else {
            List {
                if viewModel.searchText == "" {
                    ForEach(viewModel.groups.indices, id:\.self) { section in
                        Section(header: Text(viewModel.groups[section].title)
                            .foregroundColor(.black)) {
                            ForEach(viewModel.groups[section].cards.indices, id:\.self) { i in
                                NavigationLink(destination: CardEditor(isNewOne: false, cardInfo:viewModel.cardGroups[section].cardArray[i], finishEditCard: { c in
                                    withAnimation{
                                        self.viewModel.modifyCard(card: c, index: i, in: section)
                                    }
                                }).ignoresSafeArea()
                                ){
                                    HStack{
                                        Text(cellText(card: viewModel.groups[section].cards[i]))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(String(viewModel.groups[section].cards[i].weight))
                                            .foregroundColor(.black)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }.onDelete{delete(at: $0, in: section)}
                        }
                    }.listRowBackground(Color("Bg3"))
                } else {
                    ForEach(viewModel.searchedCards.indices,id:\.self) { index in
                        NavigationLink(destination: CardEditor(isNewOne: false, cardInfo: viewModel.searchedCards[index], finishEditCard: { c in
                            withAnimation{
                                self.viewModel.modifyCard(card: c, index: index, in: -1)
                            }
                        }).ignoresSafeArea()
                        ){
                            HStack{
                                Text(cellText(card: CardAdaptor.convertCard(cardInfo: viewModel.searchedCards[index])))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(viewModel.searchedCards[index].weight))
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
    
    var buttons: some View {
        HStack {
            Button(action:importFromCSV){
                Text("Import from csv")
                    .muyaoFont(size: 20)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color("qzcyan"))
            .frame(maxWidth:150, minHeight: 44)
            .padding(.trailing, 0)
            
            VStack {
                Button(action: {
                    self.viewModel.isShowImportTips = true
                }, label: {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                Spacer()
            }
            .frame(height:44)
            .offset(x:-16)
            
            
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
                GroupEditor(groups: $viewModel.cardGroups)
                    .environmentObject(cardPile)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .ignoresSafeArea()
            }
        }.padding(15)
    }
    
    var searchBar: some View {
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
                            self.viewModel.addCard(card: card)
                        }
                    }
                    url.stopAccessingSecurityScopedResource()
                    self.viewModel.fetchData()
                    print("if show alert \(CSVFileReader.isShowAlert)")
                }
            },
            onDismiss: {
                print("dismiss")
            }
        )
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
    
    func cellText(card: Card) -> String {
        let prefix = (card.type == CardType.speech) ? "🗣:" : "Text:"
        return prefix + card.question
    }
    
    func delete(at offset: IndexSet, in section: Int) {
        offset.forEach{ index in
            self.viewModel.delete(index: index, section: section)
        }
    }
    
}


//struct CardList_Previews: PreviewProvider {
//    static var previews: some View {
//        CardList().environmentObject(CardsPileViewModel())
//    }
//}
