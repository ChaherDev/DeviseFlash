//
//  HomeView.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 19/10/2024.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewViewModel()
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {  
                VStack(spacing: 10) {
                    Text("Choisissez votre devise source")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("Devise Source", selection: $viewModel.selectedCurrencySource) {
                        ForEach(viewModel.currencySource, id: \.self) { devise in
                            Text(devise)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    
                    TextField("Entrez un montant", value: $viewModel.value, formatter: viewModel.currencyFormatter)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                }
                
                VStack(spacing: 10) {
                    Text("Choisissez votre devise cible")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("Devise Cible", selection: $viewModel.selectedCurrencyTarget) {
                        ForEach(viewModel.currencyTarget, id: \.self) { devise in
                            Text(devise)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    
                    Text(viewModel.targetCurrencyFormatter.string(from: NSNumber(value: viewModel.montant)) ?? "0.00")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                        .animation(.easeInOut, value: viewModel.montant)
                }
            }
            .padding(.horizontal, 20)

            .toolbar {
                if amountIsFocused {
                    ToolbarItem(placement: .keyboard) {
                        Button("Terminé") {
                            amountIsFocused = false
                            Task {
                                await viewModel.fetchData()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
