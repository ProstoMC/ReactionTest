//
//  ViewController.swift
//  ReactionTest
//
//  Created by macSlm on 09.09.2023.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    let bag = DisposeBag()
    
    var viewModel: MainViewModelProtocol!
    
    var wallpaper = UIImageView()
    var trafficLightsView = TrafficLightsView()
    var infoLabel = UILabel()
    var scoreView = ScoreView()
    var startButton = UIButton() 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK:  - SETUP UI
extension MainViewController {
    private func setupUI() {
        viewModel = MainViewModel()
        
        
        view.backgroundColor = ColorList.mainBackground
        
        setupWallpaper()
        setupTrafficLights()
        setupInfoLabel()
        setupStartButton()
        setupScoreView()
    }
    
    private func setupWallpaper() {
        
        view.addSubview(wallpaper)
        wallpaper.translatesAutoresizingMaskIntoConstraints = false
        
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .right
        
        NSLayoutConstraint.activate([
            wallpaper.topAnchor.constraint(equalTo: view.topAnchor),
            wallpaper.leftAnchor.constraint(equalTo: view.leftAnchor),
            wallpaper.rightAnchor.constraint(equalTo: view.rightAnchor),
            wallpaper.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupInfoLabel() {
        
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        infoLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/40)
        infoLabel.textColor = ColorList.titles
        
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //Subscribe to View model RX
        
        
        
        viewModel.infoLabelText.subscribe(onNext: { text in
            self.infoLabel.text = text
        }).disposed(by: bag)
        
        viewModel.gameStatus.subscribe(onNext: { status in
            switch status {
            case .stopped:
                self.infoLabel.isHidden = false
            case .lightsOff:
                self.infoLabel.isHidden = false
            case .ready:
                self.infoLabel.isHidden = false
            case .steady:
                self.infoLabel.isHidden = false
            case .go:
                self.infoLabel.isHidden = true
            case .result:
                self.infoLabel.isHidden = true
            }
        }).disposed(by: bag)
        
    }
    
    private func setupTrafficLights() {
        
        view.addSubview(trafficLightsView)
        trafficLightsView.configure(height: UIScreen.main.bounds.height/6)
        
        NSLayoutConstraint.activate([
            trafficLightsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -UIScreen.main.bounds.height*0.3),
            trafficLightsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //Subscribe to View model RX
        viewModel.gameStatus.subscribe(onNext: { status in
            switch status {
            case .stopped:
                self.trafficLightsView.setHide()
            case .lightsOff:
                self.trafficLightsView.setOff()
            case .ready:
                self.trafficLightsView.setReady()
                
            case .steady:
                self.trafficLightsView.setSteady()
            case .go:
                self.trafficLightsView.setGo()
            case .result:
                self.trafficLightsView.setHide()
            }
        }).disposed(by: bag)
        
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        startButton.setTitleColor(ColorList.titles, for: .normal)
        //startButton.setTitle("START", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/30, weight: .regular)
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            startButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
        ])
        
        viewModel.gameStatus.subscribe(onNext: { status in
            switch status {
            case .stopped:
                self.startButton.backgroundColor = ColorList.green
                self.startButton.setTitle("START", for: .normal)
            case .lightsOff:
                self.startButton.backgroundColor = ColorList.red
                self.startButton.setTitle("STOP", for: .normal)
            case .ready:
                self.startButton.backgroundColor = ColorList.red
                self.startButton.setTitle("STOP", for: .normal)
            case .steady:
                self.startButton.backgroundColor = ColorList.red
                self.startButton.setTitle("STOP", for: .normal)
            case .go:
                self.startButton.backgroundColor = ColorList.red
                self.startButton.setTitle("STOP", for: .normal)
            case .result:
                self.startButton.backgroundColor = ColorList.green
                self.startButton.setTitle("START", for: .normal)
            }
        }).disposed(by: bag)
        
        //BEHAVIOR RX
        
        startButton.rx.tap.asDriver().drive(onNext: {
            self.viewModel.buttonPressed()
        }).disposed(by: bag)
        
    }
    
    private func setupScoreView() {
        
        view.addSubview(scoreView)
        
        NSLayoutConstraint.activate([
            scoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        scoreView.configure(height: UIScreen.main.bounds.height/20)
        
        viewModel.gameStatus.subscribe(onNext: { status in
            switch status {
            case .stopped:
                self.scoreView.isHidden = true
            case .lightsOff:
                self.scoreView.isHidden = true
            case .ready:
                self.scoreView.isHidden = true
            case .steady:
                self.scoreView.isHidden = true
            case .go:
                self.scoreView.isHidden = false
            case .result:
                self.scoreView.isHidden = false
            }
        }).disposed(by: bag)
    
        
        viewModel.seconds.subscribe(onNext: {
            self.scoreView.seconds.text = $0
        }).disposed(by: bag)
        
        viewModel.milliseconds.subscribe(onNext: {
            self.scoreView.milliseconds.text = $0
        }).disposed(by: bag)
        
        
        
    }
}

