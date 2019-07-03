//
//  ViewController.swift
//  Simple Game
//
//  Created by Natalia Kazakova on 02/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 0
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        
        updateUI()
        
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    func objectTapped() {
        guard isGameActive else { return }
        
        repositionImageWithTimer()
        
        score += 1
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayDuration, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func startGame(){
        score = 0
        
        repositionImageWithTimer()
        
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
        
        gameTimeLeft = stepper.value
        
        isGameActive = true
        
        updateUI()
    }
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        
        if gameTimeLeft <= 0 {
            stopGame()
        } else {
            updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    private func stopGame(){
        timer?.invalidate()
        gameTimer?.invalidate()
        
        isGameActive = false
        
        updateUI()
        
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        
        if isGameActive {
            timeLabel.text = "Осталось: \(Int(gameTimeLeft)) сек."
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек."
            actionButton.setTitle("Начать", for: .normal)
        }
    }
}

