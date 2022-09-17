//
//  GroupEditorViewModel.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/17.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation

final class GroupEditorViewModel:ObservableObject {
    @Published var newGroupName:String = ""
    @Published var isShowAlert = false
    @Published var alertContent = ""

}
