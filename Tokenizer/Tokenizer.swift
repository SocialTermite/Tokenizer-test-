//
//  Tokenizer.swift
//  Tokenizer
//
//  Created by Konstantin Bondar on 08.01.2024.
//

import Foundation
import Combine

class Tokenizer {
    private var inputStringStream: AnyPublisher<String, Never>
    private var inputSeparatorsStream: AnyPublisher<[String], Never>
    
    init(inputStringStream: AnyPublisher<String, Never>, inputSeparatorsStream: AnyPublisher<[String], Never>) {
        self.inputStringStream = inputStringStream
        self.inputSeparatorsStream = inputSeparatorsStream
    }
    
    func startListen() -> AnyPublisher<[String], Never> {
        return Publishers.CombineLatest(inputStringStream, inputSeparatorsStream)
            .map { [weak self] input in
                return self?.tokenize(input.0, separators: input.1) ?? []
            }
            .eraseToAnyPublisher()
    }
    
    private func tokenize(_ string: String, separators: [String]) -> [String] {
        let stateMachine = TokenizeStateMachine()
        let separatorsWithWords = stateMachine.process(string: string, separators: Set(separators))
    
        var result = separatorsWithWords.map { ($0.leadingWords + [$0.separator]).joined(separator: " ") }
        
        let lastLine = (separatorsWithWords.last?.trailingWords ?? []).joined(separator: " ")
        
        if !lastLine.isEmpty {
            result.append(lastLine)
        }
        
        return result
    }
}
