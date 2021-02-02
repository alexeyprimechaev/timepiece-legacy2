//
//  NewTimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct NewTimeItemSheet: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var timeItem = TimeItem()
    
    @Binding var isAdding: Bool
    
    @State var showingOptions = false
    
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    @State var titleFocused = false
    @State var timeFocused = false
        
    var discard: () -> Void
            
    var body: some View {
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                isAdding = false
                discard()
            }, leadingTitle: Strings.discard, leadingIcon: "xmark", leadingIsDestructive: true,
            trailingAction: {})
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    TitleEditor(title: Strings.title, becomeFirstResponder: timeItem.isStopwatch ? true : false, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused)
                    
                    if !timeItem.isStopwatch {
                        TimeEditor(timeString: $timeItem.editableTimeString, becomeFirstResponder: timeItem.isStopwatch ? false : true, textField: $timeField, isFocused: $timeFocused)
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        
                        if !timeItem.isStopwatch {
                            PremiumBadge {
                                PickerButton(title: Strings.reusable, values: [true.yesNo, false.yesNo], controlledValue: $timeItem.isReusable.yesNo)
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 7) {
                            if !timeItem.isStopwatch {
                                
                                RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                                    self.timeItem.convertToStopwatch()
                                    titleField.becomeFirstResponder()
                                }
                                
                            } else {
                                RegularButton(title: "Convert to Timer", icon: "timer") {
                                    self.timeItem.isStopwatch = false
                                    timeField.becomeFirstResponder()
                                }
                            }
                            
                            RegularButton(title: showingOptions ? "Less Options" : "More Options", icon: "ellipsis.circle") {
                                showingOptions.toggle()
                            }.opacity(showingOptions ? 0.5 : 1)
                        }
                    
                        if showingOptions {
                            
                            if !timeItem.isStopwatch {
                                PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                                
                                PremiumBadge {
                                    PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                                }
                            }
                            
                           
                            PremiumBadge {
                                if timeItem.isStopwatch {
                                    PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings.dropLast(), controlledValue: $timeItem.precisionSetting)
                                } else {
                                    PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timeItem.precisionSetting)
                                }
                            }
                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [true.yesNo, false.yesNo], controlledValue: $timeItem.showInLog.yesNo)
                            }
                        }
                            
                        }.animation(.default, value: showingOptions)
                    

                    
                    
                }.padding(.leading, 21).animation(.default, value: timeItem.isStopwatch)
            }
                EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused, showSwitcher: $timeItem.isStopwatch) {
                    if !timeItem.isStopwatch {
                        Button {
                            isAdding = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if !timeItem.isReusable {
                                    if timeItem.totalTime > 0 {
                                        timeItem.togglePause()
                                    }
                                }
                            }
                            discard()
                        } label: {
                            Label {
                                Text(timeItem.isReusable ? Strings.add : Strings.start).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: timeItem.isReusable ? "plus" : "play").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                    } else {
                        
                        Spacer()
                        
                        Button {
                            self.timeItem.editableTimeString = "000000"
                            isAdding = true
                            discard()
                        } label: {
                            Label {
                                Text(Strings.add).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: "plus").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                        
                        
                        Button {
                            self.timeItem.editableTimeString = "000000"
                            isAdding = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                timeItem.togglePause()
                            }
                            discard()
                        } label: {
                            Label {
                                Text(Strings.start).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: "play").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                    }
                    
                }
            

        }.onAppear {
            isAdding = false
        }
    }
}
