// Practical Object-Oriented Design in Ruby by Sandi Metz
// Chapter 6 - Acquiring Behavior Through Inheritance
//
// Swift version by Rob Hudson

import Foundation

// Page 107

class Bicycle {
    
    // Use enum in place of Swift symbols
    enum BicycleAttr {
        case Size
        case TapeColor
        case Chain
        case TireSize
    }
    
    var size = ""
    var tapeColor = ""
    
    init(_ args: [BicycleAttr : String]) {
        if let size = args[.Size] {
            self.size = size
        }
        
        if let tapeColor = args[.TapeColor] {
            self.tapeColor = tapeColor
        }
    }
    
    // every bike has the same defaults for tire and chain size
    func spares() -> [BicycleAttr : String] {
        return [.Chain : "10-speed", .TireSize : "23", .TapeColor : self.tapeColor]
    }
    
    // Many other methods
}

let bike = Bicycle([.Size : "m", .TapeColor : "red"])

bike.size
bike.spares()

// Page 110

class Bicycle {
    enum BicycleAttr {
        case Style
        case Size
        case TapeColor
        case Chain
        case TireSize
        case FrontShock
        case RearShock
    }
    
    enum BicycleStyle {
        case Road
        case Mountain
    }
    
    let style: String
    let size: String
    let tapeColor: String
    let frontShock: String
    let rearShock: String
    
    init(_ args: [BicycleAttr : String]) {
        // Use nil-coalescing operator, since we need to gives these properties SOME value
        self.style = args[.Style] ?? ""
        self.size = args[.Size] ?? ""
        self.tapeColor = args[.TapeColor] ?? ""
        self.frontShock = args[.FrontShock] ?? ""
        self.rearShock = args[.RearShock] ?? ""
    }
    
    func spares() -> [BicycleAttr : String] {
        if style == "road" {
            return [.Chain : "10-speed", .TireSize : "23", .TapeColor : tapeColor]
        } else {
            return [.Chain : "10-speed", .TireSize : "2.1", .RearShock : rearShock]
        }
    }
}

let bike = Bicycle([
    .Style : "mountain",
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock: "Fox"])

bike.spares()

// Page 115

// Define enum at Global scope so it can be used in both Bicycle and MountainBike
enum BikeAttr {
    case Style
    case Size
    case TapeColor
    case Chain
    case TireSize
    case FrontShock
    case RearShock
}

class Bicycle {
    
    let size: String
    let tapeColor: String
    
    init(_ args: [BikeAttr : String]) {
        self.size = args[.Size] ?? ""
        self.tapeColor = args[.TapeColor] ?? ""
    }
    
    // every bike has the same defaults for tire and chain size
    func spares() -> [BikeAttr : String] {
        return [.Chain : "10-speed", .TireSize : "23", .TapeColor : self.tapeColor]
    }
    
    // Many other methods
}

class MountainBike: Bicycle {
    let frontShock: String
    let rearShock: String
    
    override init(_ args: [BikeAttr : String]) {
        self.frontShock = args[.FrontShock] ?? ""
        self.rearShock = args[.RearShock] ?? ""
        super.init(args)
    }
    
    override func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.RearShock] = rearShock
        
        return spares
    }
}

let mountainBike = MountainBike([
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock : "Fox"])

mountainBike.size
mountainBike.spares()

// Page 119

