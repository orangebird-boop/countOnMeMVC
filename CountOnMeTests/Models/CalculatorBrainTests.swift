//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    let calculatorBrain = CalculatorBrain()

    func testSimpleAddition() {
        calculatorBrain.elements = ["1", "+", "1"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(let sum):
            XCTAssertEqual(sum, "2.0")
        case .failure(_):
            XCTFail("should return 2.0")
        }
    }

    func testSimpleSubstraction() {
        calculatorBrain.elements = ["2", "-", "1"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(let sum):
            XCTAssertEqual(sum, "1.0")
        case .failure(_):
            XCTFail("should return 1.0")
        }
    }

    func testSimpleMultiplication() {
        calculatorBrain.elements = ["2", "*", "2"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(let sum):
            XCTAssertEqual(sum, "4.0")
        case .failure(_):
            XCTFail("This calcul shouldn't fail")
        }
    }

    func testSimpleDivision() {
        calculatorBrain.elements = ["6", "÷", "2"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(let sum):
            XCTAssertEqual(sum, "3.0")
        case .failure(_):
            XCTFail("This calcul shouldn't fail")
        }
    }

    func testCalculationWithPriorities() {
        calculatorBrain.elements = ["8", "-", "6", "÷", "2", "+", "4", "*", "2"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(let sum):
            XCTAssertEqual(sum, "13.0")
        case .failure(_):
            XCTFail("This calcul shouldn't fail")
        }
    }

    func testShouldReturnInvalideExpressionWhenAdditionOrSubstraction() {
        calculatorBrain.elements = ["8", "+"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .invalidExpression)
        }
    }

    func testShouldReturnInvalideExpressionWhenMultiplicationOrAddition() {
        calculatorBrain.elements = ["8", "*"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .invalidExpression)
        }
    }

    func testShouldReturnInvalideExpressionWhenMultiplicationOrAdditionInCaseOfUnknownLeftOperand() {
        calculatorBrain.elements = ["a", "*", "2"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .invalidExpression)
        }
    }

    func testShouldReturnInvalideExpressionWhenMultiplicationOrAdditionInCaseOfUnknownRightOperand() {
        calculatorBrain.elements = ["3", "*", "a"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .invalidExpression)
        }
    }

    func testShouldReturnNotEnoughElements() {
        calculatorBrain.elements = ["8"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .notEnoughElementInExpression)
        }
    }

    func testShouldDivideByZero() {
        calculatorBrain.elements = ["8", "÷", "0"]
        let result = calculatorBrain.executeCalculus()
        switch result {
        case .success(_):
            XCTFail("should return 13.5")
        case .failure(let error):
            XCTAssertEqual(error, .divideByZero)
        }
    }
}
