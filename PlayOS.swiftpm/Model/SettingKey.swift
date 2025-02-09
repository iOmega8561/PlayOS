//
//  SettingKey.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 08/02/25.
//

struct SettingKey<ValueType: Hashable>: Hashable {

    private let namespace: String?
    private let defaultValue: ValueType
    
    var value: ValueType
    let possibleValues: [ValueType]
    
    var description: String {
        description(for: value)
    }
    
    func description(for value: ValueType) -> String {
        if let namespace {
            return "\(namespace)/\(value)"
            
        } else { return "\(value)" }
    }
    
    init(namespace: String? = nil, default value: ValueType, possibleValues: [ValueType]) {
        self.namespace = namespace
        self.defaultValue = value
        self.value = value
        self.possibleValues = possibleValues
    }
}
