//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sofyan on 03/02/2022.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation


final class Calculator {
    
    
    // MARK:  Outputs
    
    var alertMessage: ((String) -> Void)?
    
    var calculText: ((String) -> Void)?
    
    // MARK: - Initialization
    
    init() {
        self.calculString = ""
    }

    // MARK: - Properties
    
    
    //Cette variable permet d'afficher dans le textView de la View
    var calculString: String {
        didSet {
            calculText?(calculString)
        }
    }
    
    //var elements pour creer les nombres
    private var elements: [String] {
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    //Les lignes (43, 47, 51 et 55) permettent de vérifier le calcul
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
    }
    
    //var isDivideByZero est false
    var isDivideByZero: Bool {
        return calculString.contains("÷ 0")

    }
    
    //Pour commencer avec le nombre
    var isPossibleToStartWithNumber : Bool {
        if calculString >= "0" && calculString <= "9"{
            return elements.count >= 1 }
        else {
            alertMessage?("Vous ne pouvez pas commencez par un opérateur !")
        }
        return false
    }
    
    
    
    //MARK:- METHODS
    
    
    //func addNumbers qui vérifie si l'on peut ajouter un nombre
    func addNumbers(numbers: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numbers)
    }
    
    //func addOperator qui vérifie si l'on peut ajouter un opérateur
    func addOperator(with mathOperator: String) {
        if isPossibleToStartWithNumber {
            if canAddOperator {
                 calculString.append(" \(mathOperator) ")
             } else {
                 alertMessage?("Un operateur est déja mis !")
             }
        }
    }
    
    //func addAC permet de remettre à 0
    func addAC() {
        calculString.removeAll()
        calculText?("0")
    }
    
    
    //func addEqual qui effectue le calcul final avec l'expression, si tous les conditions sont remplies
    func addEqual() {
        
        guard expressionIsCorrect else {
            alertMessage?("Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            alertMessage?("Démarrez un nouveau calcul !")
            return
        }
        
        guard !isDivideByZero else {
            alertMessage?("Impossible de diviser par 0 !")
            calculString = ""
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        while operationsToReduce.count > 1 {
            
            guard var left = Double(operationsToReduce[0]) else { return }
           var operand = operationsToReduce[1]
            guard var right = Double(operationsToReduce[2]) else { return }
            
            let result: Double
                
                // Start at one or we can't assign index to (index - 1)
                var operandIndex = 1
                
                //Rechercher s'il y a plusieurs signes de division puis attribuer un index
                if let index = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) {
                    
                    operandIndex = index
                    if let leftunwrapp = Double(operationsToReduce[index - 1]) { left = leftunwrapp }
                    operand = operationsToReduce[index]
                    if let rightUnwrapp = Double(operationsToReduce[index + 1]) { right = rightUnwrapp }
                }
                
                result = calculate(left: Double(left), right: Double(right), operand: operand)
                
            
                //Boucle à l'intérieur de l'index pour supprimer l'opérateur supplémentaire
                for _ in 1...3 {
                    
                    operationsToReduce.remove(at: operandIndex - 1)
                    print("Nous avons supprimé :\(operationsToReduce)")
                }
            
                operationsToReduce.insert(formatResult(result: Double(result)), at: operandIndex - 1 )
                print("Votre resultat :\(result)")
                print("Le resultat formater :\(operationsToReduce)")
                
            }
            guard let finalResult = operationsToReduce.first else { return }
            calculString.append(" = \(finalResult)")
    }
    
    

    
    
       func calculate(left: Double, right: Double, operand: String) -> Double {
           
           let result: Double
           switch operand {
           case "+": result = left + right
           case "-": result = left - right
           case "÷": result = left / right
           case "x": result = left * right
           default: return 0.0
           }
           return result
       }
    
    //func formatResult permet de gérer les nombres décimaux
     private func formatResult(result: Double) -> String {
          let formatter = NumberFormatter()
          formatter.maximumFractionDigits = 3
          guard let resultFormated = formatter.string(from: NSNumber(value: result)) else { return String() }
          
        //Sinon on met la puissance pour des grands nombres aux petits nombres
          guard resultFormated.count <= 10 else {
              return String(result)
          }
          return resultFormated
      }
    
}




