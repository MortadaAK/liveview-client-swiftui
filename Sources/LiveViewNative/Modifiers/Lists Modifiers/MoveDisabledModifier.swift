//
//  MoveDisabledModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Adds a condition for whether the view’s view hierarchy is movable.
///
/// ```html
/// <List>
///     <Label modifiers={move_disabled(@native, is_disabled: true)}>
///         This label cannot be moved when list is editable
///     </Label>
/// </List>
/// ```
///
/// ## Arguments
/// * ``is_disabled``
struct MoveDisabledModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isDisabled: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
    }
    
    func body(content: Content) -> some View {
        content.moveDisabled(isDisabled)
    }
    
    enum CodingKeys: String, CodingKey {
        case isDisabled = "is_disabled"
    }
}