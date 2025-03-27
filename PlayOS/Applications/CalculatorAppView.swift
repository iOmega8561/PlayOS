//
//  CalculatorAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct CalculatorAppView: View {
    
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
                
                Text(verbatim: appModel.display)
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
}

// MARK: - Supporting nested types

extension CalculatorAppView {
    
    /// The model that encapsulates the calculator’s state and business logic.
    ///
    /// This class is responsible for handling user inputs, performing calculations,
    /// and updating the display value. It conforms to the `ObservableObject` protocol
    /// so that SwiftUI views can react to its published changes.
    final class Model: ObservableObject {
        
        /// The current text to be shown on the calculator display.
        @Published fileprivate var display = "0"
        
        /// The first operand in the pending calculation.
        private var firstOperand: Double?
        
        /// The operator for the pending calculation (e.g., "+", "-", "*", "/").
        private var currentOperator: String?
        
        /// A flag indicating whether the model is awaiting a second operand input.
        private var waitingForSecondOperand = false
        
        // MARK: - Input Handling
        
        /// Handles a number button tap.
        ///
        /// When a number is tapped, this method updates the display. If the calculator is waiting
        /// for the second operand, the display is reset with the tapped number. Otherwise, the tapped
        /// number is appended to the existing display (unless the display is "0", in which case it is replaced).
        ///
        /// - Parameter number: The string representation of the tapped number.
        fileprivate func buttonTapped(_ number: String) {
            if waitingForSecondOperand {
                display = number
                waitingForSecondOperand = false
            } else {
                display = (display == "0") ? number : display + number
            }
        }
        
        /// Handles an operator button tap.
        ///
        /// This method captures the current display value as the first operand and stores the operator.
        /// It then sets a flag to indicate that the calculator should wait for the next number input.
        ///
        /// - Parameter op: A string representing the operator (e.g., "+", "-", "*", "/").
        fileprivate func operatorTapped(_ op: String) {
            guard let value = Double(display) else {
                return
            }
            
            firstOperand = value
            currentOperator = op
            waitingForSecondOperand = true
        }
        
        /// Calculates the result of the pending operation.
        ///
        /// This method performs the calculation using the stored first operand, the operator,
        /// and the current display value as the second operand. If the operation results in a whole number,
        /// the result is displayed without a fractional component. Otherwise, the full result is shown.
        /// After the calculation, the internal state is cleared.
        fileprivate func calculateResult() {
            guard let op = currentOperator,
                  let first = firstOperand,
                  let second = Double(display) else { return }
            
            let result: Double = {
                switch op {
                case "+": return first + second
                case "-": return first - second
                case "*": return first * second
                case "/": return second != 0 ? first / second : 0
                default: return 0
                }
            }()
            
            let remainder = result.truncatingRemainder(dividingBy: 1)
            clearState(display: remainder == 0 ? .init(Int(result)) : .init(result))
        }
        
        /// Clears the calculator's current state.
        ///
        /// This resets the display to the provided value (defaulting to "0") and clears any
        /// stored operands and operators.
        ///
        /// - Parameter display: The new display value. Defaults to `"0"`.
        fileprivate func clearState(display: String = "0") {
            self.display = display
            firstOperand = nil
            currentOperator = nil
            waitingForSecondOperand = false
        }
    }
    
    /// A view representing an individual calculator button.
    ///
    /// This view renders a circular button with a label, a background color,
    /// and an action that is executed when the button is tapped.
    private struct CalculatorButton: View {
        /// The text label displayed on the button.
        let label: String
        /// The background color of the button.
        let color: Color
        /// The action executed when the button is tapped.
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(verbatim: label)
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
}

// MARK: - Application Protocol Conformances

/// Conformance of `CalculatorAppView.Model` to the `Application.Model` protocol.
extension CalculatorAppView.Model: Application.Model { }

/// Conformance of `CalculatorAppView` to the `Application.Content` protocol.
extension CalculatorAppView: Application.Content {
    
    /// Initializes the calculator view with the provided model.
    ///
    /// - Parameter appModel: An instance of the calculator’s model containing the app's logic.
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
