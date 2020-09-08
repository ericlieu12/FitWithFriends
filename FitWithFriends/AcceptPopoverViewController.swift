//
//  AcceptPopoverViewController.swift
//  FitWithFriends
//
//  Created by Eric Lieu on 8/31/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseFirestore
import SwiftEntryKit
class AcceptPopoverViewController: UIViewController {
    var vc = FriendStatsViewController()
     var vc2 = AddFriendViewController()
    var uid = ""
    var frienddoc = ""
    var status = 0
    
    @IBOutlet weak var profilepic: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var reportbutton: MDCButton!
    
    @IBOutlet weak var popview: UIView!
    var indexpath = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        popview.layer.cornerRadius = 25
        addfriend.setBackgroundColor(.white)
        addfriend.contentHorizontalAlignment = .left
         removefriend.setBackgroundColor(.white)
        removefriend.contentHorizontalAlignment = .left
         blockuser.setBackgroundColor(.white)
        blockuser.contentHorizontalAlignment = .left
        reportbutton.setBackgroundColor(.white)
        reportbutton.contentHorizontalAlignment = .left
        if (status == 0)
        {
            //already friends
            addfriend.alpha = 0.3
            removefriend.setTitle("remove friend", for: .normal)
            
           reportbutton.setTitle("REPORT", for: .normal)
            removefriend.addTarget(self, action: #selector(self.denyrequest(_:)), for: .touchUpInside)
                    reportbutton.addTarget(self, action: #selector(self.report(_:)), for: .touchUpInside)
                   blockuser.addTarget(self, action: #selector(self.block(_:)), for: .touchUpInside)
        }
        if (status == 1)
               {
                   //already friends
                   
                addfriend.setTitle("Accept Request", for: .normal)
                removefriend.setTitle("Deny Request", for: .normal)
                   addfriend.addTarget(self, action: #selector(self.acceptrequest(_:)), for: .touchUpInside)
                reportbutton.setTitle("REPORT", for: .normal)
                   removefriend.addTarget(self, action: #selector(self.denyrequest(_:)), for: .touchUpInside)
                           reportbutton.addTarget(self, action: #selector(self.report(_:)), for: .touchUpInside)
                          blockuser.addTarget(self, action: #selector(self.block(_:)), for: .touchUpInside)
               }
        if (status == 2)
               {
                   //already friends
                    addfriend.alpha = 0.3
                addfriend.setTitle("Add Friend", for: .normal)
                removefriend.setTitle("Remove Request", for: .normal)
                  reportbutton.setTitle("REPORT", for: .normal)
                removefriend.addTarget(self, action: #selector(self.denyrequest(_:)), for: .touchUpInside)
                        reportbutton.addTarget(self, action: #selector(self.report(_:)), for: .touchUpInside)
                       blockuser.addTarget(self, action: #selector(self.block(_:)), for: .touchUpInside)
               }
        if (status == 3)
        {
            //already friends
             addfriend.alpha = 0.3
            removefriend.alpha = 0.3
            reportbutton.alpha = 0.3
            blockuser.alpha = 0.3
        }
      
                         
         let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.setprofilepic(_:)))
        
                      self.popoverview.addGestureRecognizer(singleTap)
        let drag = UIPanGestureRecognizer(target: self, action: #selector(self.setprofilepic(_:)))
               
                             self.popoverview.addGestureRecognizer(drag)
    }
    @objc func acceptrequest(_ sender: AnyObject) {
                  let db = Firestore.firestore()
               db.collection("friendpairs").document(frienddoc).setData(["isFriends":true], merge: true)
        dismiss(animated: true, completion: nil)
                  vc.contentView.alpha = 1.0
                  vc2.contentView.alpha = 1.0
        
             }
    @objc func block(_ sender: AnyObject) {
                    
       
                     
        dismiss(animated: true, completion: nil)
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
        attributes.roundCorners = .all(radius: 25)
         attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
         attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
         attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.entryInteraction = .absorbTouches
          attributes.position = .center
        attributes.lifecycleEvents.didDisappear = {
            
            self.vc.contentView.alpha = 1.0
            self.vc2.contentView.alpha = 1.0
        }
        attributes.positionConstraints.maxSize = .init(width: .constant(value: 350), height: .intrinsic)
        let lightFont = UIFont(name: "GillSans", size: 15)!
               let mediumFont = UIFont(name: "GillSans", size: 15)
               let closeButtonLabelStyle = EKProperty.LabelStyle(
                  font: mediumFont!,
                   color: .black,
                   displayMode: .dark
               )
               let closeButtonLabel = EKProperty.LabelContent(
                   text: "No",
                   style: closeButtonLabelStyle
               )
       
        let closeButton = EKProperty.ButtonContent(
                   label: closeButtonLabel,
                   backgroundColor: EKColor(.clear),
                   highlightedBackgroundColor: EKColor.standardBackground.with(alpha: 0.2),
                   displayMode: .dark)
               {
                SwiftEntryKit.dismiss {
                   
                }
                
               
        }
            
               let pinkyColor = EKColor.black
               let okButtonLabelStyle = EKProperty.LabelStyle(
                font: lightFont, color: EKColor.black, alignment: .center, displayMode: .dark
            
               )
               let okButtonLabel = EKProperty.LabelContent(
                
                   text: "Yes",
                   style: okButtonLabelStyle
               )
               let okButton = EKProperty.ButtonContent(
                   label: okButtonLabel,
                   backgroundColor: EKColor(.clear),
                   highlightedBackgroundColor: pinkyColor.with(alpha: 0.05),
                   displayMode: .dark) {
                    SwiftEntryKit.dismiss{
                        let db = Firestore.firestore()
                       db.collection("friendpairs").document(self.frienddoc).setData(["isBlocked":true], merge: true)
                                        var attributes2 = EKAttributes.topFloat
                        attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                               attributes2.roundCorners = .all(radius: 25)
                                attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                attributes2.statusBar = .dark
                               attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                              
                                 attributes2.position = .bottom
                        let title = EKProperty.LabelContent(text: "User blocked", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                        
                            let description = EKProperty.LabelContent(text: ("User successfully blocked."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                       
                               let simpleMessage = EKSimpleMessage(title: title, description: description)
                              let alertMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                            attributes.displayDuration = 1.0
                       
                        self.vc2.suggestions.remove(at: self.indexpath)
                        
                        let indexPath = IndexPath(row: self.indexpath, section: 0)
                        self.vc2.friendslist.deleteItems(at: [indexPath])
                             let customView2 = EKNotificationMessageView(with: alertMessage)
                        SwiftEntryKit.display(entry: customView2, using: attributes)
                    }
                   
               }
               let buttonsBarContent = EKProperty.ButtonBarContent(
                   with: okButton, closeButton,
                   separatorColor: EKColor(light: .gray, dark: .gray),
                   horizontalDistributionThreshold: 2,
                   displayMode: .dark,
                   expandAnimatedly: true
               )
        let title = EKProperty.LabelContent(text: (namelabel.text?.trimmingCharacters(in: .whitespaces))!, style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
    
        let description = EKProperty.LabelContent(text: ("Are you sure you want to block this user? FitwithFriends will not notify this user that you blocked them."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
        let image = EKProperty.ImageContent(image: profilepic.image!, size: CGSize(width: 100, height: 100))
           let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
          let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
        attributes.displayDuration = .infinity
        

         let customView = EKAlertMessageView(with: alertMessage)
       
         // Set its background to white
        
         /*
         ... Customize the view as you like ...
         */

         // Display the view with the configuration
         SwiftEntryKit.display(entry: customView, using: attributes)
              /*     let db = Firestore.firestore()
        let alertController = MDCAlertController(title: "Block user", message: "Are you sure you want to block user " + namelabel.text!.trimmingCharacters(in: .whitespaces) + "?")
        let action = MDCAlertAction(title:"Yes") { (action) in  db.collection("friendpairs").document(self.frienddoc).setData(["isBlocked":true], merge: true)
            self.dismiss(animated: true, completion: nil)
            self.vc.contentView.alpha = 1.0
            self.vc2.contentView.alpha = 1.0
        }
                              
        let action2 = MDCAlertAction(title:"No") { (action2) in print("OK") }
                              
                               alertController.addAction(action2)
        alertController.addAction(action)
                          present(alertController, animated:true, completion:nil)*/
                                   
           
                }
    @objc func report(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
              
              
                   var attributes = EKAttributes.topFloat
                   attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                   attributes.roundCorners = .all(radius: 25)
                    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                    attributes.statusBar = .dark
                   attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                   attributes.entryInteraction = .absorbTouches
                     attributes.position = .center
                   attributes.lifecycleEvents.didDisappear = {
                       
                       self.vc.contentView.alpha = 1.0
                       self.vc2.contentView.alpha = 1.0
                   }
                   attributes.positionConstraints.maxSize = .init(width: .constant(value: 300), height: .intrinsic)
                   let lightFont = UIFont(name: "GillSans", size: 15)!
                          let mediumFont = UIFont(name: "GillSans", size: 15)
                          let closeButtonLabelStyle = EKProperty.LabelStyle(
                             font: mediumFont!,
                              color: .black,
                              displayMode: .dark
                          )
                          let closeButtonLabel = EKProperty.LabelContent(
                              text: "No",
                              style: closeButtonLabelStyle
                          )
                  
                   let closeButton = EKProperty.ButtonContent(
                              label: closeButtonLabel,
                              backgroundColor: EKColor(.clear),
                              highlightedBackgroundColor: EKColor.standardBackground.with(alpha: 0.2),
                              displayMode: .dark)
                          {
                           SwiftEntryKit.dismiss {
                              
                           }
                           
                          
                   }
                       
                          let pinkyColor = EKColor.black
                          let okButtonLabelStyle = EKProperty.LabelStyle(
                           font: lightFont, color: EKColor.black, alignment: .center, displayMode: .dark
                       
                          )
                          let okButtonLabel = EKProperty.LabelContent(
                           
                              text: "Yes",
                              style: okButtonLabelStyle
                          )
                          let okButton = EKProperty.ButtonContent(
                              label: okButtonLabel,
                              backgroundColor: EKColor(.clear),
                              highlightedBackgroundColor: pinkyColor.with(alpha: 0.05),
                              displayMode: .dark) {
                               SwiftEntryKit.dismiss{
                                 
                                                   var attributes2 = EKAttributes.topFloat
                                 
                                   attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                                          attributes2.roundCorners = .all(radius: 25)
                                           attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                           attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                           attributes2.statusBar = .dark
                                          attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                         
                                           
                                   let title = EKProperty.LabelContent(text: "User reported", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                   
                                       let description = EKProperty.LabelContent(text: ("User successfully reported. Thank you for your cooperation to keep this community safe!"), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                  
                                          let simpleMessage = EKSimpleMessage(title: title, description: description)
                                         let alertMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                                attributes.displayDuration = 1.0
                                 

                                        let customView2 = EKNotificationMessageView(with: alertMessage)
                                   SwiftEntryKit.display(entry: customView2, using: attributes)
                               }
                              
                          }
                          let buttonsBarContent = EKProperty.ButtonBarContent(
                              with: okButton, closeButton,
                              separatorColor: EKColor(light: .gray, dark: .gray),
                              horizontalDistributionThreshold: 2,
                              displayMode: .dark,
                              expandAnimatedly: true
                          )
                   let title = EKProperty.LabelContent(text: (namelabel.text?.trimmingCharacters(in: .whitespaces))!, style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
               
                   let description = EKProperty.LabelContent(text: ("Are you sure you want report this user? User will be checked for cheating, inappropriate profile picture, inappropriate username, etc. Please do not abuse this function. FitwithFriends will review this account within 24 hours."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                   let image = EKProperty.ImageContent(image: profilepic.image!, size: CGSize(width: 100, height: 100))
                      let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                     let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
                   attributes.displayDuration = .infinity
                   

                    let customView = EKAlertMessageView(with: alertMessage)
                  
                    // Set its background to white
                   
                    /*
                    ... Customize the view as you like ...
                    */

                    // Display the view with the configuration
                    SwiftEntryKit.display(entry: customView, using: attributes)
        
                }
  

    
    @objc func denyrequest(_ sender: AnyObject) {
         
        dismiss(animated: true, completion: nil)
       
       
            var attributes = EKAttributes.topFloat
            attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
            attributes.roundCorners = .all(radius: 25)
             attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
             attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
             attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.entryInteraction = .absorbTouches
              attributes.position = .center
            attributes.lifecycleEvents.didDisappear = {
                
                self.vc.contentView.alpha = 1.0
                self.vc2.contentView.alpha = 1.0
            }
            attributes.positionConstraints.maxSize = .init(width: .constant(value: 300), height: .intrinsic)
            let lightFont = UIFont(name: "GillSans", size: 15)!
                   let mediumFont = UIFont(name: "GillSans", size: 15)
                   let closeButtonLabelStyle = EKProperty.LabelStyle(
                      font: mediumFont!,
                       color: .black,
                       displayMode: .dark
                   )
                   let closeButtonLabel = EKProperty.LabelContent(
                       text: "No",
                       style: closeButtonLabelStyle
                   )
           
            let closeButton = EKProperty.ButtonContent(
                       label: closeButtonLabel,
                       backgroundColor: EKColor(.clear),
                       highlightedBackgroundColor: EKColor.standardBackground.with(alpha: 0.2),
                       displayMode: .dark)
                   {
                    SwiftEntryKit.dismiss {
                       
                    }
                    
                   
            }
                
                   let pinkyColor = EKColor.black
                   let okButtonLabelStyle = EKProperty.LabelStyle(
                    font: lightFont, color: EKColor.black, alignment: .center, displayMode: .dark
                
                   )
                   let okButtonLabel = EKProperty.LabelContent(
                    
                       text: "Yes",
                       style: okButtonLabelStyle
                   )
                   let okButton = EKProperty.ButtonContent(
                       label: okButtonLabel,
                       backgroundColor: EKColor(.clear),
                       highlightedBackgroundColor: pinkyColor.with(alpha: 0.05),
                       displayMode: .dark) {
                        SwiftEntryKit.dismiss{
                            let db = Firestore.firestore()
                           db.collection("friendpairs").document(self.frienddoc).delete()
                            self.vc.contentView.alpha = 1.0
                            self.vc2.contentView.alpha = 1.0
                             self.vc2.suggestions.remove(at: self.indexpath)
                                                   
                                                   let indexPath = IndexPath(row: self.indexpath, section: 0)
                                                   self.vc2.friendslist.deleteItems(at: [indexPath])
                                            var attributes2 = EKAttributes.topFloat
                            attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                                   attributes2.roundCorners = .all(radius: 25)
                                    attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                    attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                    attributes2.statusBar = .dark
                                   attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                  
                                     attributes2.position = .bottom
                            let title = EKProperty.LabelContent(text: "User removed", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                            
                                let description = EKProperty.LabelContent(text: ("User successfully removed."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                           
                                   let simpleMessage = EKSimpleMessage(title: title, description: description)
                                  let alertMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                                attributes.displayDuration = 1.0
                          

                                 let customView2 = EKNotificationMessageView(with: alertMessage)
                            SwiftEntryKit.display(entry: customView2, using: attributes)
                        }
                       
                   }
                   let buttonsBarContent = EKProperty.ButtonBarContent(
                       with: okButton, closeButton,
                       separatorColor: EKColor(light: .gray, dark: .gray),
                       horizontalDistributionThreshold: 2,
                       displayMode: .dark,
                       expandAnimatedly: true
                   )
            let title = EKProperty.LabelContent(text: (namelabel.text?.trimmingCharacters(in: .whitespaces))!, style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
        
            let description = EKProperty.LabelContent(text: ("Are you sure you want remove this user?"), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
            let image = EKProperty.ImageContent(image: profilepic.image!, size: CGSize(width: 100, height: 100))
               let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
              let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
            attributes.displayDuration = .infinity
            

             let customView = EKAlertMessageView(with: alertMessage)
           
             // Set its background to white
            
             /*
             ... Customize the view as you like ...
             */

             // Display the view with the configuration
             SwiftEntryKit.display(entry: customView, using: attributes)
        
    }
     @objc func setprofilepic(_ sender: AnyObject)
        {
            dismiss(animated: true, completion: nil)
            vc.contentView.alpha = 1.0
            vc2.contentView.alpha = 1.0
    }
    @IBOutlet weak var popoverview: UIView!
    @IBOutlet weak var addfriend: MDCButton!
    
    @IBOutlet weak var removefriend: MDCButton!
    
     @IBOutlet weak var blockuser: MDCButton!
}
