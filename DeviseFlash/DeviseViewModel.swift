//
//  DeviseViewModel.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 20/10/2024.
//

// Mon formatteur de devises

import Observation
import SwiftUI

@Observable
class DeviseViewModel {
    var montant: Decimal = 0
    let currencyFormatter: NumberFormatter
    
    init() {
        currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
    }
    
    var formattedMontant: String {
        return currencyFormatter.string(from: montant as NSDecimalNumber) ?? ""
    }
}
