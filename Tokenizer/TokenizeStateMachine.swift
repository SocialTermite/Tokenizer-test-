//
//  TokenizeStateMachine.swift
//  Tokenizer
//
//  Created by Konstantin Bondar on 09.01.2024.
//

import Foundation

class TokenizeStateMachine {
    private enum State {
        case start(separators: Set<String>)
        case word(accumulator: String)
        case whiteSpace(word: String)
        case separator(separator: String)
        case end
    }
    
    struct SeparatorWithWords: Equatable {
        let leadingWords: [String]
        let separator: String
        let trailingWords: [String]
    }
    
    private var result: [SeparatorWithWords] = []
    private var separators: Set<String> = []
    
    private var leadingWords: [String] = []
    
    func process(string: String, separators: Set<String>) -> [SeparatorWithWords] {
        guard !string.isEmpty, !separators.isEmpty  else { return [] }
        
        self.state = .start(separators: separators)
        
        for char in string {
            changeState(with: char)
        }
        
        self.state = .end
        
        return result
    }
    
    private func changeState(with char: Character) {
        if char == "." {
            print(char)
        }
        switch state {
        case .word(let accumulator):
            if char.isWhitespace {
                if separators.contains(accumulator) {
                    state = .separator(separator: accumulator)
                } else {
                    state = .whiteSpace(word: accumulator)
                }
            } else {
                state = .word(accumulator: accumulator + String(char))
            }
        case .start, .whiteSpace, .separator:
            if !char.isWhitespace {
                state = .word(accumulator: "\(char)")
            }
        default:
            break
        }
    }
    
    private var state: State = .start(separators: []) {
        didSet {
            switch state {
            case .start(let separators):
                leadingWords = []
                lastSeparator = nil
                result = []
                self.separators = separators
            case .whiteSpace(let word):
                leadingWords.append(word)
            case .separator(let separatorString):
                let separator = SeparatorWithWords(leadingWords: leadingWords,
                                                   separator: separatorString,
                                                   trailingWords: lastSeparator?.leadingWords ?? [])
                lastSeparator = separator
                leadingWords = []
            case .end:
                if case .word(let accumulator) = oldValue {
                    leadingWords.append(accumulator)
                }
                if let lastSeparator {
                    result.append(.init(leadingWords: lastSeparator.leadingWords, separator: lastSeparator.separator, trailingWords: leadingWords))
                } else {
                    result.append(.init(leadingWords: leadingWords, separator: "", trailingWords: []))
                }
                
                self.lastSeparator = nil
                leadingWords = []
            default:
                break
            }
        }
    }
    
    private var lastSeparator: SeparatorWithWords? {
        didSet {
            guard let oldValue, let lastSeparator else { return }
            result.append(.init(leadingWords: oldValue.leadingWords, separator: oldValue.separator, trailingWords: lastSeparator.leadingWords))
        }
    }
}

