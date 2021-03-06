//
//  FluxMiddleware.swift
//  ClassyFlux
//
//  Created by Natan Zalkin on 03/08/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

/*
 * Copyright (c) 2019 Natan Zalkin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

import Foundation
import ResolvingContainer

/// An object that triggers handlers in a response to specific action dispatched
open class FluxMiddleware: FluxWorker {

    /// An action handler closure. You can pass different action to subsequent workers, or stop the action to propagate.
    /// - Parameter action: The action to handle.
    /// - Returns: The next action. Use FluxNextAction(FluxAction) functor to pass next action. Passing nil action will stop action propagation.
    public typealias Handler<Action: FluxAction> = (Action) -> FluxPassthroughAction

    public let token: AnyHashable
    public let priority: UInt

    internal let handlers: ResolvingContainer

    public init(priority aPriority: UInt = 0) {
        token = UUID()
        priority = aPriority
        handlers = ResolvingContainer()
    }
    
    /// Associates a handler with the actions of specified type.
    /// - Parameter action: The type of the actions to associate with handler.
    /// - Parameter execute: The closure that will be invoked when the action received.
    public func registerHandler<Action: FluxAction>(for action: Action.Type, handler: @escaping Handler<Action>) {
        handlers.register { handler }
    }
    
    /// Unregisters handler associated with specified action type.
    /// - Parameter action: The action for which the associated handler should be removed
    public func unregisterHandler<Action: FluxAction>(for action: Action.Type) {
        handlers.unregister(Handler<Action>.self)
    }

    public func handle<Action: FluxAction>(action: Action) -> FluxPassthroughAction {
        guard let handle = self.handlers.resolve(Handler<Action>.self) else {
            return .next(action)
        }
        return handle(action)
    }
}

extension FluxWorker where Self: FluxMiddleware {

    public typealias SelfHandler<Action: FluxAction> = (Self, Action) -> FluxPassthroughAction
    
    /// Associates a handler with the actions of specified type.
    /// - Parameter action: The type of the actions to associate with handler.
    /// - Parameter execute: The closure that will be invoked when the action received.
    public func registerHandler<Action: FluxAction>(for action: Action.Type, handle: @escaping SelfHandler<Action>) {
        registerHandler(for: Action.self) { [weak self] (action) -> FluxPassthroughAction in
            guard let self = self else { return .next(action) }
            return handle(self, action)
        }
    }
}
