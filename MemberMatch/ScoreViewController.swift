//
//  ScoreViewController.swift
//  MemberMatch
//
//  Created by Tiger Chen on 2/8/18.
//  Copyright © 2018 Tiger Chen. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    var streak: Int!
    var userAnswers: [String]!
    var correctAnswers: [String]!
    
    var streakLabel: UILabel!
    var resultLabel: UILabel!
    var correctAnswerLabel: UILabel!
    var userAnswerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(red: 0.16, green: 0.60, blue: 0.90, alpha: 1.0)
        createStreakLabel()
        showPreviousAnswers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createStreakLabel() {
        streakLabel = UILabel(frame: CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 50))
        streakLabel.text = String("Longest streak: \(streak!)")
        streakLabel.textColor = .white
        streakLabel.font = UIFont.systemFont(ofSize: 35)
        streakLabel.textAlignment = .center
        view.addSubview(streakLabel)
    }
    
    func showPreviousAnswers() {
        resultLabel = UILabel(frame: CGRect(x: 30, y: streakLabel.frame.maxY + 30, width: view.frame.width - 60, height: 30))
        resultLabel.text = "Previous 3 Results:"
        resultLabel.textColor = .white
        resultLabel.font = UIFont.systemFont(ofSize: 25)
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)
        
        correctAnswerLabel = UILabel(frame: CGRect(x: 30, y: resultLabel.frame.maxY + 20, width: (view.frame.width - 70)/2, height: 30))
        correctAnswerLabel.text = "Correct Answer"
        correctAnswerLabel.textColor = .white
        correctAnswerLabel.font = UIFont.systemFont(ofSize: 20)
        correctAnswerLabel.textAlignment = .center
        view.addSubview(correctAnswerLabel)
        
        userAnswerLabel = UILabel(frame: CGRect(x: view.frame.width/2 + 5, y: resultLabel.frame.maxY + 20, width: (view.frame.width - 70)/2, height: 30))
        userAnswerLabel.text = "User Answer"
        userAnswerLabel.textColor = .white
        userAnswerLabel.font = UIFont.systemFont(ofSize: 20)
        userAnswerLabel.textAlignment = .center
        view.addSubview(userAnswerLabel)
        
        for i in 0..<correctAnswers.count {
            let correctAnswer = UILabel(frame: CGRect(x: 40, y: correctAnswerLabel.frame.maxY + 20 + CGFloat(i*40), width: (view.frame.width - 70)/2, height: 30))
            correctAnswer.text = "\(i+1). \(correctAnswers[correctAnswers.count - (i + 1)])"
            correctAnswer.textColor = .white
            correctAnswer.font = UIFont.systemFont(ofSize: 15)
            correctAnswer.adjustsFontSizeToFitWidth = true
            view.addSubview(correctAnswer)
            
            let userAnswer = UILabel(frame: CGRect(x: userAnswerLabel.frame.minX + 20, y: userAnswerLabel.frame.maxY + 20 + CGFloat(i*40), width: (view.frame.width - 70)/2, height: 30))
            userAnswer.text = "\(i+1). \(userAnswers[userAnswers.count - (i + 1)])"
            userAnswer.font = UIFont.systemFont(ofSize: 15)
            userAnswer.adjustsFontSizeToFitWidth = true
            view.addSubview(userAnswer)
            
            if correctAnswer.text == userAnswer.text {
                userAnswer.textColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.6)
            } else {
                userAnswer.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)
            }
        }
        
    }

}
