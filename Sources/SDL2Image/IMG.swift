import CSDL2Image

public enum SDLImageError: Error, CustomStringConvertible {
    case initializationFailed
    case operationFailed(String)

    public var description: String {
        switch self {
        case .initializationFailed:
            return "SDL_image initialization failed"
        case .operationFailed(let message):
            return message
        }
    }
}

public struct SDLImageInitFlags: OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let jpg  = SDLImageInitFlags(rawValue: Int32(IMG_INIT_JPG))
    public static let png  = SDLImageInitFlags(rawValue: Int32(IMG_INIT_PNG))
    public static let tif  = SDLImageInitFlags(rawValue: Int32(IMG_INIT_TIF))
    public static let webp = SDLImageInitFlags(rawValue: Int32(IMG_INIT_WEBP))
}

public struct SDLImageVersion {
    public let major: UInt8
    public let minor: UInt8
    public let patch: UInt8
}

public struct SDL2Image {
    // MARK: - Init / Quit
    public static func initialize(flags: SDLImageInitFlags = [.png, .jpg, .tif, .webp]) throws {
        let requested = flags.rawValue
        let initted = IMG_Init(requested)
        if (initted & requested) != requested {
            IMG_Quit()
            throw SDLImageError.initializationFailed
        }
    }

    public static func quit() {
        IMG_Quit()
    }

    // MARK: - Version / Error
    public static func linkedVersion() -> SDLImageVersion {
        let verPtr = IMG_Linked_Version()!
        let ver = verPtr.pointee
        return SDLImageVersion(major: ver.major, minor: ver.minor, patch: ver.patch)
    }

    public static func getError() -> String {
        String(cString: IMG_GetError())
    }

    // MARK: - Surface Loading
    public static func loadSurface(path: String) throws -> UnsafeMutablePointer<SDL_Surface> {
        guard let surface = IMG_Load(path) else {
            throw SDLImageError.operationFailed(getError())
        }
        return surface
    }

    public static func loadSurface(fromRW rwops: UnsafeMutablePointer<SDL_RWops>, freeSource: Bool) throws -> UnsafeMutablePointer<SDL_Surface> {
        guard let surface = IMG_Load_RW(rwops, freeSource ? 1 : 0) else {
            throw SDLImageError.operationFailed(getError())
        }
        return surface
    }

    public static func loadSurface(fromRW rwops: UnsafeMutablePointer<SDL_RWops>, typeHint: String, freeSource: Bool) throws -> UnsafeMutablePointer<SDL_Surface> {
        guard let surface = IMG_LoadTyped_RW(rwops, freeSource ? 1 : 0, typeHint) else {
            throw SDLImageError.operationFailed(getError())
        }
        return surface
    }

    // MARK: - Texture Loading
    public static func loadTexture(renderer: UnsafeMutablePointer<SDL_Renderer>, path: String) throws -> UnsafeMutablePointer<SDL_Texture> {
        guard let texture = IMG_LoadTexture(renderer, path) else {
            throw SDLImageError.operationFailed(getError())
        }
        return texture
    }

    public static func loadTexture(renderer: UnsafeMutablePointer<SDL_Renderer>, fromRW rwops: UnsafeMutablePointer<SDL_RWops>, freeSource: Bool) throws -> UnsafeMutablePointer<SDL_Texture> {
        guard let texture = IMG_LoadTexture_RW(renderer, rwops, freeSource ? 1 : 0) else {
            throw SDLImageError.operationFailed(getError())
        }
        return texture
    }

    public static func loadTexture(renderer: UnsafeMutablePointer<SDL_Renderer>, fromRW rwops: UnsafeMutablePointer<SDL_RWops>, typeHint: String, freeSource: Bool) throws -> UnsafeMutablePointer<SDL_Texture> {
        guard let texture = IMG_LoadTextureTyped_RW(renderer, rwops, freeSource ? 1 : 0, typeHint) else {
            throw SDLImageError.operationFailed(getError())
        }
        return texture
    }

    // MARK: - Format checks (RWops)
    public static func isICO(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isICO(rwops) == 1 }
    public static func isCUR(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isCUR(rwops) == 1 }
    public static func isBMP(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isBMP(rwops) == 1 }
    public static func isGIF(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isGIF(rwops) == 1 }
    public static func isJPG(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isJPG(rwops) == 1 }
    public static func isLBM(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isLBM(rwops) == 1 }
    public static func isPCX(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isPCX(rwops) == 1 }
    public static func isPNG(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isPNG(rwops) == 1 }
    public static func isPNM(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isPNM(rwops) == 1 }
    public static func isSVG(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isSVG(rwops) == 1 }
    public static func isTIF(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isTIF(rwops) == 1 }
    public static func isXCF(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isXCF(rwops) == 1 }
    public static func isXPM(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isXPM(rwops) == 1 }
    public static func isXV(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isXV(rwops) == 1 }
    public static func isWEBP(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isWEBP(rwops) == 1 }
    public static func isQOI(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isQOI(rwops) == 1 }
    public static func isAVIF(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isAVIF(rwops) == 1 }
    public static func isJXL(_ rwops: UnsafeMutablePointer<SDL_RWops>) -> Bool { IMG_isJXL(rwops) == 1 }

    // MARK: - Save functions
    @discardableResult
    public static func savePNG(surface: UnsafeMutablePointer<SDL_Surface>, path: String) throws -> Int32 {
        let rc = IMG_SavePNG(surface, path)
        if rc != 0 { throw SDLImageError.operationFailed(getError()) }
        return rc
    }

    @discardableResult
    public static func savePNG(surface: UnsafeMutablePointer<SDL_Surface>, toRW rwops: UnsafeMutablePointer<SDL_RWops>, freeDest: Bool) throws -> Int32 {
        let rc = IMG_SavePNG_RW(surface, rwops, freeDest ? 1 : 0)
        if rc != 0 { throw SDLImageError.operationFailed(getError()) }
        return rc
    }

    @discardableResult
    public static func saveJPG(surface: UnsafeMutablePointer<SDL_Surface>, path: String, quality: Int32) throws -> Int32 {
        let rc = IMG_SaveJPG(surface, path, quality)
        if rc != 0 { throw SDLImageError.operationFailed(getError()) }
        return rc
    }

    @discardableResult
    public static func saveJPG(surface: UnsafeMutablePointer<SDL_Surface>, toRW rwops: UnsafeMutablePointer<SDL_RWops>, freeDest: Bool, quality: Int32) throws -> Int32 {
        let rc = IMG_SaveJPG_RW(surface, rwops, freeDest ? 1 : 0, quality)
        if rc != 0 { throw SDLImageError.operationFailed(getError()) }
        return rc
    }
}


