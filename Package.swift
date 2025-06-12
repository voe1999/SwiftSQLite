// swift-tools-version:5.9
import PackageDescription

let deps: [Package.Dependency] = [
    .github("swiftlang/swift-toolchain-sqlite", exact: "1.0.4")
]

let targets: [Target] = [
    .target(
        name: "sqlite3",
        path: "Sources/sqlite3/sqlite3-3500100",
        publicHeadersPath: "./include",
        cSettings: [
            .headerSearchPath("./include")
        ]
    ),
    .target(
        name: "SQLite",
        dependencies: [
            .target(name: "sqlite3"),
            .product(
                name: "SwiftToolchainCSQLite", package: "swift-toolchain-sqlite",
                condition: .when(platforms: [.linux, .windows])),
        ],
        exclude: [
            "Info.plist",
            "PrivacyInfo.xcprivacy",
        ],
        swiftSettings: [
            .define("SQLITE_SWIFT_STANDALONE")
        ]
    ),
]

let testTargets: [Target] = [
    .testTarget(
        name: "SQLiteTests",
        dependencies: [
            "SQLite"
        ],
        path: "Tests/SQLiteTests",
        exclude: [
            "Info.plist"
        ],
        resources: [
            .copy("Resources")
        ]
    )
]

let package = Package(
    name: "SQLite.swift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v12),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SQLite",
            targets: ["SQLite"]
        )
    ],
    dependencies: deps,
    targets: targets + testTargets
)

extension Package.Dependency {

    static func github(_ repo: String, exact ver: Version) -> Package.Dependency {
        .package(url: "https://github.com/\(repo)", exact: ver)
    }
}
