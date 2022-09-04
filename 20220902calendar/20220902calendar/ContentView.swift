//
//  ContentView.swift
//  20220902calendar
//
//  Created by いーま on 2022/09/02.
//

import SwiftUI
import SelectableCalendarView
import Foundation
import UIKit

struct CalendarView: View {
    
    let monthToDisplay:Date
    
    init(monthToDisplay: Date){
        self.monthToDisplay = monthToDisplay
    }
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { weekdayName in
                Text(weekdayName)
            }

            Section {
                ForEach(monthToDisplay.getDaysForMonth(), id: \.self) { date in

                    if Calendar.current.isDate(date, equalTo: monthToDisplay, toGranularity:.month){
                        Button(action: {
                            print("押されたお")
                        }){
                        Text("\(date.getDayNumber())")
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .id(date)
                        }
                    }else{
                        Text("\(date.getDayNumber())")
                            .padding(8)
                            .foregroundColor(.gray)
                            .background(Color.blue)
                            .hidden()
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            if let targetMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date()) {
                
                Text("2022 09")
                CalendarView(monthToDisplay: targetMonth)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension Date {
    
    func getDayNumber()->Int {
        return Calendar.current.component(.day, from: self) ?? 0
    }
    
    func getDaysForMonth() -> [Date] {
        guard
            let monthInterval = Calendar.current.dateInterval(of: .month, for: self),
            let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else {
            return []
        }
        let resultDates = Calendar.current.generateDates(inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
                                                         matching: DateComponents(hour: 0, minute: 0, second: 0))
        return resultDates
    }
    
}

extension Calendar {
    
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [interval.start]
        enumerateDates(startingAfter: interval.start,
                       matching: components,
                       matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}
