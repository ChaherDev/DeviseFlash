import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewViewModel()
    @FocusState private var amountIsFocused: Bool
    let color = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.8)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        Spacer()
                        VStack(spacing: 10) {
                            Text("Choisissez votre devise source")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(color)
                            
                            Picker("Devise Source", selection: $viewModel.selectedCurrencySource) {
                                ForEach(viewModel.currencySource, id: \.self) { devise in
                                    Text(devise)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(color)
                            .cornerRadius(12)
                            
                            TextField("Entrez un montant", value: $viewModel.value, formatter: viewModel.currencyFormatter)
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                                .padding()
                                .foregroundStyle(.black)
                                .background(Color.white)
                                .cornerRadius(12)
                                .multilineTextAlignment(.center)
                                .onSubmit {
                                    Task {
                                        await viewModel.fetchData()
                                        amountIsFocused = false
                                    }
                                }
                        }
                        
                        Text("DeviseFlash\n⚡️\nVoyage au Cœur\ndes Devises !")
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                            .foregroundStyle(color)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        
                        VStack(spacing: 10) {
                            Text("Choisissez votre devise cible")
                                .font(.headline)
                                .foregroundStyle(color)
                                .fontWeight(.bold)
                            
                            Picker("Devise Cible", selection: $viewModel.selectedCurrencyTarget) {
                                ForEach(viewModel.currencyTarget, id: \.self) { devise in
                                    Text(devise)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(color)
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
                    .scrollDismissesKeyboard(.interactively)
                }
            }
            .toolbar {
                if amountIsFocused {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Convertir") {
                            amountIsFocused = false
                            Task {
                                await viewModel.fetchData()
                            }
                        }
                        .foregroundColor(color)
                    }
                }
            }
            .foregroundColor(color) // Appliquer la couleur du titre
        }
    }
}

#Preview {
    HomeView()
}
