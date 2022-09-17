//
//  CardListViewModel.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/17.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation

final class CardListViewModel:ObservableObject {
    @Published var groups:[CardGroup] = [CardGroup]()
    @Published var isShowEditor = false
    @Published var isDocumentPickerPresented = false
    @Published var showEditGroup = false
    @Published var searchText = ""
    @Published var showSearchbar = true
}
