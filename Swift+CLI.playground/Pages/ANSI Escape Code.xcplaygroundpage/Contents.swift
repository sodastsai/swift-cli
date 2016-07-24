
// An extension of String to show colors
extension String {
    enum ANSIEscapeCode: Int {
        case light     = 1
        case underline = 4
        case blink     = 5

        case black = 30
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white

        static func fromStrings<CodeStrings: Sequence where CodeStrings.Iterator.Element == String>
            (_ codeStrings: CodeStrings) -> [ANSIEscapeCode] {
            // This function is used to convert string arrays like ["1", "31"] to [.light, .red]

            // Convert strings to codes
            let codeOptionals = codeStrings.map { (string: String) -> ANSIEscapeCode? in
                guard let intValue = Int(string) else { return nil }
                return ANSIEscapeCode(rawValue: intValue)
            }
            // Remove optionals from array
            let codes = codeOptionals.flatMap { $0 }
            return codes
        }
    }

    static let escapeCode = "\u{001B}"

    /*
     Usually we would create a function which accepts a sequence of ANSI escape codes, like the following one:

     func with(ANSIEscapeCodes codes: [ANSIEscapeCode]) -> String {
         // Use like: `"Hello".with(ANSIEscapeCodes: [.red, .light])`

         // Convert `codes` to a String array
         let codesString = codes.map { String($0.rawValue) }
         // Join the String array with ";"
         let joinedCodeString = codesString.joined(separator: ";")
         // Apply it
         return "\(String.escapeCode)[\(joinedCodeString)m\(self)\(String.escapeCode)[m"
     }
     
     But here, like the next one, we can use **generic** and
     hence all sequence type, like Array and ArraySlice would be acceptable for this function.
    */

    func with<Codes: Sequence where Codes.Iterator.Element == ANSIEscapeCode>(ANSIEscapeCodes codes: Codes) -> String {
        // Use like: `"Hello".with(ANSIEscapeCodes: [.red, .light])`

        // Convert `codes` to a String array
        let codesString = codes.map { String($0.rawValue) }
        // Join the String array with ";"
        let joinedCodeString = codesString.joined(separator: ";")
        // Apply it
        return "\(String.escapeCode)[\(joinedCodeString)m\(self)\(String.escapeCode)[m"
    }

    func with(ANSIEscapeCodes codes: ANSIEscapeCode...) -> String {
        // A overloaded function to use like: `"Hello".with(ANSIEscapeCodes: .red, .light)`
        return self.with(ANSIEscapeCodes: codes)
    }
}

extension Sequence where Iterator.Element == String.ANSIEscapeCode {
    func apply(withString string: String) -> String {
        return string.with(ANSIEscapeCodes: self)
    }
}

let yellowUnderlineCodes: [String.ANSIEscapeCode] = [.yellow, .underline]
print(yellowUnderlineCodes.apply(withString: "Hello"), terminator: "")
print("world".with(ANSIEscapeCodes: .red, .blink))
