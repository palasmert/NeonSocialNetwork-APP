//
//  HorizonalLines.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import SnapKit

extension UIView {
    func addHorizontalLines(around label: UILabel, lineColor: UIColor = .lightGray) {
        let leftLine = UIView()
        leftLine.backgroundColor = lineColor

        let rightLine = UIView()
        rightLine.backgroundColor = lineColor
        
        self.addSubview(leftLine)
        self.addSubview(rightLine)
        
        leftLine.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.left.equalToSuperview()
            make.right.equalTo(label.snp.left).offset(-10)
            make.height.equalTo(1)
        }
        
        rightLine.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.left.equalTo(label.snp.right).offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
