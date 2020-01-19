//
//  TimerPlus.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import Combine
import CoreData

public class TimerPlus: NSManagedObject, Identifiable {
    
    // Main Properties
    @NSManaged public var createdAt: Date?
    @NSManaged public var isPaused: NSNumber?
    @NSManaged public var isRunning: NSNumber?
    @NSManaged public var currentTime: NSNumber?
    @NSManaged public var totalTime: NSNumber?
    @NSManaged public var timeStarted: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var title: String?
    
    // Setting Properties
    @NSManaged public var soundSetting: String?
    @NSManaged public var precisionSetting: String?
    @NSManaged public var notificationSetting: String?
    
    // Setting Collections
    static let soundSettings = ["Short", "Long"]
    static let precisionSettings = ["On", "Off", "Smart"]
    static let notificationSettings = ["On", "Off"]
    
    // Time Formatters
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm"
        return formatter
    }()
    static let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        return formatter
    }()
    static let timeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        
        return formatter
    }()
    
    static func newTimer(totalTime: Double, title: String, context: NSManagedObjectContext) {
        let timer = TimerPlus(context: context)
        
        // User Input
        timer.title = title
        timer.totalTime = totalTime as NSNumber
        
        // Defaults
        timer.createdAt = Date()
        timer.isPaused = true
        timer.isRunning = false
        timer.currentTime = timer.totalTime
        timer.timeStarted = Date()
        timer.timeFinished = timer.timeStarted?.addingTimeInterval(timer.currentTime as! TimeInterval)
    
        // Settings
        timer.soundSetting = soundSettings[0]
        timer.precisionSetting = precisionSettings[2]
        timer.notificationSetting = notificationSettings[0]
        
        // Saving
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func togglePause() {
        self.isRunning = true
        if(self.isPaused ?? true).boolValue {
            self.timeStarted = Date()
            self.timeFinished = self.timeStarted?.addingTimeInterval(self.currentTime as! TimeInterval)
            self.isPaused = false
            
        } else {

            self.timeStarted = Date()
            self.currentTime = ((self.timeFinished ?? Date()).timeIntervalSince(self.timeStarted ?? Date())) as NSNumber
            self.isPaused = true
        }
    }
    
    func reset() {
        self.isRunning = false
        self.isPaused = true
        self.timeStarted = Date()
        self.currentTime = self.totalTime
        self.timeFinished = self.timeStarted?.addingTimeInterval(self.currentTime as! TimeInterval)
    }
    
    func updateTime() {
        if !(self.isPaused?.boolValue ?? true
            ) {
            self.timeStarted = Date()
            self.currentTime = ((self.timeFinished ?? Date()).timeIntervalSince(self.timeStarted ?? Date())) as NSNumber
            
            if (self.currentTime?.doubleValue ?? 0 <= 0) {
                self.currentTime = self.totalTime
                self.timeStarted = Date()
                self.timeFinished = self.timeStarted?.addingTimeInterval(self.currentTime as! TimeInterval)
                self.isPaused = true
                self.isRunning = false
            }

            
            
        }
    }

}

extension String {
    func stringToNSNumber() -> NSNumber {
        
        var value: NSNumber
        
        var seconds = 0
        var minutes = 0
        var hours = 0
        
        if(self.count == 2) {
            seconds = Int(self) ?? 0
        } else if (self.count == 3){
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(1))) ?? 0
        } else if (self.count == 4) {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(2))) ?? 0
        } else if (self.count == 5) {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(1))) ?? 0
            minutes = Int(String(String(self.prefix(3)).suffix(2))) ?? 0
        } else {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(2))) ?? 0
            minutes = Int(String(String(self.prefix(4)).suffix(2))) ?? 0
        }
        
        
        value = NSNumber(value: (seconds + 60*minutes + 3600*hours))
        
        return value
    }
    
}

extension TimeInterval {

    func stringFromTimeInterval(precisionSetting: String) -> String {

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        
        if(precisionSetting == "Smart") {
            if (time < 60) {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if (time<3600) {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        } else if(precisionSetting == "On") {
            if (time < 60) {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if (time<3600) {
                return String(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,ms)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
            }
        } else {
            if (time < 60) {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else if (time<3600) {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        }

    }
}

extension TimerPlus {
    static func getAllTimers() -> NSFetchRequest<TimerPlus> {
        let request: NSFetchRequest<TimerPlus> = TimerPlus.fetchRequest() as! NSFetchRequest<TimerPlus>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
