# Swift + CLI

Sample files of a talk @ 
[Swift Meetup Taipei #10](http://www.meetup.com/Swift-Taipei-User-Group/events/232384262/).
Slides is here: https://goo.gl/LbnGBN

Files in this repo is targeted on Xcode 8.0 Beta 3 and macOS Sierra Developer Beta 3. 
(so some code may need to be modified to run on OS X El Capitan and Swift 2.0)

Remember to use **[Carthage](https://github.com/Carthage/Carthage)** to install dependencies first.
> For the first time: `carthage build --platform Mac --configuration Release`

## Content (by order)

- `swift hello.swift` - a hello world example
- `./myhello` - hello world example with progress bar
- `./myansi` - display ANSI colors
- `./myls` - make a `ls` command with `FileManager` (i.e. `NSFileManager`)
- `./asynctask` - Use GCD for asynchronous tasks
- `./wget` - Write a `wget` command with `URLSession` (i.e. `NSURLSession`)
- `cd adder && make && ./adder` - Compile multiple swift file as a simple command

