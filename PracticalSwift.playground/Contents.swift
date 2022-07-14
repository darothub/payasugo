import UIKit

var greeting = "Hello, playground"

func address<T: AnyObject>(of object: T) -> Int {
    return unsafeBitCast(object, to: Int.self)
}

class Dog : CustomStringConvertible {
    var age: Int
    var weight:Int
    
    var description: String {
        return "Age \(age) - Weight \(weight)"
    }
    
    init(age:Int, weight:Int) {
        self.age = age
        self.weight = weight
    }
}

struct Person {
    var name: String
    var occupation: String
}

let doberman = Dog(age: 1, weight: 70)
let chihuahua = doberman

var darot = Person(name: "Darot", occupation: "SE")
var ayinde = darot
darot.name = "peacedude"
ayinde.occupation = "SD"

doberman.age = 2

chihuahua.weight = 10

print(doberman)
print(chihuahua)
print(address(of: doberman))
print(address(of: chihuahua))

print(darot)
print(ayinde)

var someone = {
    "yoooooo"
}

someone()
