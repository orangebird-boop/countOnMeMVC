//
//  CalculatorBrain.swift
//  CountOnMe
//
//  Created by Nora Lilla Matyassi on 21/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorBrain {

    enum CalculatorBrainError: Error, Equatable {
        case invalidExpression
        case divideByZero
        case notEnoughElementInExpression
    }

    var elements: [String?] = []

    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "*"
    }

    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var expressionNotDividedByZero: Bool {
        for element in elements where element == "÷" {
            if elements[elements.index(after: 1)] == "0" {
                return false
            }
        }
        return true
    }

    // multiplication and division are prioritary in the calculation, they need to be executed before addition ad substraction.
    func processPriorities() -> Result<[String], CalculatorBrainError> {
        var processing: [String] = []
        var index = 0

        while index < elements.count {
            let element = elements[index]
            if element == "*" || element == "÷" {

                guard let lastProcessedElement = processing.popLast(), let leftOperand = Float(lastProcessedElement) else {
                    return .failure(.invalidExpression)
                }

                guard let rightElement = elements[index+1], let rightOperand = Float(rightElement) else {
                    return .failure(.invalidExpression)
                }
                // it is not possible to divide by zero
                guard element != "÷" || (element == "÷" && rightOperand != 0) else {
                    return .failure(.divideByZero)
                }

                switch element {
                case "*": processing.append(String(leftOperand * rightOperand))
                case "÷": processing.append(String(leftOperand / rightOperand))
                default: fatalError("Unknown operator !")
                }
                index += 1
            } else {
                processing.append(element!)
            }
            index += 1
        }

        return .success(processing)
    }

    func executeCalculus()-> Result<String, CalculatorBrainError> {

        guard expressionIsCorrect else {
            return .failure(.invalidExpression)

        }

        guard expressionNotDividedByZero else {
            return .failure(.divideByZero)
        }

        guard expressionHaveEnoughElement else {
            return .failure(.notEnoughElementInExpression)

        }

        // Create local copy of operations
        // the process priorities functions returns an array to reduce

        var operations = [String]()
        switch processPriorities() {
        case .success(let operationResult):
            operations = operationResult
        case .failure(let error):
            return .failure(error)
        }
        while operations.count > 1 {
            let left = Float(operations[0])!
            let operand = operations[1]
            let right = Float(operations[2])!

            let result: Float
            switch operand {
            case "+": result = left + right
            case "-": result = left - right

            default: fatalError("Unknown operator !")
            }

            operations = Array(operations.dropFirst(3))
            operations.insert("\(result)", at: 0)
        }
        return .success(operations.first!)

    }
}
