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
        ["USD": ["USD": 1.0, "GBP": 0.5, "CAN": 1.25, "EUR": 1.5],
         "GBP": ["USD": 2.0, "GBP": 1.0, "CAN": 1.74, "EUR": 1.14],
         "EUR": ["USD": 2/3, "GBP": 0.88, "CAN": 1.53, "EUR": 1.0],
         "CAN": ["USD": 0.81, "GBP": 0.58, "CAN": 1.0,"EUR": 0.65]
    ]
    
    //make an edit to take out all throws and instead use assert!
    init(amount : Int, currency : String ) {
        self.amount = amount
        self.currency = currency
        checkCurrency(currency)
    }
    
    func checkCurrency(_ currency : String) {
        assert(currency == "USD" || currency == "CAN" || currency == "EUR" || currency == "GBP")
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
        let tempMoney : Money = convert(to.currency)
        return Money(amount: (tempMoney.amount + to.amount), currency: to.currency)
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
            print("After a raise the hourly wage is: \(Int(wage * Double(hours)))")
            return Int(wage * Double(hours))
        case .Salary(let value):
            print("After a raise the salary is: \(value)")
            return (value)
        }
    }

    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let hourly):
            self.type = JobType.Hourly(amt + hourly)
        case .Salary(let salary):
            self.type = JobType.Salary(Int(amt + Double(salary)))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if(age > 21) {
                _job = value
            }
        }
    }

    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if(age > 21) {
                _spouse = value
            }
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job?.title) spouse:\(_spouse?.firstName)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    func preMarriageCheck(_ spouse1: Person, _ spouse2: Person) {
       assert(spouse1._spouse == nil && spouse2._spouse == nil)
    }

    public init(spouse1: Person, spouse2: Person) {
        preMarriageCheck(spouse1, spouse2)
        members.append(spouse1)
        members.append(spouse2)
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
    }

    open func haveChild(_ child: Person) -> Bool {
        if(members[0].age > 21 && members[1].age > 21) {
            members.append(child)
            return true
        }
        return false
    }

    open func householdIncome() -> Int {
        var totalIncome : Int = 0;
        for person in members {
            if(person._job != nil) {
                totalIncome = totalIncome + (person._job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
}





