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
class FriendStatsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let contentView: UIScrollView = UIScrollView(frame: .zero)
    var panGR: UIPanGestureRecognizer!
    var uid = ""
    var frienddoc = ""
    var dailygoal = 0
    var weeklygoal = 0
    var monthlygoal = 0
    var stepsdaily = 0
    var stepsweekly = 0
    var stepsmonthly = 0
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
        view.heroID = "profilepic"
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
       // view.layer.cornerRadius = 20
        view.tag = 1
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
        view.heroID = "name"
        view.font = UIFont(name: "GillSans-Bold", size: 30)
        view.textColor = .white
        return view
    }()
    var bottomlabel : UILabel = {
          let view = UILabel()
        view.text = "You and joe have been getting fit since 1932"
          view.font = UIFont(name: "GillSans-Light", size: 13)
          view.textColor = .lightGray
        view.textAlignment = .center
          return view
      }()
    var totalstepslabel : UILabel = {
           let view = UILabel()
         
        view.text = "236124"
           view.font = UIFont(name: "GillSans", size: 20)
           view.textColor = .white
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
        view.heroID = "steps"
        
        return view
    }()
    var stepscountlabel2 : UILabel = {
           let view = UILabel()
           view.font = UIFont(name: "GillSans-Light", size: 28)
         view.textColor = .white
           view.heroID = "steps"
           return view
       }()
    var stepscountlabel3 : UILabel = {
           let view = UILabel()
           view.font = UIFont(name: "GillSans-Light", size: 28)
         view.textColor = .white
           view.heroID = "steps"
           return view
       }()
    var stepslabel2 : UILabel = {
           let view = UILabel()
        view.text = "This Week: "
 view.textColor = .white
           view.font = UIFont(name: "GillSans-Light", size: 28)
           view.heroID = "steps"
           return view
       }()
    var stepslabel3 : UILabel = {
              let view = UILabel()
         view.textColor = .white
        view.text = "This Month: "
              view.font = UIFont(name: "GillSans-Light", size: 28)
              view.heroID = "steps"
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

    var backbutton : UIButton = {
        let view = UIButton()

        view.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        view.tintColor = .white
        view.heroID = "steps"
        return view
    }()
    var morebutton : UIButton = {
        let view = UIButton()

        view.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        view.tintColor = .white
        view.heroID = "steps"
        return view
    }()
   @objc func goback(_ sender: AnyObject)
   { dismiss(animated: true, completion: nil)
   }
    @objc func showoptions(_ sender: AnyObject)
    { let storyboard = UIStoryboard(name: "Main", bundle: nil)

    // Instantiate the desired view controller from the storyboard using the view controllers identifier
    // Cast is as the custom view controller type you created in order to access it's properties and methods
    let customViewController = storyboard.instantiateViewController(withIdentifier: "acceptvc") as! AcceptPopoverViewController
        customViewController.modalPresentationStyle = .overCurrentContext
        self.contentView.alpha = 0.6
   
        customViewController.vc = self
        if (defaults.string(forKey: "username") == self.namelabel.text)
        {
            customViewController.status = 3
        }
        present(customViewController, animated: true, completion: nil)
        customViewController.profilepic.image = self.profilepic.image
        customViewController.namelabel.text = " " + self.namelabel.text!
    }
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
           self.contentView.alpha = 0.6
       
       
           customViewController.vc = self
       
           present(customViewController, animated: true, completion: nil)
        customViewController.picimage.image = self.profilepic.image
        let name = namelabel.text
        if (sender.view!.tag == 1){
            customViewController.goallabel.text =
                name! + " has walked " + String(stepsdaily) + " steps today, " + String((progressview1.progress * 10000).rounded()/100) + "% of their daily " + String(dailygoal) + " goal!!"
             customViewController.datelabel.text = df.string(from: Date())
            
        }
      if (sender.view!.tag == 2){
                 customViewController.goallabel.text = name! + " has walked " + String(stepsweekly) + " steps so far this week, " + String((progressview2.progress * 10000).rounded()/100) + "% of their " + String(weeklygoal) + " weekly step goal!!"
        customViewController.datelabel.text = df.string(from: pastweek) + " - " + df.string(from: nextweek)
             }
        if (sender.view!.tag == 3){
            customViewController.goallabel.text = name! + " has walked "  + String(stepsmonthly) + " steps so far this month, " + String((progressview3.progress * 10000).rounded()/100) + "% of their " + String(monthlygoal) + " monthly step goal!!"
            customViewController.datelabel.text = df.string(from: pastmonth) + " - " + df.string(from: nextmonth)
        }

       }
    override func viewDidLoad() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
         let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
         let singleTap3 = UITapGestureRecognizer(target: self, action: #selector(self.showprogress(_:)))
                   
                                 self.stepsview1.addGestureRecognizer(singleTap)
        self.stepsview2.addGestureRecognizer(singleTap2)
        self.stepsview3.addGestureRecognizer(singleTap3)
        panGR = UIPanGestureRecognizer(target: self,
        action: #selector(leftSwipeDismiss(gestureRecognizer:)))
        super.viewDidLoad()
        backbutton.addTarget(self, action: #selector(goback(_:)), for: .touchUpInside)
        morebutton.addTarget(self, action: #selector(showoptions(_:)), for: .touchUpInside)
        contentView.addGestureRecognizer(panGR)
         
        contentView.heroID = "content"
        
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
                   
               }
        stepscountlabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
           
            
        }
        stepscountlabel2.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
           
            
        }
        stepscountlabel3.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.marginRight = 20
           
            
        }
        profilepic.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 150
            layout.width = 150
          layout.alignSelf = .center
            
        }
        backbutton.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 20
         
          
            
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
                                         layout.marginTop = 60
                                     case 2436:
                                         print("iPhone X/XS/11 Pro")
                                          layout.marginTop = 100
                                     case 2688:
                                         print("iPhone XS Max/11 Pro Max")
                                          layout.marginTop = 180
                                     case 1792:
                                         print("iPhone XR/ 11 ")
                                         layout.marginTop = 180
                                         
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
        
        
      contentView.addSubview(safearea)
         topview.addSubview(backbutton)
        
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
        contentView.addSubview(logoview)
        contentView.addSubview(bottomlabel)
       // contentView.addSubview(whiteline)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
       
        topview.yoga.applyLayout(preservingOrigin: true)
         contentView.yoga.applyLayout(preservingOrigin: true)
        let theme = self.defaults.string(forKey: "theme") ?? "healthy"
                                         self.contentView.addsetgradientbackground(theme: theme)
        // Do any additional setup after loading the view.
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
        if progress + gestureRecognizer.velocity(in: nil).x / view.bounds.width > 0.3 {
            Hero.shared.finish()
        } else {
            Hero.shared.cancel()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
