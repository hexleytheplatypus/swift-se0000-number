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

extension Numeric {
    // TODO: - Audit: Why not provided by the standard library?
    /// Default implementation
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = (lhs * rhs)
    }
}
