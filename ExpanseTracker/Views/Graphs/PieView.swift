//
//  PieView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct PieView: View {
    
    @ObservedObject var viewModel = DummyDataView()
    
    
    var body: some View {
        VStack {
            Chart(viewModel.getTestData()) { data in
                SectorMark(
                    angle: .value(
                        data.text,
                        data.number
                    )
                ).foregroundStyle(
                    by: .value(
                        Text(verbatim: ""),
                        data.text
                    )
                )
                
            }
        }
    }
}
