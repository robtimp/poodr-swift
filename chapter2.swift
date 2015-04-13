// Practical Object-Oriented Design in Ruby by Sandi Metz
// Chapter 2 - Designing Classes with a Single Responsibility
//
// Swift version by Rob Hudson

import Foundation

// Page 18

var chainring   = 52 // number of teeth
var cog         = 11
var ratio       = Double(chainring) / Double(cog)
println(ratio) // -> 4.72727272727273

chainring   = 30
cog         = 27
ratio       = Double(chainring) / Double(cog)
println(ratio) // -> 1.11111111111111

// Page 19

class Gear {
    let chainring: Int
    let cog: Int
    
    init(chainring: Int, cog: Int) {
        self.chainring = chainring
        self.cog = cog
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
}

println(Gear(chainring: 52, cog: 11).ratio()) // -> 4.72727272727273
println(Gear(chainring: 30, cog: 27).ratio()) // -> 1.11111111111111

// Page 20

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
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    
    func gearInches() -> Double { // Could also be implemented as a computed property
        return ratio() * (Double(rim) + (tire * 2.0))
        // tire goes around rim twice for diameter
    }
}

println(Gear(chainring: 52, cog: 11, rim: 26, tire: 1.5).gearInches())
// -> 137.090909090909

println(Gear(chainring: 52, cog: 11, rim: 24, tire: 1.25).gearInches())
// -> 125.272727272727

println(Gear(chainring: 52, cog: 11).ratio())
// Error: missing argument for parameter 'rim' in call

// Page 24

class Gear {
    let chainring: Int
    let cog: Int
    
    init(chainring: Int, cog: Int) {
        self.chainring = chainring
        self.cog = cog
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
}

// Page 25

class Gear {
    let _chainring: Int
    let _cog: Int
    
    init(chainring: Int, cog: Int) {
        _chainring = chainring
        _cog = cog
    }
    
    // No real Swift equivalent for attr_reader
    
    func chainring() -> Int {
        return _chainring
    }
    
    func cog() -> Int {
        return _cog
    }
    
    // a a simple reimplementation of cog
    
    func cog() -> Int {
        return _cog * unanticipatedAdjustmentFactor
    }
    
    // more complex one
    
    func cog() -> Int {
        return _cog * (isFoo ? barAdjustment : bazAdjustment)
    }
}

// Page 26

class ObscuringReferences {
    
    let data: [[Int]]
    
    init(data: [[Int]]) {
        self.data = data
    }
    
    func diameters() -> [Int] {
        var arrayToReturn = [Int]()
        
        for cell in data {
            // 0 is rim, 1 is tire
            arrayToReturn.append(cell[0] + (cell[1] * 2))
        }
    }
    
    // ... many other methods that index into the array
}

// Page 27

// rim and tire sizes (now in milimeters!) in a 2d array
let data = [[622, 20], [622, 23], [559, 30], [559, 40]]

// Page 28

class RevealingReferences {
    
    struct Wheel {
        let rim: Int
        let tire: Double
    }
    
    var wheels = [Wheel]()
    
    init(data: [[Int]]) {
        self.wheels = wheelify(data)
    }
    
    func diameters() -> [Int] {
        var diameters = [Int]()
        
        for wheel in wheels {
            let diameter = wheel.rim + (wheel.tire * 2)
            diameters.append(diameter)
        }
        
        return diameters
    }
    // ... now everyone can send rim/tire to wheel
    
    func wheelify(data: [[Int]]) -> [Wheel] {
        var results = [Wheel]()
        
        for cell in data {
            let wheel = Wheel(rim: cell[0], tire: cell[1])
            results.append(wheel)
        }
        
        return results
    }
}

// Page 29

// first - iterate over the array
func diameters() -> [Int] {
    return wheels.map {
        self.diameter($0)
    }
}

// second - calculate diameter of ONE wheel
func diameter(wheel: Wheel) -> Int {
    return wheel.rim + (wheel.tire * 2)
}

// Page 30

func gearInches() -> Double {
    // tire goes around rim twice for diameter
    return ratio() * (rim + (tire * 2))
}

// Page 32

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel
    
    init(chainring: Int, cog: Int, rim: Int, tire: Double) {
        self.chainring = chainring
        self.cog = cog
        self.wheel = Wheel(rim: rim, tire: tire)
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    
    func gearInches() -> Double {
        return ratio() * wheel.diameter
    }
    
    struct Wheel {
        let rim: Int
        let tire: Double
        
        func diameter() -> Double {
            return rim + (tire * 2)
        }
    }
}

// Page 33

class Gear {
    let chainring: Int
    let cog: Int
    let wheel: Wheel?
    
    init(chainring: Int, cog: Int, wheel: Wheel? = nil) {
        self.chainring = chainring
        self.cog = cog
        self.wheel = wheel
    }
    
    func ratio() -> Double {
        return Double(chainring) / Double(cog)
    }
    
    func gearInches() -> Double {
        return ratio() * (wheel?.diameter() ?? 0)
    }
}

class Wheel {
    let rim: Int
    let tire: Double
    
    init(rim: Int, tire: Double) {
        self.rim = rim
        self.tire = tire
    }
    
    func diameter() -> Double {
        return rim + (tire * 2)
    }
    
    func circumference() -> Double {
        return self.diameter() * M_PI
    }
}

let wheel = Wheel(rim: 26, tire: 1.5)
println(wheel.circumference())
// -> 91.106186954104

println(Gear(chainring: 52, cog: 11, wheel: wheel).gearInches())
// -> 137.090909090909

println(Gear(chainring: 52, cog: 11).ratio())
// -> 4.72727272727273
