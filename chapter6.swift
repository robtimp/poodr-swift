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

class Bicycle {
    // This class is now empty. All code has been moved to RoadBike.
}

class RoadBike: Bicycle {
    // Now a subclass of Bicycle. Contains all code from the old Bicycle class.
}

class MountainBike: Bicycle {
    // Still a subclass of Bicycle (which is now empty). Code has not changed.
}

// Page 120

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
    // This class is now empty. All code has been moved to RoadBike.
}

class RoadBicycle: Bicycle {
    
    let size: String
    let tapeColor: String
    
    init(_ args: [BikeAttr : String]) {
        self.size = args[.Size] ?? ""
        self.tapeColor = args[.TapeColor] ?? ""
        super.init()
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
    
    init(_ args: [BikeAttr : String]) {
        self.frontShock = args[.FrontShock] ?? ""
        self.rearShock = args[.RearShock] ?? ""
        super.init()
    }
    
    func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.RearShock] = rear
        return spares
    }
}


let roadBike = RoadBicycle([
    .Size : "M",
    .TapeColor: "Red"])

roadBike.size // "M"

let mountainBike = MountainBike([
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock : "Fox"])

mountainBike.size
// Error: MountainBike does not have a member named 'size'.

// Page 121

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
    
    let size: String // promoted from RoadBike
    
    init(args: [BikeAttr : String] = [BikeAttr : String]()) {
        self.size = args[.Size] ?? "" // promoted from RoadBike
    }
}

class RoadBike: Bicycle {
    
    let tapeColor: String
    
    override init(args: [BikeAttr : String]) {
        self.tapeColor = args[.TapeColor] ?? ""
        super.init(args: args) // RoadBike now MUST send 'super'
    }
    // ...
}

// Page 122

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
    
    let size: String // promoted from RoadBike
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        self.size = args[.Size] ?? "" // promoted from RoadBike
    }
}

class RoadBike: Bicycle {
    
    let tapeColor: String
    
    override init(_ args: [BikeAttr : String]) {
        self.tapeColor = args[.TapeColor] ?? ""
        super.init(args) // RoadBike now MUST send 'super'
    }
    // ...
}

class MountainBike: Bicycle {
    
    let frontShock: String
    let rearShock: String
    
    override init(_ args: [BikeAttr : String]) {
        self.frontShock = args[.FrontShock] ?? ""
        self.rearShock = args[.RearShock] ?? ""
        super.init(args)
    }
    
    func spares() -> [BikeAttr : String] {
        return [.RearShock : rearShock]
    }
}


let roadBike = RoadBike([
    .Size : "M",
    .TapeColor : "Red"])

roadBike.size // "M"

let mountainBike = MountainBike([
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock : "Fox"])

mountainBike.size // "S"

// Page ???

class MountainBike : Bicycle {
    // ...
    func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.RearShock] = rearShock
    }
}

mountainBike.spares() // Bicycle does not have a member named 'spares'.

// Page 123

class RoadBike: Bicycle {
    // ...
    func spares() -> [BikeAttr : String] {
        return [.Chain : "10-speed",
            .TireSize : "23",
            .TapeColor : self.tapeColor]
    }
}

// Page 125

class Bicycle {
    let size: String
    let chain: String
    let tireSize: String
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        self.size = args[.Size] ?? ""
        self.chain = args[.Chain] ?? ""
        self.tireSize = args[.TireSize] ?? ""
    }
}

// Page 126

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
    var size = ""
    var chain = ""
    var tireSize = ""
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        if let size = args[.Size] {
            self.size = size
        }
        self.chain = args[.Chain] ?? defaultChain()
        self.tireSize = args[.TireSize] ?? defaultTireSize()
    }
    
    func defaultChain() -> String {
        return "10-speed"
    }
    
    func defaultTireSize() -> String {
        return ""
    }
}

class RoadBike: Bicycle {
    // ...
    override func defaultTireSize() -> String {
        return "23"
    }
}

class MountainBike: Bicycle {
    // ...
    override func defaultTireSize() -> String {
        return "2.1"
    }
}

let roadBike = RoadBike([
    .Size : "M",
    .TapeColor : "red"])

roadBike.tireSize // "23"
roadBike.chain // "10-speed"

let mountainBike = MountainBike([
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock : "Fox"])

mountainBike.tireSize // "2.1"
roadBike.chain // "10-speed"

// Page 127 

class RecumbentBike: Bicycle {
    override func defaultChain() -> String {
        return "9-speed"
    }
}

let bent = RecumbentBike()
// This is ok because strong typing in Swift prevents us from sending arbitrary messages

// Page 130

class RoadBike: Bicycle {
    func spares() -> [BikeAttr : String] {
        return [.Chain : "10-speed",
            .TireSize : "23",
            .TapeColor : tapeColor]
    }
}

// Page 131

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
    var size = ""
    var chain = ""
    var tireSize = ""
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        if let size = args[.Size] {
            self.size = size
        }
        self.chain = args[.Chain] ?? defaultChain()
        self.tireSize = args[.TireSize] ?? defaultTireSize()
    }
    
    func spares() -> [BikeAttr : String] {
        return [.TireSize : tireSize, .Chain : chain]
    }
    
    func defaultChain() -> String {
        return "10-speed"
    }
    
    func defaultTireSize() -> String {
        return ""
    }
}

class RoadBike: Bicycle {
    var tapeColor = ""
    
    override init(_ args: [BikeAttr : String]) {
        if let tapeColor = args[.TapeColor] {
            self.tapeColor = tapeColor
        }
        super.init(args)
    }
    
    override func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.TapeColor] = tapeColor
        return spares
    }
    
    override func defaultTireSize() -> String {
        return "23"
    }
}

class MountainBike: Bicycle {
    var frontShock = ""
    var rearShock = ""
    
    override init(_ args: [BikeAttr : String]) {
        if let frontShock = args[.FrontShock] {
            self.frontShock = frontShock
        }
        if let rearShock = args[.RearShock] {
            self.rearShock = rearShock
        }
        super.init(args)
    }
    
    override func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.RearShock] = rearShock
        return spares
    }
    
    override func defaultTireSize() -> String {
        return "2.1"
    }
}

// Results for the above
let roadBike = RoadBike([
    .Size: "M",
    .TapeColor: "red"])

roadBike.spares() // [.TireSize : "23", .Chain : "10-speed", .TapeColor : "red"]

let mountainBike = MountainBike([
    .Size : "S",
    .FrontShock : "Manitou",
    .RearShock : "Fox"])

mountainBike.spares() // [.TireSize : "2.1", .Chain : "10-speed", .RearShock : "Fox"]

// Page 133

class RecumbentBike: Bicycle {
    var flag = ""
    
    override init(_ args: [BikeAttr : String]) {
        if let flag = args[.Flag] {
            self.flag = flag
        }
        // Forgot to send 'super', but seems to work anyway?
    }
    
    override func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.Flag] = flag
        return spares
    }
    
    override func defaultChain() -> String {
        return "9-speed"
    }
    
    override func defaultTireSize() -> String {
        return "28"
    }
}

let bent = RecumbentBike([.Flag : "tall and orange"])
bent.spares() // Wasn't expecting this to work. Swift must call super.init automatically.

// Page 134

class Bicycle {
    var size = ""
    var chain = ""
    var tireSize = ""
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        if let size = args[.Size] {
            self.size = size
        }
        self.chain = args[.Chain] ?? defaultChain()
        self.tireSize = args[.TireSize] ?? defaultTireSize()
        self.postInit(args) // Bicycle both sends
    }
    
    func postInit([BikeAttr : String]) { // and implements this
        return
    }
    
    func spares() -> [BikeAttr : String] {
        return [.TireSize : tireSize, .Chain : chain]
    }
    
    func defaultChain() -> String {
        return "10-speed"
    }
    
    func defaultTireSize() -> String {
        return ""
    }
}

class RoadBike: Bicycle {
    var tapeColor = ""
    
    override func postInit(args: [BikeAttr : String]) {
        if let tapeColor = args[.TapeColor] {
            self.tapeColor = tapeColor
        }
    }
    
    override func spares() -> [BikeAttr : String] {
        var spares = super.spares()
        spares[.TapeColor] = tapeColor
        return spares
    }
    
    override func defaultTireSize() -> String {
        return "23"
    }
}

let roadBike = RoadBike([.Size : "M", .TireSize : "25", .TapeColor : "red"])
roadBike.spares()

// Page 136

// There's no built-in merge function for Swift dictionaries, so it's necessary to add one
func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

enum BikeAttr {
    case Style
    case Size
    case TapeColor
    case Chain
    case TireSize
    case FrontShock
    case RearShock
    case Flag
}

class Bicycle {
    var size = ""
    var chain = ""
    var tireSize = ""
    
    init(_ args: [BikeAttr : String] = [BikeAttr : String]()) {
        if let size = args[.Size] {
            self.size = size
        }
        self.chain = args[.Chain] ?? defaultChain()
        self.tireSize = args[.TireSize] ?? defaultTireSize()
        self.postInit(args)
    }
    
    // subclasses may override
    func postInit(args: [BikeAttr : String]) {
        return
    }
    
    func spares() -> [BikeAttr : String] {
        var spares: [BikeAttr : String] = [.TireSize : tireSize, .Chain : chain]
        spares += localSpares()
        return spares
    }
    
    func localSpares() -> [BikeAttr : String] {
        return [BikeAttr : String]()
    }
    
    func defaultChain() -> String {
        return "10-speed"
    }
    
    func defaultTireSize() -> String {
        return ""
    }
    
    
}

class RoadBike: Bicycle {
    var tapeColor = ""
    
    override func postInit(args: [BikeAttr : String]) {
        if let tapeColor = args[.TapeColor] {
            self.tapeColor = tapeColor
        }
    }
    
    override func localSpares() -> [BikeAttr : String] {
        return [.TapeColor : tapeColor]
    }
    
    override func defaultTireSize() -> String {
        return "23"
    }
}

class MountainBike: Bicycle {
    var frontShock = ""
    var rearShock = ""
    
    override func postInit(args: [BikeAttr : String]) {
        if let frontShock = args[.FrontShock] {
            self.frontShock = frontShock
        }
        if let rearShock = args[.RearShock] {
            self.rearShock = rearShock
        }
    }
    
    override func localSpares() -> [BikeAttr : String] {
        return [.FrontShock : frontShock, .RearShock : rearShock]
    }
    
    override func defaultTireSize() -> String {
        return "2.1"
    }
}

// Page 138

class RecumbentBike: Bicycle {
    var flag = ""
    
    override func postInit(args: [BikeAttr : String]) {
        if let flag = args[.Flag] {
            self.flag = flag
        }
    }
    
    override func localSpares() -> [BikeAttr : String] {
        return [.Flag : flag]
    }
    
    override func defaultChain() -> String {
        return "9-speed"
    }
    
    override func defaultTireSize() -> String {
        return "28"
    }
}

let bent = RecumbentBike([.Flag : "tall and orange"])
bent.spares() // [.TireSize : "28", .Chain : "9-speed", .Flag : "tall and orange"]
