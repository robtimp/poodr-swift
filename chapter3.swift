// Practical Object-Oriented Design in Ruby by Sandi Metz
// Chapter 3 - Managing Dependencies
//
// Swift version by Rob Hudson

import Foundation

// Page 36

class Gear {
    let chainring: Int
    let cog: Int
    let rim: Int
    let tire: Double
    
    init(chainring: Int, cog: Int, rim: Int, tire: Double) {
        self.chainring = chainring
        self.cog = cog
        self.rim = rim
        self.tire = tire
    }
    
    func gearInches() -> Double {
        return ratio() * Wheel(rim: rim, tire: tire).diameter
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    // ...
}

class Wheel {
    let rim: Int
    let tire: Double
    
    init(rim: Int, tire: Double) {
        self.rim = rim
        self.tire = tire
    }
    
    func diameter() -> Double {
        return Double(rim) + (tire * 2)
    }
    // ...
}

Gear(chainring: 52, cog: 11, rim: 26, tire: 1.5).gearInches()

// Page 41 

protocol DiameterProtocol {
    // Since Swift is strongly typed, we need a protocol to make sure the object has a diameter method
    func diameter() -> Double
}

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: DiameterProtocol
    
    init(chainring: Int, cog: Int, wheel: DiameterProtocol) {
        self.chainring = chainring
        self.cog = cog
        self.wheel = wheel
    }
    
    func gearInches() -> Double {
        return ratio() * wheel.diameter()
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
}

class Wheel: DiameterProtocol {
    let rim: Int
    let tire: Double
    
    init(rim: Int, tire: Double) {
        self.rim = rim
        self.tire = tire
    }
    
    func diameter() -> Double {
        return Double(rim) + (tire * 2)
    }
    // ...
}

Gear(chainring: 52, cog: 11, wheel: Wheel(rim: 26, tire: 1.5)).gearInches()

// Page 43

class Wheel {
    let rim: Int
    let tire: Double
    
    init(rim: Int, tire: Double) {
        self.rim = rim
        self.tire = tire
    }
    
    func diameter() -> Double {
        return Double(rim) + (tire * 2)
    }
    // ...
}

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel
    
    init(chainring: Int, cog: Int, rim: Int, tire: Double) {
        self.chainring = chainring
        self.cog = cog
        self.wheel = Wheel(rim: rim, tire: tire)
    }
    
    func gearInches() -> Double {
        return ratio() * wheel.diameter()
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
}

// Page 43

class Gear {
    let chainring: Int
    let cog: Int
    let rim: Int
    let tire: Double
    // Use 'lazy' keyword in place of Ruby ||= operator
    lazy var wheel: Wheel = {
        return Wheel(rim: self.rim, tire: self.tire)
    }()
    
    init(chainring: Int, cog: Int, rim: Int, tire: Double) {
        self.chainring = chainring
        self.cog = cog
        self.rim = rim
        self.tire = tire
    }
    
    func gearInches() -> Double {
        return ratio() * wheel.diameter()
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
}

// Page 44

func gearInches() -> Double {
    return ratio() * wheel.diameter()
}

// Page 44

func gearInches() -> Double {
    // ... a few lines of scary math
    let foo = someIntermediateResult * wheel.diameter()
    // ... more lines of scary math
}

// Page 45

func gearInches() -> Double {
    // ... a few lines of scary math
    let foo = someIntermediateResult * self.diameter()
    // ... more lines of scary math
}

func diameter() -> Double {
    return wheel.diameter()
}

// Page 46

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel
    
    init(chainring: Int, cog: Int, wheel: Wheel) {
        self.chainring = chainring
        self.cog = cog
        self.wheel = wheel
    }
    // ...
}

Gear(chainring: 52,
    cog: 11,
    wheel: Wheel(rim: 26, tire: 1.5)).gearInches()

// Page 47

class Wheel {
    let rim: Int
    let tire: Double
    
    init(rim: Int, tire: Double) {
        self.rim = rim
        self.tire = tire
    }
    
    func diameter() -> Double {
        return Double(rim) + (tire * 2)
    }
    // ...
}

class Gear {
    let chainring: Int?
    let cog: Int?
    let wheel: Wheel?
    
    init(args: [String : AnyObject]) {
        // This pattern is definitely not as elegant in Swift
        self.chainring = args["chainring"] as? Int
        self.cog = args["cog"] as? Int
        self.wheel = args["wheel"] as? Wheel
    }
    
    func gearInches() -> Double? {
        if let wheel = self.wheel, ratio = self.ratio() {
            return ratio * wheel.diameter()
        }
        return nil
    }
    
    func ratio() -> Double? {
        if let chainring = self.chainring, cog = self.cog {
            return Double(chainring) / Double(cog)
        }
        return nil
    }
    // ...
}

Gear(args: ["chainring" : 52,
    "cog" : 11,
    "wheel" : Wheel(rim: 26, tire: 1.5)]).gearInches()

// Page 48

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel?
    
    init(args: [String : AnyObject]) {
        // The nil-coalescing operator performs a similar function to || in Ruby here
        self.chainring = args["chainring"] as? Int ?? 40
        self.cog = args["cog"] as? Int ?? 18
        self.wheel = args["wheel"] as? Wheel
    }
    
    func gearInches() -> Double? {
        if let wheel = self.wheel {
            return ratio() * wheel.diameter()
        }
        return nil
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    // ...
}

Gear(args: ["cog" : 11,
    "wheel" : Wheel(rim: 26, tire: 1.5)]).gearInches()
// chainring not specified, so it defaults to 40

// Page 49

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel?
    let defaults: [String : AnyObject] = ["chainring" : 40, "cog" : 18]
    
    init(args: [String : AnyObject]) {
        var mergedDictionary = self.defaults
        mergedDictionary += args
        self.chainring = mergedDictionary["chainring"] as! Int // Will never be nil, so ok to force unwrap
        self.cog = mergedDictionary["cog"] as! Int // Ditto
        self.wheel = mergedDictionary["wheel"] as? Wheel
    }
    
    func gearInches() -> Double? {
        if let wheel = self.wheel {
            return ratio() * wheel.diameter()
        }
        return nil
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    
}

// There's no built-in merge function for Swift dictionaries, so it's necessary to add one
func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

// Page 50

class SomeFramework { // Imagine this is a separate module, not just a class
    class Gear {
        let chainring: Int
        let cog: Int
        let wheel: Wheel
        
        init(chainring: Int, cog: Int, wheel: Wheel) {
            self.chainring = chainring
            self.cog = cog
            self.wheel = wheel
        }
    }
}

class GearWrapper {
    class func gear(args: [String : AnyObject]) -> SomeFramework.Gear? {
        // Use the Swift 1.2 syntax to unwrap multiple values
        if let chainring = args["chainring"] as? Int, cog = args["cog"] as? Int, wheel = args["wheel"] as? Wheel {
            return SomeFramework.Gear(chainring: chainring, cog: cog, wheel: wheel)
        }
        // We didn't get the values we need to create a new Gear
        return nil
    }
}

GearWrapper.gear(["chainring" : 52,
    "cog" : 11,
    "wheel" : Wheel(rim: 26, tire: 1.5)])?.gearInches()

// Page 52

class Gear {
    let chainring: Int
    let cog: Int
    
    init(chainring: Int, cog: Int) {
        self.chainring = chainring
        self.cog = cog
    }
    
    func gearInches(diameter: Double) -> Double {
        return ratio() / Double(cog)
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    // ...
}

class Wheel {
    let rim: Int
    let tire: Double
    let gear: Gear
    
    init(rim: Int, tire: Double, chainring: Int, cog: Int) {
        self.rim = rim
        self.tire = tire
        self.gear = Gear(chainring: chainring, cog: cog)
    }
    
    func diameter() -> Double {
        return Double(rim) + (tire * 2)
    }
    
    func gearInches() -> Double {
        return gear.gearInches(diameter())
    }
    // ...
}

Wheel(rim: 26, tire: 1.5, chainring: 52, cog: 11).gearInches()
