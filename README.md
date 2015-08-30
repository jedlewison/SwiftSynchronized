# SwiftSynchronized
@synchronized for Swift, using calls to the Objective-C runtime and providing nearly identical syntax.

# Usage: Parameters

synchronized is provided as a global public function that takes two arguments:

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
# Caution
Unlike Objective-C's @synchronized, Swift synchronized does not handle exceptions
