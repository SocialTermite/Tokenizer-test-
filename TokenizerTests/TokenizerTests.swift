//
//  TokenizerTests.swift
//  TokenizerTests
//
//  Created by Konstantin Bondar on 08.01.2024.
//

import XCTest
@testable import Tokenizer

final class TokenizerTests: XCTestCase {


    func testFakeSeparators() throws {
        let string = "Hello sdo aasiudfb asdfiuasdbg addn afdsnx fa f a rr and asd andddae asjdhj if asd,  jsifjosa, ifo ofi sdif ."
        let stateMachine = TokenizeStateMachine()
        let result = stateMachine.process(string: string, separators: ["if", "and"])
        
        XCTAssertEqual(result.count, 2)
        
        XCTAssertEqual(result[0], .init(leadingWords: ["Hello","sdo","aasiudfb","asdfiuasdbg",
                                                       "addn","afdsnx","fa","f","a","rr"],
                                        separator: "and",
                                        trailingWords: ["asd", "andddae", "asjdhj"]))
        
        XCTAssertEqual(result[1], .init(leadingWords: ["asd", "andddae", "asjdhj"],
                                        separator: "if",
                                        trailingWords: ["asd,", "jsifjosa,", "ifo", "ofi", "sdif", "."]))
        
    }
    
    func testEmptyString() {
        let stateMachine = TokenizeStateMachine()
        let result = stateMachine.process(string: "", separators: ["if", "and"])
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testNoSeparatorsInString() {
        let string = "Hello sdo aasiudfb asdfiuasdbg addn afdsnx fa f a rr and asd andddae asjdhj if asd,  jsifjosa, ifo ofi sdif ."
        let stateMachine = TokenizeStateMachine()
        let result = stateMachine.process(string: string, separators: ["ifd"])
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result[0], .init(leadingWords: ["Hello", "sdo", "aasiudfb", "asdfiuasdbg",
                                                       "addn", "afdsnx", "fa", "f", "a", "rr",
                                                       "and", "asd", "andddae", "asjdhj", "if",
                                                       "asd,", "jsifjosa,", "ifo", "ofi",
                                                       "sdif", "."],
                                        separator: "",
                                        trailingWords: []))
    }
    
    func testNoSeparators() {
        let string = "Hello sdo aasiudfb asdfiuasdbg addn afdsnx fa f a rr and asd andddae asjdhj if asd,  jsifjosa, ifo ofi sdif ."
        let stateMachine = TokenizeStateMachine()
        let result = stateMachine.process(string: string, separators: [])
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testEmptyAll() {
        let stateMachine = TokenizeStateMachine()
        let result = stateMachine.process(string: "", separators: [])
        
        XCTAssertTrue(result.isEmpty)
    }
}
