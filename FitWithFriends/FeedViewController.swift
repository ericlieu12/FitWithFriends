//
//  LoginViewController.swift
//  FitWithFriends
//
//  Created by user on 8/13/20.
//  Copyright © 2020 eric. All rights reserved.
//
//
//  SignupViewController.swift
//  FitWithFriends
//
//  Created by user on 8/13/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import YogaKit
import MaterialComponents
import Hero
import CoreMotion
import KDCircularProgress
import CoreData
import FirebaseStorage
import ViewAnimator
import Popover
import FSCalendar
import CropViewController
import SwiftEntryKit


class FeedViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var image: UIImage?
        private var croppingStyle = CropViewCroppingStyle.circular
        
        private var croppedRect = CGRect.zero
        private var croppedAngle = 0
    let defaults = UserDefaults.standard
    var panGR: UIPanGestureRecognizer!
    var factor = 0.000621371
    var distance = ""
    var distancetype = "miles"
    let contentView: UIScrollView = {
           let userfield = UIScrollView(frame: .zero)
           
          
           return userfield
       }()
    private var authListener: AuthStateDidChangeListenerHandle?
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    // Load shows from plist
    var goal = 10000
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
    let userfield: UIImageView = {
        let userfield = UIImageView()
        
       
        return userfield
    }()
    var timer = Timer()
    
    
    let morebutton: MDCButton = {
        
        let progress = MDCButton()
        progress.setTitle("More", for: .normal)
        
        return progress
    }()
    
    let stepcount: UILabel = {
        
        let progress = UILabel()
        progress.text = "0"
        
        progress.font = UIFont(name: "GillSans-Bold", size: 125)
        progress.textColor = .white
        progress.textAlignment = .center
        return progress
    }()
    let stepgoal: UILabel = {
        
        let progress = UILabel()
        progress.text = "10000"
        progress.heroID = "goal"
        progress.font = UIFont(name: "GillSans-Light", size: 30)
        progress.textColor = .white
        progress.textAlignment = .left
        return progress
    }()
    let stepgoallabel: UILabel = {
        //String(defaults.integer(forKey: "goal"))
        let progress = UILabel()
       progress.text = "      "
        progress.heroID = "goallabel"
        progress.font = UIFont(name: "GillSans-Light", size: 30)
        progress.textColor = .white
        progress.textAlignment = .right
       
        return progress
    }()
    let stepgoalview: UIView = {
        
        let progress = UIView()
       
        return progress
    }()
    
    let topbar: UIView = {
        let topbar = UIView()
        topbar.backgroundColor = .clear
        return topbar
    }()
    let stepsview: UIView = {
        let topbar = UIView()
        topbar.backgroundColor = .clear
        return topbar
    }()
    let calendarbutton: MDCButton = {
        let button = MDCButton()
        let image = UIImage(systemName: "calendar.circle",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light))
        button.setImage(image, for: .normal)
        button.setTitleFont(UIFont(name: "GillSans", size: 100), for: .normal)
     
        button.setImageTintColor(.white, for: .normal)
        button.setBackgroundColor(.clear)

        
        return button
        
    }()
    let viewchangerbutton: UIButton = {
         let button = MDCButton()
               let image = UIImage(systemName: "questionmark.circle",
               withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light))
               button.setImage(image, for: .normal)
               button.setTitleFont(UIFont(name: "GillSans", size: 100), for: .normal)
            
               button.setImageTintColor(.white, for: .normal)
               button.setBackgroundColor(.clear)
         
        return button
        
    }()
    var steps = 0
 
    let mileslbl: UILabel = {
           let view = UILabel()
        view.text = "0.0 miles"
        view.font = UIFont(name: "GillSans-Light", size: 30)
        view.textColor = .white
        view.textAlignment = .center
        view.heroID = "distance"
      
           return view
       }()
    let datelabel: UILabel = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let now = df.string(from: Date())
        
        let progress = UILabel()
        progress.text = now
        progress.textAlignment = .center
        progress.textColor = .white
        progress.font = UIFont(name: "Gill Sans", size: 35)
        return progress
    }()
    var progress:KDCircularProgress =  {
        let progress = KDCircularProgress()
                   progress.startAngle = -270
                   progress.progressThickness = 0.15
        progress.trackThickness = 0.17
        progress.trackColor = .white
                   progress.clockwise = true
                    
                  // progress.set(colors: .white)
                   progress.gradientRotateSpeed = 2
                   progress.roundedCorners = false
                   progress.glowMode = .forward
                   progress.glowAmount = 0.9
      
        return progress
    }()
    let popover = Popover(options: [
        .type(.down),
        .cornerRadius(25)
    ], showHandler: nil, dismissHandler: nil)
    /*@objc func leftSwipeDismiss(gestureRecognizer:UIPanGestureRecognizer) {
        let vc = SettingsViewController()
                           vc.hero.isEnabled = true
                           self.hero.isEnabled = true
        vc.profilepic.image = self.profilepic.image
       vc.profilepic.tintColor = .blue
                          
                           vc.modalPresentationStyle = .fullScreen
                           vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .right), dismissing: .slide(direction: .left))
            switch gestureRecognizer.state {
                   case .began:
                       present(vc, animated: true, completion: nil)
                   case .changed:
                       
                       let translation = gestureRecognizer.translation(in: nil)
                       let progress = translation.x / 2.0 / view.bounds.width
                       Hero.shared.update(progress)
                       Hero.shared.apply(modifiers: [.translate(x: translation.x)], to: self.view)
                       break
                   default:
                       let translation = gestureRecognizer.translation(in: nil)
                       let progress = translation.x / 2.0 / view.bounds.width
                       if progress + gestureRecognizer.velocity(in: nil).x / view.bounds.width > 0.3 {
                           Hero.shared.finish()
                       } else {
                           Hero.shared.cancel()
                       }
        }}*/
    @objc func showcalender(_ sender: AnyObject)
    {
        
        
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let date = df.date(from:datelabel.text!)!
        print(date)
        calendar.select(date)
        calendar.appearance.titleFont = UIFont(name: "Gill Sans",  size: 15)
        calendar.allowsMultipleSelection = false
        calendar.contentView.backgroundColor = .white
        calendar.appearance.weekdayFont = UIFont(name: "GillSans", size: 15)
        calendar.appearance.titleFont = UIFont(name: "GillSans", size: 15)
        let options = [
            .type(.down),
            .cornerRadius(25)
            ] as [PopoverOption]
        
        popover.show(calendar, fromView: self.calendarbutton)
        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let now = df.string(from: calendar.selectedDate!)
        self.datelabel.text = now
        self.reloadStepscontent(date: calendar.selectedDate!)
      
            
        self.popover.dismiss()
    }
    
   /* @objc func showbackground(_ sender: AnyObject)
    { let vc = SettingsViewController()
               vc.hero.isEnabled = true
     //   vc.backgroundslist.heroID = "contentview"
               self.hero.isEnabled = true
          vc.profilepic.image = self.profilepic.image
        vc.profilepic.tintColor = .white
        vc.modalPresentationStyle = .fullScreen
    
        vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .right), dismissing: .slide(direction: .left))
        present(vc, animated: true, completion: nil)
    }*/
    @objc func showprogress(_ sender: AnyObject)
    {
       let df = DateFormatter()
               df.dateFormat = "MM/dd/yyyy"
        let date = df.date(from: datelabel.text!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let customViewController = storyboard.instantiateViewController(withIdentifier: "statsvc") as! StatsViewController
                  customViewController.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
         self.view.alpha = 0.6
        }
        
              
              
        customViewController.vc2 = self
              
                  present(customViewController, animated: true, completion: nil)
        customViewController.picimage.image = self.profilepic.image
        let progress1 = Double(Double(self.steps)/Double(self.goal)) * 10000
        let progresspercent = progress1.rounded()/100
        if (progresspercent > 100 && (datelabel.text! == df.string(from: Date())))
        {
            customViewController.goallabel.text = "You have walked " + String(self.steps) + " steps today, which is " + String(progresspercent) + "% of your current daily goal! Congrats🥳!"
            customViewController.datelabel.text = "That's " + String(distance) + "👍!"
            return
        }
        if (datelabel.text! == df.string(from: Date()))
        {
            customViewController.goallabel.text = "You have walked " + String(self.steps) + " steps today, which is " + String(progresspercent) + "% of your current daily goal! Keep going!"
                   customViewController.datelabel.text = "That's " + String(distance) + "👍!"
        }
        else{
        customViewController.goallabel.text = "You have walked " + String(self.steps) + " steps on " + datelabel.text! + ", which is " + String(progresspercent) + "% of your current daily goal!"
            customViewController.datelabel.text = "That's " + String(distance) + "! Congrats🥳!"}
       
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
                                                                                    self.progress.isUserInteractionEnabled = false
                                                                                    self.profilepic.isUserInteractionEnabled = false
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
  
    let profilepic: UIImageView = {
           let view = UIImageView()
        view.image = UIImage(systemName: "person.circle.fill")
        view.tintColor = .white
        view.heroID = "profile"
           return view
       }()
    let emitterLayer : CAEmitterLayer = {
                         
                    let emitter = CAEmitterLayer()

      
                     let cell = CAEmitterCell()
                     cell.birthRate = 10
                     cell.lifetime = 2
                     cell.velocity = 100
                     cell.scale = 0.1
                         
        cell.emissionRange = -(CGFloat.pi * 1.0)
                     cell.contents = UIImage(named: "heart-icon")!.cgImage
                         
                     emitter.emitterCells = [cell]
        return emitter
    }()
                  let emitterLayer2 : CAEmitterLayer = {
                                         
                                    let emitter = CAEmitterLayer()

                      
                                     let cell = CAEmitterCell()
                                     cell.birthRate = 10
                                     cell.lifetime = 1
                                     cell.velocity = 100
                                     cell.scale = 0.1
                                         
                                     cell.emissionRange = -(CGFloat.pi * 0.5)
                                     cell.contents = UIImage(named: "heart-icon")!.cgImage
                                         
                                     emitter.emitterCells = [cell]
                        return emitter
                    }()
                              
    
    
    @objc func refresh(_ sender: AnyObject) {
        
        var divisor = steps/30
       if (divisor < 1)
       {divisor = 1}
        var stepstemp =  Int(stepcount.text!)
        stepcount.text = String(stepstemp! + divisor)
        if (stepstemp! >= (steps-divisor))
        {timer.invalidate()
            let animation = AnimationType.zoom(scale: 1.25)
            let animation2 = AnimationType.rotate(angle: 360)
            let animation3 = AnimationType.rotate(angle: -360)
            stepcount.text = String(steps)
            stepcount.animate(animations: [animation], duration: 0.5)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customViewController = storyboard.instantiateViewController(withIdentifier: "statsvc") as! StatsViewController
                       customViewController.modalPresentationStyle = .overCurrentContext
            
                   
                   
             customViewController.vc2 = self
                   let df = DateFormatter()
                   df.dateFormat = "MM/dd/yyyy"
            if (datelabel.text == df.string(from: Date()))
            { let progress1 = Double(Double(self.steps)/Double(self.goal)) * 10000
             let progresspercent = progress1.rounded()/100
             if (progresspercent > 100)
             {  DispatchQueue.main.asyncAfter(deadline: .now() + 0.27) {
                     self.view.alpha = 0.6
                    }
                    
                present(customViewController, animated: true, completion: nil)
                            customViewController.picimage.image = self.profilepic.image
                customViewController.goallabel.text = "You have achieved " + String(progresspercent) + "% of your goal of " + String(self.goal) + " steps. CONGRATULATIONS 🥳!"
                 customViewController.datelabel.text = "That's " + String(distance) + "!"
                 
             }
            }
           // stepcount.layer.addSublayer(emitterLayer)
            //emitterLayer.position = CGPoint(x: stepcount.frame.midX, y: stepcount.frame.minY)
            
         
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let factortemp = (defaults.value(forKey: "factor") ?? 0.000621371) as! Double
        factor = factortemp
        let typetemp = (defaults.value(forKey: "distancetype") ?? "miles") as! String
        distancetype = typetemp
        self.goal = defaults.integer(forKey: "goal")
        if (self.goal == 0)
        
        
        {
            self.goal = 10000
            defaults.set(10000, forKey: "goal")
        }
        stepgoal.text = " " + String(defaults.integer(forKey: "goal"))
      if (defaults.bool(forKey: "themechange1"))
        {  self.contentView.removeGradient()
          let theme = defaults.string(forKey: "theme") ?? "healthy"
                  self.progress.set(colors: UIColor(named: theme + "-1")!, UIColor(named: theme + "-2")!)
           
            self.contentView.addsetgradientbackground(theme: theme)
        defaults.set(false, forKey: "themechange1")
           
        }
        
        reloadStepscontent(date: Date())
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.progress.stopAnimation()
        self.timer.invalidate()
        self.stepcount.text = "0"
        
    }
    func reloadStepscontent(date : Date)
    {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: date)
       
      var miles = ""
            self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: date), to: nextDate!) { (data, error) in
                     let stepdata = data?.numberOfSteps
                miles = String(((data?.distance?.doubleValue ?? 0) * self.factor * 100).rounded()/100) + " " + self.distancetype
                self.distance = miles
               self.steps = Int(stepdata ?? 0)
                           DispatchQueue.main.async { // Correct
                                               self.stepcount.text = "0"
                                                      if (self.factor != 0)
                                                      {self.mileslbl.text = miles
                                                           self.mileslbl.isHidden = false
                                                          
                                                      }
                                                      else
                                                      {
                                                          self.mileslbl.isHidden = true
                                                      }
                                                  
                                                                               self.timer.invalidate()
                                                                                 self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
                                                         self.progress.progress = Double(self.steps)/Double(self.goal)
                                                      self.stepgoallabel.text = String(Int(self.progress.progress*100)) + "% of  "
                                                                                       self.progress.animate(fromAngle: 0, toAngle: self.progress.progress*360, duration: 3) { completed in
                                                                                                                                                       if completed {
                                                                                                                                                           
                                                                                                                                                       } else {
                                                                                                                                                           
                                                                                                                                                       }}
                                                       }
                                            
                                           }
                     
       
                  
                                        
         
    
    }
  
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
           
            if let user = user {
               
            //  self.panGR = UIPanGestureRecognizer(target: self,
                                                          //      action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
              
                //self.contentView.addGestureRecognizer(self.panGR)
                self.contentView.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.height = YGValue(self.view.bounds.height)
                    layout.width = YGValue(self.view.bounds.width)
                   layout.justifyContent = .spaceBetween
                    
                }
              
                self.stepsview.configureLayout { (layout) in
                    layout.isEnabled = true
                  //  layout.height = 200
                    layout.justifyContent = .center
                    
                }
                self.mileslbl.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                    layout.justifyContent = .center
                    
                }
                self.stepgoal.configureLayout { (layout) in
                    layout.isEnabled = true
                   
                       layout.width = 100
                    
                }
                self.stepgoalview.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                    layout.flexDirection = .row
                    layout.justifyContent = .center
                    
                    
                }

                self.stepgoallabel.configureLayout { (layout) in
                                  layout.isEnabled = true
                    layout.width = 100
                                 
                                  
                                  
                              }
               
                  self.calendarbutton.addTarget(self, action: #selector(self.showcalender(_:)), for: .touchUpInside)
                self.viewchangerbutton.addTarget(self, action: #selector(self.showprogress(_:)), for: .touchUpInside)
                 
                if (self.defaults.integer(forKey: "changepic") == 0)
                {
                    self.progress.isUserInteractionEnabled = true
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.setprofilepic(_:)))
                                
                                   self.progress.addGestureRecognizer(singleTap)
                                  
                }
               
                               let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
                                                                             self.stepcount.isUserInteractionEnabled = true
                                                  self.stepcount.addGestureRecognizer(singleTap2)
              let useruid = Auth.auth().currentUser!.uid
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let reference = storageRef.child("profilepics/"+useruid)
                    self.profilepic.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
                    
                
              
               
                self.topbar.configureLayout { (layout) in
                    layout.isEnabled = true
                    //layout.height = 120
                    layout.width = YGValue(self.view.bounds.width)
                   
                    layout.justifyContent = .spaceBetween
                    layout.flexDirection = .row
                   // layout.marginTop = 20
                   // layout.marginBottom = 20
                                if UIDevice().userInterfaceIdiom == .phone {
                                                         switch UIScreen.main.nativeBounds.height {
                                                         case 1136:
                                                             print("iPhone 5 or 5S or 5C")
                                                              layout.marginTop = 20
                                                         case 1334:
                                                             print("iPhone 6/6S/7/8")
                                                             layout.marginTop = 0
                                                         case 1920, 2208:
                                                             print("iPhone 6+/6S+/7+/8+")
                                                            layout.marginTop = 20
                                                         case 2436:
                                                             print("iPhone X/XS/11 Pro")
                                                            layout.marginTop = 20
                                                         case 2688:
                                                             print("iPhone XS Max/11 Pro Max")
                                                             layout.marginTop = 20
                                                         case 1792:
                                                             print("iPhone XR/ 11 ")
                                                             layout.marginTop = 20
                                                             
                                                         default:
                                                             print("Unknown")
                                                         }
                                                     }

                }
                
                self.viewchangerbutton.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                    layout.width = 100
                    layout.margin = 0
                    
                }
                
                
                self.stepcount.configureLayout { (layout) in
                    layout.isEnabled = true
                   
                    layout.width = YGValue(self.view.bounds.width)
                    layout.margin = 0
                    layout.alignSelf = .center
                    
                }
                
                self.datelabel.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                    
                    
                    
                    layout.alignSelf = .center
                    
                }
                self.calendarbutton.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                    layout.width = 100
                    
                    
                    
                    
                }
                self.profilepic.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.height = 300
                    layout.width = 300
                    layout.margin = 0
                    layout.alignSelf = .center
                    
                }
                let secondcontentvierw = UIView()
                secondcontentvierw.configureLayout {
                    (layout) in
                                   layout.isEnabled = true
                    layout.justifyContent = .spaceAround
                    layout.flexGrow = 1
                               }
                
                
                //   self.contentView.addSubview(self.progress)
               
                
                self.topbar.addSubview(self.viewchangerbutton)
                self.topbar.addSubview(self.datelabel)
                self.topbar.addSubview(self.calendarbutton)
                
                self.contentView.addSubview(self.topbar)
                
               
                self.stepsview.addSubview(self.stepcount)
                self.stepgoalview.addSubview(self.stepgoallabel)
                self.stepgoalview.addSubview(self.stepgoal)
                // self.stepsview.addSubview(self.stepgoalview)
                // self.stepsview.addSubview(self.mileslbl)
                secondcontentvierw.addSubview(self.profilepic)
                secondcontentvierw.addSubview(self.stepsview)
                
                self.stepgoalview.yoga.applyLayout(preservingOrigin: false)
                self.stepsview.yoga.applyLayout(preservingOrigin: false)
                
                self.topbar.yoga.applyLayout(preservingOrigin: false)
                 secondcontentvierw.yoga.applyLayout(preservingOrigin: false)
                self.contentView.addSubview(secondcontentvierw)
                self.contentView.yoga.applyLayout(preservingOrigin: false)
                self.view.addSubview(self.contentView)
               
              if UIDevice().userInterfaceIdiom == .phone {
                  switch UIScreen.main.nativeBounds.height {
                  case 1136:
                      print("iPhone 5 or 5S or 5C")
                       self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+90, width: 380, height: 380)
                  case 1334:
                      print("iPhone 6/6S/7/8")
                     self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+90, width: 380, height: 380)
                  case 1920, 2208:
                      print("iPhone 6+/6S+/7+/8+")
                      self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+110, width: 380, height: 380)
                  case 2436:
                      print("iPhone X/XS/11 Pro")
                       self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+110, width: 380, height: 380)
                  case 2688:
                      print("iPhone XS Max/11 Pro Max")
                       self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+110, width: 380, height: 380)
                  case 1792:
                      print("iPhone XR/ 11 ")
                     self.progress.frame = CGRect(x: self.profilepic.frame.minX-40, y: self.profilepic.frame.minY+110, width: 380, height: 380)
                      
                  default:
                      print("Unknown")
                  }
              }
               
                self.view.addSubview(self.progress)
                let theme = (self.defaults.value(forKey: "theme") ?? "healthy") as! String
                self.contentView.addsetgradientbackground(theme: theme)
                self.progress.set(colors: UIColor(named: theme + "-1")!, UIColor(named: theme + "-2")!)
          
                
            }
            else {
                
            }
            
            
            //flexbox initial
        }}
    /*
     import UIKit
     import FirebaseAuth
     class LoginViewController: UIViewController {
     @IBOutlet weak var emailtxtfield: UITextField!
     @IBOutlet weak var passwordtxtfield: UITextField!
     @IBOutlet weak var errorlbl: UILabel!
     override func viewDidLoad() {
     super.viewDidLoad()
     self.hideKeyboardWhenTappedAround()
     }
     
     @IBAction func signuptapped(_ sender: Any) {
     let signvc = SignupViewController(nibName: nil, bundle: nil)
     
     
     signvc.modalTransitionStyle = .flipHorizontal
     signvc.modalPresentationStyle = .fullScreen
     
     
     
     self.present(signvc, animated: true, completion: nil)
     
     }
     
     
     
     
     
     
     @IBAction func logintapped(_ sender: Any) {
     let email = emailtxtfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     let password = passwordtxtfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
     if error != nil
     {
     self.errorlbl.text = error!.localizedDescription
     }
     else {
     self.dismiss(animated:true, completion: nil)
     }
     }
     
     }
     
     }
     extension UIViewController {
     func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
     tap.cancelsTouchesInView = false
     view.addGestureRecognizer(tap)
     }
     
     @objc func dismissKeyboard() {
     view.endEditing(true)
     }
     }*/
}

