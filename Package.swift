// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftySDL2Image",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "SDL2Image", targets: ["SDL2Image"])
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
            name: "SDL2Image",
            dependencies: ["CSDL2Image"]
        )
    ]
)


