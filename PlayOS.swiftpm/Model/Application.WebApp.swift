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
        case computerQuiz = "ComputerQuiz"
        
        var displayName: String {
            switch self {
            case .homePage: .init(localized: "app-webapp-homepage")
            case .snakeGame: .init(localized: "app-webapp-snakegame")
            case .ticTacToe: .init(localized: "app-webapp-tictactoe")
            case .codingChallenge: .init(localized: "app-webapp-learncoding")
            case .computerQuiz: .init(localized: "app-webapp-computerquiz")
            }
        }
    }
}
