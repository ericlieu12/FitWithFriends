//
//  SettingsViewController.swift
//  FitWithFriends
//
//  Created by Eric Lieu on 8/25/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import FirebaseAuth
import YogaKit
import Hero
import MaterialComponents
import CropViewController
import FirebaseStorage
import BetterSegmentedControl
import SafariServices
import SwiftEntryKit
class SettingsViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate {
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.circular
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    let contentView: UIScrollView = UIScrollView(frame: .zero)
    var panGR: UIPanGestureRecognizer!
    let defaults = UserDefaults.standard
    let backgroundslist: UICollectionView = {
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        view.register(BackgroundCell.self, forCellWithReuseIdentifier: "backgroundcell")
        
        view.backgroundColor = .clear
        return view
    }()
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
    
    let logoview: UIImageView = {
        let userfield = UIImageView()
        userfield.image = UIImage(named: "whitelogo")
        
        return userfield
    }()
    let numberview: UIView = {
        let userfield = UIView()
        
        return userfield
    }()
    let numberlabel: UILabel = {
        let userfield = UILabel()
        userfield.font = UIFont(name: "GillSans-Bold", size: 25)
        userfield.text = "Goal: "
        userfield.heroID = "goallabel"
        userfield.textColor = .white
        return userfield
    }()
    let goalview : UIView = {
        let userfield = UIView()
        
        return userfield
    }()
    let goaldecrease: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("-", for: .normal)
        userfield.setBackgroundColor(.clear)
        userfield.layer.cornerRadius = 20
        userfield.setTitleFont(UIFont(name: "GillSans-Bold", size: 25), for: .normal)
        return userfield
    }()
    let goalincrease: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("+", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans-Bold", size: 25), for: .normal)
        userfield.layer.cornerRadius = 20
        userfield.setBackgroundColor(.clear)
        return userfield
    }()
    let goal: UILabel = {
        let userfield = UILabel()
       // userfield.text = "10000"
        userfield.heroID = "goal"
        userfield.font = UIFont(name: "GillSans-Bold", size: 40)
        userfield.textColor = .white
        
        
        userfield.textAlignment = .center
        return userfield
    }()
    let whiteline: UIView = {
        let userfield = UIView()
        userfield.backgroundColor = .white
        userfield.layer.cornerRadius = 5
        return userfield
    }()
    let whiteline2: UIView = {
        let userfield = UIView()
        userfield.backgroundColor = .white
        userfield.layer.cornerRadius = 5
        return userfield
    }()
    let whiteline3: UIView = {
        let userfield = UIView()
        userfield.backgroundColor = .white
        userfield.layer.cornerRadius = 5
        return userfield
    }()
    let whiteline4: UIView = {
        let userfield = UIView()
        userfield.backgroundColor = .white
        userfield.layer.cornerRadius = 5
        return userfield
    }()
    let backgroundlabel: UILabel = {
        let userfield = UILabel()
        userfield.text = "Theme:"
        userfield.font = UIFont(name: "GillSans-Bold", size: 25)
        userfield.textColor = .white
        
        
        userfield.textAlignment = .left
        return userfield
    }()
    let accountlabel: UILabel = {
        let userfield = UILabel()
        userfield.text = "Account:"
        userfield.font = UIFont(name: "GillSans-Bold", size: 25)
        userfield.textColor = .white
        
        
        userfield.textAlignment = .left
        return userfield
    }()
    let warninglabel: UILabel = {
        let userfield = UILabel()
        userfield.text = "Warning, you can only update your profile picture once a month!"
        userfield.font = UIFont(name: "GillSans-Italic", size: 20)
        userfield.textColor = .white
        
        
        userfield.textAlignment = .left
        return userfield
    }()
    let warninglabel2: UILabel = {
        let userfield = UILabel()
        userfield.text = "OFFENSIVE PICS = ACCOUNT REMOVAL"
        userfield.font = UIFont(name: "GillSans-Bold", size: 17)
        userfield.textColor = .white
        
        
        userfield.textAlignment = .left
        return userfield
    }()
    let milesbutton: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("Miles", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans-Bold", size: 15), for: .normal)
        userfield.layer.cornerRadius = 20
        return userfield
    }()
    let kmbutton: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("Kilometers", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans-Bold", size: 15), for: .normal)
        userfield.layer.cornerRadius = 20
        return userfield
    }()
    let none: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("None", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans-Light", size: 15), for: .normal)
        return userfield
    }()
    
    let distanceview: UIView = {
        let userfield = UIView()
        userfield.heroID = "distance"
        return userfield
    }()
    let profileview: UIView = {
        let userfield = UIView()
        userfield.backgroundColor = .white
        userfield.layer.cornerRadius = 25
        return userfield
    }()
    let termsandconbutton: UIButton = {
         let userfield = UIButton()
         userfield.titleLabel!.font = UIFont(name: "GillSans", size: 15)
        userfield.backgroundColor = .black
         userfield.layer.cornerRadius = 15
         userfield.setTitleColor(UIColor.white, for: .normal)
         userfield.setTitle("TERMS AND CONDITIONS", for: .normal)
          userfield.addTarget(self, action: #selector(showtermsandcons), for: .touchUpInside)
         
         return userfield
     }()
     
     let privacypolicybutton: UIButton = {
         let userfield = UIButton()
         userfield.titleLabel!.font = UIFont(name: "GillSans", size: 15)
        userfield.layer.cornerRadius = 15
         userfield.backgroundColor = .black
         userfield.setTitleColor(UIColor.white, for: .normal)
         userfield.setTitle("PRIVACY POLICY", for: .normal)
         userfield.addTarget(self, action: #selector(showprivacypolicy), for: .touchUpInside)
         return userfield
     }()
    let profilepic: UIImageView = {
        let userfield = UIImageView()
        userfield.heroID = "profile"
        return userfield
    }()
    let usernamelabel: UILabel = {
        let userfield = UILabel()
        userfield.font = UIFont(name: "GillSans", size: 20)
        
        userfield.heroID = "name1"
        return userfield
    }()
    let signoutbutton: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("Change profile picture", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans", size: 10), for: .normal)
        userfield.layer.cornerRadius = 20
        return userfield
    }()
    let signoutbutton2: MDCButton = {
        let userfield = MDCButton()
        userfield.setTitle("Sign Out", for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans", size: 15), for: .normal)
        userfield.layer.cornerRadius = 15
        return userfield
    }()
    let goalswitcher: BetterSegmentedControl = {
        let userfield = BetterSegmentedControl(frame:CGRect(x: 0.0, y: 332.0, width: 200, height: 25.0), segments: LabelSegment.segments(withTitles: ["Daily", "Weekly", "Monthly"],
                                        normalFont: UIFont(name: "GillSans-Bold", size: 15)!,
                                        normalTextColor: .black,
                                        selectedFont: UIFont(name: "GillSans-Bold", size: 15)!,
                                        selectedTextColor: .white),
        index: 1,
        options: [.backgroundColor(.clear),
                  .indicatorViewBackgroundColor(UIColor(red: 0.11, green: 0.12, blue: 0.13, alpha: 1.00)),
                  .cornerRadius(18),
                  .animationSpringDamping(1.0),
                  .panningDisabled(true)])
        
        return userfield
    }()
    let buttonsview: UIView = {
        let userfield = UIView()
        userfield.layer.cornerRadius = 20
        userfield.backgroundColor = .clear
        return userfield
    }()
    let distancelabel: UILabel = {
        let userfield = UILabel()
        userfield.font = UIFont(name: "GillSans-Bold", size: 25)
        userfield.textColor = .white
        userfield.text = "Distance:"
        return userfield
    }()
    let goallistview: UIView = {
         let userfield = UIView()
         
         return userfield
     }()
    let backgroundsview: UIView = {
        let userfield = UIView()
        
        
        return userfield
    }()
    var backgrounds = ["celestial", "peach", "healthy", "scooter", "beach"]
    let safearea : UIView =
    { let view = UIView()
        
        return view
        
    }()
    @objc func showtermsandcons(sender: Any) {
           guard let url = URL(string: "https://fitwithfriends.flycricket.io/terms.html") else {
               return
           }
         
           let safariVC = SFSafariViewController(url: url)
           safariVC.delegate = self
           present(safariVC, animated: true, completion: nil)
           
          
       }
       @objc func showprivacypolicy(sender: Any) {
           guard let url = URL(string: "https://fitwithfriends.flycricket.io/privacy.html") else {
                      return
                  }
           let safariVC = SFSafariViewController(url: url)
           safariVC.delegate = self
                 present(safariVC, animated: true, completion: nil)
     
       }
    @objc func increasegoal(_ sender: AnyObject) {
        
        var goaltemp = 0
        let goaltext = goal.text!
        goaltemp = Int(goaltext) ?? 10000
        
        goaltemp = goaltemp + 1000
        
        
        if (goalswitcher.index == 0)
        {
            if (goaltemp >= 20000)
            {  goaltemp = 20000}
           defaults.set(goaltemp, forKey: "goal")
        }
        if (goalswitcher.index == 1)
        {
            if (goaltemp >= 150000)
            {  goaltemp = 150000}
           defaults.set(goaltemp, forKey: "weeklygoal")
        }
        if (goalswitcher.index == 2)
        {
            if (goaltemp >= 750000)
            {  goaltemp = 750000}
           defaults.set(goaltemp, forKey: "monthlygoal")
        }
        goal.text = String(goaltemp)
        
    }
    @objc func decreasegoal(_ sender: AnyObject) {
        
        var goaltemp = 0
        let goaltext = goal.text!
        goaltemp = Int(goaltext) ?? 10000
        goaltemp = goaltemp - 1000
       
        if (goaltemp <= 3000)
        {  goaltemp = 3000}
          if (goalswitcher.index == 0)
               {
                if (goaltemp <= 3000)
                {  goaltemp = 3000}
                  defaults.set(goaltemp, forKey: "goal")
               }
               if (goalswitcher.index == 1)
               {
                if (goaltemp <= 5000)
                   {  goaltemp = 5000}
                  defaults.set(goaltemp, forKey: "weeklygoal")
               }
               if (goalswitcher.index == 2)
               {
                if (goaltemp <= 7000)
                                  {  goaltemp = 7000}
                  defaults.set(goaltemp, forKey: "monthlygoal")
               }
        goal.text = String(goaltemp)
        
        
    }
    @objc func leftSwipeDismiss(gestureRecognizer:UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            self.dismiss(animated: true, completion: nil)
        case .changed:
            
            let translation = gestureRecognizer.translation(in: nil)
            let progress = translation.x / 2.0 / view.bounds.width
            Hero.shared.update(progress)
            Hero.shared.apply(modifiers: [.translate(x: translation.x)], to: self.view)
            break
        default:
            let translation = gestureRecognizer.translation(in: nil)
            let progress = translation.x / 2.0 / view.bounds.width
            if progress + gestureRecognizer.velocity(in: nil).x / view.bounds.width  > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }}
    @objc func miles(_ sender: AnyObject) {
        
        self.defaults.set("miles", forKey: "distancetype")
        self.defaults.set(0.000621371, forKey: "factor")
        self.kmbutton.backgroundColor = .clear
        self.milesbutton.backgroundColor = .black
        //  self.dismiss(animated: true, completion: nil)
        
    }
    @objc func signout(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure?", message: "After signing out, you would have to login again.", preferredStyle: UIAlertController.Style.alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
               alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
               alert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
                  tabBarController.selectedIndex = 0
                })
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    do {
                                  try
                                  Auth.auth().signOut()
                                 } catch let signOutError as NSError {
                                     print ("Error signing out: %@", signOutError)
                                 }
               }
               
               
                  
            
                                            
                                           
                
              
                
               
               })))
                alert.addAction((UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                      
                })))
               self.present(alert, animated: true, completion: nil)
        
        
       
    }
    
    @objc func setprofilepic(_ sender: AnyObject)
    {
        
        
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        cropController.title = "Choose Profile Pics"
        
        
        cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2000, height: 2000)
        
        
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        //cropController.toolbar.clampButtonHidden = true
        self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        //hgjhgjg
        var attributes = EKAttributes.topFloat
                                                     attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                                                     attributes.roundCorners = .all(radius: 25)
                                                      attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                                                      attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                                                      attributes.statusBar = .dark
                                                     attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                                                     attributes.entryInteraction = .absorbTouches
                                                       attributes.position = .center
                                                     
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
                                                                    self.defaults.set(1, forKey: "changepic")
                                                                let storage = Storage.storage()
                                                                      let storageRef = storage.reference()
                                                                      let user = Auth.auth().currentUser!
                                                                      let riversRef = storageRef.child("profilepics/"+user.uid)
                                                                      
                                                                      let data = image.pngData()!
                                                                      
                                                                      // Create a reference to the file you want to upload
                                                                      let metadata = StorageMetadata()
                                                                      metadata.contentType = "image/png"
                                                                      
                                                                      // Upload file and metadata to the object 'images/mountains.jpg'
                                                                      let uploadTask = riversRef.putData(data, metadata: metadata)
                                                                      
                                                                      // Listen for state changes, errors, and completion of the upload.
                                                                      uploadTask.observe(.resume) { snapshot in
                                                                          // Upload resumed, also fires when the upload starts
                                                                      }
                                                                      
                                                                      uploadTask.observe(.pause) { snapshot in
                                                                          // Upload paused
                                                                      }
                                                                      
                                                                      uploadTask.observe(.progress) { snapshot in
                                                                          // Upload reported progress
                                                                          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                                                              / Double(snapshot.progress!.totalUnitCount)
                                                                      }
                                                                      
                                                                      uploadTask.observe(.success) { snapshot in
                                                                          print("success")
                                                                      }
                                                                      
                                                                      uploadTask.observe(.failure) { snapshot in
                                                                          if let error = snapshot.error as? NSError {
                                                                              switch (StorageErrorCode(rawValue: error.code)!) {
                                                                              case .objectNotFound:
                                                                                  print("A")
                                                                                  break
                                                                              case .unauthorized:
                                                                                  print("A1")
                                                                                  break
                                                                              case .cancelled:
                                                                                  print("b")
                                                                                  break
                                                                                  
                                                                                  /* ... */
                                                                                  
                                                                              case .unknown:
                                                                                  print("Aada")
                                                                                  break
                                                                              default:
                                                                                  print("Aadada")
                                                                                  break
                                                                              }
                                                                          }
                                                                      }
                                                                      self.navigationItem.leftBarButtonItem?.isEnabled = true
                                                                      cropViewController.dismiss(animated: true, completion: nil)
                                                                    self.signoutbutton.isEnabled = false
                                                                  }}
                                                            let buttonsBarContent = EKProperty.ButtonBarContent(
                                                                with: okButton, closeButton,
                                                                separatorColor: EKColor(light: .gray, dark: .gray),
                                                                horizontalDistributionThreshold: 1,
                                                                displayMode: .dark,
                                                                expandAnimatedly: true
                                                            )
                                                     let title = EKProperty.LabelContent(text: "CONFIRMATION", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                                 
                          let description = EKProperty.LabelContent(text: ("You are only allowed to change your profile picture ONCE every month. Are you sure you want this to be your profile pic? Profile pictures may take a few minutes to update." ), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                               
                             
                                               
        let image1 = EKProperty.ImageContent(image: image, size: CGSize(width: 100, height: 100))
                                                            let simpleMessage = EKSimpleMessage(image: image1, title: title, description: description)
                                                         

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
    @objc func km(_ sender: AnyObject) {
        self.defaults.set("km", forKey: "distancetype")
        self.defaults.set(0.001, forKey: "factor")
        self.milesbutton.backgroundColor = .clear
        self.kmbutton.backgroundColor = .black
        //self.dismiss(animated: true, completion: nil)
        
        
    }
    @objc func none(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        self.defaults.set("none", forKey: "distancetype")
        self.defaults.set(0, forKey: "factor")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaults.integer(forKey: "changepic") != 0)
        {
            signoutbutton.isEnabled = false
        }
        usernamelabel.text = defaults.string(forKey: "username")
        if (defaults.integer(forKey: "selectedgoalindex") == 0)
        { goalswitcher.setIndex(0)
            goal.text = String(defaults.integer(forKey: "goal"))
            if (goal.text == "0")
            {goal.text = "10000"}
        }
        if (defaults.integer(forKey: "selectedgoalindex") == 1)
        {goal.text = String(defaults.integer(forKey: "weeklygoal"))
            goalswitcher.setIndex(1)
            if (goal.text == "0")
            {goal.text = "50000"}
        }
        if (defaults.integer(forKey: "selectedgoalindex") == 2)
        {goal.text = String(defaults.integer(forKey: "monthlygoal"))
             goalswitcher.setIndex(2)
            if (goal.text == "0")
            {goal.text = "200000"}
        }
        if (defaults.string(forKey: "distancetype") == "miles")
        {
            self.kmbutton.backgroundColor = .clear
            self.milesbutton.backgroundColor = .black
        }
        else
        {
            self.milesbutton.backgroundColor = .clear
            self.kmbutton.backgroundColor = .black
        }
        milesbutton.addTarget(self, action: #selector(self.miles(_:)), for: .touchUpInside)
         goalswitcher.addTarget(self, action: #selector(self.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        signoutbutton.addTarget(self, action: #selector(self.setprofilepic(_:)), for: .touchUpInside)
        signoutbutton2.addTarget(self, action: #selector(self.signout(_:)), for: .touchUpInside)
        kmbutton.addTarget(self, action: #selector(self.km(_:)), for: .touchUpInside)
        none.addTarget(self, action: #selector(self.none(_:)), for: .touchUpInside)
        self.panGR = UIPanGestureRecognizer(target: self,
                                            action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
        
        contentView.addGestureRecognizer(self.panGR)
        goalincrease.addTarget(self, action: #selector(increasegoal(_:)), for: .touchUpInside)
        goaldecrease.addTarget(self, action: #selector(decreasegoal(_:)), for: .touchUpInside)
        view.addsetgradientbackground(theme: defaults.string(forKey: "theme") ?? "healthy")
        view.configureLayout{ (layout) in
                   layout.isEnabled = true
                   // layout.justifyContent = .spaceBetween
                   
                   layout.width = YGValue(self.view.bounds.width)
                   layout.height = YGValue(self.view.bounds.height)
            layout.justifyContent = .center
               }
        contentView.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            
           
        }
        accountlabel.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            
            layout.marginLeft = 15
        }
        warninglabel.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            layout.alignSelf = .center
            
        }
        warninglabel2.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            layout.alignSelf = .center
            
        }
        whiteline4.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            layout.alignSelf = .center
            layout.width = YGValue(self.view.bounds.width-20)
            layout.height = 6
        }
        whiteline.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.alignSelf = .center
            layout.width = YGValue(self.view.bounds.width-20)
            
            layout.height = 6
        }
        whiteline2.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.alignSelf = .center
            layout.width = YGValue(self.view.bounds.width-20)
            
            layout.height = 6
        }
        whiteline3.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.alignSelf = .center
            layout.width = YGValue(self.view.bounds.width-20)
            
            layout.height = 6
        }
        logoview.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.width = 175
            layout.height = 85
            layout.marginTop = 30
            layout.alignSelf = .center
            
            
        }
        goallistview.configureLayout{ (layout) in
                  layout.isEnabled = true
                  
            layout.flexDirection = .row
             layout.width = YGValue(self.view.bounds.width)
            layout.justifyContent = .spaceBetween
                  
                  
              }
        backgroundslist.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.height = 80
            layout.width = YGValue(self.view.bounds.width)
            layout.margin = 15
            
        }
        profilepic.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.height = 50
            layout.width = 50
            
        }
        profileview.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.marginTop = 15
            
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
        }
        usernamelabel.configureLayout{ (layout) in
            layout.isEnabled = true
            
            
        }
        signoutbutton.configureLayout{ (layout) in
            layout.isEnabled = true
           
            layout.height = 40
           
            layout.alignSelf = .center
            // layout.width = 150
            
        }
        termsandconbutton.configureLayout{ (layout) in
                   layout.isEnabled = true
                   layout.width = YGValue(self.view.bounds.width-20)
                   layout.height = 30
            layout.margin = 7
                   layout.alignSelf = .center
                   // layout.width = 150
                   
               }
        privacypolicybutton.configureLayout{ (layout) in
                        layout.isEnabled = true
                        layout.width = YGValue(self.view.bounds.width-20)
                        layout.height = 30
            layout.margin = 7
                        layout.alignSelf = .center
                        // layout.width = 150
                        
                    }
        goalswitcher.configureLayout{ (layout) in
                   layout.isEnabled = true
           
                   layout.height = 40
                   layout.alignSelf = .center
                   layout.width = YGValue(self.view.bounds.width-20)
                   
               }
        signoutbutton2.configureLayout{ (layout) in
            layout.isEnabled = true
             layout.width = YGValue(self.view.bounds.width-20)
            layout.height = 30
            layout.margin = 7
            layout.alignSelf = .center
            // layout.width = 150
            
        }
        goalview.configureLayout{ (layout) in
            layout.isEnabled = true
            
            
            
            layout.width = YGValue(self.view.bounds.width)
            layout.alignSelf = .center
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
            
        }
        goaldecrease.configureLayout{ (layout) in
            layout.isEnabled = true
            
            
            
            
            
        }
        goalincrease.configureLayout{ (layout) in
            layout.isEnabled = true
            //layout.marginTop = 10
            
            
            
        }
        goal.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.width = 200
            
            
        }
        numberview.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.justifyContent = .spaceBetween
            layout.flexDirection = .row
            layout.marginTop = 10
            layout.width = YGValue(self.view.bounds.width)
            
        }
        
        numberlabel.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.marginLeft = 10
            
            layout.width = 140
            
            
            
        }
        backgroundsview.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            
            layout.width = YGValue(self.view.bounds.width)
            
        }
        backgroundlabel.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.view.bounds.width)
            layout.marginLeft = 10
            
            
            
            
            
            
        }
        distanceview.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.view.bounds.width)
            layout.justifyContent = .spaceBetween
            //  layout.marginTop = 85
            layout.flexDirection = .row
            layout.height = 100
            
            
        }
        distancelabel.configureLayout{ (layout) in
            layout.isEnabled = true
            //    layout.alignSelf = .center
            
            //    layout.width = 140
            layout.marginLeft = 10
        }
        
        milesbutton.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.alignSelf = .center
            layout.width = 170
            
        }
        
        kmbutton.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.alignSelf = .center
            
            layout.width = 170
            
            
        }
        none.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.alignSelf = .center
            layout.height = 40
            
            
        }
        buttonsview.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.flexDirection = .row
            layout.alignSelf = .center
            layout.marginTop = 10
        }
        none.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.alignSelf = .center
            layout.height = 40
            
            
        }
        //    distanceview.addSubview(distancelabel)
        buttonsview.addSubview(milesbutton)
        buttonsview.addSubview(kmbutton)
        //distanceview.addSubview(buttonsview)
        profileview.addSubview(profilepic)
        profileview.addSubview(usernamelabel)
        profileview.addSubview(signoutbutton)
        
        
        //  backgroundsview.addSubview(backgroundlabel)
        //  backgroundsview.addSubview(backgroundslist)
        // numberview.addSubview(numberlabel)
        goalview.addSubview(goaldecrease)
        goalview.addSubview(goal)
        goalview.addSubview(goalincrease)
        // numberview.addSubview(goalview)
        
        let height = CGFloat(80)
        let width = (self.view.frame.size.width/6)-10
        let cellSize = CGSize(width:width,height:height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 10
        self.backgroundslist.setCollectionViewLayout(layout, animated: true)
        
        self.backgroundslist.delegate = self
        self.backgroundslist.dataSource = self
        
                   if UIDevice().userInterfaceIdiom == .phone {
                                            switch UIScreen.main.nativeBounds.height {
                                            case 1136:
                                                print("iPhone 5 or 5S or 5C")
                                                 
                                            case 1334:
                                                print("iPhone 6/6S/7/8")
                                                
                                            case 1920, 2208:
                                                print("iPhone 6+/6S+/7+/8+")
                                                 contentView.addSubview(logoview)
                                            case 2436:
                                                print("iPhone X/XS/11 Pro")
                                                 contentView.addSubview(logoview)
                                            case 2688:
                                                print("iPhone XS Max/11 Pro Max")
                                                  contentView.addSubview(logoview)
                                            case 1792:
                                                print("iPhone XR/ 11 ")
                                                 contentView.addSubview(logoview)
                                                
                                            default:
                                                print("Unknown")
                                            }
                                        }
      //
        
        contentView.addSubview(numberlabel)
         contentView.addSubview(whiteline)
         contentView.addSubview(goalswitcher)
       
        contentView.addSubview(goalview)
        contentView.addSubview(backgroundlabel)
        contentView.addSubview(whiteline2)
        contentView.addSubview(backgroundslist)
        
        contentView.addSubview(distancelabel)
        contentView.addSubview(whiteline3)
        contentView.addSubview(buttonsview)
        contentView.addSubview(accountlabel)
        contentView.addSubview(whiteline4)
        contentView.addSubview(profileview)
      //  contentView.addSubview(warninglabel)
        contentView.addSubview(warninglabel2)
        contentView.addSubview(termsandconbutton)
        contentView.addSubview(privacypolicybutton)
        contentView.addSubview(signoutbutton2)
        self.view.addSubview(contentView)
        profileview.yoga.applyLayout(preservingOrigin: false)
        buttonsview.yoga.applyLayout(preservingOrigin: false)
        // distanceview.yoga.applyLayout(preservingOrigin: false)
        numberview.yoga.applyLayout(preservingOrigin: false)
        //backgroundsview.yoga.applyLayout(preservingOrigin: false)
        goalview.yoga.applyLayout(preservingOrigin: false)
       
        contentView.yoga.applyLayout(preservingOrigin: false)
         view.yoga.applyLayout(preservingOrigin: false)
        
        backgroundslist.reloadData()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
           if sender.index == 0 {
               goal.text = String(defaults.integer(forKey: "goal"))
          
            defaults.set(0, forKey: "selectedgoalindex")
               return
               
           }
        if sender.index == 1 {
            goal.text = String(defaults.integer(forKey: "weeklygoal"))
         defaults.set(1, forKey: "selectedgoalindex")
            if goal.text == "0"
                       {
                           goal.text = "50000"
                       }
            return
        }
        if sender.index == 2 {
            goal.text = String(defaults.integer(forKey: "monthlygoal"))
         defaults.set(2, forKey: "selectedgoalindex")
            if goal.text == "0"
                       {
                           goal.text = "200000"
                       }
            return
            
        }
       }
    
}
extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(backgrounds.count)
        return (backgrounds.count)}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "backgroundcell", for: indexPath) as! BackgroundCell
        let theme = defaults.value(forKey: "theme") ?? "healthy"
        if (backgrounds[indexPath[1]] == theme as! String)
        {cella.heroID = "contentview"}
        cella.image.image = UIImage(named: backgrounds[indexPath[1]])
        
        
        
        return cella
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(backgrounds[indexPath[1]], forKey: "theme")
        let cell = backgroundslist.cellForItem(at: indexPath) as! BackgroundCell
        cell.heroID = "contentview"
        defaults.set(true, forKey: "themechange0")
        defaults.set(true, forKey: "themechange1")
        defaults.set(true, forKey: "themechange2")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
class BackgroundCell: UICollectionViewCell {
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addviews() {
        contentview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.frame.size.width)
            layout.height = 300
            layout.justifyContent = .spaceBetween
            
        }
        image.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexGrow = 1
            
        }
        addSubview(contentview)
        contentview.addSubview(image)
        contentview.yoga.applyLayout(preservingOrigin: false)
    }
    
    var image = UIImageView()
    var contentview = UIView()
}

