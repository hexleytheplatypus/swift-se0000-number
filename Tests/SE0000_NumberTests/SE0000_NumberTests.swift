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

import XCTest
@testable import SE0000_Number

final class SE0000_NumberTests: XCTestCase {

    // MARK: - Basic Arithmetic Operations
    func testAddition() {
        /// Natural Number Addition
        // Test addition of positive numbers and Test init
        let nn_nn_add1: Number = 5 + Number(NaturalNumber(Integer(3))!)
        XCTAssertEqual(nn_nn_add1, 8, "Addition of natural numbers failed")
        XCTAssertEqual(nn_nn_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test addition of positive number and zero
        let nn_wn_add1: Number = 5 + 0
        XCTAssertEqual(nn_wn_add1, 5, "Addition of natural number and zero failed")
        XCTAssertEqual(nn_wn_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and negative numbers to positive result
        let nn_in_add1: Number = 5 + -3
        XCTAssertEqual(nn_in_add1, 2, "Addition of natural number and integer failed")
        XCTAssertEqual(nn_in_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and negative numbers to zero result
        let nn_in_add2: Number = 5 + -5
        XCTAssertEqual(nn_in_add2, 0, "Addition of natural number and integer resulting in zero failed")
        XCTAssertEqual(nn_in_add2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and negative numbers to negative result
        let nn_in_add3: Number = 3 + -5
        XCTAssertEqual(nn_in_add3, -2, "Addition of natural number and integer resulting in negative integer failed")
        XCTAssertEqual(nn_in_add3.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test addition of positive and terminating fractional numbers
        let half: Number = 1 / 2
        let nn_fr_add1: Number = 5 + half
        XCTAssertEqual(nn_fr_add1, 11 / 2, "Addition of natural number and terminating fraction failed")
        XCTAssertEqual(nn_fr_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of positive and repeating fractional numbers
        let third: Number = 1 / 3
        let nn_fr_add2: Number = 5 + third
        XCTAssertEqual(nn_fr_add2, 16 / 3, "Addition of natural number and repeating fraction failed")
        XCTAssertEqual(nn_fr_add2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Addition

        // Test addition of positive and imaginary number to complex result
        let nn_im_add1: Number = 5 + Number(imaginary: 3)
        XCTAssertEqual(nn_im_add1, Number(ComplexNumber(real: 5, imaginary: 3)), "Addition of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_add1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and imaginary number to complex result
        let nn_im_add2: Number = 5 + .imaginary(from: -3)
        XCTAssertEqual(nn_im_add2, Number(ComplexNumber(real: 5, imaginary: -3)), "Addition of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and complex number to complex result
        let nn_cn_add1: Number = 5 + Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(nn_cn_add1, Number(ComplexNumber(real: 10, imaginary: 3)), "Addition of natural number and complex number failed")
        XCTAssertEqual(nn_cn_add1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and complex number to an imaginary result
        let nn_cn_add2: Number = 5 + Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(nn_cn_add2, Number(ImaginaryNumber(-3)), "Addition of natural number and complex number failed")
        XCTAssertEqual(nn_cn_add2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        /// Whole Number Addition
        // Test addition of zero and positive number
        let wn_nn_add1: Number = 0 + Number(NaturalNumber(SimpleFraction(3))!)
        XCTAssertEqual(wn_nn_add1, 3, "Addition with zero failed")
        XCTAssertEqual(wn_nn_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test addition of zero
        let wn_wn_add1: Number = 0 + 0
        XCTAssertEqual(wn_wn_add1, 0, "Addition of zeroes failed")
        XCTAssertEqual(wn_wn_add1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test addition of zero and negative numbers to positive result
        let wn_in_add1: Number = 0 + -3
        XCTAssertEqual(wn_in_add1, -3, "Addition of zero and integer failed")
        XCTAssertEqual(wn_in_add1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test addition of zero and terminating fractional numbers
        let wn_fr_add1: Number = 0 + half
        XCTAssertEqual(wn_fr_add1, 1 / 2, "Addition of natural number and terminating fraction failed")
        XCTAssertEqual(wn_fr_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of zero and repeating fractional numbers
        let wn_fr_add2: Number = 0 + third
        XCTAssertEqual(wn_fr_add2, 1 / 3, "Addition of zero and repeating fraction failed")
        XCTAssertEqual(wn_fr_add2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - WholeNumber & IrrationalNumber Addition

        // Test addition of positive and imaginary numbers to complex result
        let wn_im_add1: Number = 0 + Number(imaginary: 3)
        XCTAssertEqual(wn_im_add1, Number(ImaginaryNumber(3)), "Addition of zero and imaginary number failed")
        XCTAssertEqual(wn_im_add1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and imaginary numbers to complex result
        let wn_im_add2: Number = 0 + .imaginary(from: -3)
        XCTAssertEqual(wn_im_add2, Number(ImaginaryNumber(-3)), "Addition of zero and imaginary number failed")
        XCTAssertEqual(wn_im_add2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and complex numbers to complex result
        let wn_cn_add1: Number = 0 + Number(ComplexNumber(real: 1, imaginary: 3))
        XCTAssertEqual(wn_cn_add1, Number(ComplexNumber(real: 1, imaginary: 3)), "Addition of zero and complex number failed")
        XCTAssertEqual(wn_cn_add1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of positive and negative numbers to positive result
        let wn_cn_add2: Number = 0 + Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(wn_cn_add2, Number(ComplexNumber(real: -5, imaginary: -3)), "Addition of zero and complex number failed")
        XCTAssertEqual(wn_cn_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// Integer Number Addition
        // Test addition of negative number and zero
        let in_wn_add1: Number = -5 + 0
        XCTAssertEqual(in_wn_add1, -5, "Addition of integer and zero failed")
        XCTAssertEqual(in_wn_add1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test addition of negative and positive numbers to positive result and Test init
        let in_in_add1: Number = -5 + Number(NaturalNumber(RealNumber(8))!)
        XCTAssertEqual(in_in_add1, 3, "Addition of integer and integer failed")
        XCTAssertEqual(in_in_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test addition of negative and positive numbers to zero result and Test init
        let in_in_add2: Number = -5 + Number(NaturalNumber(RationalNumber(5))!)
        XCTAssertEqual(in_in_add2, 0, "Addition of integer and integer resulting in zero failed")
        XCTAssertEqual(in_in_add2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test addition of negative and positive numbers to negative result
        let in_in_add3: Number = -3 + -5
        XCTAssertEqual(in_in_add3, -8, "Addition of integer and integer resulting in negative integer failed")
        XCTAssertEqual(in_in_add3.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test addition of negative and terminating fractional numbers
        let in_fr_add1: Number = -5 + half
        XCTAssertEqual(in_fr_add1, -9 / 2, "Addition of integer and terminating fraction failed")
        XCTAssertEqual(in_fr_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of negative and repeating fractional numbers
        let in_fr_add2: Number = -5 + third
        XCTAssertEqual(in_fr_add2, -14 / 3, "Addition of integer and repeating fraction failed")
        XCTAssertEqual(in_fr_add2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Addition

        // Test addition of negative and imaginary number to complex result
        let in_im_add1: Number = -5 + Number(imaginary: 3)
        XCTAssertEqual(in_im_add1, Number(ComplexNumber(real: -5, imaginary: 3)), "Addition of integer and imaginary number failed")
        XCTAssertEqual(in_im_add1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of negative and imaginary number to complex result
        let in_im_add2: Number = -5 + .imaginary(from: -3)
        XCTAssertEqual(in_im_add2, Number(ComplexNumber(real: -5, imaginary: -3)), "Addition of integer and imaginary number failed")
        XCTAssertEqual(in_im_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of negative and complex number to complex result
        let in_cn_add1: Number = -5 + Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(in_cn_add1, Number(ImaginaryNumber(3)), "Addition of integer and complex number failed")
        XCTAssertEqual(in_cn_add1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test addition of negative and complex number to an imaginary result
        let in_cn_add2: Number = -5 + Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(in_cn_add2, Number(ComplexNumber(real: -10, imaginary: -3)), "Addition of integer and complex number failed")
        XCTAssertEqual(in_cn_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// SimpleFraction Addition
        // Test addition of fraction number and zero
        let fr_wn_add1: Number = half + 0
        XCTAssertEqual(fr_wn_add1, half, "Addition of fraction and zero failed")
        XCTAssertEqual(fr_wn_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of fraction and positive numbers to positive result and Test init
        let fr_in_add1: Number = half + Number(NaturalNumber(Number(8))!)
        XCTAssertEqual(fr_in_add1, 17 / 2, "Addition of fraction and fraction failed")
        XCTAssertEqual(fr_in_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of fraction and fraction to zero result
        let fr_in_add2: Number = half + -half
        XCTAssertEqual(fr_in_add2, 0, "Addition of fraction and fraction resulting in zero failed")
        XCTAssertEqual(fr_in_add2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test addition of fraction and negative number to negative result
        let fr_in_add3: Number = -half + -3
        XCTAssertEqual(fr_in_add3, -7 / 2, "Addition of fraction and fraction resulting in negative fraction failed")
        XCTAssertEqual(fr_in_add3.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of fraction and terminating fractional numbers
        let quarter: Number = 1 / 4
        let fr_fr_add1: Number = half + quarter
        XCTAssertEqual(fr_fr_add1, 3 / 4, "Addition of fraction and terminating fraction failed")
        XCTAssertEqual(fr_fr_add1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test addition of fraction and repeating fractional numbers
        let fr_fr_add2: Number = half + third
        XCTAssertEqual(fr_fr_add2, 5 / 6, "Addition of fraction and repeating fraction failed")
        XCTAssertEqual(fr_fr_add2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Addition

        // Test addition of fraction and imaginary number to complex result
        let fr_im_add1: Number = half + Number(imaginary: 3)
        XCTAssertEqual(fr_im_add1, Number(ComplexNumber(real: RealNumber(half)!, imaginary: 3)), "Addition of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_add1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of fraction and imaginary number to complex result
        let fr_im_add2: Number = half + .imaginary(from: -3)
        XCTAssertEqual(fr_im_add2, Number(ComplexNumber(real: RealNumber(half)!, imaginary: -3)), "Addition of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test addition of fraction and complex number to complex result
        let fr_cn_add1: Number = half + Number(ComplexNumber(real: RealNumber(-half)!, imaginary: 3))
        XCTAssertEqual(fr_cn_add1, Number(ImaginaryNumber(3)), "Addition of fraction and complex number failed")
        XCTAssertEqual(fr_cn_add1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test addition of fraction and complex number to an imaginary result
        let fr_cn_add2: Number = -half + Number(ComplexNumber(real: RealNumber(-half)!, imaginary: -3))
        XCTAssertEqual(fr_cn_add2, Number(ComplexNumber(real: -1, imaginary: -3)), "Addition of fraction and complex number failed")
        XCTAssertEqual(fr_cn_add2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

    }

    func testSubtraction() {
        /// Natural Number Subtraction
        // Test subtraction of positive numbers
        let nn_nn_sub1: Number = 5 - 3
        XCTAssertEqual(nn_nn_sub1, 2, "Subtraction of natural numbers failed")
        XCTAssertEqual(nn_nn_sub1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive number and zero
        let nn_wn_sub1: Number = 5 - 0
        XCTAssertEqual(nn_wn_sub1, 5, "Subtraction of natural number and zero failed")
        XCTAssertEqual(nn_wn_sub1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and negative numbers to positive result
        let nn_in_sub1: Number = 5 - -3
        XCTAssertEqual(nn_in_sub1, 8, "Subtraction of natural number and integer failed")
        XCTAssertEqual(nn_in_sub1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and negative numbers to zero result
        let nn_in_sub2: Number = 5 - 5
        XCTAssertEqual(nn_in_sub2, 0, "Subtraction of natural number and integer resulting in zero failed")
        XCTAssertEqual(nn_in_sub2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and negative numbers to negative result
        let nn_in_sub3: Number = 3 - 5
        XCTAssertEqual(nn_in_sub3, -2, "Subtraction of natural number and integer resulting in negative integer failed")
        XCTAssertEqual(nn_in_sub3.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test subtraction of positive and terminating fractional numbers
        let half: Number = 1 / 2
        let nn_fr_sub1: Number = 5 - half
        XCTAssertEqual(nn_fr_sub1, 9 / 2, "Subtraction of natural number and terminating fraction failed")
        XCTAssertEqual(nn_fr_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of positive and repeating fractional numbers
        let third: Number = 1 / 3
        let nn_fr_sub2: Number = 5 - third
        XCTAssertEqual(nn_fr_sub2, 14 / 3, "Subtraction of natural number and repeating fraction failed")
        XCTAssertEqual(nn_fr_sub2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Subtraction

        // Test subtraction of positive and imaginary number to complex result
        let nn_im_sub1: Number = 5 - Number(imaginary: 3)
        XCTAssertEqual(nn_im_sub1, Number(ComplexNumber(real: 5, imaginary: -3)), "Subtraction of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and imaginary number to complex result
        let nn_im_sub2: Number = 5 - .imaginary(from: -3)
        XCTAssertEqual(nn_im_sub2, Number(ComplexNumber(real: 5, imaginary: 3)), "Subtraction of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_sub2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and complex number to complex result
        let nn_cn_sub1: Number = 5 - Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(nn_cn_sub1, Number(ImaginaryNumber(-3)), "Subtraction of natural number and complex number failed")
        XCTAssertEqual(nn_cn_sub1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and complex number to an imaginary result
        let nn_cn_sub2: Number = 5 - Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(nn_cn_sub2, Number(ComplexNumber(real: 10, imaginary: 3)), "Subtraction of natural number and complex number failed")
        XCTAssertEqual(nn_cn_sub2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// Whole Number Subtraction
        // Test subtraction of zero and positive number
        let wn_nn_sub1: Number = 0 - 3
        XCTAssertEqual(wn_nn_sub1, -3, "Subtraction with zero failed")
        XCTAssertEqual(wn_nn_sub1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test subtraction of zero
        let wn_wn_sub1: Number = 0 - 0
        XCTAssertEqual(wn_wn_sub1, 0, "Subtraction of zeroes failed")
        XCTAssertEqual(wn_wn_sub1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test subtraction of zero and negative numbers to positive result
        let wn_in_sub1: Number = 0 - -3
        XCTAssertEqual(wn_in_sub1, 3, "Subtraction of zero and integer failed")
        XCTAssertEqual(wn_in_sub1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of zero and terminating fractional numbers
        let wn_fr_sub1: Number = 0 - half
        XCTAssertEqual(wn_fr_sub1, -1 / 2, "Subtraction of natural number and terminating fraction failed")
        XCTAssertEqual(wn_fr_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of zero and repeating fractional numbers
        let wn_fr_sub2: Number = 0 - third
        XCTAssertEqual(wn_fr_sub2, -1 / 3, "Subtraction of zero and repeating fraction failed")
        XCTAssertEqual(wn_fr_sub2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - WholeNumber & IrrationalNumber Subtraction

        // Test subtraction of positive and imaginary numbers to complex result
        let wn_im_sub1: Number = 0 - Number(imaginary: 3)
        XCTAssertEqual(wn_im_sub1, Number(ImaginaryNumber(-3)), "Subtraction of zero and imaginary number failed")
        XCTAssertEqual(wn_im_sub1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and imaginary numbers to complex result
        let wn_im_sub2: Number = 0 - .imaginary(from: -3)
        XCTAssertEqual(wn_im_sub2, Number(ImaginaryNumber(3)), "Subtraction of zero and imaginary number failed")
        XCTAssertEqual(wn_im_sub2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and complex numbers to complex result
        let wn_cn_sub1: Number = 0 - Number(ComplexNumber(real: 1, imaginary: 3))
        XCTAssertEqual(wn_cn_sub1, Number(ComplexNumber(real: -1, imaginary: -3)), "Subtraction of zero and complex number failed")
        XCTAssertEqual(wn_cn_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of positive and negative numbers to positive result
        let wn_cn_sub2: Number = 0 - Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(wn_cn_sub2, Number(ComplexNumber(real: 5, imaginary: 3)), "Subtraction of zero and complex number failed")
        XCTAssertEqual(wn_cn_sub2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// Integer Number Subtraction
        // Test subtraction of negative number and zero
        let in_wn_sub1: Number = -5 - 0
        XCTAssertEqual(in_wn_sub1, -5, "Subtraction of integer and zero failed")
        XCTAssertEqual(in_wn_sub1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test subtraction of negative and positive numbers to positive result
        let in_in_sub1: Number = -5 - 8
        XCTAssertEqual(in_in_sub1, -13, "Subtraction of integer and integer failed")
        XCTAssertEqual(in_in_sub1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test subtraction of negative and positive numbers to zero result
        let in_in_sub2: Number = -5 - 5
        XCTAssertEqual(in_in_sub2, -10, "Subtraction of integer and integer resulting in zero failed")
        XCTAssertEqual(in_in_sub2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test subtraction of negative and positive numbers to negative result
        let in_in_sub3: Number = -3 - -5
        XCTAssertEqual(in_in_sub3, 2, "Subtraction of integer and integer resulting in negative integer failed")
        XCTAssertEqual(in_in_sub3.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of negative and terminating fractional numbers
        let in_fr_sub1: Number = -5 - half
        XCTAssertEqual(in_fr_sub1, -11 / 2, "Subtraction of integer and terminating fraction failed")
        XCTAssertEqual(in_fr_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of negative and repeating fractional numbers
        let in_fr_sub2: Number = -5 - third
        XCTAssertEqual(in_fr_sub2, -16 / 3, "Subtraction of integer and repeating fraction failed")
        XCTAssertEqual(in_fr_sub2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Subtraction

        // Test subtraction of negative and imaginary number to complex result
        let in_im_sub1: Number = -5 - Number(imaginary: 3)
        XCTAssertEqual(in_im_sub1, Number(ComplexNumber(real: -5, imaginary: -3)), "Subtraction of integer and imaginary number failed")
        XCTAssertEqual(in_im_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of negative and imaginary number to complex result
        let in_im_sub2: Number = -5 - .imaginary(from: -3)
        XCTAssertEqual(in_im_sub2, Number(ComplexNumber(real: -5, imaginary: 3)), "Subtraction of integer and imaginary number failed")
        XCTAssertEqual(in_im_sub2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of negative and complex number to complex result
        let in_cn_sub1: Number = -5 - Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(in_cn_sub1, Number(ComplexNumber(real: -10, imaginary: -3)), "Subtraction of integer and complex number failed")
        XCTAssertEqual(in_cn_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of negative and complex number to an imaginary result
        let in_cn_sub2: Number = -5 - Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(in_cn_sub2, Number(ImaginaryNumber(3)), "Subtraction of integer and complex number failed")
        XCTAssertEqual(in_cn_sub2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        /// SimpleFraction Subtraction
        // Test subtraction of fraction number and zero
        let fr_wn_sub1: Number = half - 0
        XCTAssertEqual(fr_wn_sub1, half, "Subtraction of fraction and zero failed")
        XCTAssertEqual(fr_wn_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and positive numbers to positive result
        let fr_in_sub1: Number = half - 8
        XCTAssertEqual(fr_in_sub1, -15 / 2, "Subtraction of fraction and fraction failed")
        XCTAssertEqual(fr_in_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and fraction to zero result
        let fr_in_sub2: Number = half - -half
        XCTAssertEqual(fr_in_sub2, 1, "Subtraction of fraction and fraction resulting in zero failed")
        XCTAssertEqual(fr_in_sub2.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and negative number to negative result
        let fr_in_sub3: Number = -half - -3
        XCTAssertEqual(fr_in_sub3, 5 / 2, "Subtraction of fraction and fraction resulting in negative fraction failed")
        XCTAssertEqual(fr_in_sub3.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and terminating fractional numbers
        let quarter: Number = 1 / 4
        let fr_fr_sub1: Number = half - quarter
        XCTAssertEqual(fr_fr_sub1, 1 / 4, "Subtraction of fraction and terminating fraction failed")
        XCTAssertEqual(fr_fr_sub1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and repeating fractional numbers
        let fr_fr_sub2: Number = half - third
        XCTAssertEqual(fr_fr_sub2, 1 / 6, "Subtraction of fraction and repeating fraction failed")
        XCTAssertEqual(fr_fr_sub2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Subtraction

        // Test subtraction of fraction and imaginary number to complex result
        let fr_im_sub1: Number = half - Number(imaginary: 3)
        XCTAssertEqual(fr_im_sub1, Number(ComplexNumber(real: RealNumber(half)!, imaginary: -3)), "Subtraction of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and imaginary number to complex result
        let fr_im_sub2: Number = half - .imaginary(from: -3)
        XCTAssertEqual(fr_im_sub2, Number(ComplexNumber(real: RealNumber(half)!, imaginary: 3)), "Subtraction of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_sub2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and complex number to complex result
        let fr_cn_sub1: Number = half - Number(ComplexNumber(real: RealNumber(-half)!, imaginary: 3))
        XCTAssertEqual(fr_cn_sub1, Number(ComplexNumber(real: 1, imaginary: -3)), "Subtraction of fraction and complex number failed")
        XCTAssertEqual(fr_cn_sub1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test subtraction of fraction and complex number to an imaginary result
        let fr_cn_sub2: Number = -half - Number(ComplexNumber(real: RealNumber(-half)!, imaginary: -3))
        XCTAssertEqual(fr_cn_sub2, Number(ImaginaryNumber(3)), "Subtraction of fraction and complex number failed")
        XCTAssertEqual(fr_cn_sub2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")
    }


    func testMultiplication() {
        /// Natural Number Multiplication
        // Test multiplication of positive numbers
        let nn_nn_mul1: Number = 5 * 3
        XCTAssertEqual(nn_nn_mul1, 15, "Multiplication of natural numbers failed")
        XCTAssertEqual(nn_nn_mul1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive number and zero
        let nn_wn_mul1: Number = 5 * 0
        XCTAssertEqual(nn_wn_mul1, 0, "Multiplication of natural number and zero failed")
        XCTAssertEqual(nn_wn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and negative numbers to positive result
        let nn_in_mul1: Number = 5 * -3
        XCTAssertEqual(nn_in_mul1, -15, "Multiplication of natural number and integer failed")
        XCTAssertEqual(nn_in_mul1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test multiplication of positive and negative numbers to zero result
        let nn_in_mul2: Number = 5 * -5
        XCTAssertEqual(nn_in_mul2, -25, "Multiplication of natural number and integer resulting in zero failed")
        XCTAssertEqual(nn_in_mul2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test multiplication of positive and negative numbers to negative result
        let nn_in_mul3: Number = 3 * -5
        XCTAssertEqual(nn_in_mul3, -15, "Multiplication of natural number and integer resulting in negative integer failed")
        XCTAssertEqual(nn_in_mul3.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test multiplication of positive and terminating fractional numbers
        let half: Number = 1 / 2
        let nn_fr_mul1: Number = 5 * half
        XCTAssertEqual(nn_fr_mul1, 5 / 2, "Multiplication of natural number and terminating fraction failed")
        XCTAssertEqual(nn_fr_mul1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test multiplication of positive and repeating fractional numbers
        let third: Number = 1 / 3
        let nn_fr_mul2: Number = 5 * third
        XCTAssertEqual(nn_fr_mul2, 5 / 3, "Multiplication of natural number and repeating fraction failed")
        XCTAssertEqual(nn_fr_mul2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Multiplication

        // Test multiplication of positive and imaginary number to complex result
        let nn_im_mul1: Number = 5 * Number(imaginary: 3)
        XCTAssertEqual(nn_im_mul1, Number(ImaginaryNumber(15)), "Multiplication of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_mul1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and imaginary number to complex result
        let nn_im_mul2: Number = 5 * .imaginary(from: -3)
        XCTAssertEqual(nn_im_mul2, Number(ImaginaryNumber(-15)), "Multiplication of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_mul2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and complex number to complex result
        let nn_cn_mul1: Number = 5 * Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(nn_cn_mul1, Number(ComplexNumber(real: 25, imaginary: 15)), "Multiplication of natural number and complex number failed")
        XCTAssertEqual(nn_cn_mul1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and complex number to an imaginary result and Test init
        let nn_cn_mul2: Number = Number(WholeNumber(SimpleFraction(5))!) * Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(nn_cn_mul2, Number(ComplexNumber(real: -25, imaginary: -15)), "Multiplication of natural number and complex number failed")
        XCTAssertEqual(nn_cn_mul2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// Whole Number Multiplication
        // Test multiplication of zero and positive number
        let wn_nn_mul1: Number = 0 * 3
        XCTAssertEqual(wn_nn_mul1, 0, "Multiplication with zero failed")
        XCTAssertEqual(wn_nn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of zero
        let wn_wn_mul1: Number = 0 * 0
        XCTAssertEqual(wn_wn_mul1, 0, "Multiplication of zeroes failed")
        XCTAssertEqual(wn_wn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of zero and negative numbers to positive result
        let wn_in_mul1: Number = 0 * -3
        XCTAssertEqual(wn_in_mul1, 0, "Multiplication of zero and integer failed")
        XCTAssertEqual(wn_in_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of zero and terminating fractional numbers and Test init
        let wn_fr_mul1: Number = Number(WholeNumber(Number.zero)!) * half
        XCTAssertEqual(wn_fr_mul1, 0, "Multiplication of natural number and terminating fraction failed")
        XCTAssertEqual(wn_fr_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of zero and repeating fractional numbers and Test init
        let wn_fr_mul2: Number = Number(WholeNumber(RealNumber.zero)!) * third
        XCTAssertEqual(wn_fr_mul2, 0, "Multiplication of zero and repeating fraction failed")
        XCTAssertEqual(wn_fr_mul2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // TODO: - WholeNumber & IrrationalNumber Multiplication

        // Test multiplication of positive and imaginary numbers to complex result and Test init
        let wn_im_mul1: Number = Number(WholeNumber(RationalNumber.zero)!) * Number(imaginary: 3)
        XCTAssertEqual(wn_im_mul1, 0, "Multiplication of zero and imaginary number failed")
        XCTAssertEqual(wn_im_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and imaginary numbers to complex result and Test init
        let wn_im_mul2: Number = Number(WholeNumber(Integer.zero)!) * .imaginary(from: -3)
        XCTAssertEqual(wn_im_mul2, 0, "Multiplication of zero and imaginary number failed")
        XCTAssertEqual(wn_im_mul2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and complex numbers to complex result
        let wn_cn_mul1: Number = 0 * Number(ComplexNumber(real: 1, imaginary: 3))
        XCTAssertEqual(wn_cn_mul1, 0, "Multiplication of zero and complex number failed")
        XCTAssertEqual(wn_cn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of positive and negative numbers to positive result
        let wn_cn_mul2: Number = 0 * Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(wn_cn_mul2, 0, "Multiplication of zero and complex number failed")
        XCTAssertEqual(wn_cn_mul2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        /// Integer Number Multiplication
        // Test multiplication of negative number and zero
        let in_wn_mul1: Number = -5 * 0
        XCTAssertEqual(in_wn_mul1, 0, "Multiplication of integer and zero failed")
        XCTAssertEqual(in_wn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of negative and positive numbers to positive result
        let in_in_mul1: Number = -5 * 8
        XCTAssertEqual(in_in_mul1, -40, "Multiplication of integer and integer failed")
        XCTAssertEqual(in_in_mul1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test multiplication of negative and positive numbers to zero result
        let in_in_mul2: Number = -5 * 5
        XCTAssertEqual(in_in_mul2, -25, "Multiplication of integer and integer resulting in zero failed")
        XCTAssertEqual(in_in_mul2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test multiplication of negative and positive numbers to negative result
        let in_in_mul3: Number = -3 * -5
        XCTAssertEqual(in_in_mul3, 15, "Multiplication of integer and integer resulting in negative integer failed")
        XCTAssertEqual(in_in_mul3.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test multiplication of negative and terminating fractional numbers
        let in_fr_mul1: Number = -5 * half
        XCTAssertEqual(in_fr_mul1, -5 / 2, "Multiplication of integer and terminating fraction failed")
        XCTAssertEqual(in_fr_mul1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test multiplication of negative and repeating fractional numbers
        let in_fr_mul2: Number = -5 * third
        XCTAssertEqual(in_fr_mul2, -5 / 3, "Multiplication of integer and repeating fraction failed")
        XCTAssertEqual(in_fr_mul2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Multiplication

        // Test multiplication of negative and imaginary number to complex result
        let in_im_mul1: Number = -5 * Number(imaginary: 3)
        XCTAssertEqual(in_im_mul1, Number(ImaginaryNumber(-15)), "Multiplication of integer and imaginary number failed")
        XCTAssertEqual(in_im_mul1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of negative and imaginary number to complex result
        let in_im_mul2: Number = -5 * .imaginary(from: -3)
        XCTAssertEqual(in_im_mul2, Number(ImaginaryNumber(15)), "Multiplication of integer and imaginary number failed")
        XCTAssertEqual(in_im_mul2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of negative and complex number to complex result
        let in_cn_mul1: Number = -5 * Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(in_cn_mul1, Number(ComplexNumber(real: -25, imaginary: -15)), "Multiplication of integer and complex number failed")
        XCTAssertEqual(in_cn_mul1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test multiplication of negative and complex number to an imaginary result
        let in_cn_mul2: Number = -5 * Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(in_cn_mul2, Number(ComplexNumber(real: 25, imaginary: 15)), "Multiplication of integer and complex number failed")
        XCTAssertEqual(in_cn_mul2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// SimpleFraction Multiplication
        // Test multiplication of fraction number and zero
        let fr_wn_mul1: Number = half * 0
        XCTAssertEqual(fr_wn_mul1, 0, "Multiplication of fraction and zero failed")
        XCTAssertEqual(fr_wn_mul1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and positive numbers to positive result
        let fr_in_mul1: Number = half * 8
        XCTAssertEqual(fr_in_mul1, 4, "Multiplication of fraction and fraction failed")
        XCTAssertEqual(fr_in_mul1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and fraction to zero result
        let fr_in_mul2: Number = half * -half
        XCTAssertEqual(fr_in_mul2, -1 / 4, "Multiplication of fraction and fraction resulting in zero failed")
        XCTAssertEqual(fr_in_mul2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and negative number to negative result
        let fr_in_mul3: Number = -half * -3
        XCTAssertEqual(fr_in_mul3, 3 / 2, "Multiplication of fraction and fraction resulting in negative fraction failed")
        XCTAssertEqual(fr_in_mul3.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and terminating fractional numbers
        let quarter: Number = 1 / 4
        let fr_fr_mul1: Number = half * quarter
        XCTAssertEqual(fr_fr_mul1, 1 / 8, "Multiplication of fraction and terminating fraction failed")
        XCTAssertEqual(fr_fr_mul1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and repeating fractional numbers
        let fr_fr_mul2: Number = half * third
        XCTAssertEqual(fr_fr_mul2, 1 / 6, "Multiplication of fraction and repeating fraction failed")
        XCTAssertEqual(fr_fr_mul2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Multiplication

        // Test multiplication of fraction and imaginary number to complex result
        let threeHalves: Number = 3 / 2
        let fr_im_mul1: Number = half * Number(imaginary: 3)
        XCTAssertEqual(fr_im_mul1, Number(ImaginaryNumber(RealNumber(threeHalves)!)), "Multiplication of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_mul1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and imaginary number to complex result
        let fr_im_mul2: Number = half * .imaginary(from: -3)
        XCTAssertEqual(fr_im_mul2, Number(ImaginaryNumber(RealNumber(-threeHalves)!)), "Multiplication of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_mul2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and complex number to complex result
        let fr_cn_mul1: Number = half * Number(ComplexNumber(real: RealNumber(-half)!, imaginary: 3))
        XCTAssertEqual(fr_cn_mul1, Number(ComplexNumber(real: RealNumber(-quarter)!, imaginary: ImaginaryNumber(RealNumber(threeHalves)!))), "Multiplication of fraction and complex number failed")
        XCTAssertEqual(fr_cn_mul1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test multiplication of fraction and complex number to an imaginary result
        let fr_cn_mul2: Number = -half * Number(ComplexNumber(real: RealNumber(-half)!, imaginary: -3))
        XCTAssertEqual(fr_cn_mul2, Number(ComplexNumber(real: RealNumber(quarter)!, imaginary: ImaginaryNumber(RealNumber(threeHalves)!))), "Multiplication of fraction and complex number failed")
        XCTAssertEqual(fr_cn_mul2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")
    }


    func testDivision() {
        /// Natural Number Division
        // Test division of positive numbers
        let nn_nn_div1: Number = 15 / 3
        XCTAssertEqual(nn_nn_div1, 5, "Division of natural numbers failed")
        XCTAssertEqual(nn_nn_div1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test division of positive number and negative numbers to positive result
        let nn_in_div1: Number = 15 / -3
        XCTAssertEqual(nn_in_div1, -5, "Division of natural number and integer failed")
        XCTAssertEqual(nn_in_div1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test division of positive number and zero
        let nn_wn_div1: Number = 15 / 5
        XCTAssertEqual(nn_wn_div1, 3, "Division of natural number and zero failed")
        XCTAssertEqual(nn_wn_div1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test division of positive and terminating fractional numbers
        let half: Number = 1 / 2
        let nn_fr_div1: Number = 15 / half
        XCTAssertEqual(nn_fr_div1, 30, "Division of natural number and terminating fraction failed")
        XCTAssertEqual(nn_fr_div1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test division of positive and repeating fractional numbers
        let third: Number = 1 / 3
        let nn_fr_div2: Number = 15 / third
        XCTAssertEqual(nn_fr_div2, 45, "Division of natural number and repeating fraction failed")
        XCTAssertEqual(nn_fr_div2.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Division

        // Test division of positive and imaginary number to complex result
        let nn_im_div1: Number = 15 / Number(imaginary: 3)
        XCTAssertEqual(nn_im_div1, Number(ImaginaryNumber(-5)), "Division of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_div1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of positive and imaginary number to complex result
        let nn_im_div2: Number = 15 / .imaginary(from: -3)
        XCTAssertEqual(nn_im_div2, Number(ImaginaryNumber(5)), "Division of natural number and imaginary number failed")
        XCTAssertEqual(nn_im_div2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of positive and complex number to complex result
        let seventyFiveThirtyFourths: Number = 75 / 34
        let fortyFiveThirtyFourths: Number = 45 / 34
        let nn_cn_div1: Number = 15 / Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(nn_cn_div1, Number(ComplexNumber(real: RealNumber(seventyFiveThirtyFourths)!, imaginary: ImaginaryNumber(RealNumber(-fortyFiveThirtyFourths)!))), "Division of natural number and complex number failed")
        XCTAssertEqual(nn_cn_div1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test division of positive and complex number to an imaginary result
        let nn_cn_div2: Number = 15 / Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(nn_cn_div2, Number(ComplexNumber(real: RealNumber(-seventyFiveThirtyFourths)!, imaginary: ImaginaryNumber(RealNumber(fortyFiveThirtyFourths)!))), "Division of natural number and complex number failed")
        XCTAssertEqual(nn_cn_div2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// Whole Number Division
        // Test division of zero and positive number
        let wn_nn_div1: Number = 0 / 3
        XCTAssertEqual(wn_nn_div1, 0, "Division with zero failed")
        XCTAssertEqual(wn_nn_div1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of zero by positive number
        let wn_nn_div2: Number = 0 / 5
        XCTAssertEqual(wn_nn_div2, 0, "Division with zero failed")
        XCTAssertEqual(wn_nn_div2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of zero and negative numbers to positive result
        let wn_in_div1: Number = 0 / -3
        XCTAssertEqual(wn_in_div1, 0, "Division of zero and integer failed")
        XCTAssertEqual(wn_in_div1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of zero and terminating fractional numbers
        let wn_fr_div1: Number = 0 / half
        XCTAssertEqual(wn_fr_div1, 0, "Division of natural number and terminating fraction failed")
        XCTAssertEqual(wn_fr_div1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of zero and repeating fractional numbers
        let wn_fr_div2: Number = 0 / third
        XCTAssertEqual(wn_fr_div2, 0, "Division of zero and repeating fraction failed")
        XCTAssertEqual(wn_fr_div2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // TODO: - WholeNumber & IrrationalNumber Division

        // Test division of positive and imaginary numbers to complex result
        let wn_im_div1: Number = 0 / Number(imaginary: 3)
        XCTAssertEqual(wn_im_div1, 0, "Division of zero and imaginary number failed")
        XCTAssertEqual(wn_im_div1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of positive and imaginary numbers to complex result
        let wn_im_div2: Number = 0 / .imaginary(from: -3)
        XCTAssertEqual(wn_im_div2, 0, "Division of zero and imaginary number failed")
        XCTAssertEqual(wn_im_div2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of positive and complex numbers to complex result
        let wn_cn_div1: Number = 0 / Number(ComplexNumber(real: 1, imaginary: 3))
        XCTAssertEqual(wn_cn_div1, 0, "Division of zero and complex number failed")
        XCTAssertEqual(wn_cn_div1.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        // Test division of positive and negative numbers to positive result
        let wn_cn_div2: Number = 0 / Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(wn_cn_div2, 0, "Division of zero and complex number failed")
        XCTAssertEqual(wn_cn_div2.typeValue, "\(type(of: WholeNumber.self))", "Unexpected internal type produced")

        /// Integer Number Division
        // Test division of negative and positive numbers to positive result and Test init
        let in_in_div1: Number = Number(Integer(RationalNumber(-40))!) / 8
        XCTAssertEqual(in_in_div1, -5, "Division of integer and integer failed")
        XCTAssertEqual(in_in_div1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test division of negative and positive numbers to zero result and Test init
        let in_in_div2: Number = Number(Integer(RealNumber(-25))!) / 5
        XCTAssertEqual(in_in_div2, -5, "Division of integer and integer resulting in zero failed")
        XCTAssertEqual(in_in_div2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test division of negative and positive numbers to negative result and Test init
        let in_in_div3: Number = Number(Integer(Number(-15))!) / -3
        XCTAssertEqual(in_in_div3, 5, "Division of integer and integer resulting in negative integer failed")
        XCTAssertEqual(in_in_div3.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test division of negative and terminating fractional numbers
        let in_fr_div1: Number = -9 / half
        XCTAssertEqual(in_fr_div1, -18, "Division of integer and terminating fraction failed")
        XCTAssertEqual(in_fr_div1.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test division of negative and repeating fractional numbers
        let in_fr_div2: Number = -14 / third
        XCTAssertEqual(in_fr_div2, -42, "Division of integer and repeating fraction failed")
        XCTAssertEqual(in_fr_div2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Division

        // Test division of negative and imaginary number to complex result
        let in_im_div1: Number = -15 / Number(imaginary: 3)
        XCTAssertEqual(in_im_div1, Number(ImaginaryNumber(5)), "Division of integer and imaginary number failed")
        XCTAssertEqual(in_im_div1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of negative and imaginary number to complex result
        let in_im_div2: Number = -15 / .imaginary(from: -3)
        XCTAssertEqual(in_im_div2, Number(ImaginaryNumber(-5)), "Division of integer and imaginary number failed")
        XCTAssertEqual(in_im_div2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of negative and complex number to complex result
        let oneHundredTwentyFiveThirtyFourths: Number = 125 / 34
        let in_cn_div1: Number = -25 / Number(ComplexNumber(real: 5, imaginary: 3))
        XCTAssertEqual(in_cn_div1, Number(ComplexNumber(real: RealNumber(-oneHundredTwentyFiveThirtyFourths)!, imaginary: ImaginaryNumber(RealNumber(seventyFiveThirtyFourths)!))), "Division of integer and complex number failed")
        XCTAssertEqual(in_cn_div1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test division of negative and complex number to an imaginary result
        let fifteenSeventeenths: Number = 15 / 17
        let twentyFiveSeventeenths: Number = 25 / 17
        let in_cn_div2: Number = -10 / Number(ComplexNumber(real: -5, imaginary: -3))
        XCTAssertEqual(in_cn_div2, Number(ComplexNumber(real: RealNumber(twentyFiveSeventeenths)!, imaginary: ImaginaryNumber(RealNumber(-fifteenSeventeenths)!))), "Division of integer and complex number failed")
        XCTAssertEqual(in_cn_div2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        /// SimpleFraction Division
        // Test division of fraction and positive numbers to positive result
        let fr_in_div1: Number = half / 8
        XCTAssertEqual(fr_in_div1, 1 / 16, "Division of fraction and fraction failed")
        XCTAssertEqual(fr_in_div1.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test division of fraction and fraction to zero result
        let fr_in_div2: Number = half / -half
        XCTAssertEqual(fr_in_div2, -1, "Division of fraction and fraction resulting in zero failed")
        XCTAssertEqual(fr_in_div2.typeValue, "\(type(of: Integer.self))", "Unexpected internal type produced")

        // Test division of fraction and negative number to negative result
        let fr_in_div3: Number = -half / -3
        XCTAssertEqual(fr_in_div3, 1 / 6, "Division of fraction and fraction resulting in negative fraction failed")
        XCTAssertEqual(fr_in_div3.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // Test division of fraction and terminating fractional numbers
        let quarter: Number = 1 / 4
        let fr_fr_div1: Number = half / quarter
        XCTAssertEqual(fr_fr_div1, 2, "Division of fraction and terminating fraction failed")
        XCTAssertEqual(fr_fr_div1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")

        // Test division of fraction and repeating fractional numbers
        let fr_fr_div2: Number = half / third
        XCTAssertEqual(fr_fr_div2, 3 / 2, "Division of fraction and repeating fraction failed")
        XCTAssertEqual(fr_fr_div2.typeValue, "\(type(of: SimpleFraction.self))", "Unexpected internal type produced")

        // TODO: - NaturalNumber & IrrationalNumber Division

        // Test division of fraction and imaginary number to complex result
        let oneSixth: Number = 1 / 6
        let fr_im_div1: Number = half / Number(imaginary: 3)
        XCTAssertEqual(fr_im_div1, Number(ImaginaryNumber(RealNumber(-oneSixth)!)), "Division of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_div1.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of fraction and imaginary number to complex result
        let fr_im_div2: Number = half / .imaginary(from: -3)
        XCTAssertEqual(fr_im_div2, Number(ImaginaryNumber(RealNumber(oneSixth)!)), "Division of fraction and imaginary number failed")
        XCTAssertEqual(fr_im_div2.typeValue, "\(type(of: ImaginaryNumber.self))", "Unexpected internal type produced")

        // Test division of fraction and complex number to complex result
        let oneThirtySevenths: Number = 1 / 37
        let sixThirtySevenths: Number = 6 / 37
        let fr_cn_div1: Number = half / Number(ComplexNumber(real: RealNumber(-half)!, imaginary: 3))
        XCTAssertEqual(fr_cn_div1, Number(ComplexNumber(real: RealNumber(-oneThirtySevenths)!, imaginary: ImaginaryNumber(RealNumber(-sixThirtySevenths)!))), "Division of fraction and complex number failed")
        XCTAssertEqual(fr_cn_div1.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")

        // Test division of fraction and complex number to an imaginary result
        let fr_cn_div2: Number = -half / Number(ComplexNumber(real: RealNumber(-half)!, imaginary: -3))
        XCTAssertEqual(fr_cn_div2, Number(ComplexNumber(real: RealNumber(oneThirtySevenths)!, imaginary: ImaginaryNumber(RealNumber(-sixThirtySevenths)!))), "Division of fraction and complex number failed")
        XCTAssertEqual(fr_cn_div2.typeValue, "\(type(of: ComplexNumber.self))", "Unexpected internal type produced")
    }

    func testComplex() {
        let lhs = ComplexNumber(real: 2, imaginary: 3)
        let rhs = ComplexNumber(real: 1, imaginary: -4)
        XCTAssertEqual(lhs * rhs, ComplexNumber(real: 14, imaginary: -5))

        let lhs2 = ComplexNumber(real: 3, imaginary: 2)
        let rhs2 = ImaginaryNumber(14)
        XCTAssertEqual(lhs2 * rhs2, ComplexNumber(real: -28, imaginary: 42))

        let lhs3 = ImaginaryNumber(2)
        let rhs3 = ComplexNumber(real: 3, imaginary: 4)
        let exp1 = SimpleFraction(numerator: 8, denominator: 25)
        let exp2 = SimpleFraction(numerator: 6, denominator: 25)
        XCTAssertEqual(lhs3 / rhs3, ComplexNumber(real: RealNumber(exp1), imaginary: ImaginaryNumber(RealNumber(exp2))))
    }

    func testComparable() {
        // Natural Number
        XCTAssertTrue(NaturalNumber.two > NaturalNumber.one)
        XCTAssertTrue(NaturalNumber.one > WholeNumber.zero)
        XCTAssertTrue(NaturalNumber.one > Integer(-2))
        XCTAssertTrue(NaturalNumber.one > SimpleFraction(numerator: 2, denominator: 3))
        XCTAssertTrue(NaturalNumber.two > RationalNumber.one)
        //        XCTAssertTrue(NaturalNumber.two > RealFraction(numerator: RealNumber.one, denominator: RealNumber.two))
        //        XCTAssertTrue(NaturalNumber.two > RealNumber.one)
        //        XCTAssertTrue(NaturalNumber.two > ImaginaryNumber.one)
        //        XCTAssertTrue(NaturalNumber.two > ComplexNumber.one)
        //        XCTAssertTrue(NaturalNumber.two > Number.one)

        // Whole Number
        XCTAssertTrue(WholeNumber.zero < NaturalNumber.one)
        XCTAssertFalse(WholeNumber.zero > WholeNumber.zero)
        XCTAssertTrue(WholeNumber.zero > Integer(-2))
        XCTAssertTrue(WholeNumber.zero < SimpleFraction(numerator: 2, denominator: 3))
        XCTAssertTrue(WholeNumber.zero < RationalNumber.one)
        //        XCTAssertTrue(WholeNumber.zero < RealFraction(numerator: RealNumber.one, denominator: RealNumber.two))
        //        XCTAssertTrue(WholeNumber.zero < RealNumber.one)
        //        XCTAssertTrue(WholeNumber.zero < ImaginaryNumber.one)
        //        XCTAssertTrue(WholeNumber.zero < ComplexNumber.one)
        //        XCTAssertTrue(WholeNumber.zero < Number.one)

        // Integer
        XCTAssertTrue(Integer.ten > NaturalNumber.one)
        XCTAssertTrue(Integer.ten > WholeNumber.zero)
        XCTAssertTrue(Integer.ten > Integer(-2))
        XCTAssertTrue(Integer.ten > SimpleFraction(numerator: 2, denominator: 3))
        XCTAssertTrue(Integer.ten > RationalNumber.one)
        //        XCTAssertTrue(Integer.ten > RealFraction(numerator: RealNumber.one, denominator: RealNumber.two))
        //        XCTAssertTrue(Integer.ten > RealNumber.one)
        //        XCTAssertTrue(Integer.ten > ImaginaryNumber.one)
        //        XCTAssertTrue(Integer.ten > ComplexNumber.one)
        //        XCTAssertTrue(Integer.ten > Number.one)

        // Simple Fraction
        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) < NaturalNumber.one)
        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > WholeNumber.zero)
        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > Integer(-2))
        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > SimpleFraction(numerator: 1, denominator: 3))
        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) < RationalNumber.one)
        //        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > RealFraction(numerator: RealNumber.one, denominator: RealNumber.two))
        //        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > RealNumber.one)
        //        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > ImaginaryNumber.one)
        //        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > ComplexNumber.one)
        //        XCTAssertTrue(SimpleFraction(numerator: 2, denominator: 3) > Number.one)

        // Rational Number
        XCTAssertTrue(RationalNumber.ten > NaturalNumber.one)
        XCTAssertTrue(RationalNumber.ten > WholeNumber.zero)
        XCTAssertTrue(RationalNumber.ten > Integer(-2))
        XCTAssertTrue(RationalNumber.ten > SimpleFraction(numerator: 2, denominator: 3))
        XCTAssertTrue(RationalNumber.ten > RationalNumber.one)
        ////        XCTAssertTrue(RationalNumber.ten > RealFraction(numerator: RealNumber.one, denominator: RealNumber.two))
        //        XCTAssertTrue(RationalNumber.ten > RealNumber.one)
        //        XCTAssertTrue(RationalNumber.ten > ImaginaryNumber.one)
        //        XCTAssertTrue(RationalNumber.ten > ComplexNumber.one)
        //        XCTAssertTrue(RationalNumber.ten > Number.one)

        // Irrational Number

        // Real Fraction

        // Real Number

        // Imaginary Number

        // Complex Number

        // Number
    }

    // MARK: - Mathematical Laws
    func testAssociativeLaw() {
        // Test associative law for addition: (a + b) + c == a + (b + c)
        let a = Number(2)
        let b = Number(3)
        let c = Number(4)
        XCTAssertEqual((a + b) + c, a + (b + c), "Associative law failed for addition")

        // Test associative law for multiplication: (a * b) * c == a * (b * c)
        XCTAssertEqual((a * b) * c, a * (b * c), "Associative law failed for multiplication")
    }

    func testCommutativeLaw() {
        // Test commutative law for addition: a + b == b + a
        let a = Number(5)
        let b = Number(8)
        XCTAssertEqual(a + b, b + a, "Commutative law failed for addition")
    }

    func testDistributiveLaw() {
        // Test distributive law: a * (b + c) == a * b + a * c
        let a = Number(3)
        let b = Number(4)
        let c = Number(2)
        XCTAssertEqual(a * (b + c), a * b + a * c, "Distributive law failed")
    }

    // MARK: - Edge Cases
    func testEdgeCases() {
        // Test with zero
        XCTAssertEqual(Number(0) + Number(5), Number(5), "Addition with zero failed")
        XCTAssertEqual(Number(5) - Number(0), Number(5), "Subtraction with zero failed")
        XCTAssertEqual(Number(0) * Number(5), Number(0), "Multiplication with zero failed")
        XCTAssertEqual(Number(0) / Number(5), Number(0), "Division with zero failed")
    }

    func testComplexNumberMagnitude() {
        let positive = ComplexNumber(real: 3, imaginary: 4)
        let negative = ComplexNumber(real: 3, imaginary: -4)
        XCTAssertEqual(positive.magnitude, 5, "ComplexNumber magnitude failed")
        XCTAssertEqual(negative.magnitude, 5, "ComplexNumber magnitude failed")
    }

    func testExponentation() {
        /// Square
        let base0: Number = 2
        let result0 = base0.squared()
        XCTAssertEqual(result0, 4)

        /// Cube
        let base1: Number = 2
        let result1 = base1.cubed()
        XCTAssertEqual(result1, 8)

        /// Power
        let result2 = base1.raised(to: 8)
        XCTAssertEqual(result2, 256)
    }

    func testRooting() {
        /// Cube Root
        let base0: Number = 27
        let result1 = base0.cubeRoot()
        XCTAssertEqual(result1, 3)

        /// Square Root
        let base1: Number = 49
        let result2 = base1.squareRoot()
        XCTAssertEqual(result2, 7)

        /// Nth Root
        let base2: Number = 256
        let result3 = base2.radication(for: 8)
        XCTAssertEqual(result3, 2)

        /// Square Root
        let base3: Number = 4
        let result4 = base3.squareRoot()
        XCTAssertEqual(result4, 2)

        /// Nth Root
        let base4: Number = 256
        let result5 = base4.raised(to: (1 / 8))
        XCTAssertEqual(result5, 2)
    }

    func testIrrationalRooting() {
        /// Square Root
        let base0: Number = 2
        let result0 = base0.squareRoot()
        // 1.414_213_562_373_095_048_801_688_724_209_698_078_569_671_875_376_9
        XCTAssertEqual(result0, 4946041176255201878775086487573351061418968498177 / 3497379255757941172020851852070562919437964212608)
        //        XCTAssertEqual(result0, Number("1.4142135623730950488016887242096980785696718753769"))
    }

    func testInitializers() {
        let a = Number(42 as UInt8)
        XCTAssertEqual(a, 42)
        XCTAssertTrue(a == 42)
        XCTAssertEqual(a.description, "42")

        let b: Number = 420
        XCTAssertEqual(b, 420)
        XCTAssertTrue(b == 420)
        XCTAssertEqual(b.description, "420")

        let c = Number(4200000000000000000)
        XCTAssertEqual(c, 4200000000000000000)
        XCTAssertTrue(c == 4200000000000000000)
        XCTAssertEqual(c.description, "4200000000000000000")

        let d: Number = 0.42
        XCTAssertEqual(d, 0.42)
        XCTAssertTrue(d == 0.42)
        //        XCTAssertEqual(d.description, "0.42")

        let e: Number = 4.2
        XCTAssertEqual(e, 4.2)
        XCTAssertTrue(e == 4.2)
        //        XCTAssertEqual(e.description, "4.2")

        let f: Number = 0.0042
        XCTAssertEqual(f, 0.0042)
        XCTAssertTrue(f == 0.0042)
        //        XCTAssertEqual(f.description, "0.0042")

        let g: Number = 0.00042
        XCTAssertEqual(g, 0.00042)
        XCTAssertTrue(g == 0.00042)
        //        XCTAssertEqual(g.description, "0.00042")

        let h: Number = 0.0000000000000000042
        XCTAssertEqual(h, 0.0000000000000000042)
        XCTAssertTrue(h == 0.0000000000000000042)
        //        XCTAssertEqual(h.description, "0.0000000000000000042")

        let i = Number("0.00000000000000000000000000000000004000000000000000002")!
        // MARK: - TODO: A theoretical `StaticBigFloat` would make this possible with `ExpressibleByFloatLiteral`
        // XCTAssertEqual(i, 0.00000000000000000000000000000000004000000000000000002)
        // XCTAssertTrue(i == 0.00000000000000000000000000000000004000000000000000002)
        //        XCTAssertEqual(i.description, "0.00000000000000000000000000000000004000000000000000002")

        let j = Number("3.14159265358979323846264338327950288419716939937510582")!
        //        XCTAssertEqual(j.description, "3.14159265358979323846264338327950288419716939937510582")

        XCTAssertEqual(i + j, Number("3.14159265358979323846264338327950292419716939937510584")!)
        XCTAssertTrue(i + j == Number("3.14159265358979323846264338327950292419716939937510584")!)
        //        XCTAssertEqual((i + j).description, "3.14159265358979323846264338327950292419716939937510584")
    }

    func testPi() {
        /// `Double.pi` 15 digits of accuracy - 3.141_592_653_589_793
        /// 21 digits of accuracy - 3.141_592_653_589_793_238_462
        XCTAssertEqual(IrrationalNumber.pi(4)._approximation, 28471243807120253377792333689239912281715167328354127149 / 9062678375755402859802473818588507977517344680312832000)

        /// 62 digits of accuracy - 3.141_592_653_589_793_238_462_643_383_279_502_884_197_169_399_375_105_820_974_944_59
        XCTAssertEqual(IrrationalNumber.pi()._approximation, 1022106682044067297403201052276861069586250349291792321898473475715381387709118950975150502004180168210647407599239932900278538570748895594356938374349309451257304252258335461404397923 / 325346661629138981888859585616624097131341482665908711624370010607163428908952025902393288237061364105796861812959748504364064413740358063608719466443670110351928054410921402957824000)

        /// 75 digits of accuracy - 3.141_592_653_589_793_238_462_643_383_279_502_884_197_169_399_375_105_820_974_944_592_307_816_406_286
        XCTAssertEqual(IrrationalNumber.pi(10)._approximation, 1277761029229397699369339220623377485922754697667682575140943551408248272418002494400004270158924207257589666241654055046793763329349908421308303760397429710323538592647736347073892551956276060168323677837619347805574281469661284346318305680746187221449715806597461268137890468249690378005231969777757106980606715772349374542869787992695090840722724246169499448887251567004171 / 406723967784092807161776643764778825195734808040089063733911417353456512787478395973466878295361191651543000470728126147167857548475580987348420776123405919681597155734854122480691769908878459808867375726756759916854113627123599996674310302721293892688667579654833640701395856486575593953632787705712248894587128034763659815672692700880557457030954125074952573823683133440000)
    }
}
