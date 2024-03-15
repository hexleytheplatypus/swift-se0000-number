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

// MARK: - Number
public enum Number: Codable, Hashable {
    case real(RealNumber)
    case imaginary(ImaginaryNumber)
    case complex(ComplexNumber)

    public static let zero = Number(integerLiteral: 0)
    public static let one = Number(integerLiteral: 1)
    public static let two = Number(integerLiteral: 2)
    public static let ten = Number(integerLiteral: 10)
}

// MARK: - Static Properties
extension Number {
    public static let i = Number(ImaginaryNumber.i)
}

// MARK: - Standard Library Initializers
extension Number {
    public init<T: BinaryInteger>(_ source: T) {
        self.init(ArbitraryPrecisionSignedInteger(source))
    }

    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        /// Forward to `init?(_:radix:)`
        guard let result = Self("\(source)") else {
            debugPrint("Malformed Source: \(source)")
            return nil
        }
        self = result
    }
}

// MARK: - String Initializer
extension Number {
    // TODO: - Audit: Clean up, rationalize `fatalError` vs `return nil`.

    /// Creates a new instance from the given string.
    ///
    /// - Parameters:
    ///   - source: The string to parse for the new instance's value. If a
    ///     character in `source` is not in the range `0...9` or `a...z`, case
    ///     insensitive, or is not less than `radix`, the result is `nil`.
    ///   - radix: The radix to use when parsing `source`. `radix` must be in the
    ///     range `2...36`. The default is `10`.
    public init?(_ source: String, radix: Int = 10) {
        assert(2...36 ~= radix, "radix must be in range 2...36")
        var source = source

        // Remove Underscores
        // source.removeAll(where: { $0 == "_" })

        var exponent: ArbitraryPrecisionSignedInteger = .zero
        if source.hasSuffix(".0") {
            source = String(source.dropLast(2)) // exponent = 0 (Base10)
        }

        /// Catch "e-" containing `source`
        if source.contains("e-") {
            let splits = source.split(separator: "e")
            guard splits.count == 2 else {
                return nil // Too many splits, what kind of string is this?
            }
            source = String(splits[0])

            guard let newExponent = ArbitraryPrecisionSignedInteger(String(splits[1])) else {
                fatalError("Could not convert \"\(String(splits[1]))\"")
            }
            exponent = newExponent
        }

        let decimalPoint = "."
        if source.contains(decimalPoint) {
            // Locate Decimal Point
            let splits = source.split(separator: decimalPoint)
            guard splits.count == 2 else {
                return nil // Multiple Decimal Points in String
            }
            guard let index = source.firstIndex(where: { $0 == "." }) else {
                fatalError("Unable to find Index")
            }

            // Determine Exponent
            var fractional = String(source[source.index(after: index)..<source.endIndex])
            fractional.removeAll(where: { $0 == "_" })
            exponent += ArbitraryPrecisionSignedInteger(-fractional.count)

            // Remove Decimal Point
            source.remove(at: index)
        }

        guard let mantissa = ArbitraryPrecisionSignedInteger(source) else {
            fatalError("Could not convert \"\(source)\" to \(Self.self)")
        }

        let magnitude = Number(exponent.magnitude)
        self = Number(mantissa) / .ten.raised(to: magnitude, NaturalNumber(magnitude) ?? .one)
    }
}

// MARK: - AdditiveArithmetic
extension Number: AdditiveArithmetic {
    //===--- AdditiveArithmetic ---------------------------------------------===//

    /// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two arguments. For
    /// example:
    ///
    ///     1 + 2                   // 3
    ///     -10 + 15                // 5
    ///     -15 + -5                // -20
    ///     21.5 + 3.25             // 24.75
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func + (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case let (.real(lhsReal),      .real(rhsReal     )): return self.init(lhsReal + rhsReal)
            case let (.real(lhsReal), .imaginary(rhsImaginary)): return self.init(lhsReal + rhsImaginary)
            case let (.real(lhsReal),   .complex(rhsComplex  )): return self.init(lhsReal + rhsComplex)

            case let (.imaginary(lhsImaginary),      .real(rhsReal     )): return self.init(lhsImaginary + rhsReal)
            case let (.imaginary(lhsImaginary), .imaginary(rhsImaginary)): return self.init(lhsImaginary + rhsImaginary)
            case let (.imaginary(lhsImaginary),   .complex(rhsComplex  )): return self.init(lhsImaginary + rhsComplex)

            case let (.complex(lhsComplex),      .real(let rhsReal     )): return self.init(lhsComplex + rhsReal)
            case let (.complex(lhsComplex), .imaginary(let rhsImaginary)): return self.init(lhsComplex + rhsImaginary)
            case let (.complex(lhsComplex),   .complex(let rhsComplex  )): return self.init(lhsComplex + rhsComplex)
        }
    }

    /// Subtracts one value from another and produces their difference.
    ///
    /// The subtraction operator (`-`) calculates the difference of its two
    /// arguments. For example:
    ///
    ///     8 - 3                   // 5
    ///     -10 - 5                 // -15
    ///     100 - -5                // 105
    ///     10.5 - 100.0            // -89.5
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    public static func - (lhs: Self, rhs: Self) -> Self {
        switch lhs {
            case .real(let lhsReal):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsReal - rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsReal - rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsReal - rhsComplex)
                }
            case .imaginary(let lhsImaginary):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsImaginary - rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsImaginary - rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsImaginary - rhsComplex)
                }
            case .complex(let lhsComplex):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsComplex - rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsComplex - rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsComplex - rhsComplex)
                }
        }
    }
}

// MARK: - Comparable
extension Number: Comparable {
    //===--- Comparable -----------------------------------------------------===//

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
            case .real(let lhsReal):
                switch rhs {
                    case .real(let rhsReal):
                        return lhsReal < rhsReal
                    case .imaginary(let rhsImaginary):
                        return lhsReal < rhsImaginary
                    case .complex(let rhsComplex):
                        return lhsReal < rhsComplex
                }
            case .imaginary(let lhsImaginary):
                switch rhs {
                    case .real(let rhsReal):
                        return lhsImaginary < rhsReal
                    case .imaginary(let rhsImaginary):
                        return lhsImaginary < rhsImaginary
                    case .complex(let rhsComplex):
                        return lhsImaginary < rhsComplex
                }
            case .complex(let lhsComplex):
                switch rhs {
                    case .real(let rhsReal):
                        return lhsComplex < rhsReal
                    case .imaginary(let rhsImaginary):
                        return lhsComplex < rhsImaginary
                    case .complex(let rhsComplex):
                        return lhsComplex < rhsComplex
                }
        }
    }
}

// MARK: - CustomStringConvertible
extension Number: CustomStringConvertible {
    //===--- CustomStringConvertible ----------------------------------------===//

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Number, y: Number
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        switch self {
            case .real(let realNumber):
                return realNumber.description
            case .imaginary(let imaginaryNumber):
                return imaginaryNumber.description
            case .complex(let complexNumber):
                return complexNumber.description
        }
    }
}

// MARK: - Equatable
extension Number: Equatable {
    //===--- Equatable ------------------------------------------------------===//

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
            case .real(let lhsReal):
                switch rhs {
                    case .real(let rhsReal):
                        return lhsReal == rhsReal
                    default: return false
                }
            case .imaginary(let lhsImaginary):
                switch rhs {
                    case .imaginary(let rhsImaginary):
                        return lhsImaginary == rhsImaginary
                    case .complex(let rhsComplex):
                        return lhsImaginary == rhsComplex._imaginary && RealNumber.zero == rhsComplex._real
                    default: return false
                }
            case .complex(let lhsComplex):
                switch rhs {
                    case .imaginary(let rhsImaginary):
                        return lhsComplex._imaginary == rhsImaginary && lhsComplex._real == RealNumber.zero
                    case .complex(let rhsComplex):
                        return lhsComplex == rhsComplex
                    default: return false
                }
        }
    }
}

// MARK: - ExpressibleByFloatLiteral
extension Number: ExpressibleByFloatLiteral {
    //===--- ExpressibleByFloatLiteral --------------------------------------===//

    public typealias FloatLiteralType = Double
    public init(floatLiteral value: FloatLiteralType) {
        self.init(exactly: value)!
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension Number: ExpressibleByIntegerLiteral {
    //===--- ExpressibleByIntegerLiteral ------------------------------------===//

    /// Creates an instance initialized to the specified integer value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or
    /// constant using an integer literal. For example:
    ///
    ///     let x = 23
    ///
    /// In this example, the assignment to the `x` constant calls this integer
    /// literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public init(integerLiteral value: StaticBigInt) {
        self.init(RealNumber(integerLiteral: value))
    }
}

// MARK: - Numeric
extension Number: Numeric {
    //===--- Numeric --------------------------------------------------------===//

    /// Creates a new instance from the given integer, if it can be represented
    /// exactly.
    ///
    /// - Parameter source: A value to convert to this type.
    /// - Note: This initializer never returns `nil` on `Number`.
    public init?<T: BinaryInteger>(exactly source: T) {
        self.init(source)
    }

    /// The magnitude of this value.
    ///
    /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
    /// You can use the `magnitude` property in operations that are simpler to
    /// implement in terms of unsigned values, such as printing the value of an
    /// integer, which is just printing a '-' character in front of an absolute
    /// value.
    ///
    ///     let x = -200
    ///     // x.magnitude == 200
    ///
    /// The global `abs(_:)` function provides more familiar syntax when you need
    /// to find an absolute value. In addition, because `abs(_:)` always returns
    /// a value of the same type, even in a generic context, using the function
    /// instead of the `magnitude` property is encouraged.
    public var magnitude: Self {
        switch self {
            case .real(let realNumber):
                return .real(realNumber.magnitude)
            case .imaginary(let imaginaryNumber):
                return .real(imaginaryNumber.magnitude)
            case .complex(let complexNumber):
                return complexNumber.magnitude
        }
    }

    /// Multiplies two values and produces their product.
    ///
    /// The multiplication operator (`*`) calculates the product of its two
    /// arguments. For example:
    ///
    ///     2 * 3                   // 6
    ///     100 * 21                // 2100
    ///     -10 * 15                // -150
    ///     3.5 * 2.25              // 7.875
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - rhs: The second value to multiply.
    ///
    public static func * (lhs: Self, rhs: Self) -> Self {
        switch lhs {
            case .real(let lhsReal):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsReal * rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsReal * rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsReal * rhsComplex)
                }
            case .imaginary(let lhsImaginary):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsImaginary * rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsImaginary * rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsImaginary * rhsComplex)
                }
            case .complex(let lhsComplex):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsComplex * rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsComplex * rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsComplex * rhsComplex)
                }
        }
    }
}

// MARK: - Sendable
extension Number: Sendable {
    //===--- Sendable -------------------------------------------------------===//
}

// MARK: - SignedNumeric
extension Number: SignedNumeric {
    //===--- SignedNumeric --------------------------------------------------===//

    /// Returns the additive inverse of the specified value.
    ///
    /// The negation operator (prefix `-`) returns the additive inverse of its
    /// argument.
    ///
    ///     let x = 21
    ///     let y = -x
    ///     // y == -21
    ///
    /// - Returns: The additive inverse of this value.
    public static prefix func - (operand: Self) -> Self {
        switch operand {
            case .real(let realNumber):
                return self.init(-realNumber)
            case .imaginary(let imaginaryNumber):
                return self.init(-imaginaryNumber)
            case .complex(let complexNumber):
                return self.init(-complexNumber)
        }
    }

    // TODO: - Audit: Is this useful?
    public static prefix func - (operand: inout Self) {
        let copy = operand
        operand = -(copy)
    }
}

// MARK: - Strideable
extension Number: Strideable {
    //===--- Strideable -----------------------------------------------------===//

    public func distance(to other: Number) -> Number {
        return other - self
    }

    public func advanced(by n: Number) -> Number {
        return self + n
    }
}

// MARK: - Arbitrary Precision Initializers
extension Number {
    public init(_ unsigned: ArbitraryPrecisionUnsignedInteger) {
        self = .real(.rational(RationalNumber(unsigned)))
    }

    public init(_ signed: ArbitraryPrecisionSignedInteger) {
        self = .real(.rational(RationalNumber(signed)))
    }
}

// MARK: - Number Classification Initializers
extension Number {
    public init(_ natural: NaturalNumber) {
        self.init(RationalNumber(natural))
    }

    public init(_ whole: WholeNumber) {
        self.init(RationalNumber(whole))
    }

    public init(_ integer: Integer) {
        self.init(RationalNumber(integer))
    }

    public init(_ fraction: SimpleFraction) {
        self.init(RationalNumber(fraction))
    }

    public init(_ rational: RationalNumber) {
        self.init(RealNumber(rational))
    }

    public init(_ irrational: IrrationalNumber) {
        self.init(RealNumber(irrational))
    }

    public init(_ real: RealNumber) {
        self = .real(real)
    }

    public init(_ imaginary: ImaginaryNumber) {
        switch imaginary._storage {
            case .zero:
                self = .zero
            case .one:
                self = .i
            default:
                self = .imaginary(imaginary)
        }
    }

    public init(_ complex: ComplexNumber) {
        switch complex._real {
            case .zero: self.init(complex._imaginary)
            default:
                switch complex._imaginary._storage {
                    case .zero: self.init(complex._real)
                    default:
                        self = .complex(complex)
                }
        }
    }
}

// MARK: - Imaginary Literal
extension Number {
    // TODO: - Audit: Is it possible to make an `ImaginaryNumberLiteral`? Essentially a postfix operator of `i` following an `IntegerLiteral`?

    public init(imaginary: StaticBigInt) {
        self.init(ImaginaryNumber(integerLiteral: imaginary))
    }

    public static func imaginary(from integerLiteral: StaticBigInt) -> Self {
        self.init(imaginary: integerLiteral)
    }
}

// MARK: - Division Operator
extension Number {

    /// As `Number`s are a numeric value, division of any two `Number` are guaranteed to result in a `Number`.
    /// - Parameters:
    ///   - lhs (Left-hand Side): The value to divide.
    ///   - rhs (Right-hand Side): The value to divide `lhs` by. `rhs` must not be `.zero`.
    ///
    public static func / (lhs: Self, rhs: Self) -> Self {
        switch lhs {
            case .real(let lhsReal):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsReal / rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsReal / rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsReal / rhsComplex)
                }
            case .imaginary(let lhsImaginary):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsImaginary / rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsImaginary / rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsImaginary / rhsComplex)
                }
            case .complex(let lhsComplex):
                switch rhs {
                    case .real(let rhsReal):
                        return self.init(lhsComplex / rhsReal)
                    case .imaginary(let rhsImaginary):
                        return self.init(lhsComplex / rhsImaginary)
                    case .complex(let rhsComplex):
                        return self.init(lhsComplex / rhsComplex)
                }
        }
    }
}

/// Exponentation & Radication Helpers
extension Number {
    func power(_ exponent: Number, _ precision: NaturalNumber = .defaultPrecision) -> Number {
        let decimalPrecision = SimpleFraction(numerator: .one, denominator: Integer(.ten._power(Number(precision), .one))!)
        return self._power(exponent, decimalPrecision)
    }

    private func _power(_ exponent: Number, _ precision: SimpleFraction) -> Number {
        // If the exponent is 0, the result is 1 (anything to the power of 0 is 1)
        if exponent == .zero {
            return .one
        }

        // If the base is 0, the result is 0 (0 to any power is 0, except for the 0^0 which is a special case)
        if self == .zero {
            return .zero
        }

        // If the exponent is 1, the result is `self` (identity)
        if exponent == .one {
            return self
        }

        // If the exponent is negative, calculate the power with positive exponent and return its reciprocal
        if exponent < .zero {
            return .one / self._power(-exponent, precision)
        }

        switch self {
            case .real(_):
                switch exponent {
                    case .real(_):
                        var result: Number = .one
                        var power = exponent
                        var wholePower: WholeNumber = .zero
                        while power >= .one {
                            //                            result *= self
                            wholePower = wholePower + .one
                            power -= .one
                        }

                        // Fast Exponentation by Squaring
                        result = self._fastExponentiation(wholePower)

                        // Rooting/Fractional-Exponents
                        if power > .zero {
                            // TODO: - Rooting is horribly messy, I hope someone better at math can clean this up.
                            if let result = self._properRoot(.one / power, precision) {
                                return result
                            } else { /// irrational
                                result *= self._newtonsMethod(.one / power, precision)
                            }
                        }
                        return result
                    case .imaginary(let imaginaryNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                    case .complex(let complexNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                }
            case .imaginary(let imaginaryNumber):
                switch exponent {
                    case .real(let realNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                    case .imaginary(let imaginaryNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                    case .complex(let complexNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                }
            case .complex(let complexNumber):
                switch exponent {
                    case .real(let realNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                    case .imaginary(let imaginaryNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                    case .complex(let complexNumber):
                        fatalError("TODO: - \(Self.self).\(#function)")
                }
        }
    }

    private func _fastExponentiation(_ exponent: WholeNumber) -> Number {
        // If the exponent is 0, the result is 1 (anything to the power of 0 is 1)
        if exponent == .zero { return .one }

        // If the base is 0, the result is 0 (0 to any power is 0, except for the 0^0 which is a special case)
        if self == .zero { return .zero }

        // If the exponent is 1, the result is `self` (identity)
        if exponent == .one { return self }

        if exponent.isMultiple(of: .two) {
            let halfPower = self._fastExponentiation(WholeNumber(exponent / .two)!)
            return halfPower * halfPower
        } else {
            return self * _fastExponentiation(WholeNumber(exponent - .one)!)
        }
    }

    private func _properRoot(_ root: Number, _ precision: SimpleFraction) -> Number? {
        // TODO: Safeguard against negative roots, root == 0, and root == 1

        guard let _ = WholeNumber(self) else { return nil }
        guard let _ = WholeNumber(root) else { return nil }

        var highSide: Number = .zero
        var highDrop = self / root
        while highDrop > .zero {
            highDrop -= .one
            highSide += .one
        }

        var completedChecks: Number = .two
        while completedChecks <= highSide {
            if completedChecks._power(root, precision) == self {
                return completedChecks
            }
            completedChecks += .one
        }

        return nil
    }

    private func _newtonsMethod(_ root: Number, _ precision: SimpleFraction) -> Number {
        let tolerance = Number(precision)
        var previousGuess = self
        var guess = previousGuess - (previousGuess._power(root, precision) - self) / (root * previousGuess._power(root - .one, precision))

        while (guess - previousGuess).magnitude > tolerance {
            previousGuess = guess
            guess = previousGuess - (previousGuess._power(root, precision) - self) / (root * previousGuess._power(root - .one, precision))
        }

        return guess
    }
}

// MARK: - Exponentation
extension Number {
    public func raised(to power: Number, _ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.power(power, precision)
    }

    public func squared(_ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.raised(to: .two, precision)
    }

    public func cubed(_ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.raised(to: 3, precision)
    }
}

// MARK: - Rooting / Radication
extension Number {
    public func radication(for root: Number, _ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.power(.one / root, precision)
    }

    public func squareRoot(_ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.radication(for: .two, precision)
    }

    public func cubeRoot(_ precision: NaturalNumber = .defaultPrecision) -> Number {
        return self.radication(for: 3, precision)
    }
}
