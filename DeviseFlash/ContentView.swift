//
//  ContentView.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 19/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = DeviseViewModel()
    
    @State private var deviseSource = ["Dollar américain (USD)", "Euro (EUR)", "Yen japonais (JPY)", "Livre sterling (GBP)", "Franc suisse (CHF)"]
    @State private var selectedDevise = "Dollar américain (USD)"
    @State private var value: Decimal = 0
    
    var body: some View {
        Form {
            Picker("Devise Source", selection: $selectedDevise) {
                ForEach(deviseSource, id: \.self) {devise in
                    Text("\(devise)")
                }
            }
            TextField("Entre un montant", value: $value, formatter: viewModel.currencyFormatter)
        }
    }
}

#Preview {
    ContentView()
}

