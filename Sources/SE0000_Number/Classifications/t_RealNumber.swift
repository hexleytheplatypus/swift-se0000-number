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

// MARK: - RealNumber
public indirect enum RealNumber: Codable, Equatable, Hashable {
    case r(RationalNumber)
    case i(IrrationalNumber)

    public static let zero = RealNumber(integerLiteral: 0)
    public static let one = RealNumber(integerLiteral: 1)
    public static let two = RealNumber(integerLiteral: 2)
    public static let ten = RealNumber(integerLiteral: 10)
}

// MARK: - Magnitude
extension RealNumber {
    public var magnitude: Self {
        switch self {
            case let .r(r): return .r(r.magnitude)
            case let .i(i): return .i(i.magnitude)
        }
    }
}

// MARK: - Negation
extension RealNumber {
    public static prefix func - (operand: Self) -> Self {
        switch operand {
            case let .r(r): return self.init(-r)
            case let .i(i): return self.init(-i)
        }
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Standard Library Initializers
extension RealNumber {
    public init<T: BinaryInteger>(exactly source: T) {
        self.init(ArbitraryPrecisionSignedInteger(source))
    }
}

// MARK: - Comparable
extension RealNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: RealNumber, rhs: RealNumber) -> Bool {
        switch (lhs, rhs) {
            case let (.r(lhsR), .r(rhsR)): return (lhsR < rhsR)
            case let (.r(lhsR), .i(rhsI)): return (lhsR < rhsI)
            case let (.i(lhsI), .r(rhsR)): return (lhsI < rhsR)
            case let (.i(lhsI), .i(rhsI)): return (lhsI < rhsI)
        }
    }

    public static func < (lhs: RealNumber, rhs: ImaginaryNumber) -> Bool {
        if lhs > .zero { return false }
        if lhs < .zero { return true }
        if rhs._storage > .zero { return true }
        if rhs._storage < .zero { return false }
        return false /// Everything is `.zero`
    }

    public static func < (lhs: RealNumber, rhs: ComplexNumber) -> Bool {
        if lhs > rhs._real { return false }
        if lhs < rhs._real { return true }
        if rhs._imaginary._storage > .zero { return true }
        if rhs._imaginary._storage < .zero { return false }
        return false /// Everything is `.zero`
    }
}

extension RealNumber { // Inverse Comparable
    public static func > (lhs: RealNumber, rhs: ImaginaryNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: RealNumber, rhs: ComplexNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension RealNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        switch self {
            case let .r(r): return r.description
            case let .i(i): return i.description
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension RealNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: StaticBigInt) {
        self.init(ArbitraryPrecisionSignedInteger(integerLiteral: value))
    }
}

// MARK: - Sendable
extension RealNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Arbitrary Precision Initializers
extension RealNumber {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        self = .r(RationalNumber(unsigned))
    }
    
    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        self = .r(RationalNumber(signed))
    }
}
    
/// Other Number Classification Initializers
extension RealNumber {
    public init(_ natural: NaturalNumber) {
        self = .r(RationalNumber(natural))
    }
    
    public init(_ whole: WholeNumber) {
        self = .r(RationalNumber(whole))
    }
    
    public init(_ integer: Integer) {
        self = .r(RationalNumber(integer))
    }
    
    public init(_ fraction: SimpleFraction) {
        self = .r(RationalNumber(fraction))
    }
    
    public init(_ rational: RationalNumber) {
        self = .r(rational)
    }
    
    public init(_ irrational: IrrationalNumber) {
        self = .i(irrational)
    }

    public init?(_ number: Number) {
        switch number {
            case .r(let realNumber):
                switch realNumber {
                    case .r(let rationalNumber): self.init(rationalNumber)
                    case .i(let irrationalNumber): self.init(irrationalNumber)
                }
            case .i(_): return nil
            case .c(_): return nil
        }
    }
}

/// Operators
extension RealNumber {
    /// As `RealNumber`s are a RealNumberal value, addition of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch (lhs, rhs) {
            case let (.r(lhsR), .r(rhsR)): return self.init(lhsR + rhsR)
            case let (.r(lhsR), .i(rhsI)): return self.init(lhsR + rhsI)
            case let (.i(lhsI), .r(rhsR)): return self.init(lhsI + rhsR)
            case let (.i(lhsI), .i(rhsI)): return self.init(lhsI + rhsI)
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, subtraction of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch (lhs, rhs) {
            case let (.r(lhsR), .r(rhsR)): return self.init(lhsR - rhsR)
            case let (.r(lhsR), .i(rhsI)): return self.init(lhsR - rhsI)
            case let (.i(lhsI), .r(rhsR)): return self.init(lhsI - rhsR)
            case let (.i(lhsI), .i(rhsI)): return self.init(lhsI - rhsI)
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, multiplication of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch (lhs, rhs) {
            case let (.r(lhsR), .r(rhsR)): return self.init(lhsR * rhsR)
            case let (.r(lhsR), .i(rhsI)): return self.init(lhsR * rhsI)
            case let (.i(lhsI), .r(rhsR)): return self.init(lhsI * rhsR)
            case let (.i(lhsI), .i(rhsI)): return self.init(lhsI * rhsI)
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, division of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch (lhs, rhs) {
            case let (.r(lhsR), .r(rhsR)): return self.init(lhsR / rhsR)
            case let (.r(lhsR), .i(rhsI)): return self.init(lhsR / rhsI)
            case let (.i(lhsI), .r(rhsR)): return self.init(lhsI / rhsR)
            case let (.i(lhsI), .i(rhsI)): return self.init(lhsI / rhsI)
        }
    }
}

/// `RealNumber` & `ImaginaryNumber` Operators
extension RealNumber {
    /// As `RealNumber` is a real value, and `ImaginaryNumber` is an imaginary value; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RealNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs, imaginary: rhs)
    }
    
    /// As `RealNumber` is a real value, and `ImaginaryNumber` is an imaginary value; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RealNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs, imaginary: -rhs)
    }
    
    /// As `RealNumber` is a real value, and `ImaginaryNumber` is an imaginary value; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RealNumber, rhs: ImaginaryNumber) -> ImaginaryNumber {
        return ImaginaryNumber(lhs * rhs._storage)
    }
    
    /// As `RealNumber` is a real value, and `ImaginaryNumber` is an imaginary value; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RealNumber, rhs: ImaginaryNumber) -> ImaginaryNumber {
        return -ImaginaryNumber(lhs / rhs._storage)
    }
}

/// `RealNumber` & `ComplexNumber` Operators
extension RealNumber {
    /// As `RealNumber` is a real value, and `ComplexNumber` is a combination of real and imaginary values; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: RealNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs + rhs._real, imaginary: rhs._imaginary)
    }
    
    /// As `RealNumber` is a real value, and `ComplexNumber` is a combination of real and imaginary values; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RealNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs - rhs._real, imaginary: -rhs._imaginary)
    }
    
    /// As `RealNumber` is a real value, and `ComplexNumber` is a combination of real and imaginary values; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RealNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs * rhs._real, imaginary: lhs * rhs._imaginary)
    }
    
    /// As `RealNumber` is a real value, and `ComplexNumber` is a combination of real and imaginary values; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RealNumber, rhs: ComplexNumber) -> ComplexNumber {
        let newComplex = ComplexNumber(real: lhs, imaginary: .zero)
        return newComplex / rhs
    }
}

