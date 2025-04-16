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
            //            Chart(viewModel.dummyData) { dummydata in
            //                SerctorMark(
            //                    angle: .value(
            //                        Text(verbatim: dummydata.),
            //                        product.revenue
            //                    )
            //
            //                )
            //
            //            }
        }.onAppear {
            viewModel.getEssential()
        }
    }
}
