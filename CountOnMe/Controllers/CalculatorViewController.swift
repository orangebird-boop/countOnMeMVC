//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    private var calculatorBrain = CalculatorBrain()
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables

    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }

    var canAddOperator: Bool {
       return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "x"
    }

    func setCalculusElements(elements: [String]) {
        calculatorBrain.elements = elements
    }

    func calculusFailed(errorMessage: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte ! Appuiez sur AC et recommencez !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    func calculusHasCompleted(result: String) {
        textView.text.append(" = \(result)")
    }

    func executeCalculus() {
        let calculusResult = calculatorBrain.executeCalculus()

        switch calculusResult {
        case .success(let result):
            calculusHasCompleted(result: result)

        case .failure(let errorMessage):
            print("\(errorMessage)")
            switch errorMessage {
            case .invalidExpression:
                calculusFailed(errorMessage: "invalide expression")
            case .notEnoughElementInExpression:
                calculusFailed(errorMessage: "not enough elements")
            case.divideByZero:
                calculusFailed(errorMessage: "you can't divide by zero")
            }
        }
    }

    // clear all elements form variable elements in CalculatorBrain
    func clearAll() {
        calculatorBrain.elements.removeAll()
    }

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // View actions
    @IBAction func clearAllButton(_ sender: UIButton) {
        clearAll()
        textView.text.removeAll()
        textView.text.append("")
    }
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if expressionHaveResult {
            textView.text = ""
        }
        textView.text.append(numberText)
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append("+")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis ! Appuiez sur AC et recommencez !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append("-")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis ! Appuiez sur AC et recommencez !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append("*")

        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis ! Appuiez sur AC et recommencez !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append("÷")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis ! Appuie sur AC et recommence !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        setCalculusElements(elements: elements)
        executeCalculus()
    }
}
