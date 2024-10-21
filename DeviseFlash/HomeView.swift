//
//  HomeView.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 19/10/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewViewModel()
    @State private var value: Decimal = 0
    
    var body: some View {
        Form {
            Picker("Devise Source", selection: $viewModel.selectedCurrency) {
                ForEach(viewModel.currencySource, id: \.self) { devise in
                    Text(devise)
                }
            }
            .onChange(of: viewModel.selectedCurrency) { oldValue, newValue in
                viewModel.selectedCurrency = newValue
            }
            
            
            TextField("Entre un montant", value: $value, formatter: viewModel.currencyFormatter)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    HomeView()
}

