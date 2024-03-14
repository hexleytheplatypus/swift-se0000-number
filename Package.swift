// swift-tools-version:5.9
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

import PackageDescription

let package = Package(
  name: "SE0430_Number",
  platforms: [ /// For `StaticBigInt`
    .macOS(.v14),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
  ],
  products: [
    .library(
      name: "SE0430_Number",
      targets: ["SE0430_Number"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hexleytheplatypus/ArbitraryPrecisionIntegers.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "SE0430_Number",
      dependencies: ["ArbitraryPrecisionIntegers"]),

    .testTarget(
      name: "SE0430_NumberTests",
      dependencies: ["SE0430_Number"]),
  ]
)
