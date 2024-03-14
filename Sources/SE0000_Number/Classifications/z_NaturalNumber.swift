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

// MARK: - NaturalNumber
public struct NaturalNumber: Equatable, Hashable {
    let _storage: ArbitraryPrecisionUnsignedInteger

    public static let one = NaturalNumber(integerLiteral: 1)
    public static let two = NaturalNumber(integerLiteral: 2)
    public static let ten = NaturalNumber(integerLiteral: 10)

    // MARK: - Sign
    public let isNegative: Bool = false
}

// MARK: - Magnitude
extension NaturalNumber {
    public var magnitude: Self {
        return self
    }
}

// MARK: - Negation
extension NaturalNumber {
    public static prefix func - (operand: Self) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(operand._storage, isNegative: true))
    }
}

// MARK: - Standard Library Initializers
extension NaturalNumber {
    public init?<T: BinaryInteger>(exactly source: T) {
        self.init(ArbitraryPrecisionUnsignedInteger(source))
    }
}

// MARK: - Codable
extension NaturalNumber {
    enum CodingKeys: String, CodingKey {
        case numericData
    }
}

// MARK: - Comparable
extension NaturalNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: NaturalNumber, rhs: NaturalNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: NaturalNumber, rhs: WholeNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: NaturalNumber, rhs: Integer) -> Bool {
        return Integer(lhs) < rhs
    }

    public static func < (lhs: NaturalNumber, rhs: SimpleFraction) -> Bool {
        return SimpleFraction(lhs) < rhs
    }

    public static func < (lhs: NaturalNumber, rhs: RationalNumber) -> Bool {
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

extension NaturalNumber { // Inverse Comparable
    public static func > (lhs: NaturalNumber, rhs: WholeNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: NaturalNumber, rhs: Integer) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: NaturalNumber, rhs: SimpleFraction) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: NaturalNumber, rhs: RationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension NaturalNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        return self._storage.description
    }
}

// MARK: - Decodable
extension NaturalNumber: Decodable {
    //===--- Decodable ------------------------------------------------------===//

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._storage = try values.decode(ArbitraryPrecisionUnsignedInteger.self, forKey: .numericData)
    }
}

// MARK: - Encodable
extension NaturalNumber: Encodable {
    //===--- Encodable ------------------------------------------------------===//
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_storage, forKey: .numericData)
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension NaturalNumber: ExpressibleByIntegerLiteral {
    //===--- ExpressibleByIntegerLiteral ------------------------------------===//

    public init(integerLiteral value: StaticBigInt) {
        let signed = ArbitraryPrecisionSignedInteger(integerLiteral: value)
        precondition(signed.isNegative == false, "Negative values are not a valid value for Natural Number.")
        precondition(signed != .zero, "Zero is not a valid value for Natural Number.")
        self.init(signed)!
    }
}

// MARK: - Factorial
extension NaturalNumber {
    public func factorial() -> NaturalNumber {
        let factorial = self._storage.factorial()
        /// `Force Unwrap` because failure is mathematically impossible
        return NaturalNumber(factorial)!
    }
}

// MARK: - Sendable
extension NaturalNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension NaturalNumber {
    public init?(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        guard unsigned != .zero else { return nil }
        self._storage = unsigned
    }
    
    public init?(_ signed: ArbitraryPrecisionSignedInteger) {
        guard signed.isNegative == false else { return nil }
        guard signed != .zero else { return nil }
        self._storage = signed.magnitude
    }
}

/// Other Number Classification Initializers
extension NaturalNumber {
    public init?(_ whole: WholeNumber) {
        self.init(whole._storage)
    }
    
    public init?(_ integer: Integer) {
        self.init(integer._storage)
    }
    
    public init?(_ fraction: SimpleFraction) {
        guard fraction.isNegative == false else { return nil }
        guard fraction.denominator == .one else { return nil }
        guard fraction.numerator != .zero else { return nil }
        self._storage = fraction.numerator
    }
    
    public init?(_ rational: RationalNumber) {
        switch rational {
            case .natural(let naturalNumber):
                self = naturalNumber
            case .whole(let wholeNumber):
                self.init(wholeNumber)
            case .integer(let integer):
                self.init(integer)
            case .simpleFraction(let fraction):
                self.init(fraction)
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

/// `NaturalNumber` Operators
extension NaturalNumber {
    /// As `NaturalNumber`s are only positive values, addition of any two `NaturalNumber` are guaranteed to result in a `NaturalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: NaturalNumber, rhs: NaturalNumber) -> NaturalNumber {
        return NaturalNumber(_storage: lhs._storage + rhs._storage)
    }
    
    /// As `NaturalNumber`s are only positive values, subtraction of any two `NaturalNumber` could result in a positive value (i.e. 3 - 2 = 1) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: NaturalNumber, rhs: NaturalNumber) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `NaturalNumber`s are only positive values, multiplication of any two `NaturalNumber` are guaranteed to result in a `NaturalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: NaturalNumber, rhs: NaturalNumber) -> NaturalNumber {
        return NaturalNumber(_storage: lhs._storage * rhs._storage)
    }
    
    /// As `NaturalNumber`s are only positive values, division of any two `NaturalNumber` could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: NaturalNumber, rhs: NaturalNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage, isNegative: false)
    }
}

/// `NaturalNumber` & `WholeNumber` Operators
extension NaturalNumber {
    /// As `NaturalNumber` is a positive value, and `WholeNumber` is a positive value or `.zero`; addition is guaranteed to result in a `NaturalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: NaturalNumber, rhs: WholeNumber) -> NaturalNumber {
        guard rhs._storage.isZero == false else { return lhs }
        return NaturalNumber(_storage: lhs._storage + rhs._storage)
    }
    
    /// As `NaturalNumber` is a positive value, and `WholeNumber` is a positive value or `.zero`; subtraction could result in a positive value (i.e. 3 - 0 = 3) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: NaturalNumber, rhs: WholeNumber) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - ArbitraryPrecisionSignedInteger(rhs._storage))
    }
    
    /// As `NaturalNumber` is a positive value, and `WholeNumber` is a positive value or `.zero`; multiplication could result in a positive value (i.e. 3 * 2 = 6) or zero (i.e. 3 * 0 = 0); therefore we return a `WholeNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: NaturalNumber, rhs: WholeNumber) -> WholeNumber {
        return WholeNumber(_storage: lhs._storage * rhs._storage)
    }
    
    /// As `NaturalNumber` is a positive value, and `WholeNumber` is a positive value or `.zero`; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: NaturalNumber, rhs: WholeNumber) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage, isNegative: false)
    }
}

/// `NaturalNumber` & `Integer` Operators
extension NaturalNumber {
    /// As `NaturalNumber` is a positive value, and `Integer`s are positive, negative or `.zero` in value; addition is guaranteed to result in an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: NaturalNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) + rhs._storage)
    }
    
    /// As `NaturalNumber` is a positive value, and `Integer`s are positive, negative or `.zero` in value; subtraction could result in a positive value (i.e. 3 - 0 = 3) or a negative value (i.e. 2 - 3 = -1); therefore we return an `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: NaturalNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) - rhs._storage)
    }
    
    /// As `NaturalNumber` is a positive value, and `Integer`s are positive, negative or `.zero` in value; multiplication could result in a positive value (i.e. 3 * 2 = 6) or zero (i.e. 3 * 0 = 0); therefore we return a `Integer`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: NaturalNumber, rhs: Integer) -> Integer {
        return Integer(_storage: ArbitraryPrecisionSignedInteger(lhs._storage) * rhs._storage)
    }
    
    /// As `NaturalNumber` is a positive value, and `Integer`s are positive, negative or `.zero` in value; division could result in a positive whole value (i.e. 2 / 2 = 1) or a fractional value (i.e. 2 / 3); therefore we return a `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: NaturalNumber, rhs: Integer) -> SimpleFraction {
        return SimpleFraction(numerator: lhs._storage, denominator: rhs._storage.magnitude, isNegative: rhs.isNegative)
    }
}

/// `NaturalNumber` & `SimpleFraction` Operators
extension NaturalNumber {
    /// As `NaturalNumber` is a positive value, and `SimpleFraction` is a fractional value; addition is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: NaturalNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) + rhs
    }
    
    /// As `NaturalNumber` is a positive value, and `SimpleFraction` is a fractional value; subtraction is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: NaturalNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) - rhs
    }
    
    /// As `NaturalNumber` is a positive value, and `SimpleFraction` is a fractional value; multiplication is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: NaturalNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) * rhs
    }
    
    /// As `NaturalNumber` is a positive value, and `SimpleFraction` is a fractional value; division is guaranteed to result in an `SimpleFraction`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: NaturalNumber, rhs: SimpleFraction) -> SimpleFraction {
        return SimpleFraction(lhs) / rhs
    }
}

/// `NaturalNumber` & `RationalNumber` Operators
extension NaturalNumber {
    /// As `NaturalNumber` is a positive value, and `RationalNumber` is a rational value; addition is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: NaturalNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `NaturalNumber` is a positive value, and `RationalNumber` is a rational value; subtraction is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: NaturalNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `NaturalNumber` is a positive value, and `RationalNumber` is a rational value; multiplication is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: NaturalNumber, rhs: RationalNumber) -> RationalNumber {
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
    
    /// As `NaturalNumber` is a positive value, and `RationalNumber` is a rational value; division is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: NaturalNumber, rhs: RationalNumber) -> RationalNumber {
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
