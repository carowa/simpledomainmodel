//  August Carow
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    private var conversionFactors : [String : [String : Double]] =
        ["USD": ["USD": 1.0, "CAN": 0.5, "EUR": 1.25, "GBP": 1.5],
         "GBP": ["USD": 2.0, "CAN": 1.0, "EUR": 1.74, "GBP": 1.14],
         "EUR": ["USD": 1.24, "CAN": 0.88, "EUR": 1.53, "GBP": 1.0],
         "CAN": ["USD": 0.81, "CAN": 0.58, "EUR": 1.0,"GBP": 0.65]
    ]
    
    //make an edit to take out all throws and instead use assert!
    init(amount : Int, currency : String ) {
        self.amount = amount
        self.currency = currency
        checkCurrency(currency)
    }
    
    func checkCurrency(_ currency : String) {
        assert(currency != "USD" && currency != "CAN" && currency != "EUR" && currency != "GBP")
    }
    
    //MyMoney.convert("USD")
    public func convert(_ to: String) -> Money {
        checkCurrency(to)
        let factor : Double = conversionFactors[self.currency]![to]!
        let newMoney : Money = Money(amount: Int(Double(self.amount) * factor), currency: to)
        return newMoney
    }
  
    public func add(_ to: Money) -> Money {
        checkCurrency(to.currency)
        let tempMoney : Money = to.convert(self.currency)
        return Money(amount: (tempMoney.amount + self.amount), currency: self.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        checkCurrency(from.currency)
        let factor : Double = conversionFactors[self.currency]![from.currency]!
        return Money(amount: Int(Double(self.amount) - Double(from.amount) * factor), currency: from.currency)
    }

}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType

    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }

    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }

    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage * 2000)
        case .Salary(let value):
            return (value)
        }
    }

    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(var hourly):
            hourly = amt * hourly
        case .Salary(var salary):
            salary = Int(amt) * salary
        }
    }
}

////////////////////////////////////
// Person
//
//open class Person {
//  open var firstName : String = ""
//  open var lastName : String = ""
//  open var age : Int = 0
//
//  fileprivate var _job : Job? = nil
//  open var job : Job? {
//    get { }
//    set(value) {
//    }
//  }
//
//  fileprivate var _spouse : Person? = nil
//  open var spouse : Person? {
//    get { }
//    set(value) {
//    }
//  }
//
//  public init(firstName : String, lastName: String, age : Int) {
//    self.firstName = firstName
//    self.lastName = lastName
//    self.age = age
//  }
//
//  open func toString() -> String {
//  }
//}

////////////////////////////////////
// Family
//
//open class Family {
//  fileprivate var members : [Person] = []
//
//  public init(spouse1: Person, spouse2: Person) {
//  }
//
//  open func haveChild(_ child: Person) -> Bool {
//  }
//
//  open func householdIncome() -> Int {
//  }
//}





