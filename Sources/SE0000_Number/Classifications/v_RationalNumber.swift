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

// MARK: - RationalNumber
public enum RationalNumber: Codable, Equatable, Hashable {
    case natural(NaturalNumber)
    case whole(WholeNumber)
    case integer(Integer)
    case simpleFraction(SimpleFraction)

    public static let zero = RationalNumber(integerLiteral: 0)
    public static let one = RationalNumber(integerLiteral: 1)
    public static let two = RationalNumber(integerLiteral: 2)
    public static let ten = RationalNumber(integerLiteral: 10)
}

// MARK: - Magnitude
extension RationalNumber {
    public var magnitude: Self {
        switch self {
            case .natural(let naturalNumber):
                return .natural(naturalNumber.magnitude)
            case .whole(let wholeNumber):
                return .whole(wholeNumber.magnitude)
            case .integer(let integer):
                return .integer(integer.magnitude)
            case .simpleFraction(let fraction):
                return .simpleFraction(fraction.magnitude)
        }
    }
}

// MARK: - Negation
extension RationalNumber {
    public static prefix func - (operand: Self) -> Self {
        switch operand {
            case .natural(let naturalNumber):
                return self.init(-Integer(naturalNumber))
            case .whole(let wholeNumber):
                return self.init(-Integer(wholeNumber))
            case .integer(let integer):
                return self.init(-integer)
            case .simpleFraction(let fraction):
                return self.init(-fraction)
        }
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Standard Library Initializers
extension RationalNumber {
    public init<T: BinaryInteger>(exactly source: T) {
        self.init(ArbitraryPrecisionSignedInteger(source))
    }
}

// MARK: - Storage
extension RationalNumber {
    internal var isNaturalNumber: NaturalNumber? {
        switch self {
            case .natural(let naturalNumber): return naturalNumber
            default: return nil
        }
    }

    internal var isWholeNumber: WholeNumber? {
        switch self {
            case .whole(let wholeNumber): return wholeNumber
            default: return nil
        }
    }

    internal var isInteger: Integer? {
        switch self {
            case .integer(let integer): return integer
            default: return nil
        }
    }

    internal var isSimpleFraction: SimpleFraction? {
        switch self {
            case .simpleFraction(let simpleFraction): return simpleFraction
            default: return nil
        }
    }
}

// MARK: - Comparable
extension RationalNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: RationalNumber, rhs: NaturalNumber) -> Bool {
        return lhs < RationalNumber(rhs)
    }

    public static func < (lhs: RationalNumber, rhs: WholeNumber) -> Bool {
        return lhs < RationalNumber(rhs)
    }

    public static func < (lhs: RationalNumber, rhs: Integer) -> Bool {
        return lhs < RationalNumber(rhs)
    }

    public static func < (lhs: RationalNumber, rhs: SimpleFraction) -> Bool {
        return lhs < RationalNumber(rhs)
    }

    public static func < (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
        switch lhs {
            case .natural(let naturalNumber):
                return naturalNumber < rhs
            case .whole(let wholeNumber):
                return wholeNumber < rhs
            case .integer(let integer):
                return integer < rhs
            case .simpleFraction(let fraction):
                return fraction < rhs
        }
    }

    public static func < (lhs: RationalNumber, rhs: IrrationalNumber) -> Bool {
        return Number(lhs) < rhs._approximation
    }
}

extension RationalNumber { // Inverse Comparable
    public static func > (lhs: RationalNumber, rhs: NaturalNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: RationalNumber, rhs: WholeNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: RationalNumber, rhs: Integer) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: RationalNumber, rhs: SimpleFraction) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: RationalNumber, rhs: IrrationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension RationalNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        switch self {
            case .natural(let naturalNumber):
                return naturalNumber.description
            case .whole(let wholeNumber):
                return wholeNumber.description
            case .integer(let integer):
                return integer.description
            case .simpleFraction(let fraction):
                return fraction.description
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension RationalNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: StaticBigInt) {
        self.init(ArbitraryPrecisionSignedInteger(integerLiteral: value))
    }
}

// MARK: - Sendable
extension RationalNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension RationalNumber {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        if unsigned == .zero {
            self = .whole(WholeNumber.zero)
        } else {
            self = .natural(NaturalNumber(unsigned)!)
        }
    }
    
    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        if signed.isNegative == true {
            self.init(Integer(signed))
        } else {
            self.init(signed.magnitude)
        }
    }
}
    
/// Other Number Classification Initializers
extension RationalNumber {
    public init(_ natural: NaturalNumber) {
        self = .natural(natural)
    }
    
    public init(_ whole: WholeNumber) {
        guard let natural = NaturalNumber(whole) else {
            self = .whole(whole)
            return
        }
        self.init(natural)
    }
    
    public init(_ integer: Integer) {
        guard let whole = WholeNumber(integer) else {
            self = .integer(integer)
            return
        }
        self.init(whole)
    }
    
    public init(_ fraction: SimpleFraction) {
        guard let integer = Integer(fraction) else {
            self = .simpleFraction(fraction)
            return
        }
        self.init(integer)
    }
    
    public init?(_ real: RealNumber) {
        switch real {
            case .rational(let rationalNumber):
                switch rationalNumber {
                    case .natural(let naturalNumber):
                        self.init(naturalNumber)
                    case .whole(let wholeNumber):
                        self.init(wholeNumber)
                    case .integer(let integer):
                        self.init(integer)
                    case .simpleFraction(let fraction):
                        self.init(fraction)
                }
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
extension RationalNumber {
    /// As `RationalNumber`s are a RationalNumberal value, addition of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case .natural(let naturalNumber):
                return naturalNumber + rhs
            case .whole(let wholeNumber):
                return wholeNumber + rhs
            case .integer(let integer):
                return integer + rhs
            case .simpleFraction(let fraction):
                return fraction + rhs
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, subtraction of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case .natural(let naturalNumber):
                return naturalNumber - rhs
            case .whole(let wholeNumber):
                return wholeNumber - rhs
            case .integer(let integer):
                return integer - rhs
            case .simpleFraction(let fraction):
                return fraction - rhs
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, multiplication of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case .natural(let naturalNumber):
                return naturalNumber * rhs
            case .whole(let wholeNumber):
                return wholeNumber * rhs
            case .integer(let integer):
                return integer * rhs
            case .simpleFraction(let fraction):
                return fraction * rhs
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, division of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case .natural(let naturalNumber):
                return naturalNumber / rhs
            case .whole(let wholeNumber):
                return wholeNumber / rhs
            case .integer(let integer):
                return integer / rhs
            case .simpleFraction(let fraction):
                return fraction / rhs
        }
    }
}

/// `RationalNumber` & `IrrationalNumber` Operators
extension RationalNumber {
    /// As `RationalNumber` is a rational value, and `IrrationalNumber` is an irrational value; addition is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `RationalNumber` is a rational value, and `IrrationalNumber` is an irrational value; subtraction is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `RationalNumber` is a rational value, and `IrrationalNumber` is an irrational value; multiplication is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `RationalNumber` is a rational value, and `IrrationalNumber` is an irrational value; division is guaranteed to result in an `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
}
