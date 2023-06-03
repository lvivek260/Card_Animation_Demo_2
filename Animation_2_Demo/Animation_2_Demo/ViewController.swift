//
//  ViewController.swift
//  Animation_2_Demo
//
//  Created by PHN MAC 1 on 24/05/23.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var hCenter: NSLayoutConstraint!
    @IBOutlet weak var vCenter: NSLayoutConstraint!
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionViewConfiguration(sender: self.view)
        questionViewConfiguration(sender: self.questionView)
        print(self.view.frame.size.width)
    }

    func questionViewConfiguration(sender: UIView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        sender.isUserInteractionEnabled = true
        sender.addGestureRecognizer(panGesture)
    }
    @objc func draggedView(_ sender: UIPanGestureRecognizer){
        self.view.bringSubviewToFront(questionView)
        
        UIView.animate(withDuration: 0.25){
            let translation = sender.translation(in: self.view)
            self.questionView.center = CGPoint(x: self.questionView.center.x + translation.x, y: self.questionView.center.y)
           sender.setTranslation(CGPoint.zero, in: self.view)
            
           let viewX: CGFloat = self.view.center.x
           let questionViewX: CGFloat = self.questionView.center.x
           let viewWidth: CGFloat = self.view.frame.width
            print(questionViewX)
            
            let leftCgPoint =  CGPoint(x: -(self.view.center.x+10), y: self.questionView.center.y)
            let rightCgPoint = CGPoint(x: (self.view.center.x + self.view.frame.width + 10), y: self.questionView.center.y)
            
            if(viewX < questionViewX){
                self.questionView.transform = CGAffineTransform(rotationAngle: questionViewX/2000)
                if(questionViewX > self.view.frame.width-150) && sender.state == .ended{
                    //self.rightAnimation()
                    self.leftRightAnimation(point: rightCgPoint, angle: 0.35, side: "False")
                }
                else if sender.state == .ended{
                    self.goToNormalPosition()
                }
               
            }else{
                self.questionView.transform = CGAffineTransform(rotationAngle: -((viewWidth - questionViewX)/2000))
                if(questionViewX<150) && sender.state == .ended{
                   // self.leftAnimation()
                    self.leftRightAnimation(point: leftCgPoint, angle: -(0.35), side: "True")
                    self.leftRightHeilightView(lrView: self.leftView, state: true)
                }
                else if sender.state == .ended{
                    self.goToNormalPosition()
                }
            }
            
            // For Hilight View
            if(questionViewX<150){
                self.leftRightHeilightView(lrView: self.leftView, state: true)
            }else{
                self.leftRightHeilightView(lrView: self.leftView, state: false)
            }
            
            if (questionViewX > self.view.frame.width-150){
                self.leftRightHeilightView(lrView: self.rightView, state: true)
            }else{
                self.leftRightHeilightView(lrView: self.rightView, state: false)
            }
        }
    }
    
   
    func leftRightAnimation(point:CGPoint, angle:CGFloat, side:String){
        UIView.animate(withDuration: 0.25, animations: {
            self.questionView.center = point
            self.questionView.transform = CGAffineTransform(rotationAngle: angle)
        }){ done in
            if done{
                self.questionView.isHidden = true
                self.alertMessage(massage: side)
            }
        }
    }
    func goToNormalPosition(){
        UIView.animate(withDuration: 0.25, animations: {
            self.questionView.center.x = self.mainView.center.x
            self.questionView.center.y = self.mainView.frame.height/2 
            self.questionView.transform = CGAffineTransform(rotationAngle: 0)
        })
    }
    
    func alertMessage(massage: String){
        let alertMessage = UIAlertController(title: massage, message: nil, preferredStyle: .alert)
        self.present(alertMessage, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.view.endEditing(true)
        }
    }
    func leftRightHeilightView(lrView: UIView, state: Bool){
        UIView.animate(withDuration: 0.5, animations: {
            if state{
                lrView.backgroundColor = UIColor.systemPink
            }
            else{
                lrView.backgroundColor = UIColor.systemIndigo
            }
        })
    }
}
/*
func leftAnimation(){
    UIView.animate(withDuration: 0.25, animations: {
        self.questionView.center = CGPoint(x: -(self.view.center.x+10), y: self.questionView.center.y)
        self.questionView.transform = CGAffineTransform(rotationAngle: -(0.35))
    }){ done in
        if done{
            self.questionView.isHidden = true
        }
    }
}
func rightAnimation(){
    UIView.animate(withDuration: 0.25, animations: {
        self.questionView.center = CGPoint(x: (self.view.center.x + self.view.frame.width + 10), y: self.questionView.center.y)
        self.questionView.transform = CGAffineTransform(rotationAngle: (0.35))
    }){ done in
        if done{
            self.questionView.isHidden = true
        }
    }
}
*/

