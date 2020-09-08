//
//  AddFriendViewController.swift
//  FitWithFriends
//
//  Created by user on 8/16/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import MaterialComponents
import YogaKit
import Hero
import SwiftEntryKit

class AddFriendViewController: UIViewController {
   let contentView: UIScrollView = UIScrollView(frame: .zero)
    var username = String()
    
     
    
       var panGR: UIPanGestureRecognizer!
    let signuplabel = UILabel()
    let friendslist: UICollectionView = {
        
          let view = UICollectionView(
              frame: .zero,
              collectionViewLayout: UICollectionViewFlowLayout())
          view.register(SuggestionCell.self, forCellWithReuseIdentifier: "suggestioncell")
          
          view.backgroundColor = .clear
          return view
      }()
        let db = Firestore.firestore()

        private var searchqueries = 0
             
           
         
           var totalfriends = [Friend]()
          
        
         
           var suggestions = [Friend]()
           let defaults = UserDefaults.standard
        // Load shows from plist
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            // Calculate and set the content size for the scroll view
            var contentViewRect: CGRect = .zero
            for view in contentView.subviews {
                contentViewRect = contentViewRect.union(view.frame)
            }
            contentView.contentSize = contentViewRect.size
        }
        
        
        //username field, password field, and email field
        let searchfield: MDCTextField = {
            let userfield = MDCTextField()
            userfield.clearButtonMode = .unlessEditing
            userfield.backgroundColor = .clear
            
           // userfield.layer.cornerRadius = 25
            return userfield
        }()
    
        let searchfieldController: MDCTextInputControllerOutlined
       
     /*   let backbutton: UIButton = {
            let userfield = UIButton()
            userfield.addTarget(self, action: #selector(goback), for: .touchUpInside)
            userfield.titleLabel?.font = UIFont(name: "Gill Sans", size: 10)
            userfield.setTitleColor(UIColor.blue, for: .normal)
            userfield.setTitle("Go back", for: .normal)
            
            return userfield
        }()
          @objc func goback(sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }*/
        
      
        
     
        

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            //TODO: Setup text field controllers
            searchfieldController = MDCTextInputControllerOutlined(textInput: searchfield)
            searchfieldController.normalColor = .white
                        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        required init?(coder aDecoder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            print(suggestions)
            
            self.panGR = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
            //flexbox initial
           
            contentView.configureLayout { (layout) in
                layout.isEnabled = true
                layout.height = YGValue(self.view.bounds.height)
                layout.width = YGValue(self.view.bounds.width)
                layout.alignSelf = .center
                layout.justifyContent = .flexStart
            }
            self.view.addSubview(contentView)
            
            
            
            
            //for safe area bc im dumb
            let safearea = UIView()
            safearea.configureLayout{ (layout) in
                layout.isEnabled = true
                
                
                layout.width = YGValue(self.view.safeAreaLayoutGuide.layoutFrame.width)
                YGValue(self.view.safeAreaLayoutGuide.layoutFrame.minY)
                layout.height = 35
            }
         
            
            contentView.addSubview(safearea)
            
            
            
            //sign up logo
            
            //signuplabel.text = "Friends List"
            signuplabel.textAlignment = .center
            signuplabel.textColor = .white
            signuplabel.font = UIFont(name: "Gill Sans", size: 50)
            signuplabel.configureLayout{ (layout) in
                layout.isEnabled = true
                layout.alignSelf = .center
                layout.height = 100
            }
            
            
            
            //logo
            let logoview = UIImageView(frame: .zero)
            // 2
            let image = UIImage(named: "whitelogo")
            let imageWidth = image?.size.width ?? 1.0
            let imageHeight = image?.size.height ?? 1.0
            
            
            
            logoview.image = image
            
            
            
            logoview.configureLayout { (layout) in
                layout.isEnabled = true
                
                layout.aspectRatio = imageWidth / imageHeight
                layout.width = 400
                layout.height = 100
                layout.alignSelf = .center
                
            }
           // contentView.addSubview(logoview)
           
       
            
            //user pass and email fields
            
            searchfield.configureLayout { (layout) in
                layout.isEnabled = true
                
                
               
                layout.width = YGValue(self.view.frame.size.width - 20)
                layout.margin = 5
                layout.alignSelf = .center
                
                
                
            }
            friendslist.configureLayout { (layout) in
                         layout.isEnabled = true
                         layout.flexGrow = 1
                         
                         
                     }
          
             contentView.addSubview(signuplabel)
            contentView.addSubview(searchfield)
           
            
            searchfieldController.placeholderText = "Search a user to add!"
            searchfield.delegate = self
           
               
           
                let height = CGFloat(70)
                           let width = self.view.frame.size.width - 10
                           let cellSize = CGSize(width:width,height:height)
                           let layout = UICollectionViewFlowLayout()
                           layout.scrollDirection = .vertical
                           layout.itemSize = cellSize
                           layout.minimumLineSpacing = 10
                           self.friendslist.setCollectionViewLayout(layout, animated: true)
                           
                           self.friendslist.delegate = self
                           self.friendslist.dataSource = self
            contentView.addSubview(friendslist)
               contentView.addGestureRecognizer(self.panGR)
            friendslist.reloadData()
   
            
           
            
          
            
            
            
            //accept terms and conditions
            
            
            
            contentView.yoga.applyLayout(preservingOrigin: false)
        }
        @objc func acceptrequest(_ sender: MDCButton) {
              
            db.collection("friendpairs").document(suggestions[sender.tag].id!).setData(["isFriends":true], merge: true)
              
          }
    @objc func leftSwipeDismiss(gestureRecognizer:UIPanGestureRecognizer) {
      
          switch gestureRecognizer.state {
                 case .began:
                  self.dismiss(animated: true, completion: nil)
                 case .changed:
                     
                     let translation = gestureRecognizer.translation(in: nil)
                     let progress = translation.x / -2.0 / view.bounds.width
                     Hero.shared.update(progress)
                     Hero.shared.apply(modifiers: [.translate(x: translation.x + 50)], to: self.view)
                     break
                 default:
                     let translation = gestureRecognizer.translation(in: nil)
                     let progress = translation.x / -2.0 / view.bounds.width
                     if progress + gestureRecognizer.velocity(in: nil).x / view.bounds.width < -0.3 {
                         Hero.shared.finish()
                     } else {
                         Hero.shared.cancel()
                     }
      }}
    @objc func deletefriend(_ sender: MDCButton) {
       
      
      
        db.collection("friendpairs").document(suggestions[sender.tag].id!).delete()
        let indexPath = IndexPath(row: sender.tag, section: 0)
       
        suggestions.remove(at: sender.tag)
        friendslist.reloadData()
                
            }
        override func viewDidAppear(_ animated: Bool) {
                 self.contentView.removeGradient()
               let theme = self.defaults.string(forKey: "theme") ?? "healthy"
                 self.contentView.addsetgradientbackground(theme: theme)
             }
        
        /*  @IBAction func signuptap(_ sender: Any) {
         let error = validateFields()
         if error != nil {
         
         // There's something wrong with the fields, show error message
         errorlbl.text = error
         }
         else {
         //check username fields
        
         
         
         
         
         
         self.dismiss(animated: true, completion: nil)
         
         }}}}}}
        /}*/
}
extension AddFriendViewController: UITextFieldDelegate {
        
        //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
         func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder();
            
            // TextField
            if (textField == searchfield) {
                if searchfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
  
                               { searchfieldController.setErrorText("Invalid username.",
                               errorAccessibilityValue: nil)
                               }
                    else if (searchfield.text?.count ?? 14 >= 14)
                     {
                        searchfieldController.setErrorText("Invalid username.",
                         errorAccessibilityValue: nil)
                     }
                else { let invalidChars = NSCharacterSet.alphanumerics.inverted

                     
                     let range = searchfield.text?.rangeOfCharacter(from: invalidChars)

                     if range != nil {
                        searchfieldController.setErrorText("Invalid username.",
                         errorAccessibilityValue: nil)
                    }
                else {
                    let username = self.searchfield.text!
                              print(username)
                    let docRef = self.db.collection("users").whereField("lowercasedname", isEqualTo: username.lowercased())
                               docRef.getDocuments() { (querySnapshot, err) in
      if let err = err {
       self.searchfieldController.setErrorText("User not found or already added.",
         errorAccessibilityValue: nil)
      
                               
      } else {
          self.searchqueries += 1
          if (querySnapshot!.count == 0)
          
          {  self.searchfieldController.setErrorText("User not found or already added.",
 errorAccessibilityValue: nil)
                             
          }
       
          for document in querySnapshot!.documents {
           let completionstring = "User not found or already added."
         
           
              let requestingname = document.get("username") as! String
             
              
            let storeduid  =  document.documentID as! String
              
              let storage = Storage.storage()
                       let storageRef = storage.reference()
              let reference = storageRef.child("profilepics/"+(storeduid))
              let isFriends = false
            let isBlocked = false
             let initialuid = Auth.auth().currentUser?.uid
                     let defaults = UserDefaults.standard
                    
                       let initialname = defaults.value(forKey: "username")
           var checkfriendrequest = 0
           self.db.collection("friendpairs").whereField("users", isEqualTo:[initialuid,storeduid]).getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {

                     print(querySnapshot!.count)
                       if (querySnapshot!.count == 0)
                       {
                           checkfriendrequest = checkfriendrequest + 1
                    }
                    if (checkfriendrequest == 2) {
                        
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
                                           self.db.collection("friendpairs").addDocument(data: ["initial":initialuid, "isFriends": isFriends, "initialname" : initialname, "requesting":storeduid, "isBlocked": isBlocked, "requestingname":requestingname, "users":[initialuid,storeduid]])
                                                            var attributes2 = EKAttributes.topFloat
                                            attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                                                   attributes2.roundCorners = .all(radius: 25)
                                                    attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                                    attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                                    attributes2.statusBar = .dark
                                                   attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                                  
                                                     attributes2.position = .bottom
                                            let title = EKProperty.LabelContent(text: "Request sent", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                            
                                                let description = EKProperty.LabelContent(text: ("Friend request successfully sent."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                           
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
                            let title = EKProperty.LabelContent(text: requestingname, style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                        
                            let description = EKProperty.LabelContent(text: ("Do you want to send this user a friend request?"), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                        let storage = Storage.storage()
                                               let storageRef = storage.reference()
                                               let reference = storageRef.child("profilepics/"+storeduid)
                                        let ui = UIImageView()
                        
                        ui.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           let image = EKProperty.ImageContent(image: ui.image!, size: CGSize(width: 100, height: 100))
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
                        
                        //self.db.collection("friendpairs").addDocument(data: ["initial":initialuid, "isFriends": isFriends, "initialname" : initialname, "requesting":storeduid, "requestingname":requestingname, "isBlocked":isBlocked, "users":[initialuid,storeduid]])
                            
                    
                             
                           
    }
    else {
        print("ASS")
    }
                       }
                   }
           
          self.db.collection("friendpairs").whereField("users", isEqualTo: [storeduid,initialuid]).getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                     
                       print(querySnapshot!.count)
                     if
                       (querySnapshot!.count == 0)
       {
         checkfriendrequest = checkfriendrequest + 1
                        
                    }
                    if (checkfriendrequest == 2) {
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
                                                                  self.db.collection("friendpairs").addDocument(data: ["initial":initialuid, "isFriends": isFriends, "initialname" : initialname, "requesting":storeduid, "isBlocked": isBlocked, "requestingname":requestingname, "users":[initialuid,storeduid]])
                                                                                   var attributes2 = EKAttributes.topFloat
                                                                   attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                                                                          attributes2.roundCorners = .all(radius: 25)
                                                                           attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                                                           attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                                                           attributes2.statusBar = .dark
                                                                          attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                                                         
                                                                            attributes2.position = .bottom
                                                                   let title = EKProperty.LabelContent(text: "Request sent", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                                                   
                                                                       let description = EKProperty.LabelContent(text: ("Friend request successfully sent."), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                                                  
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
                                                   let title = EKProperty.LabelContent(text: requestingname, style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                               
                                                   let description = EKProperty.LabelContent(text: ("Do you want to send this user a friend request?"), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                               let storage = Storage.storage()
                                                                      let storageRef = storage.reference()
                                                                      let reference = storageRef.child("profilepics/"+storeduid)
                                                               let ui = UIImageView()
                                               
                                               ui.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
                                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                  let image = EKProperty.ImageContent(image: ui.image!, size: CGSize(width: 100, height: 100))
                                                          let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                                                       

                                                         let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
                                                       attributes.displayDuration = .infinity
                                                       

                                                        let customView = EKAlertMessageView(with: alertMessage)
                                                   
                                                        // Set its background to white
                                                       
                                                        /*
                                                        ... Customize the view as you like ...
                                                        */

                                                        // Display the view with the configuration
                                                SwiftEntryKit.display(entry: customView, using: attributes)}
          
            
            
  }
         else {
                        self.searchfieldController.setErrorText("User not found or already added.",
                        errorAccessibilityValue: nil)
                    }
                               }
                   
           }
       
          
         // self.imagepic.sd_setImage(with: reference)
             
                }
            }
               
                        }

                    }}
                
            }
            return false
            
    }
    
}

extension AddFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource {

 
     
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
    return suggestions.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestioncell", for: indexPath) as! SuggestionCell
        //for users that sent the request
     
      let friend = suggestions[indexPath[1]]
        if (self.username == friend.initialname && self.username == friend.requestingname)
        {
            let storage = Storage.storage()
                                  let storageRef = storage.reference()
                                  let reference = storageRef.child("profilepics/"+suggestions[indexPath[1]].requesting)
                               
                                  cella.image.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
             cella.name.text = suggestions[indexPath[1]].requestingname
            cella.messagelbl.text = "(YOU)"
            return cella
        }
       
        if (self.username == friend.initialname)
                {
                   
                    if (friend.isFriends)
                    {cella.acceptbutton.isEnabled = false}
                    else {
                        cella.messagelbl.text = "PENDING"}
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let reference = storageRef.child("profilepics/"+suggestions[indexPath[1]].requesting)
                     
                        cella.image.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
                        cella.name.text = suggestions[indexPath[1]].requestingname
                        
                    cella.acceptbutton.addTarget(self, action: #selector(self.acceptrequest(_:)), for: .touchUpInside)
                    cella.deletebutton.addTarget(self, action: #selector(self.deletefriend(_:)), for: .touchUpInside)
                    cella.acceptbutton.tag = indexPath[1]
                    cella.deletebutton.tag = indexPath[1]
                        return cella
                }
            

                    else
                    {   //for users recieving the request
                        if (friend.isFriends)
                        {cella.acceptbutton.isEnabled = false}
          else {
               cella.messagelbl.text = "REQUEST"
                            
                        }
                       
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let reference = storageRef.child("profilepics/"+suggestions[indexPath[1]].initial)
                        cella.image.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
                          cella.name.text = suggestions[indexPath[1]].initialname
                      cella.acceptbutton.addTarget(self, action: #selector(self.acceptrequest(_:)), for: .touchUpInside)
        cella.deletebutton.addTarget(self, action: #selector(self.deletefriend(_:)), for: .touchUpInside)
                        cella.acceptbutton.tag = indexPath[1]
                        cella.deletebutton.tag = indexPath[1]
                        return cella
                    }
                
              
            }
        
        
               
        
               
                             
             
              
            
            
              
       
              
                 

         
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)

           // Instantiate the desired view controller from the storyboard using the view controllers identifier
           // Cast is as the custom view controller type you created in order to access it's properties and methods
        
           let customViewController = storyboard.instantiateViewController(withIdentifier: "acceptvc") as! AcceptPopoverViewController
               customViewController.modalPresentationStyle = .overCurrentContext
               self.contentView.alpha = 0.6
      let cell = friendslist.cellForItem(at: indexPath) as! SuggestionCell
               customViewController.vc2 = self
        let friendpair = suggestions[indexPath[1]]
        customViewController.frienddoc = friendpair.id ?? ""
        customViewController.indexpath = indexPath[1]
        if (friendpair.initialname.lowercased() == defaults.string(forKey: "username")?.lowercased() && friendpair.isFriends == false)
        {
            customViewController.status = 2
        }
        if (friendpair.isFriends == true)
        {
            customViewController.status = 0
        
        }
        if (friendpair.initialname.lowercased() != defaults.string(forKey: "username")?.lowercased() && friendpair.isFriends == false)
               {
                   customViewController.status = 1
               }
      if (self.username == friendpair.initialname && self.username == friendpair.requestingname)
      {
        customViewController.status = 3
        }
          
        present(customViewController, animated: true, completion: nil)
        customViewController.namelabel.text = " " + cell.name.text!
        customViewController.profilepic.image = cell.image.image
            }
     
          
        
       
     
  }
                class SuggestionCell: MDCCollectionViewCell {
                    
                    
                    
                    
                    override init(frame: CGRect) {
                        super.init(frame: frame)
                        
                        addviews()
                    }
                    required init?(coder aDecoder: NSCoder) {
                        fatalError("init(coder:) has not been implemented")
                    }
                    func addviews() {
                        name.font = UIFont(name: "GillSans-Light", size: 17)
                        messagelbl.font = UIFont(name: "GillSans-Light", size: 17)
                        contentview.backgroundColor = .white
                        contentview.layer.cornerRadius = 35
                     contentview.configureLayout { (layout) in
                                layout.isEnabled = true
                                layout.height = 70
                        layout.width = YGValue(self.contentView.bounds.width - 10)
                        layout.marginLeft = 5
                           layout.marginRight = 5
                        layout.flexDirection = .row
                                
                                
                            }
                        messagelbl.configureLayout { (layout) in
      layout.isEnabled = true

                            layout.width = 200
      
      
  }
                        image.configureLayout { (layout) in
                              layout.isEnabled = true
                            layout.height = 70
layout.width = 70
                              
                            layout.alignSelf = .center
                          }
                        name.configureLayout { (layout) in
                              layout.isEnabled = true
                            layout.marginLeft = 10
                        
layout.width = 100
                              
                              
                          }
                      
                        contentview.addSubview(image)
                         contentview.addSubview(name)
//contentview.addSubview(messagelbl)
                        
                        contentview.addSubview(messagelbl)
                        contentview.yoga.applyLayout(preservingOrigin: false)
                        addSubview(contentview)
                    }
let messagelbl = UILabel()
                    let image = UIImageView()
                    let name = UILabel()
                 let contentview = UIView()
                 let acceptbutton = MDCButton()
                    let deletebutton = MDCButton()

                }

