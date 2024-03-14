//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArbitraryPrecisionIntegers

// MARK: - SimpleFraction
public struct SimpleFraction: Codable, Equatable, Hashable {
    private(set) var numerator: ArbitraryPrecisionUnsignedInteger
    private(set) var denominator: ArbitraryPrecisionUnsignedInteger
    public let isNegative: Bool

    public var isRepeating: Bool {
        var primeSet = Set(denominator.primeFactors)
        if primeSet.isEmpty {
            guard denominator == .two || denominator == 5 else {
                return true
            }
            return false
        }
        primeSet.remove(2)
        primeSet.remove(5)
        return !primeSet.isEmpty
    }
    
    public var reciprocal: SimpleFraction {
        return SimpleFraction(numerator: denominator, denominator: numerator, isNegative: isNegative)
    }
    
    public init(numerator: ArbitraryPrecisionUnsignedInteger, denominator: ArbitraryPrecisionUnsignedInteger, isNegative: Bool = false) {
        defer { self._simplify() }
        self.numerator = numerator
        self.denominator = denominator
        self.isNegative = isNegative
    }

    public init(numerator: Integer, denominator: Integer) {
        defer { self._simplify() }
        self.numerator = numerator._storage.magnitude
        self.denominator = denominator._storage.magnitude
        self.isNegative = !(numerator.isNegative == denominator.isNegative)
    }

    /// Private Methods
    private mutating func _simplify() {
        let greatestCommonFactor = numerator.greatestCommonDivisor(with: denominator)
        guard greatestCommonFactor != .one else { return } // Early exit; already simplified
        numerator /= greatestCommonFactor
        denominator /= greatestCommonFactor
    }
    
    private static func _commonize(lhs: SimpleFraction, rhs: SimpleFraction) -> (lhs: SimpleFraction, rhs: SimpleFraction) {
        guard lhs.denominator != rhs.denominator else { return (lhs, rhs) } // Early exit; already share common denominator
        let leastCommonMultiple = lhs.denominator.leastCommonMultiple(with: rhs.denominator)
        let lhsFactor = leastCommonMultiple / lhs.denominator
        let rhsFactor = leastCommonMultiple / rhs.denominator
        
        var lhsCopy = lhs
        lhsCopy.numerator = lhs.numerator * lhsFactor
        lhsCopy.denominator = leastCommonMultiple
        
        var rhsCopy = rhs
        rhsCopy.numerator = rhs.numerator * rhsFactor
        rhsCopy.denominator = leastCommonMultiple
        
        return (lhsCopy, rhsCopy)
    }
}

// MARK: - Magnitude
extension SimpleFraction {
    public var magnitude: Self {
        return SimpleFraction(numerator: self.numerator, denominator: self.denominator, isNegative: false)
    }
}

// MARK: - Negation
extension SimpleFraction {
    public static prefix func - (operand: Self) -> Self {
        return self.init(numerator: operand.numerator, denominator: operand.denominator, isNegative: !operand.isNegative)
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Static Properties
extension SimpleFraction {
    public static let zero = SimpleFraction(integerLiteral: 0)
    public static let one = SimpleFraction(integerLiteral: 1)
    public static let two = SimpleFraction(integerLiteral: 2)
    public static let ten = SimpleFraction(integerLiteral: 10)
}

// MARK: - Comparable
extension SimpleFraction: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: SimpleFraction, rhs: SimpleFraction) -> Bool {
        let (lhsCommon, rhsCommon) = _commonize(lhs: lhs, rhs: rhs)
        var lhsNumerator = Integer(lhsCommon.numerator)
        if lhs.isNegative { lhsNumerator = -lhsNumerator }
        var rhsNumerator = Integer(rhsCommon.numerator)
        if rhs.isNegative { rhsNumerator = -rhsNumerator }
        return lhsNumerator < rhsNumerator
    }

    public static func < (lhs: SimpleFraction, rhs: NaturalNumber) -> Bool {
        return lhs < SimpleFraction(rhs)
    }

    public static func < (lhs: SimpleFraction, rhs: WholeNumber) -> Bool {
        return lhs < SimpleFraction(rhs)
    }

    public static func < (lhs: SimpleFraction, rhs: Integer) -> Bool {
        return lhs < SimpleFraction(rhs)
    }

    public static func < (lhs: SimpleFraction, rhs: RationalNumber) -> Bool {
        switch rhs {
            case .natural(let naturalNumber):
                return lhs < naturalNumber
            case .whole(let wholeNumber):
                return lhs < wholeNumber
            case .integer(let integer):
                return lhs < integer
            case .simpleFraction(let fraction):
                return lhs < fraction
        }
    }
}

extension SimpleFraction { // Inverse Comparable
    public static func > (lhs: SimpleFraction, rhs: NaturalNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: SimpleFraction, rhs: WholeNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: SimpleFraction, rhs: Integer) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: SimpleFraction, rhs: RationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension SimpleFraction: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        // TODO: - Audit Heuretics: Should this return a decimal when it is terminating and a fraction when repeating.
        var result = ""
        if self.isNegative {
            result.append("-")
        }
        result.append("\(numerator) / \(denominator)")
        return "(" + result + ")"
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension SimpleFraction: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: StaticBigInt) {
        self.init(Integer(integerLiteral: value))
    }
}

// MARK: - Sendable
extension SimpleFraction: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension SimpleFraction {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        self.numerator = unsigned
        self.denominator = .one
        self.isNegative = false
    }
    
    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        self.numerator = signed.magnitude
        self.denominator = .one
        self.isNegative = signed.isNegative
    }
}

/// Other Number Classification Initializers
extension SimpleFraction {
    public init(_ natural: NaturalNumber) {
        self.init(natural._storage)
    }
    
    public init(_ whole: WholeNumber) {
        self.init(whole._storage)
    }
    
    public init(_ integer: Integer) {
        self.init(integer._storage)
    }
    
    public init(_ rational: RationalNumber) {
        switch rational {
            case .natural(let naturalNumber):
                self.init(naturalNumber)
            case .whole(let wholeNumber):
                self.init(wholeNumber)
            case .integer(let integer):
                self.init(integer)
            case .simpleFraction(let fraction):
                self = fraction
        }
    }
    
    public init?(_ real: RealNumber) {
        switch real {
            case .rational(let rationalNumber): self.init(rationalNumber)
            case .irrational(_): return nil
        }
    }
    
    public init?(_ number: Number) {
        switch number {
            case .real(let realNumber): self.init(realNumber)
            case .imaginary(_): return nil
            case .complex(_): return nil
        }
    }
}

/// Operators
extension SimpleFraction {
    /// As `SimpleFraction`s are a fractional value, addition of any two `SimpleFraction` are guaranteed to result in a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: SimpleFraction, rhs: SimpleFraction) -> SimpleFraction {
        let (lhsCommon, rhsCommon) = _commonize(lhs: lhs, rhs: rhs)
        let lhsNumerator = ArbitraryPrecisionSignedInteger(lhsCommon.numerator, isNegative: lhs.isNegative)
        let rhsNumerator = ArbitraryPrecisionSignedInteger(rhsCommon.numerator, isNegative: rhs.isNegative)
        let result = lhsNumerator + rhsNumerator
        return SimpleFraction(numerator: result.magnitude, denominator: lhsCommon.denominator, isNegative: result.isNegative)
    }
    
    /// As `SimpleFraction`s are a fractional value, subtraction of any two `SimpleFraction` are guaranteed to result in a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: SimpleFraction, rhs: SimpleFraction) -> SimpleFraction {
        let (lhsCommon, rhsCommon) = _commonize(lhs: lhs, rhs: rhs)
        let lhsNumerator = ArbitraryPrecisionSignedInteger(lhsCommon.numerator, isNegative: lhs.isNegative)
        let rhsNumerator = ArbitraryPrecisionSignedInteger(rhsCommon.numerator, isNegative: rhs.isNegative)
        let result = lhsNumerator - rhsNumerator
        return SimpleFraction(numerator: result.magnitude, denominator: lhsCommon.denominator, isNegative: result.isNegative)
    }
    
    /// As `SimpleFraction`s are a fractional value, multiplication of any two `SimpleFraction` are guaranteed to result in a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: SimpleFraction, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator, isNegative: lhs.isNegative != rhs.isNegative)
    }
    
    /// As `SimpleFraction`s are a fractional value, division of any two `SimpleFraction` are guaranteed to result in a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: SimpleFraction, rhs: SimpleFraction) -> SimpleFraction {
        precondition(rhs.numerator.isZero == false, "Division by 0 is undefined")
        return lhs * rhs.reciprocal
    }
}

/// `SimpleFraction` & `NaturalNumber` Operators
extension NaturalNumber {
    /// As `SimpleFraction` is a fractional value, and `NaturalNumber` is a positive value; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: SimpleFraction, rhs: NaturalNumber) -> SimpleFraction {
        return lhs + SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `NaturalNumber` is a positive value; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: SimpleFraction, rhs: NaturalNumber) -> SimpleFraction {
        return lhs - SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `NaturalNumber` is a positive value; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: SimpleFraction, rhs: NaturalNumber) -> SimpleFraction {
        return lhs * SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `NaturalNumber` is a positive value; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: SimpleFraction, rhs: NaturalNumber) -> SimpleFraction {
        return lhs / SimpleFraction(rhs)
    }
}

/// `SimpleFraction` & `WholeNumber` Operators
extension WholeNumber {
    /// As `SimpleFraction` is a fractional value, and `WholeNumber` is a positive value or `.zero`; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: SimpleFraction, rhs: WholeNumber) -> SimpleFraction {
        return lhs + SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `WholeNumber` is a positive value or `.zero`; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: SimpleFraction, rhs: WholeNumber) -> SimpleFraction {
        return lhs - SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `WholeNumber` is a positive value or `.zero`; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: SimpleFraction, rhs: WholeNumber) -> SimpleFraction {
        return lhs * SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `WholeNumber` is a positive value or `.zero`; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: SimpleFraction, rhs: WholeNumber) -> SimpleFraction {
        return lhs / SimpleFraction(rhs)
    }
}

/// `SimpleFraction` & `Integer` Operators
extension Integer {
    /// As `SimpleFraction` is a fractional value, and `Integer`s are positive, negative or `.zero` in value; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: SimpleFraction, rhs: Integer) -> SimpleFraction {
        return lhs + SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `Integer`s are positive, negative or `.zero` in value; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: SimpleFraction, rhs: Integer) -> SimpleFraction {
        return lhs - SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `Integer`s are positive, negative or `.zero` in value; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: SimpleFraction, rhs: Integer) -> SimpleFraction {
        return lhs * SimpleFraction(rhs)
    }
    
    /// As `SimpleFraction` is a fractional value, and `Integer`s are positive, negative or `.zero` in value; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: SimpleFraction, rhs: Integer) -> SimpleFraction {
        return lhs / SimpleFraction(rhs)
    }
}

/// `SimpleFraction` & `RationalNumber` Operators
extension SimpleFraction {
    /// As `SimpleFraction` is a fractional value, and `RationalNumber` is a rational value; addition is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: SimpleFraction, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .natural(let naturalNumber):
                return RationalNumber(lhs + naturalNumber)
            case .whole(let wholeNumber):
                return RationalNumber(lhs + wholeNumber)
            case .integer(let integer):
                return RationalNumber(lhs + integer)
            case .simpleFraction(let fraction):
                return RationalNumber(lhs + fraction)
        }
    }
    
    /// As `SimpleFraction` is a fractional value, and `RationalNumber` is a rational value; subtraction is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: SimpleFraction, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .natural(let naturalNumber):
                return RationalNumber(lhs - naturalNumber)
            case .whole(let wholeNumber):
                return RationalNumber(lhs - wholeNumber)
            case .integer(let integer):
                return RationalNumber(lhs - integer)
            case .simpleFraction(let fraction):
                return RationalNumber(lhs - fraction)
        }
    }
    
    /// As `SimpleFraction` is a fractional value, and `RationalNumber` is a rational value; multiplication is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: SimpleFraction, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .natural(let naturalNumber):
                return RationalNumber(lhs * naturalNumber)
            case .whole(let wholeNumber):
                return RationalNumber(lhs * wholeNumber)
            case .integer(let integer):
                return RationalNumber(lhs * integer)
            case .simpleFraction(let fraction):
                return RationalNumber(lhs * fraction)
        }
    }
    
    /// As `SimpleFraction` is a fractional value, and `RationalNumber` is a rational value; division is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: SimpleFraction, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .natural(let naturalNumber):
                return RationalNumber(lhs / naturalNumber)
            case .whole(let wholeNumber):
                return RationalNumber(lhs / wholeNumber)
            case .integer(let integer):
                return RationalNumber(lhs / integer)
            case .simpleFraction(let fraction):
                return RationalNumber(lhs / fraction)
        }
    }
}
