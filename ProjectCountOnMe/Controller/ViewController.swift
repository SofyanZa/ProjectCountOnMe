//
//  ViewController.swift
//  CountOnMe
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    

    //MARK: PROPERTIES
    
    let calculator = Calculator()
    
    
    //MARK:- OUTLETS connect the View and the Controller
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    
    //MARK:- ACTIONS connect between the View and The methods of Controller
    
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumbers(numbers: numberText)
    }
    

    @IBAction func tappetheOperator(_ sender: UIButton) {
        guard let mathOperator = sender.titleLabel?.text else { return }
        calculator.addOperator(with: mathOperator)
    }

    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.addEqual()
    }
    
    
    @IBAction func tappedACButton(_ sender: UIButton) {
        calculator.addAC()
        
    }
    
    
    //MARK:- VIEW LIFE CYCLES

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
    //MARK:- METHODS
    
    
    func alertMessage(message: String) -> Void {
        let alertVC = UIAlertController(title: "Oups", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    

    func bind(){
        calculator.alertMessage = alertMessage
        calculator.calculText = { calculText in
            self.textView.text = calculText
        }
    }

}
