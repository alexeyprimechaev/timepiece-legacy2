//
//  TabBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 5/30/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    var actions: [() -> ()]
    
    @EnvironmentObject var settings: Settings
    
    @State var showingSubscriptionSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Spacer().frame(width: 14)
                TabItem(title: newString,icon: "plus", action: { self.actions[0]() })
                TabItem(title: logString, icon: "bolt", action: {
                    self.actions[1]()
                    
                    }).overlay(
                        Circle().frame(width: 7, height: 7).foregroundColor(.red).padding(.top, 7).padding(.leading, 26).opacity(settings.hasSeenTrends ? 0 : 1)
                    , alignment: .topLeading)
                TabItem(title: settingsString, icon: "gear", action: { self.actions[2]() })
                Spacer()
            }
        }.betterSheet(isPresented: $showingSubscriptionSheet) {
            SubscriptionSheet(discard: {self.showingSubscriptionSheet = false}).environmentObject(self.settings)
        }
    }
}
