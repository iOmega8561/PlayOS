//
//  DesktopLink.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 13/02/25.
//
    
@dynamicMemberLookup
enum DesktopLink: CaseIterable, Hashable {
    
    struct MetaData {
        let application: Application
        let displayName: String
        let sfSymbol: String
        let initialState: any Application.Model
    }
    
    case learnCoding
    case learnComputers
    
    private var metaData: MetaData {
        switch self {
        case .learnCoding: .init(
            application: .explore,
            displayName: .init(localized: "desktoplink-learncoding"),
            sfSymbol: "chevron.left.slash.chevron.right",
            initialState: ExploreAppView.Model(
                currentApp: .codingChallenge
            ))
        case .learnComputers: .init(
            application: .explore,
            displayName: .init(localized: "desktoplink-learncomputers"),
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
