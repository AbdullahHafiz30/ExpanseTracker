//
//  ContentView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 27/09/1446 AH.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    let viewMonths: [ViewMonth] = [
        .init(date: .from(year: 2024, month: 1, day: 1), viewcount: 5500),
        .init(date: .from(year: 2024, month: 2, day: 1), viewcount: 3000),
        .init(date: .from(year: 2024, month: 3, day: 1), viewcount: 3300),
        .init(date: .from(year: 2024, month: 4, day: 1), viewcount: 4000),
        .init(date: .from(year: 2024, month: 5, day: 1), viewcount: 4500),
        .init(date: .from(year: 2024, month: 6, day: 1), viewcount: 7600),
        .init(date: .from(year: 2024, month: 7, day: 1), viewcount: 8300),
        .init(date: .from(year: 2024, month: 8, day: 1), viewcount: 2400),
        .init(date: .from(year: 2024, month: 9, day: 1), viewcount: 3700),
        .init(date: .from(year: 2024, month: 10, day: 1), viewcount: 8700),
        .init(date: .from(year: 2024, month: 11, day: 1), viewcount: 3700),
        .init(date: .from(year: 2024, month: 12, day: 1), viewcount: 8200),
    ]
    
    let lessMonths: [ViewMonth] = [
        .init(date: .from(year: 2024, month: 1, day: 1), viewcount: 4000),
        .init(date: .from(year: 2024, month: 2, day: 1), viewcount: 1500),
        .init(date: .from(year: 2024, month: 3, day: 1), viewcount: 2000),
        .init(date: .from(year: 2024, month: 4, day: 1), viewcount: 1500),
        .init(date: .from(year: 2024, month: 5, day: 1), viewcount: 1300),
        .init(date: .from(year: 2024, month: 6, day: 1), viewcount: 4000),
        .init(date: .from(year: 2024, month: 7, day: 1), viewcount: 6200),
        .init(date: .from(year: 2024, month: 8, day: 1), viewcount: 1700),
        .init(date: .from(year: 2024, month: 9, day: 1), viewcount: 2700),
        .init(date: .from(year: 2024, month: 10, day: 1), viewcount: 6400),
        .init(date: .from(year: 2024, month: 11, day: 1), viewcount: 2900),
        .init(date: .from(year: 2024, month: 12, day: 1), viewcount: 3400),
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewMonths) { month in
                    LineMark(
                        x: .value("Month", month.date, unit: .month),
                        y: .value("Views", month.viewcount)
                    )
                }
                
            }
            
            Chart {
                ForEach(viewMonths) { month in
                    BarMark(
                        x: .value("Month", month.date, unit: .month),
                        y: .value("Views", month.viewcount)
                    )
                }
                ForEach(lessMonths) { month in
                    BarMark(
                        x: .value("Month", month.date, unit: .month),
                        y: .value("Views", month.viewcount)
                    )
                    
                }
            }
            
            
            
            Chart {
                ForEach(viewMonths) { month in
                    SectorMark(
                        angle: .value("Views", month.viewcount)
                            
                    ).foregroundStyle(by: .value("Month", month.date.formatted(.dateTime.year().month())))
                }
                
            }
        }
        .padding()
    }
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewcount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

#Preview {
    ContentView()
}
