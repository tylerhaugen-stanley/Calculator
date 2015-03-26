//
//  ViewController.swift
//  Calculator
//
//  Created by Tyler Haugen-Stanley on 2015-03-15.
//  Copyright (c) 2015 Tyler Haugen-Stanley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var opHistory: UILabel!
    
    
    // In swift all properties have to be initialized when the object is initialized.
//    var userIsInTheMiddleOfTypingANumber: Bool = false
    // If the type can be inferred, it is considered bad form to put it in.
    var userIsInTheMiddleOfTypingANumber = false
    var decimalPointTyped = false

    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        opHistory.numberOfLines = 4
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        // Let represents constants in swift
        // There is a variable type in swift called optional represented by a '?'. There are two options for this variable.
            // 'Not Set' - nil is the value
            // 'Something'
        var digit = sender.currentTitle!
        

        if !(digit == "." && decimalPointTyped){
            if digit == "." {
                decimalPointTyped = true
            }
            
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }

    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointTyped = false
        // Tell the brain to clear everything.
        brain.clearBrain()
        // Reset display value
        displayValue = 0
        updateHistory(-1)
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointTyped = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            updateHistory(result)
        } else {
            displayValue = 0
        }
    }
    
    func updateHistory(operationOrOperand: Double) {
        // opHistory.text will always contain a value, no need to check 
        // optional.
//        opHistory.text = opHistory.text! + "\n" + "\(operationOrOperand)"
        if operationOrOperand == -1 {
            opHistory.text = nil
        } else {
//            opHistory.text = "\(operationOrOperand)"
            opHistory.text = opHistory.text! + "\n" + "\(operationOrOperand)"
        }
    }
    
    var displayValue: Double{
        get{
            // Compute the double value of the display text.
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

