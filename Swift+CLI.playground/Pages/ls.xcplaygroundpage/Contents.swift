
import Foundation

// Utilities -----------------------------------------------------------------------------------------------------------

// An extension of String to show colors
extension String {
    enum ANSIEscapeCode: Int {
        case light     = 1
        case underline = 4
        case blink     = 5

        case black   = 30
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white
    }

    func with(ANSIEscapeCodes codes: ANSIEscapeCode...) -> String {
        return self.with(ANSIEscapeCodes: codes)
    }

    func with(ANSIEscapeCodes codes: [ANSIEscapeCode]) -> String {
        // Convert `codes` to a String array
        let codesString = codes.map { String($0.rawValue) }
        // Join the String array with ";"
        let joinedCodeString = codesString.joined(separator: ";")
        // Apply it
        return "\u{001B}[\(joinedCodeString)m\(self)\u{001B}[m"
    }
}

// Main Body -----------------------------------------------------------------------------------------------------------

let sharedDateFormatter = DateFormatter()
sharedDateFormatter.dateStyle = .short
sharedDateFormatter.timeStyle = .short

func fileMetadata(ofURL url: URL, withProperties properties: Set<URLResourceKey>) -> String {
    if let fileMetadata = try? url.resourceValues(forKeys: properties) {
        var metadataString = " -> "
        // File type
        if let isPackage = fileMetadata.isPackage, isPackage {
            metadataString += "A package"
        } else if let isDirectory = fileMetadata.isDirectory, isDirectory {
            metadataString += "A directory"
        } else {
            metadataString += "A file"
        }
        // File permissions
        if let isReadable = fileMetadata.isReadable, isReadable {
            metadataString += ", readable"
        }
        if let isWritable = fileMetadata.isWritable, isWritable {
            metadataString += ", writable"
        }
        if let isExecutable = fileMetadata.isExecutable, isExecutable {
            metadataString += ", executable"
        }
        // File size
        if let fileSize = fileMetadata.fileSize {
            let fileSizeString = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
            metadataString += ", \(fileSizeString)"
        }
        // mdate
        if let contentModificationDate = fileMetadata.contentModificationDate {
            let dateString = sharedDateFormatter.string(from: contentModificationDate)
            metadataString += ", modified at \(dateString)"
        }
        return metadataString.with(ANSIEscapeCodes: .white)
    } else {
        return " -> Cannot get file metadata.".with(ANSIEscapeCodes: .red)
    }
}

// Create a main function
func listDir(path workingPath: String) -> Int32 {
    let workingURL = URL(fileURLWithPath: workingPath)

    // Get content of the working path
    let urlProperties = [
        URLResourceKey.isDirectoryKey,
        URLResourceKey.isPackageKey,
        URLResourceKey.fileSizeKey,
        URLResourceKey.contentModificationDateKey,
        URLResourceKey.isReadableKey,
        URLResourceKey.isWritableKey,
        URLResourceKey.isExecutableKey,
    ]
    let urlPropertiesInString = urlProperties.map { $0.rawValue }
    // 1. Get with `do...catch`` and use NSError for error message
    /*
    let contentURLs: [URL]
    do {
       contentURLs = try FileManager.default.contentsOfDirectory(at: workingURL,
                                                                 includingPropertiesForKeys: urlPropertiesInString)
    } catch let error as NSError {
       print("Failed to list the content of a directory. \(error.localizedDescription)")
       return 1
    }
    */
    // 2. Get with `guard`
    guard let contentURLs = try? FileManager.default.contentsOfDirectory(at: workingURL,
                                                                         includingPropertiesForKeys: urlPropertiesInString)
        else {
            print("Cannot list the content of \"\(workingPath)\"")
            return 1
    }

    // === Output Section ===

    var headerMessage = "Show the content of ".with(ANSIEscapeCodes: .white)
    // Use `workingURL.path!` which is an absolute path representation of `workingPath``
    headerMessage += workingURL.path!.with(ANSIEscapeCodes: .cyan, .underline)
    print(headerMessage)

    // List the content
    for contentURL in contentURLs {
        let contentPath = contentURL.path!
        print(contentPath.with(ANSIEscapeCodes: .yellow))
        print(fileMetadata(ofURL: contentURL, withProperties: Set(urlProperties)))
    }
    
    // Done
    return 0
}

listDir(path: "/")
