# SwiftSynchronized

SwiftSynchronized provides synchronized, a global public function that serves as a Swift-substitute for Objective-C's @synchronized directive takes two arguments:

  - lockToken: An Objective-C object to synchronize on.
  - action: A closure with a generic return type.

synchronized returns synchronously. For Void return type, simply don't return anything.

# Usage: Returning a value

    return synchronized(self) {
        return protectedProperty
    }

# Usage: Returning void
    synchronized(self) {
        protectedProperty = newValue
    }

# Installation

To install via Cocoapods:

    pod 'SwiftSynchronized'
    
Don't forget to

    import SwiftSynchronized
    
somewhere in your project. Or just add SwiftSynchronized.swift to your project.

# Caution
Unlike Objective-C's @synchronized, Swift synchronized does not handle exceptions
