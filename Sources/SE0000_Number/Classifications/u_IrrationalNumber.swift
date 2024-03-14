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

// MARK: - IrrationalNumber
public struct IrrationalNumber: Codable, Equatable, Hashable {
    enum IrrationalNumberFormat: Codable, Equatable, Hashable, Sendable {
        case nthRoot(_ degree: Number, _ radicand: Number, _ precision: NaturalNumber)
        case pi(_ precision: NaturalNumber, _ isNegative: Bool)
    }
    let format: IrrationalNumberFormat

    private init(format: IrrationalNumberFormat) {
        defer {
            /// This computes an approximation which will meet or exceed the requested precision
            switch format {
                case .nthRoot(let degree, let radicand, let precision):
                    self._approximation = radicand.radication(for: degree, precision)
                case .pi(let precision, let isNegative):
                    let result = IrrationalNumber._piApproximation(precision)
                    self._approximation = isNegative ? -result : result
            }
        }
        self.format = format
    }

    // MARK: - Private
    internal var _approximation: Number!
}

// MARK: - Pi Initializer
extension IrrationalNumber {
    public static func pi(_ precision: NaturalNumber = 7, _ isNegative: Bool = false) -> Self {
        return Self.init(format: .pi(precision, isNegative))
    }
}

// MARK: - Pi Approximation
extension IrrationalNumber {
    private static func _piApproximation(_ precision: NaturalNumber = 7) -> Number {
        let iterations = Number(precision).squared()
        var pi: Number = .zero
        var k: Number = .zero
        while k < iterations {
            let fraction: Number = .one / Number(16).raised(to: k)
            let eightK: Number = (Number(8) * k)
            let term1: Number = Number(4) / (eightK + 1)
            let term2: Number = Number.two / (eightK + 4)
            let term3: Number = Number.one / (eightK + 5)
            let term4: Number = Number.one / (eightK + 6)
            pi += fraction * (term1 - term2 - term3 - term4)
            k += .one
        }
        return pi
    }
}

// MARK: - Rooting / Radication Initializers
extension IrrationalNumber {
    public static func nthRoot(_ degree: Number, radicand: Number, _ precision: NaturalNumber = .defaultPrecision) -> Self {
        return Self.init(format: .nthRoot(degree, radicand, precision))
    }

    public static func squareRoot(of value: Number, with precision: NaturalNumber = .defaultPrecision) -> Self {
        return Self.nthRoot(.two, radicand: value, precision)
    }

    public static func cubeRoot(of value: Number, with precision: NaturalNumber = .defaultPrecision) -> Self {
        return Self.nthRoot(3, radicand: value, precision)
    }
}

// MARK: - Default Precision
extension NaturalNumber {
    /// NOTE: Reasonable default for `IrrationalNumber` precision - `42`- despite the vastness, it only takes 39-40 digits of `pi` to calculate the size of the observable universe to the accuracy of a single hydrogen atom.
    ///     Also, the `"Answer to the Ultimate Question of Life, The Universe, and Everything"` See: https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything_(42)
    public static let defaultPrecision: NaturalNumber = 42
}

extension IrrationalNumber {
    static let zero = IrrationalNumber.nthRoot(.one, radicand: .zero)
//    static let goldenRatio = (.one + IrrationalNumber.squareRoot5) / .two
    static let squareRoot2 = IrrationalNumber.squareRoot(of: 2)
    static let squareRoot3 = IrrationalNumber.squareRoot(of: 3)
    static let squareRoot5 = IrrationalNumber.squareRoot(of: 5)
}

// MARK: - Magnitude
extension IrrationalNumber {
    public var magnitude: Self {
        switch self.format {
            case .nthRoot(let degree, let radicand, let precision):
                return Self.nthRoot(degree, radicand: radicand.magnitude, precision)
            case .pi(let precision, _):
                return Self.pi(precision) // Default Positive
        }
    }
}

// MARK: - Negation
extension IrrationalNumber {
    public static prefix func - (operand: Self) -> Self {
        switch operand.format {
            case .nthRoot(let degree, let radicand, let precision):
                return Self.nthRoot(degree, radicand: -radicand, precision)
            case .pi(let precision, let isNegative):
                return Self.pi(precision, isNegative ? false : true) /// Invert `isNegative`
        }
    }
    
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Comparable
extension IrrationalNumber: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    public static func < (lhs: IrrationalNumber, rhs: IrrationalNumber) -> Bool {
        return lhs._approximation < rhs._approximation
    }

    public static func < (lhs: IrrationalNumber, rhs: RationalNumber) -> Bool {
        return lhs._approximation < Number(rhs)
    }
}

extension IrrationalNumber { // Inverse Comparable
    public static func > (lhs: IrrationalNumber, rhs: RationalNumber) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - CustomStringConvertible
extension IrrationalNumber: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    public var description: String {
        switch format {
            case .nthRoot(let degree, let radicand, _):
                return "\(degree.description.superscriptDigits)√\(radicand)"
            case .pi(_, let isNegative):
                var result = "π"
                if isNegative {
                    result = "-" + result
                }
                return result
        }
    }
}

extension String {
    var superscriptDigits: String {
        let superscriptMap: [Character: String] = [
            "0": "\u{2070}",
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"
        ]

        return self.map { superscriptMap[$0] ?? String($0) }.joined()
    }
}

// MARK: - Sendable
extension IrrationalNumber: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

// MARK: - Operators
extension IrrationalNumber {
    /// As `IrrationalNumber`s are an irrational value, addition of any two `IrrationalNumber` are guaranteed to result in a `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: IrrationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber`s are an irrational value, subtraction of any two `IrrationalNumber` are guaranteed to result in a `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: IrrationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber`s are an irrational value, multiplication of any two `IrrationalNumber` are guaranteed to result in a `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: IrrationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber`s are an irrational value, division of any two `IrrationalNumber` are guaranteed to result in a `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: IrrationalNumber, rhs: IrrationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
}

/// `IrrationalNumber` & `RationalNumber` Operators
extension IrrationalNumber {
    /// As `IrrationalNumber` is an irrational value, and `RationalNumber` is a rational value; addition is guaranteed to result in an `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to add.
    ///   - rhs (Right-hand Side): The second value to add.
    ///
    public static func + (lhs: IrrationalNumber, rhs: RationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber` is an irrational value, and `RationalNumber` is a rational value; subtraction is guaranteed to result in an `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): A numeric value.
    ///   - rhs (Right-hand Side): The value to subtract from `lhs`.
    ///
    public static func - (lhs: IrrationalNumber, rhs: RationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber` is an irrational value, and `RationalNumber` is a rational value; multiplication is guaranteed to result in an `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The first value to multiply.
    ///   - rhs (Right-hand Side): The second value to multiply.
    ///
    public static func * (lhs: IrrationalNumber, rhs: RationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
    
    /// As `IrrationalNumber` is an irrational value, and `RationalNumber` is a rational value; division is guaranteed to result in an `IrrationalNumber`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: IrrationalNumber, rhs: RationalNumber) -> IrrationalNumber {
        fatalError("TODO: - \(Self.self).\(#function)")
    }
}
