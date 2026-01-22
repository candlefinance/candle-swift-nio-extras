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
        name: "NIOExtras",
        dependencies: [
            .product(name: "CandleNIO", package: "candle-swift-nio"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "CandleNIOHTTPCompression",
        dependencies: [
            "CandleCNIOExtrasZlib",
            .product(name: "CandleNIO", package: "candle-swift-nio"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "HTTPServerWithQuiescingDemo",
        dependencies: [
            "NIOExtras",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOWritePCAPDemo",
        dependencies: [
            "NIOExtras",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOWritePartialPCAPDemo",
        dependencies: [
            "NIOExtras",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOExtrasPerformanceTester",
        dependencies: [
            "NIOExtras",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "CandleNIOSOCKS",
        dependencies: [
            .product(name: "CandleNIO", package: "candle-swift-nio"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOSOCKSClient",
        dependencies: [
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
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
        name: "NIOExtrasTests",
        dependencies: [
            "NIOExtras",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
            .product(name: "NIOTestUtils", package: "candle-swift-nio"),
            .product(name: "CandleNIOConcurrencyHelpers", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOHTTPCompressionTests",
        dependencies: [
            "CandleCNIOExtrasZlib",
            "CandleNIOHTTPCompression",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
            .product(name: "CandleNIOConcurrencyHelpers", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOSOCKSTests",
        dependencies: [
            "CandleNIOSOCKS",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIONFS3",
        dependencies: [
            .product(name: "CandleNIOCore", package: "candle-swift-nio")
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIONFS3Tests",
        dependencies: [
            "NIONFS3",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
            .product(name: "NIOTestUtils", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOHTTPTypes",
        dependencies: [
            .product(name: "CandleHTTPTypes", package: "candle-swift-http-types"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOHTTPTypesHTTP1",
        dependencies: [
            "NIOHTTPTypes",
            .product(name: "CandleNIOHTTP1", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOHTTPTypesHTTP2",
        dependencies: [
            "NIOHTTPTypes",
            .product(name: "CandleNIOHTTP2", package: "candle-swift-nio-http2"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOHTTPTypesHTTP1Tests",
        dependencies: [
            "NIOHTTPTypesHTTP1"
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOHTTPTypesHTTP2Tests",
        dependencies: [
            "NIOHTTPTypesHTTP2"
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOResumableUpload",
        dependencies: [
            "NIOHTTPTypes",
            .product(name: "CandleHTTPTypes", package: "candle-swift-http-types"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "StructuredFieldValues", package: "candle-swift-http-structured-headers"),
            .product(name: "CandleAtomics", package: "candle-swift-atomics"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .executableTarget(
        name: "NIOResumableUploadDemo",
        dependencies: [
            "NIOResumableUpload",
            "NIOHTTPTypesHTTP1",
            .product(name: "CandleHTTPTypes", package: "candle-swift-http-types"),
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOPosix", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOResumableUploadTests",
        dependencies: [
            "NIOResumableUpload",
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOHTTPResponsiveness",
        dependencies: [
            "NIOHTTPTypes",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleHTTPTypes", package: "candle-swift-http-types"),
            .product(name: "CandleAlgorithms", package: "candle-swift-algorithms"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOHTTPResponsivenessTests",
        dependencies: [
            "NIOHTTPResponsiveness",
            "NIOHTTPTypes",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOEmbedded", package: "candle-swift-nio"),
            .product(name: "CandleHTTPTypes", package: "candle-swift-http-types"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .target(
        name: "NIOCertificateReloading",
        dependencies: [
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOSSL", package: "candle-swift-nio-ssl"),
            .product(name: "X509", package: "candle-swift-certificates"),
            .product(name: "SwiftASN1", package: "candle-swift-asn1"),
            .product(name: "CandleServiceLifecycle", package: "candle-swift-service-lifecycle"),
            .product(name: "CandleAsyncAlgorithms", package: "candle-swift-async-algorithms"),
            .product(name: "CandleLogging", package: "candle-swift-log"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
    .testTarget(
        name: "NIOCertificateReloadingTests",
        dependencies: [
            "NIOCertificateReloading",
            .product(name: "CandleNIOCore", package: "candle-swift-nio"),
            .product(name: "CandleNIOSSL", package: "candle-swift-nio-ssl"),
            .product(name: "X509", package: "candle-swift-certificates"),
            .product(name: "SwiftASN1", package: "candle-swift-asn1"),
        ],
        swiftSettings: strictConcurrencySettings
    ),
]

let package = Package(
    name: "candle-swift-nio-extras",
    products: [
        .library(name: "NIOExtras", targets: ["NIOExtras"]),
        .library(name: "CandleNIOSOCKS", targets: ["CandleNIOSOCKS"]),
        .library(name: "CandleNIOHTTPCompression", targets: ["CandleNIOHTTPCompression"]),
        .library(name: "NIOHTTPTypes", targets: ["NIOHTTPTypes"]),
        .library(name: "NIOHTTPTypesHTTP1", targets: ["NIOHTTPTypesHTTP1"]),
        .library(name: "NIOHTTPTypesHTTP2", targets: ["NIOHTTPTypesHTTP2"]),
        .library(name: "NIOResumableUpload", targets: ["NIOResumableUpload"]),
        .library(name: "NIOHTTPResponsiveness", targets: ["NIOHTTPResponsiveness"]),
        .library(name: "NIOCertificateReloading", targets: ["NIOCertificateReloading"]),
    ],
    dependencies: [
        .package(url: "https://github.com/candlefinance/swift-nio.git", name: "candle-swift-nio", branch: "fix-candle-2.82.1"),
        .package(url: "https://github.com/candlefinance/swift-nio-http2.git", name: "candle-swift-nio-http2", branch: "fix-candle-1.38.0"),
        .package(url: "https://github.com/candlefinance/swift-http-types.git", name: "candle-swift-http-types", branch: "fix-candle-1.3.1"),
        .package(url: "https://github.com/candlefinance/swift-http-structured-headers.git", name: "candle-swift-http-structured-headers", branch: "fix-candle-1.4.0"),
        .package(url: "https://github.com/candlefinance/swift-atomics.git", name: "candle-swift-atomics", branch: "fix-candle-1.2.0"),
        .package(url: "https://github.com/candlefinance/swift-algorithms.git", name: "candle-swift-algorithms", branch: "fix-candle-1.2.1"),
        .package(url: "https://github.com/candlefinance/swift-certificates.git", name: "candle-swift-certificates", branch: "fix-candle-1.13.0"),
        .package(url: "https://github.com/candlefinance/swift-nio-ssl.git", name: "candle-swift-nio-ssl", branch: "fix-candle-2.33.0"),
        .package(url: "https://github.com/candlefinance/swift-asn1.git", name: "candle-swift-asn1", branch: "fix-candle-1.3.2"),
        .package(url: "https://github.com/candlefinance/swift-service-lifecycle.git", name: "candle-swift-service-lifecycle", branch: "fix-candle-2.8.0"),
        .package(url: "https://github.com/candlefinance/swift-async-algorithms.git", name: "candle-swift-async-algorithms", branch: "fix-candle-1.0.4"),
        .package(url: "https://github.com/candlefinance/swift-log.git", name: "candle-swift-log", branch: "fix-candle-1.6.3"),

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
