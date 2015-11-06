//
//  ViewController.swift
//  Calculator
//
//  Created by 程庆春 on 15/10/25.
//  Copyright © 2015年 Qiuncheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTyingANumber:Bool = false
    
    var brain = CalculateBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyingANumber = true
        }
        
    }
    
    @IBAction func ooperate(sender: UIButton) {
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        if userIsInTheMiddleOfTyingANumber{
            enterButtonClicked()
        }
        
       
    }
    
    
    var operandStack = [Double]()
    
    @IBAction func enterButtonClicked() {
        userIsInTheMiddleOfTyingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
//        print(operandStack)
    }
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyingANumber = false
        }
    }

    @IBAction func clearDisplay(sender: UIButton) {
        display.text = "0"
    }
    func clear(_display:UILabel){
        if _display.text == "0" {
            _display.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

