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
                            print(date.getDayNumber())
                        }){
                        Text("\(date.getDayNumber())")
                            .padding(8)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.gray)
                            .id(date)
                        }
                    }else{
                        Text("\(date.getDayNumber())")
                            .padding(8)
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                            .background(Color.gray)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State var num:Int = 0
    var body: some View {
        VStack {
            
            Text("Simple Calendar")
                .font(.title)
                .padding()
            if let targetMonth = Calendar.current.date(byAdding: .month, value: num, to: Date()) {
                
                HStack{
                    Button(action: {
                        num -= 1
                    }){
                        Image(systemName: "lessthan")
                    }
                    
                    Text(targetMonth.formatYearMonth())
                    
                    Button(action: {
                        num += 1
                    }){
                        Image(systemName: "greaterthan")
                    }
                }
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

// extension some func for Date and Calendar
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
    
    func formatYearMonth() -> String{
        
        let rowDate = self.formatted().split(separator: "/")
        
        var s = ""
        var cnt = 0
        
        for i in rowDate[2]{
            if cnt > 3{
                break
            }
            s += String(i)
            cnt += 1
        }
        
        if rowDate[0].count < 2{
            s += "  \(rowDate[0])月"
        }else{
            s += " \(rowDate[0])月"
        }
        
        return s
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
