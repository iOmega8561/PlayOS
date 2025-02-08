//
//  CalculatorAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct CalculatorAppView: View {
    
    private struct CalculatorButton: View {
        let label: String
        let backgroundColor: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(label)
                    .font(.system(size: 48))
                    .frame(width: 100)
                    .foregroundColor(.white)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
        }
    }
    
    @State private var display = "0"
    @State private var firstOperand: Double? = nil
    @State private var currentOperator: String? = nil
    @State private var waitingForSecondOperand = false

    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 64))
                    .lineLimit(1)
                    .padding()
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 12) {

                HStack(spacing: 12) {
                    CalculatorButton(label: "7", backgroundColor: .gray) { buttonTapped("7") }
                    CalculatorButton(label: "8", backgroundColor: .gray) { buttonTapped("8") }
                    CalculatorButton(label: "9", backgroundColor: .gray) { buttonTapped("9") }
                    CalculatorButton(label: "/", backgroundColor: .orange) { operatorTapped("/") }
                }

                HStack(spacing: 12) {
                    CalculatorButton(label: "4", backgroundColor: .gray) { buttonTapped("4") }
                    CalculatorButton(label: "5", backgroundColor: .gray) { buttonTapped("5") }
                    CalculatorButton(label: "6", backgroundColor: .gray) { buttonTapped("6") }
                    CalculatorButton(label: "*", backgroundColor: .orange) { operatorTapped("*") }
                }

                HStack(spacing: 12) {
                    CalculatorButton(label: "1", backgroundColor: .gray) { buttonTapped("1") }
                    CalculatorButton(label: "2", backgroundColor: .gray) { buttonTapped("2") }
                    CalculatorButton(label: "3", backgroundColor: .gray) { buttonTapped("3") }
                    CalculatorButton(label: "-", backgroundColor: .orange) { operatorTapped("-") }
                }

                HStack(spacing: 12) {
                    CalculatorButton(label: "0", backgroundColor: .gray) { buttonTapped("0") }
                    CalculatorButton(label: "C", backgroundColor: .red) { clear() }
                    CalculatorButton(label: "=", backgroundColor: .blue) { calculateResult() }
                    CalculatorButton(label: "+", backgroundColor: .orange) { operatorTapped("+") }
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
    
    private func buttonTapped(_ number: String) {
        if waitingForSecondOperand {
            display = number
            waitingForSecondOperand = false
        } else {

            if display == "0" {
                display = number
                
            } else { display += number }
        }
    }
    
    private func operatorTapped(_ op: String) {
        if let value = Double(display) {
            firstOperand = value
            currentOperator = op
            waitingForSecondOperand = true
        }
    }
    
    private func calculateResult() {
        guard let op = currentOperator,
              let first = firstOperand,
              let second = Double(display) else { return }
        
        let result: Double
        
        switch op {
        case "+": result = first + second
        case "-": result = first - second
        case "*": result = first * second
        case "/": result = second != 0 ? first / second : 0
        default: return
        }
        
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            display = String(Int(result))
            
        } else { display = String(result) }
        
        currentOperator = nil
        firstOperand = nil
        waitingForSecondOperand = false
    }
    
    private func clear() {
        display = "0"
        firstOperand = nil
        currentOperator = nil
        waitingForSecondOperand = false
    }
}
