// Practical Object-Oriented Design in Ruby by Sandi Metz
// Chapter 5 - Reducing Costs with Duck Typing
//
// Swift version by Rob Hudson

import Foundation

// Page 87

// In Swift, need a protocol in order to send the same message to unrelated classes
protocol BicyclePreparer {
    func prepareBicycles(bicycles: [Bicycle])
}

class Bicycle {
    // ...
}

class Trip {
    var bicycles: [Bicycle]
    var customers: [Customer]
    var vehicle: Vehicle
    
    // this 'mechanic' argument could be of any class (that implements the protocol)
    func prepare(mechanic: BicyclePreparer) {
        mechanic.prepareBicycles(self.bicycles)
    }
    
    // ...
}

class Mechanic: BicyclePreparer {
    func prepareBicycles(bicycles: [Bicycles]) {
        for bicycle in bicycles {
            prepareBicycle(bicycle)
        }
    }
    
    func prepareBicycle(bicycle: Bicycle) {
        // ...
    }
}

// Page 88

// Trip preparation becomes more complicated
class Trip {
    var bicycles: [Bicycle]
    var customers: [Customer]
    var vehicle: Vehicle
    
    func prepare(preparers: [AnyObject]) {
        for preparer in preparers {
            if let mechanic = preparer as? Mechanic {
                mechanic.prepareBicycles(bicycles)
            }
            if let tripCoordinator = preparer as? TripCoordinator {
                tripCoordinator.buyFood(customers)
            }
            if let driver = preparer as? Driver {
                driver.gasUp(vehicle)
                driver.fillWaterTank(vehicle)
            }
        }
    }
}

// when you introduce TripCoordinator and Driver
class TripCoordinator {
    func buyFood(customers: [Customer]) {
        // ...
    }
}

class Driver {
    func gasUp(vehicle: Vehicle) {
        // ...
    }
    
    func fillWaterTank(vehicle: Vehicle) {
        // ...
    }
}

// Page 93

// Trip preparation becomes easier
protocol TripPreparer {
    // This protocol ensures that all our 'ducks' can respond to prepareTrip:
    func prepareTrip(trip: Trip)
}

class Trip {
    var bicycles: [Bicycle]
    var customers: [Customer]
    var vehicle: Vehicle
    
    init(bicycles: [Bicycle], customers: [Customer], vehicle: Vehicle) {
        self.bicycles = bicycles
        self.customers = customers
        self.vehicle = vehicle
    }
    
    func prepare(preparers: [TripPreparer]) {
        for prepaper in preparers {
            prepaper.prepareTrip(self)
        }
    }
}

// when every preparer is a Duck that responds to 'prepareTrip'
class Mechanic: TripPreparer {
    func prepareTrip(trip: Trip) {
        for bicycle in trip.bicycles {
            prepareBicycle(bicycle)
        }
    }
    
    // ...
}

class TripCoordinator: TripPreparer {
    func prepareTrip(trip: Trip) {
        buyFood(trip.customers)
    }
    
    // ...
}

class Driver: TripPreparer {
    func prepareTrip(trip: Trip) {
        let vehicle = trip.vehicle
        gasUp(vehicle)
        fillWaterTank(vehicle)
    }
    
    // ...
}

// Page 97

// These objects must inherit from NSObject in order for their methods to be available on AnyObject
// (Not that we should be using this anti-pattern, anyway)
class Driver: NSObject {
    func gasUp(vehicle: Vehicle) {
        // ...
    }
    
    func fillWaterTank(vehicle: Vehicle) {
        // ...
    }
}

class Mechanic: NSObject {
    func prepareBicycles(bicycles: [Bicycle]) {
        // ...
    }
}

class TripCoordinator: NSObject {
    func buyFood(customers: [Customer]) {
        // ...
    }
}

class Trip {
    var bicycles: [Bicycle]
    var customers: [Customer]
    var vehicle: Vehicle
    
    init(bicycles: [Bicycle], customers: [Customer], vehicle: Vehicle) {
        self.bicycles = bicycles
        self.customers = customers
        self.vehicle = vehicle
    }
    
    func prepare(preparers: [AnyObject]) {
        for preparer in preparers {
            if preparer is Mechanic {
                preparer.prepareBicycles(bicycles)
            } else if preparer is TripCoordinator {
                preparer.buyFood(customers)
            } else if preparer is Driver {
                preparer.gasUp(vehicle)
                preparer.fillWaterTank(vehicle)
            }
        }
    }
}

// Page 97

if preparer.respondsToSelector("prepareBicycles:") {
    preparer.prepareBicycles(bicycles)
} else if preparer.respondsToSelector("buyFood:") {
    preparer.buyFood(customers)
} else if preparer.respondsToSelector("gasUp:") {
    preparer.gasUp(vehicle)
    preparer.fillWaterTank(vehicle)
}
