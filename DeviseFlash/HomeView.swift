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
                Section {
                    Picker("Devise Source", selection: $viewModel.selectedCurrencySource) {
                        ForEach(viewModel.currencySource, id: \.self) { devise in
                            Text(devise)
                        }
                    }
                    TextField("Entre un montant", value: $viewModel.value, formatter: viewModel.currencyFormatter)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Section {
                    Picker("Devise Cible", selection: $viewModel.selectedCurrencyTarget) {
                        ForEach(viewModel.currencyTarget, id: \.self) { devise in
                            Text(devise)
                        }
                    }
                    Text("\(viewModel.montant, specifier: "%.2f")")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("DeviseFlash")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                        Task {
                            await viewModel.fetchData()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

