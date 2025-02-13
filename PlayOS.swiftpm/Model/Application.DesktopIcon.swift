//
//  Application.DesktopIcon.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 13/02/25.
//

extension Application {
    
    @dynamicMemberLookup
    enum DesktopIcon: CaseIterable, Hashable {
        
        struct MetaData {
            let application: Application
            let title: String
            let sfSymbol: String
            let initialState: any Model
        }
        
        case learnCoding
        case learnComputers
        
        private var metaData: MetaData {
            switch self {
            case .learnCoding: .init(
                application: .explore,
                title: .init(localized: "app-icon-learncoding"),
                sfSymbol: "chevron.left.slash.chevron.right",
                initialState: ExploreAppView.Model(
                    currentApp: .codingChallenge
            ))
            case .learnComputers: .init(
                application: .explore,
                title: .init(localized: "app-icon-learncomputers"),
                sfSymbol: "laptopcomputer.and.ipad",
                initialState: ExploreAppView.Model(
                    currentApp: .computerQuiz
            ))
            }
        }
        
        subscript<T>(dynamicMember keyPath: KeyPath<MetaData, T>) -> T {
            self.metaData[keyPath: keyPath]
        }
    }
}
