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

// MARK: - ImaginaryNumber
public struct ImaginaryNumber: Codable, Equatable, Hashable {
    let _storage: RealNumber /// this is always multiplied by `i`
    
    public init(_ real: RealNumber) {
        self._storage = real
    }
    
    public init?(_ number: Number) {
        switch number {
            case .real(let realNumber):
                self.init(realNumber)
            case .imaginary(_): return nil
            case .complex(_): return nil
        }
    }
}

// MARK: - Static Properties
extension ImaginaryNumber {
    public static let zero = ImaginaryNumber(integerLiteral: 0)
    public static let i = ImaginaryNumber(integerLiteral: 1)
}

// MARK: - Magnitude
extension ImaginaryNumber {
    public var magnitude: RealNumber {
        return self._storage.magnitude
    }
}

// MARK: - Negation
extension ImaginaryNumber {
    public static prefix func - (operand: Self) -> Self {
        return ImaginaryNumber(-operand._storage)
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Comparable
extension ImaginaryNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: ImaginaryNumber, rhs: ImaginaryNumber) -> Bool {
        return lhs._storage < rhs._storage
    }

    public static func < (lhs: ImaginaryNumber, rhs: RealNumber) -> Bool {
        if rhs > .zero { return false }
        if rhs < .zero { return true }
        if lhs._storage > .zero { return true }
        if lhs._storage < .zero { return false }
        return false /// Everything is `.zero`
    }

    public static func < (lhs: ImaginaryNumber, rhs: ComplexNumber) -> Bool {
        if lhs > rhs._imaginary { return false }
        if lhs < rhs._imaginary { return true }
        if rhs._real > .zero { return true }
        if rhs._real < .zero { return false }
        return false /// Everything is `.zero`
    }
}

extension ImaginaryNumber { // Inverse Comparable
    public static func > (lhs: ImaginaryNumber, rhs: RealNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: ImaginaryNumber, rhs: ComplexNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension ImaginaryNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        return "\(_storage.description)i"
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension ImaginaryNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: StaticBigInt) {
        self.init(RealNumber(integerLiteral: value))
    }
}

// MARK: - Sendable
extension ImaginaryNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Operators
extension ImaginaryNumber {
    /// As `ImaginaryNumber`s are imaginary values, addition of any two `ImaginaryNumber` are guaranteed to result in a `ImaginaryNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ImaginaryNumber, rhs: ImaginaryNumber) -> ImaginaryNumber {
        return ImaginaryNumber(lhs._storage + rhs._storage)
    }
    
    /// As `ImaginaryNumber`s are imaginary values, subtraction of any two `ImaginaryNumber` are guaranteed to result in a `ImaginaryNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ImaginaryNumber, rhs: ImaginaryNumber) -> ImaginaryNumber {
        return ImaginaryNumber(lhs._storage - rhs._storage)
    }
    
    /// As `ImaginaryNumber`s are imaginary values, multiplication of any two `ImaginaryNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ImaginaryNumber, rhs: ImaginaryNumber) -> RealNumber {
        return -(lhs._storage * rhs._storage)
    }
    
    /// As `ImaginaryNumber`s are imaginary values, division of any two `ImaginaryNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ImaginaryNumber, rhs: ImaginaryNumber) -> RealNumber {
        return lhs._storage / rhs._storage
    }
}

/// `ImaginaryNumber` & `RealNumber` Operators
extension ImaginaryNumber {
    /// As `ImaginaryNumber` is an imaginary value, and `RealNumber` is a real value; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ImaginaryNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: rhs, imaginary: lhs)
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `RealNumber` is a real value; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ImaginaryNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: -rhs, imaginary: lhs)
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `RealNumber` is a real value; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ImaginaryNumber, rhs: RealNumber) -> ImaginaryNumber {
        return ImaginaryNumber(lhs._storage * rhs)
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `RealNumber` is a real value; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ImaginaryNumber, rhs: RealNumber) -> ImaginaryNumber {
        return -ImaginaryNumber(lhs._storage / rhs)
    }
}

/// `ImaginaryNumber` & `ComplexNumber` Operators
extension ImaginaryNumber {
    /// As `ImaginaryNumber` is an imaginary value, and `ComplexNumber` is a combination of real and imaginary values; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ImaginaryNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: rhs._real, imaginary: lhs + rhs._imaginary)
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `ComplexNumber` is a combination of real and imaginary values; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ImaginaryNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: -rhs._real, imaginary: lhs - rhs._imaginary)
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `ComplexNumber` is a combination of real and imaginary values; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ImaginaryNumber, rhs: ComplexNumber) -> ComplexNumber {
        return rhs * lhs // Multiplication is Commutative
    }
    
    /// As `ImaginaryNumber` is an imaginary value, and `ComplexNumber` is a combination of real and imaginary values; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ImaginaryNumber, rhs: ComplexNumber) -> ComplexNumber {
        let newComplex = ComplexNumber(real: .zero, imaginary: lhs)
        return newComplex / rhs
    }
}
