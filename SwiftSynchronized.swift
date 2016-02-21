//
// SwiftSynchronized.swift
// SwiftSynchronized
//
// Created by Jed Lewison on 8/30/15.
// Copyright © 2015 Magic App Factory.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import ObjectiveC

/// Protects `action` using an Objective-C as a token for a mutex lock; similar to Objective-C @synchronized directive.
///
///     synchronized(self) {
///        // Critical section
///     }
/// - Parameters:
///    - lockToken: An Objective-C object to protect the critical section of code
///    - action: The critical section of code to be protected
/// - Returns: Result of `action()`
public func synchronized<ReturnType>(lockToken: AnyObject, @noescape action: () -> ReturnType) -> ReturnType {
    return synchronized(lockToken, action: action())
}

/// Protects `action` using an Objective-C as a token for a mutex lock; similar to Objective-C @synchronized directive.
///
///     return synchronized(self, action: atomicProperty)
/// - Parameters:
///    - lockToken: An Objective-C object to protect the critical section of code
///    - action: The critical section of code to be protected
/// - Returns: Result of `action()`
public func synchronized<ReturnType>(lockToken: AnyObject, @autoclosure action: () -> ReturnType) -> ReturnType {
    defer { objc_sync_exit(lockToken) }
    objc_sync_enter(lockToken)
    return action()
}

public protocol LockPerforming: NSLocking {
    /// Protects `action` using `lock()` and `unlock()`.
    ///
    ///     lockObj.performAndWait {
    ///        // Critical section
    ///     }
    /// - Parameters:
    ///    - action: The critical section of code to be protected
    /// - Returns: Result of `action()`
    func performAndWait<ReturnType>(@noescape action: () -> ReturnType) -> ReturnType

    /// Protects `action` using `lock()` and `unlock()`.
    ///
    ///     lockObj.performAndWait(atomicProperty)
    /// - Parameters:
    ///    - action: The critical section of code to be protected
    /// - Returns: Result of `action()`
    func performAndWait<ReturnType>(@autoclosure action: () -> ReturnType) -> ReturnType
}

extension NSLock: LockPerforming { }
extension NSRecursiveLock: LockPerforming { }

public extension LockPerforming {
    /// Protects `action` using `lock()` and `unlock()`.
    ///
    /// - SeeAlso: `LockPerforming` protocol
    func performAndWait<ReturnType>(@noescape action: () -> ReturnType) -> ReturnType {
        return performAndWait(action())
    }

    /// Protects `action` using `lock()` and `unlock()`.
    ///
    /// - SeeAlso: `LockPerforming` protocol
    func performAndWait<ReturnType>(@autoclosure action: () -> ReturnType) -> ReturnType {
        defer { unlock() }
        lock()
        return action()
    }
}

