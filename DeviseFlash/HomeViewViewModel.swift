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
    let currencySource = ["USD", "EUR", "JPY", "GBP", "CHF"]
    let currencyTarget = ["USD", "EUR", "JPY", "GBP", "CHF"]
    let currencyFormatter: NumberFormatter
    var montant: Double = 0
    var value: Double = 0
    var selectedCurrencySource = "USD" {
        didSet {
            updateCurrencyFormatter()
        }
    }
    var selectedCurrencyTarget = "EUR" {
        didSet {
            updateCurrencyFormatter()
        }
    }
    var conversionResponse: CurrencyConversionResponse?
    var errorMessage: String?
    
    init() {
        currencyFormatter = NumberFormatter()
        updateCurrencyFormatter()
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
        default :
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
            print("Données brutes: \(dataString ?? "Acune donnée brute")")
            
        } catch {
            errorMessage = "Erreur lors de la récupération des données."
            print(errorMessage ?? "Pas d'erreurs lors de la récupération des données")
        }
    }
    
}
