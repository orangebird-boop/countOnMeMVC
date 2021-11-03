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

    func setCalculusElements(elements: [String]) {
        calculatorBrain.elements = elements
    }

    func displayErrorMessage(errorMessage: String) {
        let alertVC = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
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

        case .failure(let error):
            displayErrorMessage(errorMessage: error.message())
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

    func addOperator(operatorToAdd: String) {
        setCalculusElements(elements: elements)
        if calculatorBrain.canAddOperator {
            textView.text.append(operatorToAdd)
        } else {
            displayErrorMessage(errorMessage: "Un operateur est déja mis ! Appuiez sur AC et recommencez !")
        }
    }
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
       addOperator(operatorToAdd: " + ")
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        addOperator(operatorToAdd: " - ")
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        addOperator(operatorToAdd: " * ")
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        addOperator(operatorToAdd: " ÷ ")
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        setCalculusElements(elements: elements)
        executeCalculus()
    }
}
