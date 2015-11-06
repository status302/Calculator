//
//  CalculateBrain.swift
//  Calculator
//
//  Created by 程庆春 on 15/11/1.
//  Copyright © 2015年 Qiuncheng. All rights reserved.
//

import Foundation

class CalculateBrain {
    
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        
        var description: String{
            switch self{
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        
        knownOps["+"] = Op.BinaryOperation("+", {$0 + $1})
        knownOps["−"] = Op.BinaryOperation("−", {$0 - $1})
        knownOps["×"] = Op.BinaryOperation("×", {$0 * $1})
        knownOps["÷"] = Op.BinaryOperation("÷", {$0 / $1})
        knownOps["√"] = Op.UnaryOperation("√",{sqrt($0)})

    }
    
    
    typealias PropertryList = AnyObject
    
    var program: PropertryList{ // guaranteed to be a propertryList
        get {
//            var returnValue = Array<String>()
//            for op in opStack {
//                returnValue.append(op.description)
//            }
//            return returnValue
            
            return opStack.map({ $0.description }) // 也可以用这句话来代替上面那些
        }
        set {
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op])->(result: Double?, remainingOps: [Op]){
    
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluate = evaluate(remainingOps)
                if let operand = operandEvaluate.result{
                    return (operation(operand), operandEvaluate.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluate = evaluate(remainingOps)
                if let operand1 = op1Evaluate.result{
                    let op2Evaluate = evaluate(op1Evaluate.remainingOps)
                    if let operand2 = op2Evaluate.result{
                        return (operation(operand1, operand2), op2Evaluate.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate()->Double?{
        let (result, remainer) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainer) left over")
        return result
    }
    
    func pushOperand(operand: Double)->Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String)->Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
