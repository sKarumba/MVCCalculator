//
//  CalculatorModel.swift
//  MVCCalculator
//
//  Created by Karumba Samuel on 30/01/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class CalculatorModel {
    private var accumulator = 0.0
    
    
    
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constants(M_PI),
        "√" : Operation.UnaryOperations(sqrt),
        "×" : Operation.BinaryOperation( { $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constants(Double)
        case UnaryOperations((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOp{
        var binaryFunc: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOp?
    

    
    func getOperands(operand: Double) {
        accumulator = operand
    }

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constants(let value):
                accumulator = value
            case .UnaryOperations(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executeOp()
                pending = PendingBinaryOp(binaryFunc: function, firstOperand: accumulator)
            case .Equals:
                executeOp()

            }
        }
        
    }
    
    func executeOp(){
        if pending != nil {
            accumulator = pending!.binaryFunc(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    var result: Double {
        get{
            return accumulator
        }
    }
}
