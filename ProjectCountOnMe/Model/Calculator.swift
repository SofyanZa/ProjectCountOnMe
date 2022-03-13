//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sofyan on 03/02/2022.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorProtocol: AnyObject {
    func presentAlert(with message : String)
    func presentResult(with calculationString: String)
}

final class Calculator {
    // MARK: Outputs
    
    weak var delegate: CalculatorProtocol?
    
    // MARK: Initialization
    init() {
        self.calculString = ""
    }
    
    // MARK: - Properties
    // Cette variable permet d'afficher dans le textView de la View
    var calculString: String {
        didSet {
            delegate?.presentResult(with: calculString)
            // calculText?(calculString)
        }
    }
    // var elements pour creer les nombres
    private var elements: [String] {
        return calculString.split(separator: " ").map { "\($0)" }
    }
    // Ces variables permettent de verifier le calcul
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
    // var isDivideByZero est false
    var isDivideByZero: Bool {
        return calculString.contains("÷ 0")
    }
    // Permet de commencer avec un nombre
    var isPossibleToStartWithNumber: Bool {
        if calculString >= "0" && calculString <= "9"{
            return elements.count >= 1 } else {
                delegate?.presentAlert(with: "Vous ne pouvez pas commencer par un opérateur")
            }
        return false
    }
    // MARK: - METHODS
    // func addNumbers qui vérifie si l'on peut ajouter un nombre
    func addNumbers(numbers: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numbers)
    }
    // func addOperator qui vérifie si l'on peut ajouter un opérateur
    func addOperator(with mathOperator: String) {
        if isPossibleToStartWithNumber {
            if canAddOperator {
                calculString.append(" \(mathOperator) ")
            } else {
                delegate?.presentAlert(with: "Un opérateur est deja mis")
            }
        }
    }
    
    func addAC() {
        calculString.removeAll()
    }
    
    func addEqual() {
        guard expressionIsCorrect else {
            delegate?.presentAlert(with: "Entrez une expression correct")
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.presentAlert(with: "Démarrez un nouveau calcul")
            return
        }
        guard !isDivideByZero else {
            delegate?.presentAlert(with: "Impossible de diviser par zero")
            calculString = ""
            return
        }
        // Si tout est vérifié on lance la fonction getResult
        getResult()
    }
    
    func getResult() {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            
            guard var left = Double(operationsToReduce[0]) else { return }
            var operand = operationsToReduce[1]
            guard var right = Double(operationsToReduce[2]) else { return }
            let result: Double
            
            var operandIndex = 1
            
            // Priorité des opérations
            if let index = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) {
                operandIndex = index
                if let leftunwrapp = Double(operationsToReduce[index - 1]) { left = leftunwrapp }
                operand = operationsToReduce[index]
                if let rightUnwrapp = Double(operationsToReduce[index + 1]) { right = rightUnwrapp }
            }
            result = calculate(left: Double(left), right: Double(right), operand: operand)
            
            for _ in 1...3 {
                operationsToReduce.remove(at: operandIndex - 1)
            }
            operationsToReduce.insert(formatResult(result: Double(result)), at: operandIndex - 1 )
        }
        guard let finalResult = operationsToReduce.first else { return }
        calculString.append(" = \(finalResult)")
    }
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
    private func formatResult(result: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 3
    guard let resultFormated = formatter.string(from: NSNumber(value: result)) else { return String() }
    // Sinon on met la puissance pour des grands nombres aux petits nombres
    guard resultFormated.count <= 10 else {
        return String(result)}
    return resultFormated
}
