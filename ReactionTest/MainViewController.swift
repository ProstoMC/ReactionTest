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
    
    var trafficLightsView = TrafficLightsView()
    var infoLabel = UILabel()
    var startButton = UIButton() 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}
// MARK:  - Actions
extension MainViewController {
    
    @objc func startButtonPressed() {
        trafficLightsView.setReady()
        viewModel.startGame()
    }
}


// MARK:  - SETUP UI
extension MainViewController {
    private func setupUI() {
        viewModel = MainViewModel()
        
        
        view.backgroundColor = ColorList.mainBackground
        
        setupTrafficLights()
        setupInfoLabel()
        setupStartButton()
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
        
        //Subscribe to View model
        
        viewModel.labelText.subscribe(onNext: { text in
            self.infoLabel.text = text
        }).disposed(by: bag)
        
    }
    
    private func setupTrafficLights() {
        
        view.addSubview(trafficLightsView)
        trafficLightsView.configure(height: UIScreen.main.bounds.height/6)
        
        NSLayoutConstraint.activate([
            trafficLightsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -UIScreen.main.bounds.height*0.3),
            trafficLightsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //Subscribe to View model
        viewModel.trafficLightsStatus.subscribe(onNext: { status in
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
            }
        }).disposed(by: bag)
        
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        startButton.backgroundColor = ColorList.green
        startButton.setTitleColor(ColorList.titles, for: .normal)
        startButton.setTitle("START", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/30, weight: .regular)
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            startButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
        ])
        
        //BEHAVIOR
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        
    }
}

