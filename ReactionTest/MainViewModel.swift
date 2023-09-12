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
    var infoLabelText: BehaviorSubject<String> { get }
    var gameStatus: BehaviorSubject<GameStatuses> { get }
    
    var seconds: BehaviorSubject<String> { get }
    var milliseconds: BehaviorSubject<String> { get }
    
    func buttonPressed()
    
}

class MainViewModel: MainViewModelProtocol {
    
    //Protocol
    var infoLabelText = BehaviorSubject<String>(value: "PRESS BUTTON")
    var gameStatus = BehaviorSubject<GameStatuses>(value: .stopped)
    
    var seconds = BehaviorSubject<String>(value: "0,")
    var milliseconds = BehaviorSubject<String>(value: "00")
    
    var time = 0
    
    
    
    
    // Inside
    let bag = DisposeBag()
    var currentStatusGame = GameStatuses.stopped
    
    //    var stopwatch = Observable<Int>.interval(RxTimeInterval.milliseconds(10), scheduler: MainScheduler.asyncInstance)
    
    var stopwatch: Timer!

    
    
    init() {
        // Get current status from flow
        gameStatus.subscribe(onNext: { self.currentStatusGame = $0 }).disposed(by: bag)
        

        
        
        
    }
   
    
    func buttonPressed() {
        
        switch currentStatusGame {
        case .stopped:
            self.startGame()
        case.lightsOff:
            return
        case .ready:
            return
        case .steady:
            return
        case .go:
            self.getResult()
        case .result:
            self.startGame()
        }
    
        
    }
    
    
    private func startGame() {

        gameStatus.onNext(.lightsOff) // All lights are off
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStatus.onNext(.ready) // First is red - READY
            self.infoLabelText.onNext("READY")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gameStatus.onNext(.steady) // 2 are red - STEADY
                self.infoLabelText.onNext("STEADY")
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int.random(in: 2..<10))) {
                    self.gameStatus.onNext(.go) // 2 red and green - GO

                    self.time = 0
                    
                    self.stopwatch = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                        self?.time += Int(timer.timeInterval*100)
                        let sec = String( (self?.time ?? 0) / 100 ) + ","
                        self?.seconds.onNext(sec)
                        let msec = String((self?.time ?? 0) % 100 )
                        self?.milliseconds.onNext(msec)
                    })
                   
                }
            }

        }
    }
    
    private func getResult() {
        print ("SCORE")
        gameStatus.onNext(.result)
        
        stopwatch.invalidate()
        
        
    }
}
