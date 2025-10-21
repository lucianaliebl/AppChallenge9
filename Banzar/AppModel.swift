//
//  Untitled.swift
//  Challenge9
//
//  Created by Luciana Liebl de Freitas on 21/10/25.
//

import Foundation
import FoundationModels

//Cardápio que a irá ler e processar
//Dicionário --> Chave String : Valor [Array de String]
let menu: [String: [String]] = [
    //Chave
    "Comidas":[
        "Pastel", //Item 1 do array
        "Coxinha", //item 2 do array
        "Pão de queijo",
        "Enroladinho de salsicha",
        "Bolinha de queijo",
        "Esfirra de carne",
        "Esfirra de frango",
        "Quibe",
        "Bolo de chocolate",
        "Sanduíche natural"
    ],
    //Chave
    "Bebidas":[
        "Refrigerante", //Item 1 do array
        "Suco de laranja", //item 2 do array
        "Suco de uva",
        "Café",
        "Café com leite",
        "Toddynho",
        "Chá"
    ]
]

// O viewModel para gerenciar o estado da IA
@Observable
class AppModel{
    
    var outputText: String = "Pressione o botão para receber uma sugestão de lanche para hoje" //declara uma variavel para armazenar o texto de saída do modelo.
    var isLoading: Bool = false //variável de estado para controlar se a IA está processando. Usada para desabilitar o botão e mostrar um ProgressView.
    
    //O model e a sessão são inicializados ao criar o AppModel
    private let model = SystemLanguageModel.default //inicializa uma constante com o modelo de linguagem on-device padrão da apple. É o motor da IA que será usado
    
    private let session = LanguageModelSession() //Cria uma sessão de comunicação com o modelo de linguagem. Uma Session é o objeto principal que você usa para enviar prompts e receber respostas.
    
    //Funçào assíncrona para chamar o modelo. Função chamada quando o user clica no botão
    func generateSuggestion(){
        //Inicia um bloco de código assíncrono, porque a chamada da IA (session.respond) leva tempo e usa await
        Task{
            //Atualiza o estado na thread principal
            await MainActor.run{//Envia o código para ser executado na thread principal (Main Thread).
                self.isLoading = true
                self.outputText = "Gerando sugestão de lanche..."
            }
            
           
            do{
                //LLM só entende texto, este bloco de código transforma o dicionário em uma única string de texto formatada e organizada para o prompt
                let menuString = menu.map { (key, value) in
                    "\(key): \(value.joined(separator: ", "))"
                }.joined(separator: "\n")
                
                //Define a string (o texto) que será enviada ao modelo de IA (o "prompt").
                let prompt = """
                    
                Aja como um sommerlier de lanches e bebidas para sugerir uma única opção de lanche. Eu forncerei um cardápio para você e você deve sugerir apenas UMA única combinação de UMA comida com UMA bebida que combinam perfeitamente quando o botão for pressionado. Use sua criatividade.
                
                O menu é: 
                \(menuString)
                
                Sua resposta deve ser no seguinte formato em que pule uma linha entre cada frase: 
                "Sugestão de lanche: 
                \n"
                [Nome da comida] + [Nome da bebida]"
                
                E depois dê uma breve explicação do por que essa comida e essa bebida combinam
                """
            
                //respond nessa linha é o método principal da classe LanguageModelSession que você usa para enviar um prompt de texto para o Foundation Model da Apple e obter uma resposta única e completa.
                let response = try await session.respond(to: prompt)
                
                //Atualiza a UI com o resultado na thread principal
                await MainActor.run{
                    //Acessa o texto gerado pela IA. O objeto response contém a saída completa do modelo.
                    self.outputText = response.content  //.content: Esta é uma propriedade (variável) dentro do objeto response. O valor dessa propriedade é o texto puro gerado pelo Large Language Model (LLM). É a string final que você quer exibir para o usuário.
                    self.isLoading = false
                }
            } catch {
                //Bloco de código que é executado apenas se o bloco do falhar (ex: erro de indisponibilidade do modelo)
                await MainActor.run{
                    self.outputText = "Erro ao gerar resposta: \(error.localizedDescription)" //Acessa a descrição do erro de forma amigável ao usuário.
                    self.isLoading = false
                }
            }
        }
    }
}
