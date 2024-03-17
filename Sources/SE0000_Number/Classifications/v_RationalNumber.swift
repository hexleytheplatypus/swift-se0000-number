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
    case n(NaturalNumber)
    case w(WholeNumber)
    case i(Integer)
    case f(SimpleFraction)

    public static let zero = RationalNumber(integerLiteral: 0)
    public static let one = RationalNumber(integerLiteral: 1)
    public static let two = RationalNumber(integerLiteral: 2)
    public static let ten = RationalNumber(integerLiteral: 10)
}

// MARK: - Magnitude
extension RationalNumber {
    public var magnitude: Self {
        switch self {
            case let .n(n): return .n(n.magnitude)
            case let .w(w): return .w(w.magnitude)
            case let .i(i): return .i(i.magnitude)
            case let .f(f): return .f(f.magnitude)
        }
    }
}

// MARK: - Negation
extension RationalNumber {
    public static prefix func - (operand: Self) -> Self {
        switch operand {
            case let .n(n): return self.init(-Integer(n))
            case let .w(w): return self.init(-Integer(w))
            case let .i(i): return self.init(-i)
            case let .f(f): return self.init(-f)
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
            case .n(let naturalNumber): return naturalNumber
            default: return nil
        }
    }

    internal var isWholeNumber: WholeNumber? {
        switch self {
            case .w(let wholeNumber): return wholeNumber
            default: return nil
        }
    }

    internal var isInteger: Integer? {
        switch self {
            case .i(let integer): return integer
            default: return nil
        }
    }

    internal var isSimpleFraction: SimpleFraction? {
        switch self {
            case .f(let simpleFraction): return simpleFraction
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
            case let .n(lhsN): return (lhsN < rhs)
            case let .w(lhsW): return (lhsW < rhs)
            case let .i(lhsI): return (lhsI < rhs)
            case let .f(lhsF): return (lhsF < rhs)
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
            case let .n(n): return n.description
            case let .w(w): return w.description
            case let .i(i): return i.description
            case let .f(f): return f.description
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
            self = .w(WholeNumber.zero)
        } else {
            self = .n(NaturalNumber(unsigned)!)
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
        self = .n(natural)
    }
    
    public init(_ whole: WholeNumber) {
        guard let natural = NaturalNumber(whole) else {
            self = .w(whole)
            return
        }
        self.init(natural)
    }
    
    public init(_ integer: Integer) {
        guard let whole = WholeNumber(integer) else {
            self = .i(integer)
            return
        }
        self.init(whole)
    }
    
    public init(_ fraction: SimpleFraction) {
        guard let integer = Integer(fraction) else {
            self = .f(fraction)
            return
        }
        self.init(integer)
    }
    
    public init?(_ real: RealNumber) {
        switch real {
            case .r(let rationalNumber):
                switch rationalNumber {
                    case let .n(n): self.init(n)
                    case let .w(w): self.init(w)
                    case let .i(i): self.init(i)
                    case let .f(f): self.init(f)
                }
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
extension RationalNumber {
    /// As `RationalNumber`s are a RationalNumberal value, addition of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case let .n(lhsN): return (lhsN + rhs)
            case let .w(lhsW): return (lhsW + rhs)
            case let .i(lhsI): return (lhsI + rhs)
            case let .f(lhsF): return (lhsF + rhs)
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, subtraction of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case let .n(lhsN): return (lhsN - rhs)
            case let .w(lhsW): return (lhsW - rhs)
            case let .i(lhsI): return (lhsI - rhs)
            case let .f(lhsF): return (lhsF - rhs)
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, multiplication of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case let .n(lhsN): return (lhsN * rhs)
            case let .w(lhsW): return (lhsW * rhs)
            case let .i(lhsI): return (lhsI * rhs)
            case let .f(lhsF): return (lhsF * rhs)
        }
    }
    
    /// As `RationalNumber`s are a RationalNumberal value, division of any two `RationalNumber` are guaranteed to result in a `RationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
        switch lhs {
            case let .n(lhsN): return (lhsN / rhs)
            case let .w(lhsW): return (lhsW / rhs)
            case let .i(lhsI): return (lhsI / rhs)
            case let .f(lhsF): return (lhsF / rhs)
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
