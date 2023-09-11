//
//  MainViewModel.swift
//  ReactionTest
//
//  Created by macSlm on 10.09.2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol MainViewModelProtocol {
    var labelText: BehaviorSubject<String> { get }
    var trafficLightsStatus: BehaviorSubject<GameStatuses> { get }
    
    func startGame()
    
}

class MainViewModel: MainViewModelProtocol {
    
    let bag = DisposeBag()
    //let trafficLightsStatuses = [0, 1, 2, 3, 4]
    
    var labelText = BehaviorSubject<String>(value: "PRESS BUTTON")
    var trafficLightsStatus = BehaviorSubject<GameStatuses>(value: .stopped)
    
    
    func startGame() {

        trafficLightsStatus.onNext(.lightsOff) // All lights are off
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.trafficLightsStatus.onNext(.ready) // First is red - READY
            self.labelText.onNext("READY")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.trafficLightsStatus.onNext(.steady) // 2 are red - STEADY
                self.labelText.onNext("STEADY")
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int.random(in: 3..<10))) {
                    self.trafficLightsStatus.onNext(.go) // 2 red and green - GO
                }
            }

        }
           
    }
}
