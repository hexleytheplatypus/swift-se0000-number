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

// MARK: - ComplexNumber
public struct ComplexNumber: Codable, Equatable, Hashable {
    let _real: RealNumber
    let _imaginary: ImaginaryNumber
    
    public init(real: RealNumber, imaginary: ImaginaryNumber) {
        self._real = real
        self._imaginary = imaginary
    }

    public var conjugate: ComplexNumber {
        return ComplexNumber(real: self._real, imaginary: -self._imaginary)
    }
}

// MARK: - Magnitude
extension ComplexNumber {
    public var magnitude: Number {
        let aSquared = Number(_real.magnitude).squared()
        let bSquared = Number(_imaginary.magnitude).squared()
        return (aSquared + bSquared).squareRoot()
    }
}

// MARK: - Negation
extension ComplexNumber {
    public static prefix func - (operand: Self) -> Self {
        return ComplexNumber(real: -operand._real, imaginary: -operand._imaginary)
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Comparable
extension ComplexNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: ComplexNumber, rhs: ComplexNumber) -> Bool {
        guard lhs._real != rhs._real else {
            guard lhs._imaginary != rhs._imaginary else { return false }
            return lhs._imaginary < rhs._imaginary
        }
        return lhs._real < rhs._real
    }

    public static func < (lhs: ComplexNumber, rhs: RealNumber) -> Bool {
        if rhs > lhs._real { return false }
        if rhs < lhs._real { return true }
        if lhs._imaginary._storage > .zero { return true }
        if lhs._imaginary._storage < .zero { return false }
        return false /// Everything is `.zero`
    }

    public static func < (lhs: ComplexNumber, rhs: ImaginaryNumber) -> Bool {
        if rhs > lhs._imaginary { return false }
        if rhs < lhs._imaginary { return true }
        if lhs._real > .zero { return true }
        if lhs._real < .zero { return false }
        return false /// Everything is `.zero`
    }
}

extension ComplexNumber { // Inverse Comparable
    public static func > (lhs: ComplexNumber, rhs: RealNumber) -> Bool {
        return !(lhs < rhs)
    }

    public static func > (lhs: ComplexNumber, rhs: ImaginaryNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension ComplexNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        return "\(_real) + \(_imaginary)"
    }
}

//// MARK: - Equatable
//extension ComplexNumber: Equatable {
//    //===--- Equatable ------------------------------------------------------===//
//
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs._real == rhs._real && lhs._imaginary == rhs._imaginary
//    }
//}

// MARK: - Sendable
extension ComplexNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

/// Operators
extension ComplexNumber {
    /// As `ComplexNumber`s are a combination of real and imaginary values, addition of any two `ComplexNumber` are guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ComplexNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real + rhs._real, imaginary: lhs._imaginary + rhs._imaginary)
    }
    
    /// As `ComplexNumber`s are a combination of real and imaginary values, subtraction of any two `ComplexNumber` are guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ComplexNumber, rhs: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real - rhs._real, imaginary: lhs._imaginary - rhs._imaginary)
    }
    
    /// As `ComplexNumber`s are a combination of real and imaginary values, multiplication of any two `ComplexNumber` are guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ComplexNumber, rhs: ComplexNumber) -> ComplexNumber {
        let reals = lhs._real * rhs._real
        let imaginaries = lhs._imaginary._storage * rhs._imaginary._storage
        let crossTerm1 = lhs._real * rhs._imaginary._storage
        let crossTerm2 = lhs._imaginary._storage * rhs._real
        return ComplexNumber(real: reals - imaginaries, imaginary: ImaginaryNumber(crossTerm1 + crossTerm2))
    }
    
    /// As `ComplexNumber`s are a combination of real and imaginary values, division of any two `ComplexNumber` are guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ComplexNumber, rhs: ComplexNumber) -> ComplexNumber {
        let newlhs = lhs * rhs.conjugate
        let newrhs = (rhs * rhs.conjugate)._real
        let real = newlhs._real / newrhs
        let imaginary = newlhs._imaginary._storage / newrhs
        return ComplexNumber(real: real, imaginary: ImaginaryNumber(imaginary))
    }
}

/// `ComplexNumber` & `RealNumber` Operators
extension ComplexNumber {
    /// As `ComplexNumber` is a combination of real and imaginary values, and `RealNumber` is a real value; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ComplexNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real + rhs, imaginary: lhs._imaginary)
    }
    
    /// As `ComplexNumber` is a combination of real and imaginary values, and `RealNumber` is a real value; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ComplexNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real - rhs, imaginary: lhs._imaginary)
    }
    
    /// As `ComplexNumber` is a combination of real and imaginary values, and `RealNumber` is a real value; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ComplexNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real * rhs, imaginary: lhs._imaginary * rhs)
    }
    
    /// As `ComplexNumber` is a combination of real and imaginary values, and `RealNumber` is a real value; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ComplexNumber, rhs: RealNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real / rhs, imaginary: lhs._imaginary / rhs)
    }
}

/// `ComplexNumber` & `ImaginaryNumber` Operators
extension ComplexNumber {
    /// As `ComplexNumber` is a combination of real and imaginary values, and `ImaginaryNumber` is an imaginary value; addition is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: ComplexNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real, imaginary: lhs._imaginary + rhs)
    }
    
    /// As `ComplexNumber` is a combination of real and imaginary values, and `ImaginaryNumber` is an imaginary value; subtraction is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: ComplexNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real, imaginary: lhs._imaginary - rhs)
    }
    
    /// As `ComplexNumber` is a combination of real and imaginary values, and `ImaginaryNumber` is an imaginary value; multiplication is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: ComplexNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        let real = -lhs._imaginary._storage * rhs._storage
        let imaginary = lhs._real * rhs._storage
        return ComplexNumber(real: real, imaginary: ImaginaryNumber(imaginary))
    }


    /// As `ComplexNumber` is a combination of real and imaginary values, and `ImaginaryNumber` is an imaginary value; division is guaranteed to result in a `ComplexNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: ComplexNumber, rhs: ImaginaryNumber) -> ComplexNumber {
        return ComplexNumber(real: lhs._real / rhs._storage, imaginary: -ImaginaryNumber(lhs._imaginary / rhs))
    }
}
