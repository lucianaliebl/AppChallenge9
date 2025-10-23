//  AppModel.swift
//  Challenge09_Group8

import Foundation
import FoundationModels

//Cardápio que a irá ler e processar
//Dicionário --> Chave String : Valor [Array de String]
let menu: [String: [String]] = [
    //Chave
    "Comidas":[
        "Pastel", //Item 1 do array
        "Pão de queijo",
        "Enroladinho de salsicha",
        "Bolinha de queijo",
        "Esfirra de carne",
        "Esfirra de frango",
        "Quibe",
        "Bolo de chocolate",
        "Sanduíche natural",
        "Batata Frita",
        "Batata Rústica",
        "Batata Especial Completa",
        "Burguer Banzos Chicken",
        "Burguer Banzos Cheese",
        "Burguer Banzos Bacon",
        "Burguer Banzos Cheese Egg",
        "Burguer Banzos Bruto",
        "Burguer Banzos Double",
        "Burguer X-Salada",
        "Burguer X-Bacon",
        "Burguer X-Egg",
        "Burguer X-Tudo",
        "Hot Dog na Chapa",
        "Hot Dog na Chapa de Frango",
        "Nuggets Crocantes",
        "Strogonoff de Frango",
        "Macarrão",
        "Omelete Simples",
        "Omelete Frango",
        "Omelete Presunto",
        "Tapioca com Margarina",
        "Tapioca com Mussarela",
        "Tapioca com Ovos",
        "Tapioca c/ Mussarela e Ovo",
        "Tapioca c/ Mussarela e Presunto",
        "Tapioca c/ Mussarela e Frango Desfiado",
        "Pão de Sal na Chapa com Ovo",
        "Pão de Sal na Chapa com Queijo Mussarela",
        "Pão de Sal na Chapa com Queijo, Mussarela e Presunto",
        "Pão de Sal na Chapa com Queijo Mussarela, Presunto e Ovo",
        "Pão de Sal na Chapa com Queijo Mussarela, Tomate e Orégano",
        "Pão de Sal na Chapa com Ovo, Calabresa, Queijo Mussarela e Presunto",
        "Crepe",
        "Coxinha de frango com catupiry",
        "Coxinha de frango com cheddar",
        "Coxinha de frango com bacon",
        "Croissant de chocolate",
        "Salgado de presunto e queijo",
        "Pão pizza",
        "Barrinha de Cereal",
        "Bolo no Pote"
    ],
    
    //Chave
    "Bebidas":[
        "Refrigerante",
        "Suco de laranja",
        "Suco de uva",
        "Café",
        "Café com leite",
        "Achocolatado",
        "Chá",
        "Energético",
        "Suco de pêssego"
    ]
]

// O viewModel para gerenciar o estado da IA
@Observable
class AppModel{
    
    var outputText: String = "Pressione o botão para receber uma sugestão de lanche para a hora de Banzar!" //declara uma variavel para armazenar o texto de saída do modelo.
    var isLoading: Bool = false //variável de estado para controlar se a IA está processando. Usada para desabilitar o botão e mostrar um ProgressView.
    
    //O model e a sessão são inicializados ao criar o AppModel
    private let model = SystemLanguageModel.default //inicializa uma constante com o modelo de linguagem on-device padrão da apple. É o motor da IA que será usado
    
    private let session = LanguageModelSession() //Cria uma sessão de comunicação com o modelo de linguagem. Uma Session é o objeto principal que você usa para enviar prompts e receber respostas.
    
    //Função assíncrona para chamar o modelo. Função chamada quando o user clica no botão
    func generateSuggestion(){
        //Inicia um bloco de código assíncrono, porque a chamada da IA (session.respond) leva tempo e usa await
        Task{
            //Atualiza o estado na thread principal
            await MainActor.run{ //Envia o código para ser executado na thread principal (Main Thread).
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
