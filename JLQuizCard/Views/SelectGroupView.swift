//
//  SelectGroupView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/18.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct SelectGroupView: View {
    @EnvironmentObject var cardPileModel:CardPileViewModel
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    
    var done:() -> Void
    init(done:@escaping () -> Void) {
        self.done = done
    }
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("btn_close")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("qzblue"))
                }).frame(width: 44, height: 44)
                    .padding(20)
            }
            Spacer()
            Text("Select a group:")
                .foregroundColor(.black)
            
            Picker("", selection:$cardPileModel.currentGroupIndex) {
                ForEach(cardPileModel.groupNames.indices, id:\.self) {
                    Text(cardPileModel.groupNames[$0])
                        .foregroundColor(.black)
                }
            }.pickerStyle(WheelPickerStyle())
                .background(Color("Bg2"))
                .overlay(RoundedRectangle(cornerRadius: 22)
                            .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(35)
            
            Button(action: {
                done()
            }) {
                Text("Done")
                    .muyaoFont(size: 24)
                    .foregroundColor(Color.white)
            }.remenberButtonStyle(color: Color.blue)
            Spacer()
        }
        .background(Color("Bg1"))
    }
}

struct SelectGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGroupView(done: {})
    }
}
