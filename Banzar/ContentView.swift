//
//  ContentView.swift
//  Challenge09_Group8
//
//  Created by Luciana Liebl de Freitas on 20/10/25.
//

import SwiftUI
import UserNotifications

//Conectando o ViewModel à interface do usuário
struct ContentView: View {
   
    @State private var notificationManager = NotificationManager()
    @State private var appModel = AppModel()
    
    var body: some View{
        VStack(spacing: 20){
            Text("Sugestões de lanches Banzos")
                
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            //Exibe o resultado do modelo
            TextEditor(text: .constant(appModel.outputText))
                .frame(height: 200)
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 2)
                .border(Color.secondary.opacity(0.5), width: 1)
                .padding()
            
            //Botão que chama a função de IA
            Button {
                appModel.generateSuggestion()
            } label: {
                Text(appModel.isLoading ? "Gerando sugestão..." : "Gerar sugestão de lanche")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 250)
            .padding()
            .background(appModel.isLoading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .buttonStyle(.borderedProminent)
            .disabled(appModel.isLoading) //Desabilita o botão (o usuário não pode clicar) se appModel.isLoading for true. Isso evita cliques múltiplos enquanto a IA está processando.
            
            if appModel.isLoading{
                ProgressView()//Elemento de UI. Exibe o indicador de carregamento (a roda giratória).
            }
        }.task {
            do {
                let request = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                if request {
                    print("Permissão aprovada")
                } else {
                    print("Permissão Negada")
                }
            } catch {
                print("Falha ao pedir solicitação \(error.localizedDescription)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
