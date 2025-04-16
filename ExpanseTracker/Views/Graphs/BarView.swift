//
//  BarView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct BarView: View {
    
    @ObservedObject var viewModel = DummyDataView()
    
    var body: some View {
        
        VStack {
            Chart(viewModel.getTestData()) {
                BarMark(
                    x: .value("category", $0.text),
                    y: .value("expense", $0.number)
                ).foregroundStyle(by: .value("Product Category", $0.text))
                
            }
        }
    }
}
