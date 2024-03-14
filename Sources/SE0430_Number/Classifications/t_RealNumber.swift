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
    case rational(RationalNumber)
    case irrational(IrrationalNumber)

    public static let zero = RealNumber(integerLiteral: 0)
    public static let one = RealNumber(integerLiteral: 1)
    public static let two = RealNumber(integerLiteral: 2)
    public static let ten = RealNumber(integerLiteral: 10)
}

// MARK: - Magnitude
extension RealNumber {
    public var magnitude: Self {
        switch self {
            case .rational(let rationalNumber):
                return .rational(rationalNumber.magnitude)
            case .irrational(let irrationalNumber):
                return .irrational(irrationalNumber.magnitude)
        }
    }
}

// MARK: - Negation
extension RealNumber {
    public static prefix func - (operand: Self) -> Self {
        switch operand {
            case .rational(let rationalNumber):
                return self.init(-rationalNumber)
            case .irrational(let irrationalNumber):
                return self.init(-irrationalNumber)
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
        switch lhs {
            case .rational(let lhsRational):
                switch rhs {
                    case .rational(let rhsRational):
                        return lhsRational < rhsRational
                    case .irrational(let rhsIrrational):
                        return lhsRational < rhsIrrational
                }
            case .irrational(let lhsIrrational):
                switch rhs {
                    case .rational(let rhsRational):
                        return lhsIrrational < rhsRational
                    case .irrational(let rhsIrrational):
                        return lhsIrrational < rhsIrrational
                }
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
            case .rational(let rationalNumber):
                return rationalNumber.description
            case .irrational(let irrationalNumber):
                return irrationalNumber.description
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
        self = .rational(RationalNumber(unsigned))
    }
    
    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        self = .rational(RationalNumber(signed))
    }
}
    
/// Other Number Classification Initializers
extension RealNumber {
    public init(_ natural: NaturalNumber) {
        self = .rational(RationalNumber(natural))
    }
    
    public init(_ whole: WholeNumber) {
        self = .rational(RationalNumber(whole))
    }
    
    public init(_ integer: Integer) {
        self = .rational(RationalNumber(integer))
    }
    
    public init(_ fraction: SimpleFraction) {
        self = .rational(RationalNumber(fraction))
    }
    
    public init(_ rational: RationalNumber) {
        self = .rational(rational)
    }
    
    public init(_ irrational: IrrationalNumber) {
        self = .irrational(irrational)
    }

    public init?(_ number: Number) {
        switch number {
            case .real(let realNumber):
                switch realNumber {
                    case .rational(let rationalNumber): self.init(rationalNumber)
                    case .irrational(let irrationalNumber): self.init(irrationalNumber)
                }
            case .imaginary(_): return nil
            case .complex(_): return nil
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
        switch lhs {
            case .rational(let lhsRational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .rational(lhsRational + rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsRational + rhsIrrational)
                }
            case .irrational(let lhsIrrational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .irrational(lhsIrrational + rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsIrrational + rhsIrrational)
                }
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, subtraction of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch lhs {
            case .rational(let lhsRational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .rational(lhsRational - rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsRational - rhsIrrational)
                }
            case .irrational(let lhsIrrational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .irrational(lhsIrrational - rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsIrrational - rhsIrrational)
                }
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, multiplication of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch lhs {
            case .rational(let lhsRational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .rational(lhsRational * rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsRational * rhsIrrational)
                }
            case .irrational(let lhsIrrational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .irrational(lhsIrrational * rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsIrrational * rhsIrrational)
                }
        }
    }
    
    /// As `RealNumber`s are a RealNumberal value, division of any two `RealNumber` are guaranteed to result in a `RealNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
        switch lhs {
            case .rational(let lhsRational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .rational(lhsRational / rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsRational / rhsIrrational)
                }
            case .irrational(let lhsIrrational):
                switch rhs {
                    case .rational(let rhsRational):
                        return .irrational(lhsIrrational / rhsRational)
                    case .irrational(let rhsIrrational):
                        return .irrational(lhsIrrational / rhsIrrational)
                }
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

