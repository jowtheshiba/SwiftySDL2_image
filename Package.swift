// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftySDL2Image",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "SwiftySDL2_image", targets: ["SwiftySDL2_image"])
    ],
    targets: [
        .systemLibrary(
            name: "CSDL2Image",
            pkgConfig: "SDL2_image",
            providers: [
                .brew(["sdl2", "sdl2_image", "pkg-config"]),
                .apt(["libsdl2-dev", "libsdl2-image-dev", "pkg-config"])
            ]
        ),
        .target(
            name: "SwiftySDL2_image",
            dependencies: ["CSDL2Image"]
        )
    ]
)


