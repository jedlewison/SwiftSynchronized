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

/**
A Swift substitute for the Objective-C @synchronized directive using calls to
the Objective-C runtime.

- parameter lockToken: An Objective-C object to synchronize on.
- parameter action: A closure with a generic return type.

- returns: Synchronously returns the result of the synchronized action. For Void return type, simply don't return anything.

```swift
// Returning a value
return synchronized(self) {
    return protectedProperty
}

// Returning Void
synchronized(self) {
    protectedProperty = newValue
}
*/

public func synchronized<ReturnType>(lockToken: AnyObject, @noescape action: () -> ReturnType) -> ReturnType {
    objc_sync_enter(lockToken)
    let result = action()
    objc_sync_exit(lockToken)
    return result
}
