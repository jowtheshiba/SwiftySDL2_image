# SwiftySDL2Image (targets SDL_image 2.x)

- Swift wrapper for SDL_image v2.x (not SDL3)
- Upstream releases: https://github.com/libsdl-org/SDL_image/releases

### Install dependencies

macOS (Homebrew):
```bash
brew install sdl2 sdl2_image pkg-config
```

Debian/Ubuntu:
```bash
sudo apt-get install -y libsdl2-dev libsdl2-image-dev pkg-config
```

### Add to your Package.swift
```swift
.package(url: "https://github.com/your/repo/SwiftySDL2_image.git", from: "0.1.0"),
```

### Example 1: Load a PNG as SDL_Texture
Assumes you already created an `SDL_Renderer`.
```swift
import SwiftySDL2_image

try SDL2Image.initialize(flags: [.png])
let texture = try SDL2Image.loadTexture(renderer: renderer, path: "image.png")
// ... render with SDL_RenderCopy(renderer, texture, nil, &destRect)
SDL2Image.quit()
```

### Example 2: Load a Surface and save it as PNG (or JPG)
```swift
import SwiftySDL2_image

try SDL2Image.initialize() // enables PNG/JPG/TIF/WebP by default
let surface = try SDL2Image.loadSurface(path: "image.png")
try SDL2Image.savePNG(surface: surface, path: "/tmp/out.png")
// Or save as JPEG with quality (0-100):
// try SDL2Image.saveJPG(surface: surface, path: "/tmp/out.jpg", quality: 90)
SDL2Image.quit()
```

### Example 3 (optional): Load a texture from in-memory PNG data (RWops)
```swift
import SwiftySDL2_image

// data: [UInt8] holds the PNG bytes
let texture: UnsafeMutablePointer<SDL_Texture>
try SDL2Image.initialize(flags: [.png])
var bytes = data // make a var to ensure contiguous storage
texture = try bytes.withUnsafeMutableBytes { rawBuf in
    guard let base = rawBuf.baseAddress else { throw SDLImageError.operationFailed("empty buffer") }
    guard let rw = SDL_RWFromMem(base, Int32(rawBuf.count)) else { throw SDLImageError.operationFailed("RWFromMem failed") }
    return try SDL2Image.loadTexture(renderer: renderer, fromRW: rw, typeHint: "PNG", freeSource: true)
}
SDL2Image.quit()
```

### Notes
- Uses pkg-config module `SDL2_image`.
- SDL_image 2.x depends on SDL2; make sure SDL2 is installed.
