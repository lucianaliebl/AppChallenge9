//  ContentView.swift
//  Challenge09_Group8

import SwiftUI
import UserNotifications

// Arco Vermelho
struct RedArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Começa no canto inferior esquerdo
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Linha até o canto superior esquerdo (onde a curva começa)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        // Adiciona a curva convexa (para cima) no topo
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.minY - 70)
        )
        
        // Linha do canto superior direito para o inferior direito
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Fecha o caminho (linha inferior)
        path.closeSubpath()
        
        return path
    }
}


//Conectando o ViewModel à interface do usuário
struct ContentView: View {
    @State private var appModel = AppModel()
    
    var body: some View {
        ZStack(alignment: .top) { // Alinha todo o conteúdo ao topo
            
           
            Color.white.edgesIgnoringSafeArea(.all)
            
            
            // VStack para empurrar o arco vermelho para baixo
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 250) // altura da área branca no topo
                
                RedArchShape()
                    .fill(Color.colorRed)
                    .edgesIgnoringSafeArea(.bottom) // Preenche o resto da tela para baixo
            }
            
            VStack(spacing: 20) {
                
                Text("Banzooouuu!")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.colorRed)
                    .padding(.top, 75)

                Text("Pergunte para Siri se é hora de Banzar!")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 2)

               
                Text("Sugestão de Lanche")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .padding(.top, 90)

                ScrollView {
                    Text((appModel.outputText))
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 280)
                }
                .frame(width: 350, height: 380)
                .background(Color(red: 239/255, green: 208/255, blue: 208/255))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                .scrollIndicators(.hidden)
                

                Spacer()

               
                Button {
                    appModel.generateSuggestion()
                } label: {
                    Text(appModel.isLoading ? "Gerando..." : "Gerar Sugestão de Lanche")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                }
                .frame(maxWidth: 310)
                .background(appModel.isLoading ? Color.gray : Color.yellow)
                .foregroundColor(Color.black.opacity(0.8))
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                .buttonStyle(.plain)
                .disabled(appModel.isLoading)
                .padding(.bottom, 40)
                
                if appModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .scaleEffect(1.5)
                }
            }
            
            // Lógica de notificação
            .task {
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
        }
    }
}


#Preview {
    ContentView()
}
