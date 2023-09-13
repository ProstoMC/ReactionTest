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
    
    // Inside
    let bag = DisposeBag()
    var currentStatusGame = GameStatuses.stopped
    
    
    var stopwatch: Timer!
    var time = 0 //Count of msecs
    
    init() {
        // Get current status from flow
        gameStatus.subscribe(onNext: { self.currentStatusGame = $0 }).disposed(by: bag)
        
        setupGameProcess()
    }
   
    // MARK:  - PROTOCOL
    func buttonPressed() {
        
        switch currentStatusGame {
        case .stopped:
            gameStatus.onNext(.lightsOff)
           // self.startGame()
        case.lightsOff:
            gameStatus.onNext(.stopped)
        case .ready:
            gameStatus.onNext(.stopped)
        case .steady:
            gameStatus.onNext(.stopped)
        case .go:
            gameStatus.onNext(.result)
            //self.getResult()
        case .result:
            gameStatus.onNext(.lightsOff)
            //self.startGame()
        }
    
        
    }
    
    // MARK:  - Setup from init
    
    private func setupGameProcess() {
        gameStatus.subscribe(onNext: { status in
            switch status {
            case .stopped:
                return
            case.lightsOff:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.currentStatusGame == .lightsOff {
                        self.gameStatus.onNext(.ready)
                    }
                    
                }
            case .ready:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.currentStatusGame == .ready {
                        self.gameStatus.onNext(.steady)
                    }
                }
            case .steady:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int.random(in: 2..<10))) {
                    if self.currentStatusGame == .steady {
                        self.gameStatus.onNext(.go)
                    }
                }
            case .go:
                self.time = 0
                self.stopwatch = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                    self?.time += Int(timer.timeInterval*100)
                    let sec = String( (self?.time ?? 0) / 100 ) + ","
                    self?.seconds.onNext(sec)
                    let msec = String((self?.time ?? 0) % 100 )
                    self?.milliseconds.onNext(msec)
                })
            case .result:
                self.stopwatch.invalidate()
            }
        }).disposed(by: bag)
    }
    
}
