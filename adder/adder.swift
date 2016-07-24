struct Adder {
    private var current: Int
    private let step: Int

    init(base: Int, step: Int = 1) {
        self.current = base
        self.step = step
    }

    @discardableResult mutating func increase() -> Int {
        self.current += self.step
        return self.current
    }
}
