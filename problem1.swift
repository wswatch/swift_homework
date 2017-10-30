//: Playground - noun: a place where people can play

import Cocoa

enum myError : Error {
    case notFoundMorse
    case notFoundWord
    case empty
    case failRead
}
func ReadMorse(path:String) throws -> ([String: Character], [Character: String]) {
    do{
        let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = data.components(separatedBy: CharacterSet.newlines)
        var chToMorse: [Character: String] = [:]
        var morseToCh: [String: Character] = [:]
        var lowerline = ""
        for line in lines {
            lowerline = line.lowercased()        // change the A-Z to a-z
            if line.count > 0{
                let ch = lowerline[lowerline.startIndex]  // the letter
                // get the reference morse code
                let maxRange = lowerline.index(lowerline.endIndex, offsetBy: -1)
                let lastWord = lowerline[maxRange]
                // the final comma "," in each line is not in morse code
                var rightMost: String.Index = lowerline.endIndex
                if lastWord == "," {
                    rightMost = lowerline.index(lowerline.endIndex, offsetBy: -1)
                }
                else {
                    rightMost = lowerline.endIndex
                }
                let leftMost = lowerline.index(lowerline.startIndex, offsetBy: 4)
                // use substring to get the
                let morseCode = String( lowerline[leftMost ..< rightMost] )
                chToMorse[ch] = morseCode
                morseToCh[morseCode] = ch
            }
        }
        return (morseToCh, chToMorse)
    }
    catch{
        throw myError.failRead
    }
}
struct Morse {
    var word: String = ""
    var morseWord: String = ""
    var morseToCh: [String: Character] = [:]
    var chToMorse: [Character: String] = [:]
    init(alph: String) throws {
        (morseToCh, chToMorse) = try ReadMorse(path: "morse_code.txt")
        word = alph
        morseWord = try encode(alph: alph)
    }
    init(morse: String) throws {
        (morseToCh, chToMorse) = try ReadMorse(path: "morse_code.txt")
        morseWord = morse
        word = try decode(morse: morse)
    }
    func encode(alph: String) throws -> String {
        let alphList = Array<Character>(alph)
        var str: String = ""
        for ch in alphList {
            if let code = chToMorse[ch] {
                str = str + code + " "
            }
            else {
                throw myError.notFoundWord
            }
        }
        return str
    }
    func decode(morse: String) throws -> String {
        let morseList = morse.components(separatedBy: CharacterSet.whitespaces)
        var str: String = ""
        for morseCode in morseList {
            if morseCode.count > 0 {
                if let ch = morseToCh[morseCode] {
                    str = str + String(ch)
                }
                else {
                    throw myError.notFoundMorse
                }
            }
        }
        return str
    }
    func getMorse() -> String {
        return morseWord
    }
    func getWord() -> String {
        return word
    }
}
func run() {
    do{
        print("Enter message:", terminator: " ")
        let input = readLine()
        if let input = input {
            guard input.count > 0 else {
                throw myError.empty
            }
            let startLetter = input[input.startIndex]    // if the first letter is blank, then it can only be a word
            if startLetter == "." || startLetter == "/" || startLetter == "-" {  // judge which kind the input is
                let morser: Morse = try Morse(morse: input)
                print( morser.getWord() )
            }
            else {
                let morser: Morse = try Morse(alph: input.lowercased())
                print( morser.getMorse() )
            }
        }
        else {
            throw myError.empty
        }
    }
    catch myError.empty {
        print("The input is empty!")
    }
    catch myError.failRead {
        print("The word fail to read file!")
    }
    catch myError.notFoundMorse {
        print("The input has some unreasonable letter as a morseCode!")
    }
    catch myError.notFoundWord {
        print("The input has some unreasonable letter as a sentence!")
    }
    catch {
        print("Some error occur!")
    }
}
run()
