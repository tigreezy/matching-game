//
//  ViewController.swift
//  MemberMatch
//
//  Created by Tiger Chen on 2/7/18.
//  Copyright © 2018 Tiger Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var countLabel: UILabel!
    var timer: UILabel!
    var startButton: UIButton!
    var statisticsButton: UIButton!
    var answerOne: UIButton!
    var answerTwo: UIButton!
    var answerThree: UIButton!
    var answerFour: UIButton!
    var answerButtons: [UIButton]!
    var imageView: UIImageView!
    var backgroundImageView: UIImageView!
    var overlayView: UIView!
    
    var width: CGFloat!
    var currMember: String!
    var buttonValues: [String]!
    var userAnswers: [String] = []
    var correctAnswers: [String] = []
    var membersSeen: [String] = []
    
    var clock: Timer!
    
    var game = false
    var longestStreak = 0
    var currStreak = 0
    var totalCorrect = 0
    var time = 5
    var pauseTimer = false
    var correctButtonIndex: Int!
    
    let members = ["Daniel Andrews", "Nikhar Arora", "Tiger Chen", "Xin Yi Chen", "Julie Deng", "Radhika Dhomse", "Kaden Dippe", "Angela Dong", "Zach Govani", "Shubham Gupta", "Suyash Gupta", "Joey Hejna", "Cody Hsieh", "Stephen Jayakar", "Aneesh Jindal", "Mohit Katyal", "Mudabbir Khan", "Akkshay Khoslaa", "Justin Kim", "Eric Kong", "Abhinav Koppu", "Srujay Korlakunta", "Ayush Kumar", "Shiv Kushwah", "Leon Kwak", "Sahil Lamba", "Young Lin", "William Lu", "Louie McConnell", "Max Miranda", "Will Oakley", "Noah Pepper", "Samanvi Rai", "Krishnan Rajiyah", "Vidya Ravikumar", "Shreya Reddy", "Amy Shen", "Wilbur Shi", "Sumukh Shivakumar", "Fang Shuo", "Japjot Singh", "Victor Sun", "Sarah Tang", "Kanyes Thaker", "Aayush Tyagi", "Levi Walsh", "Carol Wang", "Sharie Wang", "Ethan Wong", "Natasha Wong", "Aditya Yadav", "Candice Ye", "Vineeth Yeevani", "Jeffery Zhang"]
    
    // memberGenders[i] is true if members[i] is a male
    let memberGenders = [true, false, true, false, false, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, false, false, true, true, true, true, true, false, true, true, true, false, false, true, false, true, false, true, true]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        width = view.frame.width
        setBackgroundImage()
        createOverlay()
        createStartButton()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        pauseTimer = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startButtonTapped(sender: UIButton) {
        toggleStartButton()
        if(imageView != nil) {
            // toggle game state
            toggleGameState()
        } else {
            // create game state
            createStatisticsBar()
            createImage()
            createAnswerButtons()
            createTimer()
            
            setNextMember()
            startTimer()
            
            overlayView.backgroundColor = UIColor(red: 0.16, green: 0.60, blue: 0.90, alpha: 0.8)
            backgroundImageView.isHidden = true
        }
    }
    
    @objc func answerButtonTapped(sender: UIButton) {
        pauseTimer = true
        let buttonColor: UIColor!
        if sender.currentTitle! == currMember! {
            buttonColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
            updateStatistics(true)
        } else {
            buttonColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
            updateStatistics(false)
        }
        
        updateAnswersList(sender.currentTitle!)
        
        UIView.animate(withDuration: 1, animations: {
            sender.backgroundColor = buttonColor
            self.answerButtons[self.correctButtonIndex].backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
        },completion: { _ in
            sender.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
            self.answerButtons[self.correctButtonIndex].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
            self.setNextMember()
        })
    }
    
    @objc func statisticsButtonTapped() {
//        stopTimer()
        performSegue(withIdentifier: "toStatistics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pauseTimer = true
        if segue.destination is ScoreViewController {
            let vc = segue.destination as? ScoreViewController
            vc?.streak = self.longestStreak
            vc?.userAnswers = self.userAnswers
            vc?.correctAnswers = self.correctAnswers
        }
    }
    
    @objc func setNextMember() {
        currMember = getName()
        while membersSeen.contains(currMember) {
            currMember = getName()
        }
        let currGender = getGender(currMember)
        let imageName = getImageName(name: currMember)
        imageView.image = UIImage(named: imageName)
        buttonValues = [currMember]
        
        var buttonVal = getName()
        for button in answerButtons {
            while buttonValues.contains(buttonVal) || currGender != getGender(buttonVal) {
                buttonVal = getName()
            }
            button.setTitle(buttonVal, for: .normal)
            buttonValues = buttonValues + [buttonVal]
        }
        correctButtonIndex = Int(arc4random_uniform(UInt32(answerButtons.count)))
        answerButtons[correctButtonIndex].setTitle(currMember, for: .normal)
        
        pauseTimer = false
        timer.text = "5"
        time = 5
        
        updateMembersSeen()
    }
    
    func toggleGameState() {
        imageView.isHidden = !imageView.isHidden
        for button in answerButtons {
            button.isHidden = !button.isHidden
        }
        statisticsButton.isHidden = !statisticsButton.isHidden
        countLabel.isHidden = !countLabel.isHidden
        backgroundImageView.isHidden = !backgroundImageView.isHidden
        overlayView.isHidden = !overlayView.isHidden
        timer.isHidden = !timer.isHidden
        pauseTimer = !pauseTimer
    }
    
    func updateMembersSeen() {
        membersSeen.append(currMember)
        if membersSeen.count == members.count {
            membersSeen.removeAll()
        }
    }
    
    func getGender(_ member: String) -> Bool {
        return memberGenders[members.index(of: member)!]
    }
    
    func startTimer() {
        time = 5
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        clock.invalidate()
        clock = nil
    }
    
    @objc func updateTimer() {
        if pauseTimer {
        } else {
            time = time - 1
            timer.text = String(time)
            if time == 0 {
                pauseTimer = true
                updateAnswersList("Time ran out")
                updateStatistics(false)
                showCorrectAnswer()
            }
        }
    }
    
    func showCorrectAnswer() {
        UIView.animate(withDuration: 1, animations: {
            self.answerButtons[self.correctButtonIndex].backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        },completion: { _ in
            self.answerButtons[self.correctButtonIndex].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
            self.setNextMember()
        })
    }
    
    func updateAnswersList(_ answer: String) {
        if userAnswers.count >= 3 {
            userAnswers.remove(at: 0)
            correctAnswers.remove(at: 0)
        }
        userAnswers.append(answer)
        correctAnswers.append(currMember)
    }
    
    func updateStatistics(_ isCorrect: Bool) {
        if isCorrect {
            totalCorrect = totalCorrect + 1
            currStreak = currStreak + 1
            if currStreak > longestStreak {
                longestStreak = currStreak
            }
            countLabel.text = "Score: \(String(totalCorrect))"
        } else {
            currStreak = 0
        }
    }
    
    func toggleStartButton() {
        game = !game
        if !game {
            startButton.setTitle("Start", for: .normal)
        } else {
            startButton.setTitle("Pause", for: .normal)
        }
    }
    
    func getName() -> String {
        let index = Int(arc4random_uniform(UInt32(members.count)))
        return members[index]
    }
    
    func getImageName(name: String) -> String {
        var ret = name.lowercased()
        ret = ret.replacingOccurrences(of: " ", with: "")
        return ret
    }
    
    func createOverlay() {
        overlayView = UIView(frame: view.frame)
        view.addSubview(overlayView)
    }
    
    func createStartButton() {
        startButton = UIButton(frame: CGRect(x: 20, y: view.frame.height*9/10, width: width - 40, height: 45))
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    func createStatisticsBar() {
        statisticsButton = UIButton(frame: CGRect(x: 20, y: 50, width: 120, height: 45))
        statisticsButton.setTitleColor(.white, for: .normal)
        statisticsButton.setTitle("Statistics", for: .normal)
        statisticsButton.layer.borderColor = UIColor.white.cgColor
        statisticsButton.layer.borderWidth = 1.0
        statisticsButton.layer.cornerRadius = 5
        statisticsButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
        view.addSubview(statisticsButton)
        
        countLabel = UILabel(frame: CGRect(x: width - 130, y: 50, width: 110, height: 45))
        countLabel.text = "Score: 0"
        countLabel.textColor = .white
        countLabel.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(countLabel)
    }
    
    func createImage() {
        imageView = UIImageView(image: UIImage())
        imageView.frame = CGRect(x: 20, y: statisticsButton.frame.maxY + 15, width: width - 40, height: width - 40)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    func createAnswerButtons() {
        // display answers
        answerOne = UIButton(frame: CGRect(x: 20, y: imageView.frame.maxY + 15, width: (width - 45)/2, height: 50))
        answerTwo = UIButton(frame: CGRect(x: (width - 45)/2 + 25, y: imageView.frame.maxY + 15, width: (width - 45)/2, height: 50))
        answerThree = UIButton(frame: CGRect(x: 20, y: answerOne.frame.maxY + 5, width: (width - 45)/2, height: 50))
        answerFour = UIButton(frame: CGRect(x: (width - 45)/2 + 25, y: answerTwo.frame.maxY + 5, width: (width - 45)/2, height: 50))
        
        answerButtons = [answerOne, answerTwo, answerThree, answerFour]
        
        for button in answerButtons {
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
            button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
            button.layer.cornerRadius = 5
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            view.addSubview(button)
        }
    }
    
    func createTimer() {
        timer = UILabel(frame: CGRect(x: imageView.frame.maxX - 50, y: imageView.frame.maxY - 55, width: 50, height: 50))
        timer.textColor = .white
        timer.font = UIFont.systemFont(ofSize: 50)
        timer.textAlignment = .center
        view.addSubview(timer)
    }
    
    func setBackgroundImage() {
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = UIImage(named: "MDBlogo")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.8
        view.addSubview(backgroundImageView)
    }

}


