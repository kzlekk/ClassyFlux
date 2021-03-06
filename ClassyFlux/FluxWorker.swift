//
//  FluxWorker.swift
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

/// A protocol that defines how the concrete action can be handled and how to pass the next action to subsequent workers.
public protocol FluxWorker: AnyObject {

    /// A unique identifier.
    var token: AnyHashable { get }
    
    /// A priority of handling an action.
    /// The priority is used by a dispatcher to determine which worker should handle an action first.
    /// The smaller the value the higher the priority with the 0 is highest priority possible.
    var priority: UInt { get }

    /// Handles the action dispatched. The function can be performed on a background thread.
    /// - Parameter action: The action to handle.
    /// - Returns: The action composer that passes an action to next workers.
    func handle<Action: FluxAction>(action: Action) -> FluxPassthroughAction
}
