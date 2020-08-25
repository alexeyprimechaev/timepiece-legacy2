//
//  PersonCard.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PersonCard: View {
    
    @State var name = LocalizedStringKey("")
    
    @State var description = LocalizedStringKey("")
    
    @State var link = String()
    
    @State var image = String()
    
    @State var icon = String()
    
    var body: some View {
        Button(action: {
            mediumHaptic()
            UIApplication.shared.open(URL(string: self.link)!)
        }) {
            HStack(alignment: .center, spacing: 7) {
                Image(image).frame(width: 44, height: 44).cornerRadius(100).overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.black, lineWidth: 0.5)
                ).padding(7)
                VStack(alignment: .leading) {
                    HStack {
                        Text(name)
                        Image(icon)
                    }
                    Text(description).opacity(0.5)
                }.smallTitle()
            }
        }.buttonStyle(RegularButtonStyle())
    }
}

struct PersonCard_Previews: PreviewProvider {
    static var previews: some View {
        PersonCard()
    }
}