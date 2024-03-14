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

//// MARK: - Additional Left-Hand Number Operators
//extension Number { /// `Number` & `NaturalNumber`
//    public static func + (lhs: Self, rhs: NaturalNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: NaturalNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: NaturalNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: NaturalNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `WholeNumber`
//    public static func + (lhs: Self, rhs: WholeNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: WholeNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: WholeNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: WholeNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `Integer`
//    public static func + (lhs: Self, rhs: Integer) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: Integer) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: Integer) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: Integer) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `SimpleFraction`
//    public static func + (lhs: Self, rhs: SimpleFraction) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: SimpleFraction) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: SimpleFraction) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: SimpleFraction) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `RationalNumber`
//    public static func + (lhs: Self, rhs: RationalNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: RationalNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: RationalNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: RationalNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `IrrationalNumber`
//    public static func + (lhs: Self, rhs: IrrationalNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: IrrationalNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: IrrationalNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: IrrationalNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `RealNumber`
//    public static func + (lhs: Self, rhs: RealNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: RealNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: RealNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: RealNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `ImaginaryNumber`
//    public static func + (lhs: Self, rhs: ImaginaryNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: ImaginaryNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: ImaginaryNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: ImaginaryNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}
//
//extension Number { /// `Number` & `ComplexNumber`
//    public static func + (lhs: Self, rhs: ComplexNumber) -> Self {
//        return lhs + Number(rhs)
//    }
//
//    public static func - (lhs: Self, rhs: ComplexNumber) -> Self {
//        return lhs - Number(rhs)
//    }
//
//    public static func * (lhs: Self, rhs: ComplexNumber) -> Self {
//        return lhs * Number(rhs)
//    }
//
//    public static func / (lhs: Self, rhs: ComplexNumber) -> Self {
//        return lhs / Number(rhs)
//    }
//}

// MARK: - Additional Right-Hand Number Operators
//extension NaturalNumber { /// `NaturalNumber` & `Number`
//    public static func + (lhs: NaturalNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: NaturalNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: NaturalNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: NaturalNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension WholeNumber { /// `WholeNumber` & `Number`
//    public static func + (lhs: WholeNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: WholeNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: WholeNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: WholeNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension Integer { /// `Integer` & `Number`
//    public static func + (lhs: Integer, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: Integer, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: Integer, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: Integer, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension SimpleFraction { /// `SimpleFraction` & `Number`
//    public static func + (lhs: SimpleFraction, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: SimpleFraction, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: SimpleFraction, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: SimpleFraction, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension RationalNumber { /// `RationalNumber` & `Number`
//    public static func + (lhs: RationalNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: RationalNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: RationalNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: RationalNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension IrrationalNumber { /// `IrrationalNumber` & `Number`
//    public static func + (lhs: IrrationalNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: IrrationalNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: IrrationalNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: IrrationalNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension RealNumber { /// `RealNumber` & `Number`
//    public static func + (lhs: RealNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: RealNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: RealNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: RealNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension ImaginaryNumber { /// `ImaginaryNumber` & `Number`
//    public static func + (lhs: ImaginaryNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: ImaginaryNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: ImaginaryNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: ImaginaryNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
//
//extension ComplexNumber { /// `ComplexNumber` & `Number`
//    public static func + (lhs: ComplexNumber, rhs: Number) -> Number {
//        return Number(lhs) + rhs
//    }
//
//    public static func - (lhs: ComplexNumber, rhs: Number) -> Number {
//        return Number(lhs) - rhs
//    }
//
//    public static func * (lhs: ComplexNumber, rhs: Number) -> Number {
//        return Number(lhs) * rhs
//    }
//
//    public static func / (lhs: ComplexNumber, rhs: Number) -> Number {
//        return Number(lhs) / rhs
//    }
//}
