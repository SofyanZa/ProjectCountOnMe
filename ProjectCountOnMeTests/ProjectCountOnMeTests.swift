//
//  ProjectCountOnMeTests.swift
//
//  Created by SofyanZ on 06/03/2022.

import XCTest

@testable import ProjectCountOnMe

class CalculatorTest: XCTestCase {

    var calculator: Calculator!

    // Methode setUp permet de faire une initialisation
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    func testGivenCanAddOperator_WhenCanAddOperator_ThenReturnTrue() {
        calculator.calculString = " 2 + 2 + 3 "
        XCTAssertTrue(calculator.canAddOperator)
    }
    func testGivenExpressionHaveResult_WhenExpressionHaveResult_ThenReturnTrue() {
          calculator.calculString = " = 30 "
          XCTAssertTrue(calculator.canAddOperator)
    }
    func testGivenAddNumber_WhenAddNumber_ThenReturnNumber() {
          calculator.addNumbers(numbers: "3")
          XCTAssertTrue(calculator.calculString == "3")
    }
    func testGivenExpressionIsCorrect_WhenStringGreaterThanOrEqualTo3_ThenReturnTrue() {
        calculator.addNumbers(numbers: "2")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()
        XCTAssertEqual(calculator.calculString, "2 + 2 = 4")

    }
    func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
        calculator.addNumbers(numbers: "5")
        calculator.addEqual()
        XCTAssertEqual(calculator.calculString, "5")
    }
    func testGivenPresentationCalcul_WhenTryMultiplicationOrAddition_ThenShowAlert() {
        calculator.addAC()
        calculator.addOperator(with: "x")
        calculator.addOperator(with: "+")
        // Error: Vous ne pouvez pas commencez par un opérateur !
        XCTAssertEqual(calculator.calculString, "")
    }
    func testGivenNumberOne_WhenTryDivideByZero_ThenInitialiseNil() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "0")
        calculator.addEqual()
        // Error: Impossible de diviser par 0
        XCTAssertEqual(calculator.calculString, "")
    }
    func testGivenNumberOne_WhenDoFormat_ThenGiveResult() {
        calculator.addNumbers(numbers: "10")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "3")
        calculator.addEqual()
        XCTAssertEqual(calculator.calculString, "10 ÷ 3 = 3.333")
    }
    func testGivenNumberOne_WhenApplyTenZero_ThenResultCorect() {
        calculator.addNumbers(numbers: "10000000000")
        calculator.addOperator(with: "x")
        calculator.addNumbers(numbers: "10000000000")
        calculator.addEqual()

        XCTAssertEqual(calculator.calculString, "10000000000 x 10000000000 = 1e+20")
    }
}
