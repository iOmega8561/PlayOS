//
//  SettingKey.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 08/02/25.
//

import Foundation

/// A generic structure representing a setting key with a value of a specific type.
/// The setting key includes an optional namespace, a default value, a current value, and a list of possible values.
struct SettingKey<ValueType: Hashable>: Hashable {
    
    /// An optional namespace used to group or identify the setting key.
    private let namespace: String?
    
    /// The default value for the setting key.
    private let defaultValue: ValueType
    
    /// The current value of the setting key.
    var value: ValueType
    
    /// An array of all possible values that the setting key can hold.
    let possibleValues: [ValueType]
    
    /// A computed property that returns a description of the current value.
    /// If a namespace is present, it prefixes the value with the namespace.
    var description: String {
        description(for: value)
    }
    
    /// Returns a description for a given value.
    /// If a namespace is provided, the description will include the namespace followed by the value.
    ///
    /// - Parameter value: The value for which to generate a description.
    /// - Returns: A string representation of the value, optionally prefixed with the namespace.
    func description(for value: ValueType) -> String {
        if let namespace {
            return "\(namespace)/\(value)"
            
        } else { return "\(value)" }
    }
    
    /// Initializes a new instance of `SettingKey` with an optional namespace, a default value, and possible values.
    ///
    /// - Parameters:
    ///   - namespace: An optional string representing the namespace for the setting key.
    ///   - value: The default value for the setting key.
    ///   - possibleValues: An array of possible values that the setting key can hold.
    init(namespace: String? = nil, default value: ValueType, possibleValues: [ValueType]) {
        self.namespace = namespace
        self.defaultValue = value
        self.value = value
        self.possibleValues = possibleValues
    }
}
