//
//  TrafficLight.swift
//  ReactionTest
//
//  Created by macSlm on 09.09.2023.
//

import UIKit

class TrafficLightView: UIView {
    
    var lights = [UIView(), UIView(), UIView()]
   
    let label = UILabel()
    
    func configure(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = ColorList.trafficLightBackground
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            self.widthAnchor.constraint(equalToConstant: height*0.3)
        ])
        
        self.layer.cornerRadius = height*0.04

        setupLights(size: height*0.3*0.8)
    }
    
    func setupLights(size: CGFloat) {
        
        lights.forEach { light in
            
            self.addSubview(light)
            print (self.subviews.count)
                        
            
            light.backgroundColor = ColorList.trafficLightOff
            light.translatesAutoresizingMaskIntoConstraints = false
            light.layer.cornerRadius = size/2
            
            //Common Constrainsts
            NSLayoutConstraint.activate([
                light.heightAnchor.constraint(equalToConstant: size),
                light.widthAnchor.constraint(equalToConstant: size),
                light.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                //light.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
        
        //Individual Constrains
        
        NSLayoutConstraint.activate([
            lights[0].centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -size*1.35),
            lights[1].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lights[2].centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: size*1.35)
        ])
    }
    
}
