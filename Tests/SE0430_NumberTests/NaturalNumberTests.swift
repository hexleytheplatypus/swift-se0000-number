import XCTest
import SE0430_Number

/// NOTE: - These tests serve to fill in for `NumberTests`, only when the
/// container must be forced to taken a certain shape not actually granted by
/// `Number`-proper.
class NaturalNumberTests: XCTestCase {
    // MARK: - Basic Arithmetic Operations
    func testAddition() {
        /// `WholeNumber` when created via `Number` only ever holds `.zero` as it's
        ///     value; as positive numbers land in `NaturalNumber` and negative
        ///     values fall into `Integer`.
        let nn_wn_add1 = NaturalNumber(5) + WholeNumber(3)
        XCTAssertEqual(nn_wn_add1, 8, "Addition of natural numbers failed")

        /// `ImaginaryNumber` when created via `Number` never holds `.zero`. It
        ///     instead passes the `Number.zero` constant, as `0i` is `.zero`.
        let nn_im_add1: Number = 5 + .imaginary(from: 0)
        XCTAssertEqual(nn_im_add1, 5, "Addition of natural number and zero failed")
        XCTAssertEqual(nn_im_add1.typeValue, "\(type(of: NaturalNumber.self))", "Unexpected internal type produced")
    }
}

extension Number {
    internal var typeValue: String {
        switch self {
            case .complex(_):
                return "\(type(of: ComplexNumber.self))"
            case .imaginary(_):
                return "\(type(of: ImaginaryNumber.self))"
            case .real(let realNumber):
                switch realNumber {
                    case .irrational(_):
                        return "\(type(of: IrrationalNumber.self))"
                    case .rational(let rationalNumber):
                        switch rationalNumber {
                            case .simpleFraction(_):
                                return "\(type(of: SimpleFraction.self))"
                            case .integer(_):
                                return "\(type(of: Integer.self))"
                            case .whole(_):
                                return "\(type(of: WholeNumber.self))"
                            case .natural(_):
                                return "\(type(of: NaturalNumber.self))"
                        }
                }
        }
    }
}
