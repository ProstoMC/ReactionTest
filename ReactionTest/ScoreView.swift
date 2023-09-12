//
//  ScoreView.swift
//  ReactionTest
//
//  Created by macSlm on 12.09.2023.
//

import UIKit

class ScoreView: UIView {
    var seconds = UILabel()
    var milliseconds = UILabel()
    
    func configure(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false

        
        seconds.translatesAutoresizingMaskIntoConstraints = false
        milliseconds.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(seconds)
        self.addSubview(milliseconds)
        
        NSLayoutConstraint.activate([
            seconds.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            milliseconds.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            seconds.rightAnchor.constraint(equalTo: self.centerXAnchor),
            milliseconds.leftAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        seconds.font = UIFont.systemFont(ofSize: height)
        milliseconds.font = UIFont.systemFont(ofSize: height)
        
        seconds.textColor = ColorList.titles
        milliseconds.textColor = ColorList.titles
        
        seconds.textAlignment = .right
        milliseconds.textAlignment = .left
        
    }
    
}
