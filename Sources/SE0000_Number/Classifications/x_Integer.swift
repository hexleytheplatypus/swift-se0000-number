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

// MARK: - Integer
public struct Integer: Equatable, Hashable {
    let _storage: ArbitraryPrecisionSignedInteger
    
    public static let zero = Integer(integerLiteral: 0)
    public static let one = Integer(integerLiteral: 1)
    public static let two = Integer(integerLiteral: 2)
    public static let ten = Integer(integerLiteral: 10)
}

extension Integer {
    public var isZero: Bool { _storage.isZero }
}

// MARK: - Codable
extension Integer {
    enum CodingKeys: String, CodingKey {
        case numericData
    }
}

// MARK: - Magnitude
extension Integer {
    public var magnitude: Self {
        return Integer(self._storage.magnitude)
    }
}

// MARK: - Negation
extension Integer {
    public static prefix func - (operand: Self) -> Self {
        return self.init(_storage: -operand._storage)
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Sign
extension Integer {
    public var isNegative: Bool { _storage.isNegative }
}

// MARK: - Standard Library Initializers
extension Integer {
    public init<T: BinaryInteger>(exactly source: T) {
        self.init(ArbitraryPrecisionSignedInteger(source))
    }
}

// MARK: - Comparable
extension Integer: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: Integer, rhs: Integer) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: Integer, rhs: NaturalNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: Integer, rhs: WholeNumber) -> Bool {
        return lhs < Integer(rhs)
    }

    public static func < (lhs: Integer, rhs: SimpleFraction) -> Bool {
        return SimpleFraction(lhs) < rhs
    }

    public static func < (lhs: Integer, rhs: RationalNumber) -> Bool {
        switch rhs {
            case .n(let naturalNumber):
                return lhs < naturalNumber
            case .w(let wholeNumber):
                return lhs < wholeNumber
            case .i(let integer):
                return lhs < integer
            case .f(let fraction):
                return lhs < fraction
        }
    }
}

extension Integer { // Inverse Comparable
    public static func > (lhs: Integer, rhs: NaturalNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: Integer, rhs: WholeNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: Integer, rhs: SimpleFraction) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: Integer, rhs: RationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension Integer: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        return self._storage.description
    }
}

// MARK: - Decodable
extension Integer: Decodable {
    //===--- Decodable ------------------------------------------------------===//

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._storage = try values.decode(ArbitraryPrecisionSignedInteger.self, forKey: .numericData)
    }
}

// MARK: - Encodable
extension Integer: Encodable {
    //===--- Encodable ------------------------------------------------------===//

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_storage, forKey: .numericData)
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension Integer: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: StaticBigInt) {
        self.init(ArbitraryPrecisionSignedInteger(integerLiteral: value))
    }
}

// MARK: - Sendable
extension Integer: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension Integer {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        self._storage = ArbitraryPrecisionSignedInteger(unsigned)
    }
    
    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        self._storage = signed
    }
}

/// Other Number Classification Initializers
extension Integer {
    public init(_ natural: NaturalNumber) {
        self.init(natural._storage)
    }
    
    public init(_ whole: WholeNumber) {
        self.init(whole._storage)
    }
    
    public init?(_ fraction: SimpleFraction) {
        guard fraction.numerator != .zero else { self = .zero; return }
        guard fraction.denominator == .one else { return nil }
        self._storage = ArbitraryPrecisionSignedInteger(fraction.numerator, isNegative: fraction.isNegative)
    }
    
    public init?(_ rational: RationalNumber) {
        switch rational {
            case .n(let naturalNumber):
                self.init(naturalNumber)
            case .w(let wholeNumber):
                self.init(wholeNumber)
            case .i(let integer):
                self = integer
            case .f(let fraction):
                self.init(fraction)
        }
    }
    
    public init?(_ real: RealNumber) {
        switch real {
            case .r(let rationalNumber): self.init(rationalNumber)
            case .i(_): return nil
        }
    }
    
    public init?(_ number: Number) {
        switch number {
            case .r(let realNumber): self.init(realNumber)
            case .i(_): return nil
            case .c(_): return nil
        }
    }
}

/// Operators
extension Integer {
    /// As `Integer`s are positive, negative or `.zero` in value, addition of any two `Integer` are guaranteed to result in a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(_storage: lhs._storage + rhs._storage)
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, subtraction of any two `Integer` could result in a positive value (i.e. 3 - 2 = 1), a negative value (i.e. 2 - 3 = -1), or `.zero` itself (i.e. 1 - 1 = 0) ; therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(_storage: lhs._storage - rhs._storage)
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, multiplication of any two `Integer` are guaranteed to result in a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: Integer, rhs: Integer) -> Integer {
        return Integer(_storage: lhs._storage * rhs._storage)
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, division of any two `Integer` could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Integer, rhs: Integer) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage.magnitude, denominator: rhs._storage.magnitude, isNegative: lhs.isNegative != rhs.isNegative)
    }
}

/// `Integer` & `NaturalNumber` Operators
extension Integer {
    /// As `Integer`s are positive, negative or `.zero` in value, and `NaturalNumber` is a positive value; addition is guaranteed to result in an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: Integer, rhs: NaturalNumber) -> Integer {
        return Integer(_storage: lhs._storage + ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `NaturalNumber` is a positive value; subtraction could result in a positive value (i.e. 3 - 0 = 3) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: Integer, rhs: NaturalNumber) -> Integer {
        return Integer(_storage: lhs._storage - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `NaturalNumber` is a positive value; multiplication could result in a positive value (i.e. 3 * 2 = 6) or zero (i.e. 3 * 0 = 0); therefore we return a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: Integer, rhs: NaturalNumber) -> Integer {
        return Integer(_storage: lhs._storage * ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `NaturalNumber` is a positive value; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Integer, rhs: NaturalNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage.magnitude, denominator: rhs._storage, isNegative: lhs.isNegative)
    }
}

/// `Integer` & `WholeNumber` Operators
extension Integer {
    /// As `Integer`s are positive, negative or `.zero` in value, and `WholeNumber` is a positive value or `.zero`; addition is guaranteed to result in an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: Integer, rhs: WholeNumber) -> Integer {
        return Integer(_storage: lhs._storage + ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `WholeNumber` is a positive value or `.zero`; subtraction could result in a positive value (i.e. 3 - 0 = 3) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: Integer, rhs: WholeNumber) -> Integer {
        return Integer(_storage: lhs._storage - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `WholeNumber` is a positive value or `.zero`; multiplication could result in a positive value (i.e. 3 * 2 = 6) or zero (i.e. 3 * 0 = 0); therefore we return a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: Integer, rhs: WholeNumber) -> Integer {
        return Integer(_storage: lhs._storage * ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `WholeNumber` is a positive value or `.zero`; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Integer, rhs: WholeNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage.magnitude, denominator: rhs._storage, isNegative: lhs.isNegative)
    }
}

/// `Integer` & `SimpleFraction` Operators
extension Integer {
    /// As `Integer`s are positive, negative or `.zero` in value, and `SimpleFraction` is a fractional value; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: Integer, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) + rhs
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `SimpleFraction` is a fractional value; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: Integer, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) - rhs
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `SimpleFraction` is a fractional value; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: Integer, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) * rhs
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `SimpleFraction` is a fractional value; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Integer, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) / rhs
    }
}

/// `Integer` & `RationalNumber` Operators
extension Integer {
    /// As `Integer`s are positive, negative or `.zero` in value, and `RationalNumber` is a rational value; addition is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: Integer, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .n(let naturalNumber):
                return RationalNumber(lhs + naturalNumber)
            case .w(let wholeNumber):
                return RationalNumber(lhs + wholeNumber)
            case .i(let integer):
                return RationalNumber(lhs + integer)
            case .f(let fraction):
                return RationalNumber(lhs + fraction)
        }
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `RationalNumber` is a rational value; subtraction is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: Integer, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .n(let naturalNumber):
                return RationalNumber(lhs - naturalNumber)
            case .w(let wholeNumber):
                return RationalNumber(lhs - wholeNumber)
            case .i(let integer):
                return RationalNumber(lhs - integer)
            case .f(let fraction):
                return RationalNumber(lhs - fraction)
        }
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `RationalNumber` is a rational value; multiplication is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: Integer, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .n(let naturalNumber):
                return RationalNumber(lhs * naturalNumber)
            case .w(let wholeNumber):
                return RationalNumber(lhs * wholeNumber)
            case .i(let integer):
                return RationalNumber(lhs * integer)
            case .f(let fraction):
                return RationalNumber(lhs * fraction)
        }
    }
    
    /// As `Integer`s are positive, negative or `.zero` in value, and `RationalNumber` is a rational value; division is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Integer, rhs: RationalNumber) -> RationalNumber {
        switch rhs {
            case .n(let naturalNumber):
                return RationalNumber(lhs / naturalNumber)
            case .w(let wholeNumber):
                return RationalNumber(lhs / wholeNumber)
            case .i(let integer):
                return RationalNumber(lhs / integer)
            case .f(let fraction):
                return RationalNumber(lhs / fraction)
        }
    }
}
