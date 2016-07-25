#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

func main(arguments: [String]) -> Int32 {

    var adder = Adder(base: 5)
    adder.increase()
    adder.increase()
    print(adder)

    return 0
}

let arguments = [String](Process.arguments[1..<Process.arguments.count])
exit(main(arguments: arguments))
