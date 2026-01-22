// swift-tools-version:5.10
//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2024 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let strictConcurrencyDevelopment = false

let strictConcurrencySettings: [SwiftSetting] = {
    var initialSettings: [SwiftSetting] = []
    initialSettings.append(contentsOf: [
        .enableUpcomingFeature("StrictConcurrency"),
        .enableUpcomingFeature("InferSendableFromCaptures"),
    ])

    if strictConcurrencyDevelopment {
        // -warnings-as-errors here is a workaround so that IDE-based development can
        // get tripped up on -require-explicit-sendable.
        initialSettings.append(.unsafeFlags(["-require-explicit-sendable", "-warnings-as-errors"]))
    }

    return initialSettings
}()

var targets: [PackageDescription.Target] = [
    .target(
        name: "CandleNIOHTTPCompression",
        dependencies: [
            "CandleCNIOExtrasZlib",
            .product(name: "CandleNIO",package: "candle-swift-nio"),
            .product(name: "CandleNIOCore",package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1",package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "CandleNIOSOCKS",
        dependencies: [
            .product(name: "CandleNIO",package: "candle-swift-nio"),
            .product(name: "CandleNIOCore",package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOSOCKSClient",
        dependencies: [
            .product(name: "CandleNIOCore",package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix",package: "candle-swift-nio"),
            "CandleNIOSOCKS",
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "CandleCNIOExtrasZlib",
        dependencies: [],
        linkerSettings: [
            .linkedLibrary("z")
        ]
    ),
    .testTarget(
        name: "NIOHTTPCompressionTests",
        dependencies: [
            "CandleCNIOExtrasZlib",
            "CandleNIOHTTPCompression",
            .product(name: "CandleNIOCore",package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded",package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1",package: "candle-swift-nio"),
            .product(name: "CandleNIOConcurrencyHelpers",package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOSOCKSTests",
        dependencies: [
            "CandleNIOSOCKS",
            .product(name: "CandleNIOCore",package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded",package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIONFS3",
        dependencies: [
            .product(name: "CandleNIOCore",package: "candle-swift-nio")
        ],
        swiftSettings: strictConcurrencySettings
    ),
]

let package = Package(
    name: "swift-nio-extras",
    products: [
        .library(name: "CandleNIOSOCKS", targets: ["CandleNIOSOCKS"]),
        .library(name: "CandleNIOHTTPCompression", targets: ["CandleNIOHTTPCompression"]),
    ],
    dependencies: [
        .package(url: "https://github.com/candlefinance/candle-swift-nio.git", branch: "fix-candle-2.82.1"),
        .package(url: "https://github.com/candlefinance/candle-swift-nio-http2.git", branch: "fix-candle-1.38.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-http-types.git", branch: "fix-candle-1.3.1"),
        .package(url: "https://github.com/candlefinance/candle-swift-http-structured-headers.git", branch: "fix-candle-1.4.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-atomics.git", branch: "fix-candle-1.2.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-algorithms.git", branch: "fix-candle-1.2.1"),
        .package(url: "https://github.com/candlefinance/candle-swift-certificates.git", branch: "fix-candle-1.13.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-nio-ssl.git", branch: "fix-candle-2.33.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-asn1.git", branch: "fix-candle-1.3.2"),
        .package(url: "https://github.com/candlefinance/candle-swift-service-lifecycle.git", branch: "fix-candle-2.8.0"),
        .package(url: "https://github.com/candlefinance/candle-swift-async-algorithms.git", branch: "fix-candle-1.0.4"),
        .package(url: "https://github.com/candlefinance/candle-swift-log.git", branch: "fix-candle-1.6.3"),

    ],
    targets: targets
)

// ---    STANDARD CROSS-REPO SETTINGS DO NOT EDIT   --- //
for target in package.targets {
    switch target.type {
    case .regular, .test, .executable:
        var settings = target.swiftSettings ?? []
        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
        settings.append(.enableUpcomingFeature("MemberImportVisibility"))
        target.swiftSettings = settings
    case .macro, .plugin, .system, .binary:
        ()  // not applicable
    @unknown default:
        ()  // we don't know what to do here, do nothing
    }
}
// --- END: STANDARD CROSS-REPO SETTINGS DO NOT EDIT --- //
