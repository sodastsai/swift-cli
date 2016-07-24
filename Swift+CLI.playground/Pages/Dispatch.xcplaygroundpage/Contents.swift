import Foundation


func threadPrint(_ message: String) {
    print("\(Thread.current): \(message)")
}


func sleep(arguments: [String]) -> Int32 {
    let sleepTimeInterval: TimeInterval? = arguments.isEmpty ? nil : TimeInterval(arguments[0])

    // Create a group to prevent the main thread from killed
    let group = DispatchGroup()
    // Go
    let bgQueue = DispatchQueue.global(attributes: .qosBackground)
    bgQueue.async(group: group) {
        let unwrappedSleepTimeInterval = sleepTimeInterval ?? 1.0
        Thread.sleep(forTimeInterval: unwrappedSleepTimeInterval)
        threadPrint("Wake up after \(unwrappedSleepTimeInterval) seconds. \(Date())")
    }
    print("Yo hey \(Date())")
    // Hmmm...
    group.wait()
    print("Blocked ... \(Date())")

    return 0
}

func sum(arguments: [String]) -> Int32 {
    let optionalRange: Int? = arguments.isEmpty ? nil : Int(arguments[0])
    let range = optionalRange ?? 42
    var numbers = [Int](repeating: 0, count: range+1)
    for idx in 0...range {
        numbers[idx] = idx
    }
    print("Adding from numbers: \(numbers)\n")

    let bucketSize = 5
    let iterations = numbers.count / bucketSize + (numbers.count % bucketSize > 0 ? 1 : 0)
    var localResultPool = [Int](repeating: 0, count: iterations)
    DispatchQueue.concurrentPerform(iterations: iterations) { iterIdx in
        let lowerBound = bucketSize * iterIdx
        let upperBound = min(lowerBound + bucketSize, numbers.count)
        let localNumbers = numbers[Range(lowerBound..<upperBound)]
        print("Bucket \(iterIdx):\t\(lowerBound)-\(upperBound):\t\(localNumbers)")
        var localSum = 0
        for localNumber in localNumbers {
            localSum += localNumber
        }
        print("Bucket \(iterIdx):\tResult: \(localSum)")
        localResultPool[iterIdx] = localSum
    }
    var globalResult = 0
    for localResult in localResultPool {
        globalResult += localResult
    }
    print("\nThe result of adding from 1 to \(range) is \(globalResult).")

    return 0
}


// Go
sleep(arguments: ["1.5"])
print("---------------------------------------------")
sum(arguments: ["50"])
