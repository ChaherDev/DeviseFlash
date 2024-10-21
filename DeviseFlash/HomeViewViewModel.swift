//
//  HomeViewViewModel.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 20/10/2024.
//

// Mon formatteur de devises

import Observation
import SwiftUI

@Observable
class HomeViewViewModel {
    let currencySource = ["Dollar américain (USD)", "Euro (EUR)", "Yen japonais (JPY)", "Livre sterling (GBP)", "Franc suisse (CHF)"]
    let currencyFormatter: NumberFormatter
    var montant: Decimal = 0
    var value: Double = 0
    var selectedCurrency = "Dollar américain (USD)" {
        didSet {
            updateCurrencyFormatter()
        }
    }
    
    init() {
        currencyFormatter = NumberFormatter()
        updateCurrencyFormatter()
    }
    
    func updateCurrencyFormatter() {
        currencyFormatter.numberStyle = .currency
        switch selectedCurrency {
        case "Dollar américain (USD)":
            currencyFormatter.locale = Locale(identifier: "en_US_POSIX")
        case "Euro (EUR)":
            currencyFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        case "Yen japonais (JPY)":
            currencyFormatter.locale = Locale(identifier: "ja_JP_POSIX")
        case "Livre sterling (GBP)":
            currencyFormatter.locale = Locale(identifier: "en_GB_POSIX")
        case "Franc suisse (CHF)":
            currencyFormatter.locale = Locale(identifier: "fr_CH_POSIX")
        default :
            currencyFormatter.locale = Locale.current
        }
    }
    
    var formattedMontant: String {
        return currencyFormatter.string(from: montant as NSDecimalNumber) ?? ""
    }
}
