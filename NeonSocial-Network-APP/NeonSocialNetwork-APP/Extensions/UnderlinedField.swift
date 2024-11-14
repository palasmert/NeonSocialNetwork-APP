//
//  UnderlinedTF.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit

extension UITextField {
    func setUnderlined() {
        let border = UIView()
        border.backgroundColor = .lightGray
        border.translatesAutoresizingMaskIntoConstraints = false // Auto Layout'u kullanmak için gerekli

        guard let superview = self.superview else { return }
        superview.addSubview(border)
        superview.bringSubviewToFront(self)

        // Alt çizginin konumlandırılması
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0),
            border.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0),
            border.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func configurePlaceholder(_ placeholder: String, isSecure: Bool = false) -> UITextField {
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.borderStyle = .none
        
        if isSecure {
            self.textContentType = .oneTimeCode
        }
        return self
    }

}


