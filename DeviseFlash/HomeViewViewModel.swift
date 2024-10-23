//
//  HomeViewViewModel.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 20/10/2024.
//

// Mon formatteur de devises

import Foundation
import Observation

struct CurrencyConversionResponse: Codable {
    let success: Bool
    let terms: URL
    let privacy: URL
    let query: Query
    let result: Double
    
    struct Query: Codable {
        let from: String
        let to: String
        let amount: Double
    }
}

@Observable
class HomeViewViewModel {
    let currencySource = ["Dollar américain (USD)", "Euro (EUR)", "Yen japonais (JPY)", "Livre sterling (GBP)", "Franc suisse (CHF)"]
    let currencyTarget = ["Dollar américain (USD)", "Euro (EUR)", "Yen japonais (JPY)", "Livre sterling (GBP)", "Franc suisse (CHF)"]
    let currencyFormatter: NumberFormatter
    var montant: Decimal = 0
    var value: Double = 0
    var selectedCurrencySource = "Dollar américain (USD)" {
        didSet {
            updateCurrencyFormatter()
        }
    }
    var selectedCurrencyTarget = "Dollar américain (USD)"
    var conversionResponse: CurrencyConversionResponse?
    var errorMessage: String?
    
    init() {
        currencyFormatter = NumberFormatter()
        updateCurrencyFormatter()
    }
    
    func updateCurrencyFormatter() {
        currencyFormatter.numberStyle = .currency
        switch selectedCurrencySource {
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
    
    func fetchData() async {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            errorMessage = "Clé API manquante."
            return
        }
        
        let urlString = "https://api.currencylayer.com/convert?access_key=\(apiKey)&from=USD&to=EUR&amount=25&format=1"
        guard let url = URL(string: urlString) else {
            errorMessage = "URL invalide."
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            conversionResponse = try JSONDecoder().decode(CurrencyConversionResponse.self, from: data)
            montant = Decimal(conversionResponse?.result ?? 5)
        } catch {
            errorMessage = "Erreur lors de la récupération des données."
        }
    }
    
}



//
//Task {
//    do {
//        try await fetchData()
//    } catch {
//        print("Erreur lors de la récupération des données : \(error)")
//    }
//}
//
