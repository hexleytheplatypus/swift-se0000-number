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

// MARK: - WholeNumber
public struct WholeNumber: Equatable, Hashable {
    let _storage: ArbitraryPrecisionUnsignedInteger
    
    public static let zero = WholeNumber(integerLiteral: 0)
    public static let one = WholeNumber(integerLiteral: 1)
    public static let two = WholeNumber(integerLiteral: 2)
    public static let ten = WholeNumber(integerLiteral: 10)

    // MARK: - Sign
    public let isNegative: Bool = false
}

extension WholeNumber {
    public var isZero: Bool { _storage.isZero }
}

// MARK: - Standard Library Initializers
extension WholeNumber {
    public init?<T: BinaryInteger>(exactly source: T) {
        self.init(ArbitraryPrecisionSignedInteger(source))
    }
}

// MARK: - Codable
extension WholeNumber {
    enum CodingKeys: String, CodingKey {
        case numericData
    }
}

// MARK: - Magnitude
extension WholeNumber {
    public var magnitude: Self {
        return self
    }
}

// MARK: - isMultiple
extension WholeNumber {
    func isMultiple(of other: WholeNumber) -> Bool {
        return self._storage.isMultiple(of: other._storage)
    }
}

// MARK: - Negation
extension WholeNumber {
    public static prefix func - (operand: Self) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(operand._storage, isNegative: true))
    }
}

// MARK: - Comparable
extension WholeNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: WholeNumber, rhs: WholeNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: WholeNumber, rhs: NaturalNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: WholeNumber, rhs: Integer) -> Bool {
        return Integer(lhs) < rhs
    }

    public static func < (lhs: WholeNumber, rhs: SimpleFraction) -> Bool {
        return SimpleFraction(lhs) < rhs
    }

    public static func < (lhs: WholeNumber, rhs: RationalNumber) -> Bool {
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

extension WholeNumber { // Inverse Comparable
    public static func > (lhs: WholeNumber, rhs: NaturalNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: WholeNumber, rhs: Integer) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: WholeNumber, rhs: SimpleFraction) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: WholeNumber, rhs: RationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension WholeNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        return self._storage.description
    }
}

// MARK: - Decodable
extension WholeNumber: Decodable {
    //===--- Decodable ------------------------------------------------------===//

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._storage = try values.decode(ArbitraryPrecisionUnsignedInteger.self, forKey: .numericData)
    }
}

// MARK: - Encodable
extension WholeNumber: Encodable {
    //===--- Encodable ------------------------------------------------------===//

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_storage, forKey: .numericData)
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension WholeNumber: ExpressibleByIntegerLiteral {
    //===--- ExpressibleByIntegerLiteral ------------------------------------===//

    public init(integerLiteral value: StaticBigInt) {
        let signed = ArbitraryPrecisionSignedInteger(integerLiteral: value)
        precondition(signed.isNegative == false, "Negative values are not a valid value for Whole Number.")
        self.init(signed)!
    }
}

// MARK: - Sendable
extension WholeNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension WholeNumber {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        self._storage = unsigned
    }
    
    public init?(_ signed: ArbitraryPrecisionSignedInteger) {
        guard signed.isNegative == false else { return nil }
        self._storage = signed.magnitude
    }
}

/// Other Number Classification Initializers
extension WholeNumber {
    public init(_ natural: NaturalNumber) {
        self.init(natural._storage)
    }
    
    public init?(_ integer: Integer) {
        self.init(integer._storage)
    }
    
    public init?(_ fraction: SimpleFraction) {
//        guard fraction.numerator != .zero else { self = .zero; return }
        guard fraction.isNegative == false, fraction.numerator != .zero else { return nil } /// This catches "-0" and allows "0" to make it to storage.
        guard fraction.denominator == .one else { return nil }
        self._storage = fraction.numerator
    }
    
    public init?(_ rational: RationalNumber) {
        switch rational {
            case .n(let naturalNumber):
                self.init(naturalNumber)
            case .w(let wholeNumber):
                self = wholeNumber
            case .i(let integer):
                self.init(integer)
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
extension WholeNumber {
    /// As `WholeNumber`s are only positive value or `.zero`, addition of any two `WholeNumber` are guaranteed to result in a `WholeNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: WholeNumber, rhs: WholeNumber) -> WholeNumber {
        return WholeNumber(_storage: lhs._storage + rhs._storage)
    }
    
    /// As `WholeNumber`s are only positive value or `.zero`, subtraction of any two `WholeNumber` could result in a positive value (i.e. 3 - 2 = 1) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: WholeNumber, rhs: WholeNumber) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `WholeNumber`s are only positive value or `.zero`, multiplication of any two `WholeNumber` are guaranteed to result in a `WholeNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: WholeNumber, rhs: WholeNumber) -> WholeNumber {
        return WholeNumber(_storage: lhs._storage * rhs._storage)
    }
    
    /// As `WholeNumber`s are only positive value or `.zero`, division of any two `WholeNumber` could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: WholeNumber, rhs: WholeNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage, isNegative: false)
    }
}

/// `WholeNumber` & `NaturalNumber` Operators
extension WholeNumber {
    /// As `WholeNumber` is a positive value or `.zero`, and `NaturalNumber` is a positive value; addition is guaranteed to result in a `NaturalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: WholeNumber, rhs: NaturalNumber) -> NaturalNumber {
        guard lhs._storage.isZero == false else { return rhs }
        return NaturalNumber(_storage: lhs._storage + rhs._storage)
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `NaturalNumber` is a positive value; subtraction could result in a positive value (i.e. 3 - 2 = 1) or a negative value (i.e. 0 - 3 = -3); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: WholeNumber, rhs: NaturalNumber) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `NaturalNumber` is a positive value; multiplication could result in a positive value (i.e. 2 * 3 = 6) or zero (i.e. 0 * 3 = 0); therefore we return a `WholeNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: WholeNumber, rhs: NaturalNumber) -> WholeNumber {
        return WholeNumber(_storage: lhs._storage * rhs._storage)
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `NaturalNumber` is a positive value; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: WholeNumber, rhs: NaturalNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage, isNegative: false)
    }
}

/// `WholeNumber` & `Integer` Operators
extension WholeNumber {
    /// As `WholeNumber` is a positive value or `.zero`, and `Integer`s are positive, negative or `.zero` in value; addition is guaranteed to result in an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: WholeNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) + rhs._storage)
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `Integer`s are positive, negative or `.zero` in value; subtraction could result in a positive value (i.e. 3 - 0 = 3) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: WholeNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - rhs._storage)
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `Integer`s are positive, negative or `.zero` in value; multiplication could result in a positive value (i.e. 3 * 2 = 6) or zero (i.e. 3 * 0 = 0); therefore we return a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: WholeNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) * rhs._storage)
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `Integer`s are positive, negative or `.zero` in value; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: WholeNumber, rhs: Integer) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage.magnitude, isNegative: rhs.isNegative)
    }
}

/// `WholeNumber` & `SimpleFraction` Operators
extension WholeNumber {
    /// As `WholeNumber` is a positive value or `.zero`, and `SimpleFraction` is a fractional value; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: WholeNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) + rhs
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `SimpleFraction` is a fractional value; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: WholeNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) - rhs
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `SimpleFraction` is a fractional value; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: WholeNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) * rhs
    }
    
    /// As `WholeNumber` is a positive value or `.zero`, and `SimpleFraction` is a fractional value; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: WholeNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) / rhs
    }
}

/// `WholeNumber` & `RationalNumber` Operators
extension WholeNumber {
    /// As `WholeNumber` is a positive value or `.zero`, and `RationalNumber` is a rational value; addition is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: WholeNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `WholeNumber` is a positive value or `.zero`, and `RationalNumber` is a rational value; subtraction is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: WholeNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `WholeNumber` is a positive value or `.zero`, and `RationalNumber` is a rational value; multiplication is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: WholeNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `WholeNumber` is a positive value or `.zero`, and `RationalNumber` is a rational value; division is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: WholeNumber, rhs: RationalNumber) -> RationalNumber {
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
