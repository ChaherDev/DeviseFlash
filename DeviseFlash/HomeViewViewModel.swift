//
//  HomeViewViewModel.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 20/10/2024.
//

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
    let currencySource = ["USD", "EUR", "JPY", "GBP", "CHF", "AUD", "CAD", "NZD", "CNY", "SEK", "NOK", "MXN", "SGD"]
    let currencyTarget = ["USD", "EUR", "JPY", "GBP", "CHF", "AUD", "CAD", "NZD", "CNY", "SEK", "NOK", "MXN", "SGD"]
    
    let currencyFormatter: NumberFormatter
    var montant: Double = 0
    var value: Double = 0
    var selectedCurrencySource = "USD" {
        didSet {
            updateCurrencyFormatter()
            Task {
                await fetchData()
            }
        }
    }
    
    var targetCurrencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var selectedCurrencyTarget = "EUR" {
        didSet {
            updateTargetCurrencyFormatter()
            Task {
                await fetchData()
            }
        }
    }
    
    var conversionResponse: CurrencyConversionResponse?
    var errorMessage: String?
    
    init() {
        currencyFormatter = NumberFormatter()
        updateCurrencyFormatter()
    }
    
    func updateTargetCurrencyFormatter() {
        targetCurrencyFormatter.currencyCode = selectedCurrencyTarget
        switch selectedCurrencyTarget {
        case "USD":
            targetCurrencyFormatter.locale = Locale(identifier: "en_US_POSIX")
        case "EUR":
            targetCurrencyFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        case "JPY":
            targetCurrencyFormatter.locale = Locale(identifier: "ja_JP_POSIX")
        case "GBP":
            targetCurrencyFormatter.locale = Locale(identifier: "en_GB_POSIX")
        case "CHF":
            targetCurrencyFormatter.locale = Locale(identifier: "fr_CH_POSIX")
        case "AUD":
            targetCurrencyFormatter.locale = Locale(identifier: "en_AU_POSIX")
        case "CAD":
            targetCurrencyFormatter.locale = Locale(identifier: "en_CA_POSIX")
        case "NZD":
            targetCurrencyFormatter.locale = Locale(identifier: "en_NZ_POSIX")
        case "CNY":
            targetCurrencyFormatter.locale = Locale(identifier: "zh_CN")
        case "SEK":
            targetCurrencyFormatter.locale = Locale(identifier: "sv_SE")
        case "NOK":
            targetCurrencyFormatter.locale = Locale(identifier: "no_NO")
        case "MXN":
            targetCurrencyFormatter.locale = Locale(identifier: "es_MX")
        case "SGD":
            targetCurrencyFormatter.locale = Locale(identifier: "en_SG")
        default:
            targetCurrencyFormatter.locale = Locale.current
        }
    }

    func updateCurrencyFormatter() {
        currencyFormatter.numberStyle = .currency
        switch selectedCurrencySource {
        case "USD":
            currencyFormatter.locale = Locale(identifier: "en_US_POSIX")
        case "EUR":
            currencyFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        case "JPY":
            currencyFormatter.locale = Locale(identifier: "ja_JP_POSIX")
        case "GBP":
            currencyFormatter.locale = Locale(identifier: "en_GB_POSIX")
        case "CHF":
            currencyFormatter.locale = Locale(identifier: "fr_CH_POSIX")
        case "AUD":
            currencyFormatter.locale = Locale(identifier: "en_AU_POSIX")
        case "CAD":
            currencyFormatter.locale = Locale(identifier: "en_CA_POSIX")
        case "NZD":
            currencyFormatter.locale = Locale(identifier: "en_NZ_POSIX")
        case "CNY":
            currencyFormatter.locale = Locale(identifier: "zh_CN")
        case "SEK":
            currencyFormatter.locale = Locale(identifier: "sv_SE")
        case "NOK":
            currencyFormatter.locale = Locale(identifier: "no_NO")
        case "MXN":
            currencyFormatter.locale = Locale(identifier: "es_MX")
        case "SGD":
            currencyFormatter.locale = Locale(identifier: "en_SG")
        default:
            currencyFormatter.locale = Locale.current
        }
    }
    
    func fetchData() async {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("Clé API manquante.")
        }
        
        let urlString = "https://api.currencylayer.com/convert?access_key=\(apiKey)&from=\(selectedCurrencySource)&to=\(selectedCurrencyTarget)&amount=\(value)&format=1"
        print("URL utilisée pour la request: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            errorMessage = "URL invalide."
            print(errorMessage ?? "L'URL est valide")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    errorMessage = "Erreur HTTP: \(httpResponse.statusCode)."
                    print(errorMessage ?? "Pas d'erreurs HTTP")
                    
                    // Conversion et affichage de la réponse brute pour déboguer
                    if let errorDataString = String(data: data, encoding: .utf8) {
                        print("Réponse d'erreur : \(errorDataString)")
                    }
                    
                    return
                }
            }
            
            conversionResponse = try JSONDecoder().decode(CurrencyConversionResponse.self, from: data)
            montant = conversionResponse?.result ?? 5
            print("Montant converti: \(montant)")
            
        } catch let decodingError as DecodingError {
            // Gestion spécifique des erreurs de décodage
            errorMessage = "Erreur lors du décodage des données: \(decodingError.localizedDescription)"
            print(errorMessage ?? "Erreur de décodage")
            
            // Affichage des données brutes pour le décodage
            let dataString = await String(data: (try? URLSession.shared.data(from: url).0) ?? Data(), encoding: .utf8)
            print("Données brutes: \(dataString ?? "Aucune donnée brute")")
            
        } catch {
            errorMessage = "Erreur lors de la récupération des données."
            print(errorMessage ?? "Pas d'erreurs lors de la récupération des données")
        }
    }
}
