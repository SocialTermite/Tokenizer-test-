//
//  ViewController.swift
//  Tokenizer
//
//  Created by Konstantin Bondar on 08.01.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var separatorsTF: UITextField!
    
    private lazy var separatorsPublisher: AnyPublisher<[String], Never> = {
        separatorsTF.textPublisher.map { $0.components(separatedBy: " ") }.eraseToAnyPublisher()
    }()
    
    private lazy var tokenizer = Tokenizer(inputStringStream: inputTF.textPublisher.eraseToAnyPublisher(),
                                           inputSeparatorsStream: separatorsPublisher.eraseToAnyPublisher())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenizer.startListen()
            .sink { _ in } receiveValue: { [weak self] strings in
                self?.demoLabel.text = strings.count > 1 ? strings.joined(separator: "\n\t------Separated-------\t\n") : strings.joined()
            }
            .store(in: &cancellables)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}

