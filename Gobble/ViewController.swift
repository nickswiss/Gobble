//
//  ViewController.swift
//  Gobble
//
//  Created by Nick Arnold on 11/20/15.
//  Copyright © 2015 Relative Path, LLC. All rights reserved.
//

import UIKit
import AVFoundation
import FontAwesome_swift


class ViewController: UIViewController {
    
    var sounds = ["Wing Bone", "Push Pull", "Scratch Box", "Slate Over Glass", "Crystal Over Slate"]
    var turkeyPlayer : AVAudioPlayer?
    
    var callInfo = [
        "Wingbone calls originally were made from the wingbones of a turkey, and some still are. They are a suction-type call. Sounds are made with quick, forceful sucking motions, much like kissing the end of the call. Good wingbone calls make a hollow sounding yelp.",
        "Push-pull turkey calls are the simplest of all turkey calls to use, and create realistic turkey sounds. A push-pull call functions by pushing and/or pulling a button on the end of the call, forcing a surface across a peg.",
        "Box calls create turkey sounds with the friction created by sliding the lid across the surface of the box. Box calls are convenient and are capable of producing more volume than any other call in the world.",
        "The tube call is a popular caller for many of the nation's top turkey hunters. With it, a hunter can make virtually any sound in a turkey's vocabulary from yelps to purrs to gobbles. Tube calls consist of a small hollow barrel with latex fixed across half of the top with an elastic band.",
        "Friction calls feature a round (usually) surface, and the user creates sound by drawing a peg, or striker, across the surface. Friction call surfaces can be slate, aluminum, glass or a variety of other materials.",
    
    ]
    
    
    /** Views/Buttons **/
    @IBOutlet var turkeyImageView: UIImageView!
    @IBOutlet var soundPickerView: UIPickerView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var slideLabel: UILabel!
    
    @IBOutlet var bottomView: UIView!
    
    /** Consraints for animation **/
    @IBOutlet var infoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var infoTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        turkeyPlayer = AVAudioPlayer()
        infoLabel.text = callInfo[0]
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        turkeyImageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        turkeyImageView.addGestureRecognizer(swipeLeft)
        turkeyImageView.userInteractionEnabled = true
        
        playButton.titleLabel?.font = UIFont.fontAwesomeOfSize(40)
        playButton.setTitle(String.fontAwesomeIconWithName(.Play), forState: .Normal)
        
        
        stopButton.titleLabel?.font = UIFont.fontAwesomeOfSize(40)
        stopButton.setTitle(String.fontAwesomeIconWithName(.Stop), forState: .Normal)
        
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor(red: 0.965, green: 0.902, blue: 0.80, alpha: 1.0).CGColor
        
        stopButton.enabled = false
        stopButton.alpha = 0.5
        
    
    }
    
    override func viewWillAppear(animated: Bool) {
        infoLeadingConstraint.constant -= self.view.bounds.width
        infoTrailingConstraint.constant -= self.view.bounds.width
        self.view.layoutIfNeeded()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playPressed(sender: AnyObject) {
        if let pickerDelegate = soundPickerView.delegate {
            var url: NSURL = NSURL()
            let selectedSound = pickerDelegate.pickerView!(soundPickerView, titleForRow: soundPickerView.selectedRowInComponent(0), forComponent: 0)
            
            // Uses value of UIPicker to set URL for sound to be played
            switch(selectedSound!){
            case "Wing Bone":
                url = NSBundle.mainBundle().URLForResource("wingbone", withExtension: "mp3")!
                break
            case "Push Pull":
                url = NSBundle.mainBundle().URLForResource("rosewood", withExtension: "mp3")! //TODO: Fix mp3
                break
            case "Scratch Box":
                url = NSBundle.mainBundle().URLForResource("scratch", withExtension: "mp3")!
                break
            case "Tube Turkey Call":
                url = NSBundle.mainBundle().URLForResource("slate", withExtension: "mp3")! //TODO: FIX mp3
                break
            case "Crystal Over Slate":
                url = NSBundle.mainBundle().URLForResource("crystal", withExtension: "mp3")!
                break
            default:
                url = NSBundle.mainBundle().URLForResource("wingbone", withExtension: "mp3")!
                break
            }
            
            print(url)
            
            // Instantiate AVPlayer with URL, catch only prints at this point
            do {
                turkeyPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
            } catch _ {
                return print("file not found")
            }
            if let turkeyPlayer = turkeyPlayer {
                turkeyPlayer.numberOfLoops = 1
                turkeyPlayer.prepareToPlay()
                turkeyPlayer.play()
                stopButton.enabled = true
                stopButton.alpha = 1.0
            }
        }
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        if let tp = turkeyPlayer {
            tp.stop()
        }
    }

    var infoRight = true
    func respondToSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if !infoRight {
                    self.slideLabel.text = "<<<"
                    self.infoLeadingConstraint.constant -= self.view.bounds.width
                    self.infoTrailingConstraint.constant -= self.view.bounds.width
                    UIView.animateWithDuration(0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    infoRight = true
                }
            case UISwipeGestureRecognizerDirection.Left:
                if infoRight {
                    self.slideLabel.text = ">>>"
                    self.infoLeadingConstraint.constant += self.view.bounds.width
                    self.infoTrailingConstraint.constant += self.view.bounds.width
                    UIView.animateWithDuration(0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    infoRight = false
                }
            default:
                break
            }
        }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sounds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sounds[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let sliderColor = UIColor(red: 0.965, green: 0.902, blue: 0.80, alpha: 1.0)
        return NSAttributedString(string: sounds[row], attributes: [NSForegroundColorAttributeName:sliderColor])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        //TODO: Stop music when switch occurs
        
        var image: UIImage = UIImage()
        
        switch(row) {
        case 0:
            image = UIImage(named: "wingbone.jpg")!
            break
        case 1:
            image = UIImage(named: "pushpull.jpeg")!
            break
        case 2:
            image = UIImage(named: "scratchbox.jpeg")!
            break
        case 3:
            image = UIImage(named: "slate-glass.jpg")!
            break
        case 4:
            image = UIImage(named: "slate-crystal.jpg")!
            break
        default:
            break
        }

        infoLabel.text = callInfo[row]
        turkeyImageView.image = image
    }
}

