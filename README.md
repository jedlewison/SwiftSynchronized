# SwiftSynchronized

SwiftSynchronized provides synchronized, a global public function that serves as a Swift-substitute for Objective-C's @synchronized directive. It also adds a `performAndWait` extension to NSLock and NSRecursiveLock.

## Usage: Executing a critical section of code

Using synchronized:

```swift
synchronized(self) {
    // Critical section
}
```

Using NSLock and NSRecursiveLock:

```swift
lock.performAndWait {
    // Critical section
}
```

## Usage: Returning/setting value

Using synchronized:

```swift
var _privateStorage: String // The actual private storage

var threadSafeAccessor: String { // A thread safe accessor
    get { return synchronized(self, _privateStorage) }
    set { synchronized(self, _privateStorage = newValue) }
}

```

Using NSLock and NSRecursiveLock:

```swift
let lock = NSLock() // Or NSRecursiveLock()
var _privateStorage: String // The actual private storage

var threadSafeAccessor: String { // A thread safe accessor
    get { return lock.performAndWait(_privateStorage) }
    set { lock.performAndWait(_privateStorage = newValue) }
}

```


## Installation

To install via CocoaPods:

```ruby
pod 'SwiftSynchronized'
```

Don't forget to:

```swift
import SwiftSynchronized
```

somewhere in your project.

You can also use Carthage, or simply add SwiftSynchronized.swift directly to your project.

### Caution
Unlike Objective-C's @synchronized, Swift synchronized does not handle exceptions.
