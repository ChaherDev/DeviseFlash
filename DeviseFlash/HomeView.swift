//
//  HomeView.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 19/10/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewViewModel()
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Devise Source", selection: $viewModel.selectedCurrency) {
                    ForEach(viewModel.currencySource, id: \.self) { devise in
                        Text(devise)
                    }
                }
                TextField("Entre un montant", value: $viewModel.value, formatter: viewModel.currencyFormatter)
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
            }
            .navigationTitle("DeviseFlash")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

