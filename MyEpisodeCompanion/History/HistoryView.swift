//
//  HistoryView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var stateManager : StateManager

    
    var body: some View {
        CalendarRootView()
    }
}

struct CalendarRootView : View {
    @Environment(\.calendar) var calendar
    
    private var year: DateInterval{
        return DateInterval(
            start: myUserSettings.registrationDate,
            end: Date())
    }
    
    var body: some View{
        
        CalendarView(interval: year){date in
            //TODO: If health history has a date
            
            
            // else ...
            Text("30")
                .hidden()
                .padding(8)
                .background(.white)
                .clipShape(Circle())
                .padding(.vertical, 4)
                .overlay(
                    Text(String(self.calendar.component(.day, from: date))).foregroundColor(.black)
                )
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(
        interval: DateInterval,
        @ViewBuilder content: @escaping (Date) -> DateView
    ){
        self.interval = interval
        self.content = content
    }
    
    //TODO: Fix spacing
    private var spacing: Double = 5
    private var header: some View {
        HStack{
            Group {
                
                Text("Sun")
                Divider()
                
                Text("Mon")
                Divider()
                
                Text("Tue")
                Divider()
                
            }
            
            Group{
                Text("Wed")
                Divider()
                
                Text("Thu")
                Divider()
                
                Text("Fri")
                Divider()
                
                Text("Sat")
                Divider()
            }
        }.padding()
            .frame(height: 50)
            .background(.thinMaterial)
            .cornerRadius(6)
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        VStack{
            header//TODO: pading, .horizontal 20?
            ScrollViewReader{ scrollReader in
                ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ForEach(months, id: \.self){month in
                        MonthView(
                            month: month,
                                  content: self.content)
                    }
                }
                }.onAppear{
                    scrollReader.scrollTo(months[months.endIndex - 1])
                }
                
            }
        }
    }
}

struct MonthView<DateView>: View where DateView : View {
    @Environment(\.calendar) var calendar
    
    let month: Date
    let content: (Date) -> DateView
    
    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else{return[]}
        
        return calendar.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        
        let txt = Text(formatter.string(from: month))
            .font(.title)
            .overlay(Rectangle().fill(.gray).frame(height:1), alignment: .bottom)
            .padding([.top, .trailing])
        
        return txt
    }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                header
            }
            
            ForEach(weeks, id:\.self){week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(
        week: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ){
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else { return[] }
        return calendar.generateDates(inside: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    var body: some View {
        HStack {
            ForEach(days, id: \.self){date in
                HStack{
                    if self.calendar.isDate(self.week, equalTo:date, toGranularity: .month){
                        self.content(date)
                    }else{
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}


//Extensions
fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates : [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime){ date, _, stop in
                
                if let date = date {
                    if date < interval.end{
                        dates.append(date)
                    }else{
                        stop = true
                    }
                }
            }
        return dates
    }
}

fileprivate extension DateFormatter {
    
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
