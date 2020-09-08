//
//  FriendStatsViewController.swift
//  FitWithFriends
//
//  Created by Eric Lieu on 8/22/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import YogaKit
import Hero
import Popover
import MaterialComponents
import FirebaseStorage
import FirebaseAuth
import CoreMotion
import Hero
class ProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let contentView: UIScrollView = UIScrollView(frame: .zero)
    var panGR: UIPanGestureRecognizer!
    var uid = ""
    var frienddoc = ""
    var dailygoal = 0
    var stepsdaily = 0
     var factor = 0.000621371
    let pedometer = CMPedometer()
    let defaults = UserDefaults.standard
    var stepsweekly = 0
    var stepsmonthly = 0
    var distance1 = ""
    var distance2 = ""
    var distance3 = ""
       var distancetype = "miles"
    var weeklygoal = 0
    var monthlygoal = 0
    // Load shows from plist
    private var authListener: AuthStateDidChangeListenerHandle?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Calculate and set the content size for the scroll view
        var contentViewRect: CGRect = .zero
        for view in contentView.subviews {
            contentViewRect = contentViewRect.union(view.frame)
        }
        contentView.contentSize = contentViewRect.size
    }
    
    
   
    
    let whiteline: UIView = {
               let userfield = UIView()
               userfield.backgroundColor = .white
               userfield.layer.cornerRadius = 5
               return userfield
           }()
    let safearea: UIView = {
               let userfield = UIView()
               userfield.backgroundColor = .clear
             
               return userfield
           }()

    var profilepic : UIImageView = {
        let view = UIImageView()
        view.heroID = "profile"
        return view
    }()
    var topview : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var stepsview1 : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.tag = 1
       // view.layer.cornerRadius = 20
        return view
    }()
    var stepsview2 : UIView = {
           let view = UIView()
           view.backgroundColor = .clear
           //view.layer.cornerRadius = 20
        view.tag = 2
           return view
       }()
    var stepsview3 : UIView = {
           let view = UIView()
           view.backgroundColor = .clear
          // view.layer.cornerRadius = 20
        view.tag = 3
           return view
       }()
    var namelabel : UILabel = {
        let view = UILabel()
        view.heroID = "name1"
        view.font = UIFont(name: "GillSans-Bold", size: 30)
        view.textColor = .white
        return view
    }()
    var bottomlabel : UILabel = {
          let view = UILabel()
        view.text = "Congratulations!!!"
          view.font = UIFont(name: "GillSans-Light", size: 13)
          view.textColor = .lightGray
        view.textAlignment = .center
          return view
      }()
    var view2 : UIView = {
             let view = UIView()
           
             return view
         }()
    var totalstepslabel : UILabel = {
           let view = UILabel()
        view.text = "0"
        
           view.font = UIFont(name: "GillSans", size: 20)
           view.textColor = .white
        view.textAlignment = .center
           return view
       }()
    var logoview : UIImageView = {
          let view = UIImageView()
        view.image = UIImage(named: "whitelogo")
          return view
      }()
    var stepslabel1 : UILabel = {
           let view = UILabel()
        view.text = "Today: "
          view.textColor = .white
       
           view.font = UIFont(name: "GillSans-Light", size: 28)
        
           return view
       }()
    var stepscountlabel1 : UILabel = {
        let view = UILabel()
          view.textColor = .white
        view.font = UIFont(name: "GillSans-Light", size: 28)
       view.heroID = "steps1"
        view.textAlignment = .right
        return view
    }()
    var stepscountlabel2 : UILabel = {
           let view = UILabel()
           view.font = UIFont(name: "GillSans-Light", size: 28)
         view.textColor = .white
          view.textAlignment = .right
           return view
       }()
    var stepscountlabel3 : UILabel = {
           let view = UILabel()
           view.font = UIFont(name: "GillSans-Light", size: 28)
         view.textColor = .white
           view.textAlignment = .right
           return view
       }()
    var stepslabel2 : UILabel = {
           let view = UILabel()
        view.text = "This Week: "
 view.textColor = .white
           view.font = UIFont(name: "GillSans-Light", size: 28)
         
           return view
       }()
    var stepslabel3 : UILabel = {
              let view = UILabel()
         view.textColor = .white
        view.text = "This Month: "
              view.font = UIFont(name: "GillSans-Light", size: 28)
             
              return view
          }()
    var progressview1 : MDCProgressView = {
                let view = MDCProgressView()
        view.progress = 0.0
        view.setHidden(true, animated: true, completion: nil)
        view.tintColor = .black
                return view
            }()

   var progressview2 : MDCProgressView = {
           let view = MDCProgressView()
   view.progress = 0.0
   view.setHidden(true, animated: true, completion: nil)
   view.tintColor = .black
           return view
       }()
    var progressview3 : MDCProgressView = {
            let view = MDCProgressView()
    view.progress = 0.0
    view.setHidden(true, animated: true, completion: nil)
    view.tintColor = .black
            return view
        }()

   @objc func showprogress(_ sender: AnyObject)
         { let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let theCalendar     = Calendar.current
            let pastweek        = Date.today().previous(.sunday)
          let nextweek = Date.today().next(.saturday)
           
          let pastmonth        = Date().startOfMonth()
          let nextmonth = Date().endOfMonth()
          let df = DateFormatter()
          df.dateFormat = "MM/dd/yyyy"
         
         
         // Instantiate the desired view controller from the storyboard using the view controllers identifier
         // Cast is as the custom view controller type you created in order to access it's properties and methods
         let customViewController = storyboard.instantiateViewController(withIdentifier: "statsvc") as! StatsViewController
             customViewController.modalPresentationStyle = .overCurrentContext
             self.view.alpha = 0.6
         
         
            customViewController.vc3 = self
         
             present(customViewController, animated: true, completion: nil)
          customViewController.picimage.image = self.profilepic.image
         
          if (sender.view!.tag == 1){
              customViewController.goallabel.text =
                  "You have walked " + String(stepsdaily) + " steps today, " + String((progressview1.progress * 10000).rounded()/100) + "% of your daily " + String(dailygoal) + " goal!!"
              customViewController.datelabel.text = "That's " + String(distance1) + "! Congrats🥳!"
              
          }
        if (sender.view!.tag == 2){
                   customViewController.goallabel.text = "You have walked " + String(stepsweekly) + " steps so far this week, " + String((progressview2.progress * 10000).rounded()/100) + "% of their " + String(weeklygoal) + " your step goal!!"
        customViewController.datelabel.text = "That's " + String(distance2) + "! Congrats🥳!"
               }
          if (sender.view!.tag == 3){
              customViewController.goallabel.text = "You have walked "  + String(stepsmonthly) + " steps so far this month, " + String((progressview3.progress * 10000).rounded()/100) + "% of your " + String(monthlygoal) + " monthly step goal!!"
             customViewController.datelabel.text = "That's " + String(distance3) + "! Congrats🥳!"
          }

         }
    var morebutton : UIButton = {
        let view = UIButton()

        view.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        view.tintColor = .white
        
        return view
    }()
 @objc func leftSwipeDismiss(gestureRecognizer:UIPanGestureRecognizer) {
     let vc = SettingsViewController()
   
                vc.hero.isEnabled = true
      //   vc.backgroundslist.heroID = "contentview"
                self.hero.isEnabled = true
           vc.profilepic.image = self.profilepic.image
         vc.profilepic.tintColor = .white
         vc.modalPresentationStyle = .fullScreen
     
         vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
     switch gestureRecognizer.state {
     case .began:
        present(vc, animated: true, completion: nil)
     case .changed:
         
         let translation = gestureRecognizer.translation(in: nil)
         let progress = translation.x / -2.0 / view.bounds.width
         Hero.shared.update(progress)
         Hero.shared.apply(modifiers: [.translate(x: translation.x)], to: self.view)
         break
     default:
         let translation = gestureRecognizer.translation(in: nil)
         let progress = translation.x / -2.0 / view.bounds.width
         if progress + gestureRecognizer.velocity(in: nil).x / view.bounds.width  < -0.3 {
             Hero.shared.finish()
         } else {
             Hero.shared.cancel()
         }
     }}

    @objc func showoptions(_ sender: AnyObject)
    {

 let vc = SettingsViewController()
            vc.hero.isEnabled = true
  //   vc.backgroundslist.heroID = "contentview"
            self.hero.isEnabled = true
       vc.profilepic.image = self.profilepic.image
     vc.profilepic.tintColor = .white
     vc.modalPresentationStyle = .fullScreen
 
     vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
     present(vc, animated: true, completion: nil)
     }
  /*  @objc func showprogress(_ sender: AnyObject)
       { let storyboard = UIStoryboard(name: "Main", bundle: nil)

       // Instantiate the desired view controller from the storyboard using the view controllers identifier
       // Cast is as the custom view controller type you created in order to access it's properties and methods
       let customViewController = storyboard.instantiateViewController(withIdentifier: "statsvc") as! StatsViewController
           customViewController.modalPresentationStyle = .overCurrentContext
           self.contentView.alpha = 0.6
       
       
           customViewController.vc = self
     
           present(customViewController, animated: true, completion: nil)
         customViewController.progressview.progress = self.progressview1.progress
       }*/
    override func viewDidLoad() {
      /*  let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
                   
                                 self.stepsview1.addGestureRecognizer(singleTap)
        panGR = UIPanGestureRecognizer(target: self,
        action: #selector(leftSwipeDismiss(gestureRecognizer:)))
        super.viewDidLoad()
        backbutton.addTarget(self, action: #selector(goback(_:)), for: .touchUpInside)*/
        
       let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
               let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
               let singleTap3 = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
                         
                                       self.stepsview1.addGestureRecognizer(singleTap)
              self.stepsview2.addGestureRecognizer(singleTap2)
              self.stepsview3.addGestureRecognizer(singleTap3)
       
        panGR = UIPanGestureRecognizer(target: self, action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
        
        contentView.addGestureRecognizer(self.panGR)
        morebutton.addTarget(self, action: #selector(showoptions(_:)), for: .touchUpInside)
      //  contentView.addGestureRecognizer(panGR)
        namelabel.text = defaults.string(forKey: "username")
          let storage = Storage.storage()
         let storageRef = storage.reference()
        let reference = storageRef.child("profilepics/"+Auth.auth().currentUser!.uid)
                           self.profilepic.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
          super.viewDidLoad()
        contentView.heroID = "contentview"
        contentView.backgroundColor = .white
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(self.view.bounds.height)
            layout.width = YGValue(self.view.bounds.width)
           
            
        }
        namelabel.configureLayout { (layout) in
            layout.isEnabled = true
           // layout.marginBottom = 10
           layout.alignSelf = .center
            
        }
        totalstepslabel.configureLayout { (layout) in
                   layout.isEnabled = true
                   layout.marginBottom = 10
                  layout.alignSelf = .center
                   layout.width = 100
               }
        let factortemp = (defaults.value(forKey: "factor") ?? 0.000621371) as! Double
                     factor = factortemp
                     let typetemp = (defaults.value(forKey: "distancetype") ?? "miles") as! String
                     distancetype = typetemp
             
         let theCalendar     = Calendar.current
        let isoDate = "2020-08-14T10:44:00+0000"
              
               let dateFormatter = DateFormatter()
               dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
               let date = dateFormatter.date(from:isoDate)!
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: Date()), to: Date()) { (data, error) in
            let miles = String(((data?.distance?.doubleValue ?? 0) * self.factor * 100).rounded()/100) + " " + self.distancetype
                         self.distance1 = miles
                            let stepdata = data?.numberOfSteps ?? 0
            DispatchQueue.main.async { // Correct
                     self.stepscountlabel1.text = stepdata.stringValue + " steps"
                self.stepsdaily = stepdata.intValue
                 }
           
                            
                        }
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: Date().previous(.sunday)), to: Date()) { (data, error) in
            let miles = String(((data?.distance?.doubleValue ?? 0) * self.factor * 100).rounded()/100) + " " + self.distancetype
            self.distance2 = miles
              let stepdata = data?.numberOfSteps ?? 0
            DispatchQueue.main.async { // Correct
                self.stepscountlabel2.text = stepdata.stringValue + " steps"
                self.stepsweekly = stepdata.intValue
            }
             
         }
              
        
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: Date().startOfMonth()), to: Date()) { (data, error) in
            let miles = String(((data?.distance?.doubleValue ?? 0) * self.factor * 100).rounded()/100) + " " + self.distancetype
            self.distance3 = miles
            let stepdata = data?.numberOfSteps ?? 0
                        DispatchQueue.main.async { // Correct
                            self.stepscountlabel3.text = stepdata.stringValue + " steps"
                            self.stepsmonthly = stepdata.intValue
                        }
             
            
            }
         self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: date), to: Date()) { (data, error) in
                    let stepdata = data?.numberOfSteps ?? 0
                               DispatchQueue.main.async { // Correct
                                   self.totalstepslabel.text = stepdata.stringValue
                               
                                self.bottomlabel.text = "You have walked "
                                    + stepdata.stringValue + " steps since downloading this app."
                               }
                    
                   
                   }
         
        stepscountlabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
            layout.width = 175
           
            
        }
        stepscountlabel2.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
            layout.width = 175
            
        }
        stepscountlabel3.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
           layout.width = 175
            
        }
        profilepic.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 150
            layout.width = 150
          layout.alignSelf = .center
            
        }
   
        morebutton.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginRight = 20
         
          
            
        }
        bottomlabel.configureLayout { (layout) in
                   layout.isEnabled = true
            layout.height = 20
            layout.marginBottom = 20
                 
                   
               }
        logoview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
          layout.width = 200
            
            layout.alignSelf = .center
            
            if UIDevice().userInterfaceIdiom == .phone {
                                     switch UIScreen.main.nativeBounds.height {
                                     case 1136:
                                         print("iPhone 5 or 5S or 5C")
                                          layout.marginTop = 0
                                     case 1334:
                                         print("iPhone 6/6S/7/8")
                                         layout.marginTop = 0
                                     case 1920, 2208:
                                         print("iPhone 6+/6S+/7+/8+")
                                         layout.marginTop = 20
                                     case 2436:
                                         print("iPhone X/XS/11 Pro")
                                          layout.marginTop = 50
                                     case 2688:
                                         print("iPhone XS Max/11 Pro Max")
                                          layout.marginTop = 120
                                     case 1792:
                                         print("iPhone XR/ 11 ")
                                         layout.marginTop = 120
                                         
                                     default:
                                         print("Unknown")
                                     }
                                 }
          
            
        }
        stepsview1.configureLayout { (layout) in
            layout.isEnabled = true
           
         layout.width = YGValue(self.view.bounds.width-20)
            layout.height = 70
            layout.flexDirection = .row
            layout.flexWrap = .wrap
            layout.justifyContent = .spaceBetween
            layout.alignSelf = .center
            layout.marginBottom = 10
            layout.marginTop = 10
        }
        progressview1.configureLayout { (layout) in
                  layout.isEnabled = true
            layout.height = 3
            layout.marginLeft = 20
            layout.marginRight = 20
            layout.marginBottom = 7
            layout.width = YGValue(self.view.bounds.width-60)
            
              }
        progressview2.configureLayout { (layout) in
                         layout.isEnabled = true
                   layout.height = 3
                   layout.marginLeft = 20
                   layout.marginRight = 20
                   layout.marginBottom = 7
                   layout.width = YGValue(self.view.bounds.width-60)
                   
                     }
        progressview3.configureLayout { (layout) in
                         layout.isEnabled = true
                   layout.height = 3
                   layout.marginLeft = 20
                   layout.marginRight = 20
                   layout.marginBottom = 7
                   layout.width = YGValue(self.view.bounds.width-60)
                   
                     }
        stepsview2.configureLayout { (layout) in
                   layout.isEnabled = true
                  
               layout.width = YGValue(self.view.bounds.width-20)
                layout.height = 70
                layout.flexDirection = .row
                layout.flexWrap = .wrap
                layout.justifyContent = .spaceBetween
                layout.alignSelf = .center
                layout.marginBottom = 10
                layout.marginTop = 10
               }
        stepsview3.configureLayout { (layout) in
                          layout.isEnabled = true
                         
                    layout.width = YGValue(self.view.bounds.width-20)
                       layout.height = 70
                       layout.flexDirection = .row
                       layout.flexWrap = .wrap
                       layout.justifyContent = .spaceBetween
                       layout.alignSelf = .center
                       layout.marginBottom = 10
                       layout.marginTop = 10
                      }
        self.view.addSubview(contentView)
        topview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            
        }
        stepslabel1.configureLayout { (layout) in
            layout.isEnabled = true
           layout.marginLeft = 20
            layout.height = 60
          
            
        }
        stepslabel2.configureLayout { (layout) in
            layout.isEnabled = true
           layout.marginLeft = 20
            layout.height = 60
           
            
        }
        stepslabel3.configureLayout { (layout) in
            layout.isEnabled = true
           layout.marginLeft = 20
            layout.height = 60
            
            
        }
        safearea.configureLayout { (layout) in
                   layout.isEnabled = true
            layout.width = YGValue(self.view.bounds.width)
           
           if UIDevice().userInterfaceIdiom == .phone {
                          switch UIScreen.main.nativeBounds.height {
                          case 1136:
                              print("iPhone 5 or 5S or 5C")
                               layout.height = 0
                          case 1334:
                              print("iPhone 6/6S/7/8")
                               layout.height = 10
                          case 1920, 2208:
                              print("iPhone 6+/6S+/7+/8+")
                              layout.height = 10
                          case 2436:
                              print("iPhone X/XS/11 Pro")
                               layout.height = 32
                          case 2688:
                              print("iPhone XS Max/11 Pro Max")
                               layout.height = 32
                          case 1792:
                              print("iPhone XR/ 11 ")
                              layout.height = 32
                              
                          default:
                              print("Unknown")
                          }
                      }
                   
               }
        
        whiteline.configureLayout { (layout) in
                  layout.isEnabled = true
                  layout.alignSelf = .center
                             layout.width = YGValue(self.view.bounds.width-60)
                             layout.height = 6
            layout.marginTop = 10
            layout.marginBottom = 10
              
                  
              }
        
        view2.configureLayout { (layout) in
                         layout.isEnabled = true
                        
                                    layout.width = 10
                                    layout.height = 60
                  
                     
                         
                     }
               
        
      contentView.addSubview(safearea)
   
        topview.addSubview(view2)
       topview.addSubview(morebutton)
              
    contentView.addSubview(topview)
     
        contentView.addSubview(profilepic)
         contentView.addSubview(namelabel)
        contentView.addSubview(totalstepslabel)
         contentView.addSubview(whiteline)
        contentView.addSubview(stepsview1)
         stepsview1.addSubview(stepslabel1)
        stepsview1.addSubview(stepscountlabel1)
       
        stepsview1.addSubview(progressview1)
        contentView.addSubview(stepsview2)
         stepsview2.addSubview(stepslabel2)
        stepsview2.addSubview(stepscountlabel2)
       stepsview2.addSubview(progressview2)
        contentView.addSubview(stepsview3)
         stepsview3.addSubview(stepslabel3)
        stepsview3.addSubview(stepscountlabel3)
        stepsview3.addSubview(progressview3)
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

       
        contentView.addSubview(bottomlabel)
       // contentView.addSubview(whiteline)
       
      
       
        topview.yoga.applyLayout(preservingOrigin: true)
         contentView.yoga.applyLayout(preservingOrigin: true)
        let theme = self.defaults.string(forKey: "theme") ?? "healthy"
                                         self.contentView.addsetgradientbackground(theme: theme)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
      
                if (self.defaults.bool(forKey: "themechange2"))
           {  self.contentView.removeGradient()
            let theme = self.defaults.string(forKey: "theme") ?? "healthy"
                     
              
               self.contentView.addsetgradientbackground(theme: theme)
            self.defaults.set(false, forKey: "themechange2")
              
           }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.weeklygoal = self.defaults.integer(forKey: "weeklygoal")
            self.dailygoal = self.defaults.integer(forKey: "goal")
            self.monthlygoal = self.defaults.integer(forKey: "monthlygoal")
           
                    self.progressview1.setHidden(false, animated: true)
                    
                    self.progressview1.setProgress(
                        (Float(self.stepsdaily)/Float(self.dailygoal)), animated: true)
                    self.progressview2.setHidden(false, animated: true)
                               
                               self.progressview2.setProgress(
                                   (Float(self.stepsweekly)/Float(self.weeklygoal)), animated: true)
                    self.progressview3.setHidden(false, animated: true)
                               
                               self.progressview3.setProgress(
                                   (Float(self.stepsmonthly)/Float(self.monthlygoal)), animated: true)
                           }
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        }}

