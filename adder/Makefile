SWIFTC=swiftc
SWIFT_FLAGS=-O
EXECUTABLE=adder

.PHONY: all clean build

all: clean build

clean:
	rm -f $(EXECUTABLE)

build:
	$(SWIFTC) *.swift $(SWIFT_FLAGS) -o $(EXECUTABLE)
