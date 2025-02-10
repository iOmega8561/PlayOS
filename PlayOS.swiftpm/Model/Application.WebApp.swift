//
//  Application.WebApp.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 10/02/25.
//

extension Application {
    
    enum WebApp: String, CaseIterable {
        
        case homePage = "ExploreHome"
        case snakeGame = "SnakeGame"
        case ticTacToe = "TicTacToe"
        case codingChallenge = "CodingChallenge"
        
        var displayName: String {
            switch self {
            case .homePage: "Homepage"
            case .snakeGame: "Snake"
            case .ticTacToe: "Tic Tac Toe"
            case .codingChallenge: "Learn Coding"
            }
        }
    }
}
