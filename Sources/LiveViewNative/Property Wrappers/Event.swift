//
//  Event.swift
//  
//
//  Created by Carson.Katri on 2/28/23.
//

import SwiftUI
import Combine
import LiveViewNativeCore

/// A property wrapper that handles sending events to the server, with automatic debounce and throttle handling.
///
/// Specify the attribute that contains the event name and an event type to create the wrapper.
/// Then, call the wrapped value with a payload and completion handler.
///
/// ```swift
/// struct MyCounterElement: View {
///     @Event("on-increment", type: "click") private var increment
///
///     var body: some View {
///         MyCounterView(onIncrement: {
///             increment(["new-value": 10]) {
///                 // on complete
///             }
///         })
///     }
/// }
/// ```
///
/// The element should include an attribute with the name of the event to trigger.
///
/// ```html
/// <my-counter on-increment="increment_count" />
/// ```
///
/// Any `phx-debounce` or `phx-throttle` attributes on this element will be respected automatically.
///
@propertyWrapper
public struct Event: DynamicProperty {
    @ObservedElement private var element: ElementNode
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    @StateObject private var handler = Handler()
    private let event: String?
    private let name: AttributeName?
    private let type: String
    
    final class Handler: ObservableObject {
        let currentEvent = CurrentValueSubject<(() -> ())?, Never>(nil)
        
        private var cancellable: AnyCancellable?
        private var elementWillChangeCancellable: AnyCancellable?
        
        init() {}
        
        func bind(element: ElementNode, elementWillChange: AnyPublisher<Void, Never>) {
            guard cancellable == nil else { return }
            // If the element changes, invalidate the current sink.
            elementWillChangeCancellable = elementWillChange.sink(receiveValue: { [weak self] _ in
                self?.cancellable = nil
            })
            if let debounce = element.attributeValue(for: "phx-debounce").flatMap(Double.init(_:)) {
                cancellable = currentEvent
                    .debounce(for: .init(debounce / 1000), scheduler: RunLoop.main)
                    .sink(receiveValue: { value in
                        value?()
                    })
            } else if let throttle = element.attributeValue(for: "phx-throttle").flatMap(Double.init(_:)) {
                cancellable = currentEvent
                    .throttle(for: .init(throttle / 1000), scheduler: RunLoop.main, latest: true)
                    .sink(receiveValue: { value in
                        value?()
                    })
            } else {
                cancellable = currentEvent
                    .sink(receiveValue: { value in
                        value?()
                    })
            }
        }
    }
    
    public init(_ name: AttributeName, type: String) {
        self.event = nil
        self.name = name
        self.type = type
    }
    
    public init(_ name: String, type: String) {
        self.event = nil
        self.name = .init(name: name)
        self.type = type
    }
    
    public init(event: String, type: String) {
        self.event = event
        self.name = nil
        self.type = type
    }
    
    public var wrappedValue: (Any, @escaping () -> ()) -> () {
        { value, didSend in
            guard let event = self.event ?? self.name.flatMap(element.attributeValue(for:)) else {
                return
            }
            handler.bind(element: element, elementWillChange: $element)
            handler.currentEvent.send({
                Task {
                    try await coordinatorEnvironment?.pushEvent(type, event, value)
                    didSend()
                }
            })
        }
    }
}