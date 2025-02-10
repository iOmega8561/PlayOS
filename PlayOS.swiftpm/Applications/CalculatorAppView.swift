//
//  CalculatorAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

import SwiftUI

struct CalculatorAppView: Application.Content {
    
    final class Model: Application.Model {
        
        @Published fileprivate var display = "0"
        
        private var firstOperand: Double?
        private var currentOperator: String?
        private var waitingForSecondOperand = false
        
        fileprivate func buttonTapped(_ number: String) {
            if waitingForSecondOperand {
                display = number
                waitingForSecondOperand = false
                
            } else { display = (display == "0") ? number : display + number }
        }
        
        fileprivate func operatorTapped(_ op: String) {
            
            guard let value = Double(display) else {
                return
            }
            
            firstOperand = value
            currentOperator = op
            waitingForSecondOperand = true
        }
        
        fileprivate func calculateResult() {
            
            guard let op = currentOperator,
                  let first = firstOperand,
                  let second = Double(display) else { return }
            
            let result: Double = {
                switch op {
                case "+": first + second
                case "-": first - second
                case "*": first * second
                case "/": second != 0 ? first / second : 0
                default: 0
                }
            }()
            
            let remainder = result.truncatingRemainder(dividingBy: 1)
            
            clearState(display: remainder == 0 ? .init(Int(result)) : .init(result))
        }
        
        fileprivate func clearState(display: String = "0") {
            self.display = display
            firstOperand = nil
            currentOperator = nil
            waitingForSecondOperand = false
        }
        
        init() {}
    }
    
    private struct CalculatorButton: View {
        let label: String,
            color: Color,
            action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(label)
                    .font(.system(size: 48))
                    .frame(width: 75)
                    .foregroundColor(.white)
                    .background(color)
                    .contentShape(Circle())
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
    
    @StateObject private var appModel: Model
    
    private let buttons: [[(String, Color)]] = [
        [("7", .gray), ("8", .gray), ("9", .gray), ("/", .orange)],
        [("4", .gray), ("5", .gray), ("6", .gray), ("*", .orange)],
        [("1", .gray), ("2", .gray), ("3", .gray), ("-", .orange)],
        [("0", .gray), ("C", .red), ("=", .blue), ("+", .orange)]
    ]
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text(appModel.display)
                    .font(.system(size: 64))
                    .lineLimit(1)
                    .padding()
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 12) {
                
                ForEach(0..<buttons.count, id: \.self) { row in
                    HStack(spacing: 6) {
                        
                        ForEach(buttons[row], id: \.0) { item in
                            
                            CalculatorButton(label: item.0, color: item.1) {
                                switch item.0 {
                                case "C": appModel.clearState()
                                case "=": appModel.calculateResult()
                                case "+", "-", "*", "/": appModel.operatorTapped(item.0)
                                default: appModel.buttonTapped(item.0)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
    
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
