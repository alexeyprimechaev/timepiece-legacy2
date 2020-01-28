//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import CoreData

struct TimerDetailView: View {
    
    @ObservedObject var timer = TimerPlus()
        
    @State var name = ""
    
    var onDismiss: () -> ()
    
    var delete: () -> ()
    
    var body: some View {
        
        VStack(spacing:0) {
            HStack() {
                Button(action: {
                    self.onDismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11.0, weight: .heavy))
                        Text("Dismiss")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 128)
                    .foregroundColor(Color.primary)
                }
                .frame(height: 52)
                Spacer()
            }
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                        
                    PropertyView(title: "Title", timer: timer)
                    
                    if (((self.timer.totalTime as! TimeInterval).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off")).count + ((self.timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off")).count > 13) {
                        
                        if (timer.totalTime != timer.currentTime) {
                            TimeView(time: $timer.currentTime, precisionSetting: $timer.precisionSetting, title: "Left", update: {})
                        }
                        EditableTimeView(time: $timer.totalTime, title: "Total", update: {
                            self.timer.reset()
                            self.timer.currentTime = self.timer.totalTime
                        })
                    } else {
                        HStack() {
                            
                            if (timer.totalTime != timer.currentTime) {
                                TimeView(time: $timer.currentTime, precisionSetting: $timer.precisionSetting, title: "Left", update: {})
                            }
                        
                            EditableTimeView(time: $timer.totalTime, title: "Total", update: {
                                self.timer.reset()
                                self.timer.currentTime = self.timer.totalTime
                            })
                        }
                    }
                        
                    PropertyView(title: "Created at", timer: timer)
                    
                    ToggleButton(title: "Notifications", values: TimerPlus.notificationSettings, value: $timer.notificationSetting)
                    ToggleButton(title: "Sound", values: TimerPlus.soundSettings, value: $timer.soundSetting)
                    ToggleButton(title: "Milliseconds", values: TimerPlus.precisionSettings, value: $timer.precisionSetting)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 21)

            }
            
            HStack() {
                Spacer().frame(width:28)
                MainButton(color: Color.red, isPaused: $timer.isRunning, offTitle: "Stop", onTitle: "Delete", offIcon: "stop.fill", onIcon: "trash.fill", onTap: {self.timer.reset()}, offTap: {self.delete()})
                Spacer().frame(width:28)
                MainButton(color: Color.primary, isPaused: $timer.isPaused, offTitle: "Start", onTitle: "Pause", offIcon: "play.fill", onIcon: "pause.fill", onTap: {self.timer.togglePause()}, offTap: {self.timer.togglePause()})
                Spacer().frame(width:28)
            }.padding(.vertical, 7)
        }
    }
    
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDetailView(onDismiss: {}, delete: {})
    }
}