//
//  ViewController.swift
//  BestPractice
//
//  Created by Bach Le on 1/7/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import UIKit

class ViewController: LifecycleViewController {

    private lazy var textField: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = .red
        return tv
    }()
    
    private lazy var hideKBButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(onClickHideKb), for: .touchUpInside)
        return btn
    }()
    
    @objc private func onClickHideKb() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    override var isTouchIgnoreViewController: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(!self.view.isKind(of: TouchIgnoreView.self))
        
        self.view.backgroundColor = .white
        self.view.addSubview(textField)
        self.view.addSubview(hideKBButton)

        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textField.text = "hello"
        
        hideKBButton.translatesAutoresizingMaskIntoConstraints = false
        hideKBButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 18).isActive = true
    }

    override func viewDidBecomeActive() {
        super.viewDidBecomeActive()
        print("BecomeActive")
    }
    
    override func viewWillResignActive() {
        super.viewWillResignActive()
        print("ResignActive")
    }
    
    override func viewWillEnterForeground() {
        super.viewWillEnterForeground()
        print("Foreground")
    }
    
    override func viewDidEnterBackground() {
        super.viewDidEnterBackground()
        print("Background")
    }
    
    override func keyboardWillShow(keyboardBeginFrame: CGRect, keyboardEndFrame: CGRect, animationCurve: UIView.AnimationCurve, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardBeginFrame: keyboardBeginFrame, keyboardEndFrame: keyboardEndFrame, animationCurve: animationCurve, animationDuration: animationDuration)
        
        
        print("KB will show")
    }
    
    override func keyboardWillHide(animationCurve: UIView.AnimationCurve, animationDuration: TimeInterval) {
        super.keyboardWillHide(animationCurve: animationCurve, animationDuration: animationDuration)
        
            print("KB will hide")
    }
}

