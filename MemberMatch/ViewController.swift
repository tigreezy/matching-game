//
//  ViewController.swift
//  MemberMatch
//
//  Created by Tiger Chen on 2/7/18.
//  Copyright © 2018 Tiger Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startButton: UIButton!
    var answerOne: UIButton!
    var answerTwo: UIButton!
    var answerThree: UIButton!
    var answerFour: UIButton!
    var width: CGFloat!
    var currMember: String!
    
    var imageView: UIImageView!
    var answerButtons: [UIButton]!
    
    var game = false
    
    let members = ["Daniel Andrews", "Nikhar Arora", "Tiger Chen", "Xin Yi Chen", "Julie Deng", "Radhika Dhomse", "Kaden Dippe", "Angela Dong", "Zach Govani", "Shubham Gupta", "Suyash Gupta", "Joey Hejna", "Cody Hsieh", "Stephen Jayakar", "Aneesh Jindal", "Mohit Katyal", "Mudabbir Khan", "Akkshay Khoslaa", "Justin Kim", "Eric Kong", "Abhinav Koppu", "Srujay Korlakunta", "Ayush Kumar", "Shiv Kushwah", "Leon Kwak", "Sahil Lamba", "Young Lin", "William Lu", "Louie McConnell", "Max Miranda", "Will Oakley", "Noah Pepper", "Samanvi Rai", "Krishnan Rajiyah", "Vidya Ravikumar", "Shreya Reddy", "Amy Shen", "Wilbur Shi", "Sumukh Shivakumar", "Fang Shuo", "Japjot Singh", "Victor Sun", "Sarah Tang", "Kanyes Thaker", "Aayush Tyagi", "Levi Walsh", "Carol Wang", "Sharie Wang", "Ethan Wong", "Natasha Wong", "Aditya Yadav", "Candice Ye", "Vineeth Yeevani", "Jeffery Zhang"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        width = view.frame.width
        print(width)
        createStartButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startButtonTapped(sender: UIButton) {
        toggleStartButton()
        if(imageView != nil) {
            // toggle game state
            imageView.isHidden = !imageView.isHidden
            for button in answerButtons {
                button.isHidden = !button.isHidden
            }
        } else {
            // create game state
            createImage()
            createAnswerButtons()
            setNextMember()
        }
    }
    
    @objc func answerButtonTapped(sender: UIButton) {
        let buttonColor: UIColor!
        if sender.currentTitle! == currMember! {
            buttonColor = .green
        } else {
            buttonColor = .red
        }
        UIView.animate(withDuration: 1, animations: {
            sender.backgroundColor = buttonColor
        },completion: { _ in
            sender.backgroundColor = UIColor.lightGray
        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            self.setNextMember()
//        }
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setNextMember), userInfo: nil, repeats: false)
    }
    
    @objc func setNextMember() {
        currMember = getName()
        let imageName = getImageName(name: currMember)
        imageView.image = UIImage(named: imageName)
        
        for button in answerButtons {
            button.setTitle(getName(), for: .normal)
        }
        let answer = Int(arc4random_uniform(UInt32(answerButtons.count)))
        answerButtons[answer].setTitle(currMember, for: .normal)
    }
    
    func toggleStartButton() {
        game = !game
        if !game {
            startButton.setTitle("Start", for: .normal)
        } else {
            startButton.setTitle("Stop", for: .normal)
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
    
    func createStartButton() {
        startButton = UIButton(frame: CGRect(x: 20, y: 50, width: width - 40, height: 35))
        startButton.backgroundColor = UIColor.lightGray
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 5
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    func createImage() {
        imageView = UIImageView(image: UIImage())
        imageView.frame = CGRect(x: 20, y: 100, width: width - 40, height: width - 40)
        view.addSubview(imageView)
    }
    
    func createAnswerButtons() {
        // display answers
        answerOne = UIButton(frame: CGRect(x: 20, y: 450, width: (width - 50)/2, height: 50))
        answerTwo = UIButton(frame: CGRect(x: (width - 50)/2 + 30, y: 450, width: (width - 50)/2, height: 50))
        answerThree = UIButton(frame: CGRect(x: 20, y: 510, width: (width - 50)/2, height: 50))
        answerFour = UIButton(frame: CGRect(x: (width - 50)/2 + 30, y: 510, width: (width - 50)/2, height: 50))
        
        answerButtons = [answerOne, answerTwo, answerThree, answerFour]
        
        for button in answerButtons {
            button.backgroundColor = .lightGray
            button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
            button.layer.cornerRadius = 5
            view.addSubview(button)
        }
    }

}

