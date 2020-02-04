//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
//MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timer = TimerPlus()
    @State var showingDetail = false
    @State var value = "88:88"
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context

    
//MARK: - View
    var body: some View {
        
        
        Button(action:
            
        //MARK: Action
        {
            self.timer.togglePause()
        })
            
            
        //MARK: Layout
        {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(timer.title)
                    
                    Text(timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .opacity(0.5)
                        .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                            self.timer.updateTime()
                            self.value = self.timer.currentTime.stringFromTimeInterval(precisionSetting: self.timer.precisionSetting)
                    }
                    
                }
                if self.value.count == 8 {
                    Text("88:88:88")
                        .opacity(0)
                } else if self.value.count == 5 {
                    Text("88:88")
                        .opacity(0)
                } else {
                    Text("88:88:88.88")
                        .opacity(0)
                }
                
            }
        }
        
            
        //MARK: Styling
        .titleStyle()
        .buttonStyle(DeepButtonStyle())
        .padding(7)
        .fixedSize()
    
        
    }
}

//MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
