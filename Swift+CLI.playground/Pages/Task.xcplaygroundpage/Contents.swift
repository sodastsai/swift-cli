import Foundation


// Main function, use `@discardableResult` to suppress the unused return function
@discardableResult func shell(launchPath: String="/usr/bin/env", _ arguments: [String]) -> (Int32, String?, String?) {
    // Create a NSTask which spawns a subprocess to execute the command
    let task = Task()
    task.launchPath = launchPath
    task.arguments = arguments

    // Use NSPipe to capture stdout and stderr
    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    task.standardOutput = stdoutPipe
    task.standardError = stderrPipe

    // Go and wait for finished
    task.launch()
    task.waitUntilExit()

    // Fix the capurted stdout and stderr
    let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
    let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
    let stdoutString = String(data: stdoutData, encoding: .utf8)
    let stderrString = String(data: stderrData, encoding: .utf8)

    // done
    return (task.terminationStatus, stdoutString, stderrString)
}


// A function which calls `[String]`'s form (overloading)
@discardableResult func shell(launchPath: String="/usr/bin/env", _ arguments: String...) -> (Int32, String?, String?) {
    return shell(launchPath: launchPath, arguments)
}


let (returnCode, stdout, stderr) = shell("uname", "-a")
print(returnCode)
print(stdout!)
print(stderr!)
