//
//  TrafficLight.swift
//  ReactionTest
//
//  Created by macSlm on 09.09.2023.
//

import UIKit
import RxSwift


class TrafficLightsView: UIStackView {
    
    var trafficLights = [TrafficLightView(), TrafficLightView(), TrafficLightView()]
    
    func configure(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = height*0.1
        
        trafficLights.forEach { trafficLight in
            self.addArrangedSubview(trafficLight)
            trafficLight.configure(height: height)
        }
        
    }
    
    func setOff() {
        self.isHidden = false
        trafficLights.forEach { trafficLight in
            trafficLight.setOff()
        }
    }
    
    
    func setReady() {
        self.isHidden = false
        trafficLights.forEach { trafficLight in
            trafficLight.setReady()
        }
    }
    
    func setSteady() {
        self.isHidden = false
        trafficLights.forEach { trafficLight in
            trafficLight.setSteady()
        }
    }
    func setGo() {
        self.isHidden = false
        trafficLights.forEach { trafficLight in
            trafficLight.setGo()
        }
    }
    func setHide() {
        self.isHidden = true
    }
    
    
}







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
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorList.borderColor

        setupLights(size: height*0.3*0.8)
    }
    
    func setupLights(size: CGFloat) {
        
        lights.forEach { light in
            
            self.addSubview(light)
            light.translatesAutoresizingMaskIntoConstraints = false
                                
            light.backgroundColor = ColorList.trafficLightOff
            light.layer.cornerRadius = size/2
            light.layer.borderWidth = 1
            light.layer.borderColor = ColorList.borderColor
            
            
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
    

    
    func setOff() {
        
        lights.forEach { light in
            light.backgroundColor = ColorList.trafficLightOff
        }
    }
    
    func setReady() {
        
        lights[0].backgroundColor = ColorList.trafficLightRed
        lights[1].backgroundColor = ColorList.trafficLightOff
        lights[2].backgroundColor = ColorList.trafficLightOff
    }
    
    func setSteady() {
        
        lights[0].backgroundColor = ColorList.trafficLightRed
        lights[1].backgroundColor = ColorList.trafficLightRed
        lights[2].backgroundColor = ColorList.trafficLightOff
    }
    func setGo() {
        
        lights[0].backgroundColor = ColorList.trafficLightRed
        lights[1].backgroundColor = ColorList.trafficLightRed
        lights[2].backgroundColor = ColorList.trafficLightGreen
    }
    
}
