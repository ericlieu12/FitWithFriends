//
//  FriendsViewController.swift
//  FitWithFriends
//
//  Created by user on 8/14/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseUI
import YogaKit
import MaterialComponents
import Hero
import CoreData
import ViewAnimator
import CoreMotion
import SwiftEntryKit
class FriendsViewController: UIViewController {
    let defaults = UserDefaults.standard
  let pedometer = CMPedometer()
    //iglistkit setup
    let friendslist: UICollectionView = {
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        view.register(CustomCell.self, forCellWithReuseIdentifier: "friendscell")
        view.register(CustomCell2.self, forCellWithReuseIdentifier: "addfriendcell")
        
        view.backgroundColor = .clear
        return view
    }()
    let leaderboardimage : UIImageView = {
                    let image = UIImageView()
                    image.image = UIImage(named: "friendslogo")
                    return image
                }()
    let timedescription = UILabel()
    var change = false
    
    
    var username = String()
    @IBOutlet weak var backgroundGradient: UIView!
    var friends = [Friend]()
    var users = [User]()
    let profilepictemp = UIImageView()
    private var authListener: AuthStateDidChangeListenerHandle?
     var panGR: UIPanGestureRecognizer!
    var ranfirstload = false
    
    @objc func leftSwipeDismiss(gestureRecognizer:UIPanGestureRecognizer) {
        
    
          let vc = AddFriendViewController()
                        vc.hero.isEnabled = true
                        self.hero.isEnabled = true
            vc.suggestions = friends
        vc.username = self.username
        vc.signuplabel.text = "Friends List"
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
                  }
     // lastly, present the view controller like normal
               
    }
    let conview : UIView = {
                       let view = UIView()
                       return view
                   }()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
   
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                
              
                self.username = self.defaults.string(forKey: "username") ?? "problems"
                print(self.username)
               
               
            
               
                /*gradient
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.view.bounds
                gradientLayer.colors = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1).cgColor]
                
                gradientLayer.shouldRasterize = true
                let conview = UIView()
                //   self.backgroundGradient.layer.insertSublayer(gradientLayer, at: 0)*/
               
                
                self.panGR = UIPanGestureRecognizer(target: self,
             action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))

                self.conview.addGestureRecognizer(self.panGR)
                self.conview.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.height = YGValue(self.view.bounds.height)
                    layout.width = YGValue(self.view.bounds.width)
                }
                
                let safearea : UIView =
                { let view = UIView()
                    view.backgroundColor = .clear
                    return view
                    
                }()
                safearea.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.height = YGValue(self.view.safeAreaLayoutGuide.layoutFrame.minY)
                    
                    
                }
               
                let navbar : UIView = {
                    let view = UIView()
                    view.backgroundColor = .clear
                    return view
                    }()
                
                
                navbar.configureLayout { (layout) in
                    layout.isEnabled = true
                    
                  if UIDevice().userInterfaceIdiom == .phone {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        print("iPhone 5 or 5S or 5C")
         layout.marginTop = 50
    case 1334:
        print("iPhone 6/6S/7/8")
        layout.height = 225
    case 1920, 2208:
        print("iPhone 6+/6S+/7+/8+")
       layout.height = 225
    case 2436:
        print("iPhone X/XS/11 Pro")
       layout.height = 255
    case 2688:
        print("iPhone XS Max/11 Pro Max")
        layout.height = 255
    case 1792:
        print("iPhone XR/ 11 ")
        layout.height = 255
        
    default:
        print("Unknown")
    }
}
                   
                    layout.width = YGValue(self.view.frame.width)
                    
                }
                
      
            
               
            
               
                self.leaderboardimage.configureLayout { (layout) in
                    layout.isEnabled = true
                   if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                        case 1136:
                            print("iPhone 5 or 5S or 5C")
                             layout.marginTop = 50
                        case 1334:
                            print("iPhone 6/6S/7/8")
                            layout.marginTop = 20
                        case 1920, 2208:
                            print("iPhone 6+/6S+/7+/8+")
                           layout.marginTop = 20
                        case 2436:
                            print("iPhone X/XS/11 Pro")
                            layout.marginTop = 50
                        case 2688:
                            print("iPhone XS Max/11 Pro Max")
                            layout.marginTop = 50
                        case 1792:
                            print("iPhone XR/ 11 ")
                            layout.marginTop = 50
                            
                        default:
                            print("Unknown")
                        }
                    }
                    
                    layout.height = 200
                    layout.alignSelf = .center
                    layout.width = 200
                   
                    
                }
                navbar.addSubview(self.leaderboardimage)
                
              
                self.friendslist.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.flexGrow = 1
                }
             
                let height = CGFloat(60)
                let width = self.view.frame.size.width-10
                let cellSize = CGSize(width:width,height:height)
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.itemSize = cellSize
                layout.minimumLineSpacing = 10
                self.friendslist.setCollectionViewLayout(layout, animated: true)
                
                self.friendslist.delegate = self
                self.friendslist.dataSource = self
                
               self.conview.addSubview(navbar)
               
                
               
                 self.conview.addSubview(self.friendslist)
                
                self.view.addSubview(self.conview)
                
                
                
              
                //layout
              //  print("uid" + Auth.auth().currentUser!.uid)
                 //database shit
                
                   
               
               navbar.yoga.applyLayout(preservingOrigin: true)
               self.conview.yoga.applyLayout(preservingOrigin: true)
                self.conview.removeGradient()
                                let theme = self.defaults.string(forKey: "theme") ?? "healthy"
                                  self.conview.addsetgradientbackground(theme: theme)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.change = false
                                                                          self.users.sort(by: { $0.steps > $1.steps })
                                                                          self.friendslist.reloadData()
                                                       
                                                                          }

            } else {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = LoginViewController()
                appDelegate.window?.makeKeyAndVisible()
                appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
                
                
            }
        }
        
        
        
        //adadada
        
    }
    private var listener : ListenerRegistration? = nil
    override func viewDidAppear(_ animated: Bool) {
        if (self.defaults.integer(forKey: "firstlaunch") == 0)
        {
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
                                               
                                                  text: "OK",
                                                  style: okButtonLabelStyle
                                              )
                                              let okButton = EKProperty.ButtonContent(
                                                  label: okButtonLabel,
                                                  backgroundColor: EKColor(.clear),
                                                  highlightedBackgroundColor: pinkyColor.with(alpha: 0.05),
                                                  displayMode: .dark) {
                                                   SwiftEntryKit.dismiss{
                                                      
                                                  
                                                    }}
                                              let buttonsBarContent = EKProperty.ButtonBarContent(
                                                  with: okButton,
                                                  separatorColor: EKColor(light: .gray, dark: .gray),
                                                  horizontalDistributionThreshold: 1,
                                                  displayMode: .dark,
                                                  expandAnimatedly: true
                                              )
                                       let title = EKProperty.LabelContent(text: "WELCOME", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                                   
            let description = EKProperty.LabelContent(text: ("Welcome " + self.username + " to FitwithFriends. Remember to change your profile pic by going to 'Me' and clicking 'CHANGE PROFILE PICTURE'!" ), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                                 
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                 
            let image = EKProperty.ImageContent(image: UIImage(named:"blacklogo")!, size: CGSize(width: 300, height: 100))
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
                self.defaults.set(1, forKey: "firstlaunch")
            }
                                   
        }
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
        
        let db = Firestore.firestore()
                 
                                     listener =  db.collection("friendpairs").whereField("users", arrayContains:Auth.auth().currentUser!.uid).addSnapshotListener { //1
                                  querySnapshot, error in
                                   if let error = error {
print("Error getting documents: \(error)")
                                   } else { //2
                                    
                                    self.users.removeAll()
                                    self.friends.removeAll()
                                    self.change = true
                                    

for document in querySnapshot!.documents {//3
   
    let result = Result {
        
        try document.data(as: Friend.self)
       
    }
  
    switch result {//4
    case .success(let city):
        if let city = city {//5
         if (!city.isBlocked)
         {
          
           
               
                self.friends.append(city)
               
               if (city.isFriends)
               {if (self.username == city.initialname)//7
               {//8
                 
                   db.collection("users").document(city.requesting).addSnapshotListener { //9
                       querySnapshot, error in
    if let error = error {
        print("Error getting documents: \(error)")
    } else {//10
     
     
            let result = Result {
                
                try querySnapshot!.data(as: User.self)
        }
       
            switch result {//11
            case .success(let user):
                if let user = user { //12
              
              
                           if let userindex = self.users.firstIndex(where: { $0.id == user.id })
                           {
                
                  self.change = true
                              self.users[userindex] = user
                              }
                              else
                           {
                          
                              self.change = true
                              self.users.append(user)
                              }
                         //11
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            } //10
        }//9
        
    }//8
    
    
                                   
                                   
                                   
                   //7
               
            
          //7
               }
               else {
                db.collection("users").document(city.initial).addSnapshotListener { //9
                                   querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {//10
                 
                 
                        let result = Result {
                            
                            try querySnapshot!.data(as: User.self)
                    }
                   
                        switch result {//11
                        case .success(let user):
                            if let user = user { //12
                          
                          
                                       if let userindex = self.users.firstIndex(where: { $0.id == user.id })
                                       {
                            
                              self.change = true
                                          self.users[userindex] = user
                                          }
                                          else
                                       {
                                      
                                          self.change = true
                                          self.users.append(user)
                                          }
                                     //11
                            } else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            // A `City` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding city: \(error)")
                        } //10
                    }//9
                    
                }//8
                
                
                                               
                                               
                                               
                }          //7
                           
                        
                
                }
           }//5
           
        }//4
            
        else {
            // A nil value was successfully initialized from the DocumentSnapshot,
            // or the DocumentSnapshot was nil.
            print("Document does not exist")
        }
       
    case .failure(let error):
        // A `City` value could not be initialized from the DocumentSnapshot.
        print("Error decoding city: \(error)")
    }//3
   
}//2
                               
                                   
 
                                   }//1
                                   
                                   
                          
                           
                           
                      }//0
                   
       self.timer.fire()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                           self.change = false
                                                                                 self.users.sort(by: { $0.steps > $1.steps })
         
                                                                                 self.friendslist.reloadData()
                                                              
                                                                                 }
        if (defaults.bool(forKey: "themechange0"))
        {  self.conview.removeGradient()
          let theme = defaults.string(forKey: "theme") ?? "healthy"
            self.conview.addsetgradientbackground(theme: theme)
        defaults.set(false, forKey: "themechange0")}
          
      }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
        listener?.remove()
       
    }
      
    func saveprofilepic(uid: String, data: Data)
    {
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         let entity =
              NSEntityDescription.entity(forEntityName: "Person",
  in: context)
        let person = NSManagedObject(entity: entity!,
                                      insertInto: context)
         
         // 3
         person.setValue(uid, forKeyPath: "uid")
      
    
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("profilepics/"+uid)
        reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            person.setValue(data, forKey: "image")
            
          }
        }
  
            do {
            try context.save()
            print("Image is saved")
            } catch {
            print(error.localizedDescription)
                  }
        }
    
 func DeleteAllData(){


      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let managedContext = appDelegate.persistentContainer.viewContext
      let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Person"))
      do {
          try managedContext.execute(DelAllReqVar)
      }
      catch {
          print(error)
      }
  }
    @objc func refresh(_ sender: AnyObject) {
 
         
               let theCalendar     = Calendar.current
        let pastweek        = Date.today().previous(.sunday)
        let components = theCalendar.dateComponents([.year, .month], from: Date())
        let pastmonth        = theCalendar.date(from: components)
       
               var goal = self.defaults.integer(forKey: "goal")
                      if (goal == 0)
                      {
                          goal = 10000
                        defaults.set(10000, forKey: "goal")
                      }
        var weeklygoal = self.defaults.integer(forKey: "weeklygoal")
        if (weeklygoal == 0)
        {
            weeklygoal = 50000
            defaults.set(50000, forKey: "weeklygoal")
        }
        var monthlygoal = self.defaults.integer(forKey: "monthlygoal")
               if (monthlygoal == 0)
               {
                   monthlygoal = 200000
                defaults.set(200000, forKey: "monthlygoal")
               }
         let db = Firestore.firestore()
        
           var steps = 0
        var weeklysteps = 0
        var monthlysteps = 0
        let isoDate = "2020-08-14T10:44:00+0000"
        var totalsteps = 0
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: pastweek), to: Date()) { (data, error) in
            weeklysteps = (data?.numberOfSteps.intValue ?? 0)
        }
             
       
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: Date()), to: Date()) { (data, error) in
            
            steps = (data?.numberOfSteps.intValue ?? 0)
            
           
           }
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: date), to: Date()) { (data, error) in
                   totalsteps = (data?.numberOfSteps.intValue ?? 0)
                   
                  
                  }
        self.pedometer.queryPedometerData(from: theCalendar.startOfDay(for: pastmonth!), to: Date()) { (data, error) in
            monthlysteps = (data?.numberOfSteps.intValue ?? 0)
         
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["steps" : steps, "dailygoal" : goal, "weeklygoal" : weeklygoal, "monthlygoal" : monthlygoal, "monthlysteps" : monthlysteps, "weeklysteps" : weeklysteps, "totalsteps" : totalsteps])
        }
         
       self.ranfirstload = true
        if (self.change)
        { print("refresh")
            users.sort(by: { $0.steps > $1.steps })
        friendslist.reloadData()
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
     //   let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        friendslist.performBatchUpdates({
          UIView.animate(views: friendslist.visibleCells,
                                animations: [zoomAnimation],
                                duration: 0.1)})
             self.change = false
        }
        else {
        }
        
        
    }
    @objc func launchsettings(){
        
        
        let signvc = self.storyboard?.instantiateViewController(identifier: "addvc") as? AddFriendViewController
        signvc!.hero.isEnabled = true
        self.view.alpha = 0.5
        
        signvc?.modalPresentationStyle = .overCurrentContext
        
        signvc!.heroModalAnimationType = .push(direction: .left)
        
        
        // lastly, present the view controller like normal
        present(signvc!, animated: true, completion: nil)
        
    }
}
    
    
    
  
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension FriendsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return (users.count+1)}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (users.count == indexPath[1])
        {         let cellb = collectionView.dequeueReusableCell(withReuseIdentifier: "addfriendcell", for: indexPath) as! CustomCell2

            return cellb
        }

        let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "friendscell", for: indexPath) as! CustomCell
         cella.image.heroID = "."
               cella.name.heroID = "."
               cella.stepscount.heroID = "."
               cella.contentview.heroID = "."
        cella.users.removeAll()
        cella.users.append(users[indexPath[1]])
      
             let storage = Storage.storage()
            let storageRef = storage.reference()
                let reference = storageRef.child("profilepics/"+users[indexPath[1]].id!)
           cella.image.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder"))
              // saveprofilepic(uid: users[indexPath[1]].id!, data: (cella.image.image?.pngData())!)}
        
           let userobject = users[indexPath[1]]
            cella.rank.text = String(indexPath[1]+1)
            cella.name.text = userobject.username
        
            cella.stepscount.text = String(userobject.steps)
            
            cella.image.isHidden = false
         
           
            
            
            return cella
        
            
            
     
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        if (indexPath[1] == users.count)
        {
            let vc = AddFriendViewController()
                            vc.hero.isEnabled = true
                            self.hero.isEnabled = true
                vc.suggestions = friends
          
            vc.username = self.username
                            vc.modalPresentationStyle = .fullScreen
               vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .right), dismissing: .slide(direction: .left))
              vc.signuplabel.text = "Friends List"
             present(vc, animated: true, completion: nil)
        }
        else{
            let vc = FriendStatsViewController()
                  vc.hero.isEnabled = true
                  
        let cell = friendslist.cellForItem(at: indexPath) as! CustomCell
           
            cell.isHeroEnabled = true
        cell.image.heroID = "profilepic"
        cell.name.heroID = "name"
        cell.stepscount.heroID = "stepscount"
        cell.contentview.heroID = "content"
            cell.alpha = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                cell.alpha = 1.0
            }
            let user = cell.users[0]
             print(user)
            vc.uid = user.id!
            vc.bottomlabel.text = user.username + " has walked " +
            String(user.totalsteps) + " steps since downloading this app."
        vc.profilepic.image = cell.image.image
        vc.namelabel.text = user.username
            vc.dailygoal = user.dailygoal
            vc.weeklygoal = user.weeklygoal
            vc.monthlygoal = user.monthlygoal
            vc.stepsweekly = user.weeklysteps
            vc.stepsmonthly = user.monthlysteps
            vc.totalstepslabel.text = String(user.totalsteps)
            vc.stepsdaily = Int(cell.stepscount.text ?? "0") ?? 0
            vc.stepscountlabel1.text = (cell.stepscount.text ?? "0") + " steps"
            vc.stepscountlabel2.text = String(user.weeklysteps) + " steps"
             vc.stepscountlabel3.text = String(user.monthlysteps) + " steps"
        vc.modalPresentationStyle = .fullScreen
        vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))

        // lastly, present the view controller like normal
        present(vc, animated: true, completion: nil)
         }
    }
    
    
}


class CustomCell: MDCCollectionViewCell {
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addviews() {
        contentview.layer.cornerRadius = 25
        contentview.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        
        contentview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.frame.size.width)
            layout.height = 60
            layout.margin = 0
            
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
        }
        listview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 220
            layout.height = 60
            layout.flexDirection = .row
            
        }
        
        image.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.width = 50
            layout.margin = 5
            
        }
       
        rank.text = "1"
        rank.font = UIFont(name: "GillSans" , size: 10)
        rank.configureLayout { (layout) in
                   layout.isEnabled = true
            layout.marginLeft = 20
            layout.width = 20
            layout.alignSelf = .center
                  
                   
               }
        stepscountview.backgroundColor = .clear
        stepscountview.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 60
            layout.width = 70
           layout.marginRight = 25
            
        }
        name.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.width = 170
            layout.alignSelf = .center
            
            layout.margin = 5
            
        }
        stepscount.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.width = 70
            
            layout.margin = 5
            
            
            
        }
        
        stepscount.textAlignment = .right
        name.font = UIFont(name: "GillSans-Light", size: 20)
         stepscount.font = UIFont(name: "GillSans", size: 20)
        
        listview.addSubview(rank)
        
        listview.addSubview(image)
        listview.addSubview(name)
        
        contentview.addSubview(listview)
        stepscountview.addSubview(stepscount)
        contentview.addSubview(stepscountview)
        stepscountview.yoga.applyLayout(preservingOrigin: false)
       
        listview.yoga.applyLayout(preservingOrigin: false)
        contentview.yoga.applyLayout(preservingOrigin: false)
        addSubview(contentview)
        
    }
   
    let rank = UILabel()
    
    let listview = UIView()
    let image = UIImageView()
    let name = UILabel()
    let rankview = UIView()
    let contentview = UIView()
    let stepscountview = UIView()
    let stepscount = UILabel()
    let staackview = UIStackView()
    var users = [User]()
}
class CustomCell2: MDCCollectionViewCell {




override init(frame: CGRect) {
    super.init(frame: frame)
    
    addviews()
}
required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
func addviews() {
    contentview.layer.cornerRadius = 25
    contentview.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    contentview.configureLayout { (layout) in
               layout.isEnabled = true
             layout.width = YGValue(self.frame.size.width)
                          layout.height = 60
        
           }
   
    name.font = UIFont(name: "GillSans-Light", size: 20)
    name.textAlignment = .center
    name.text = "+ Add New Friends"
           name.configureLayout { (layout) in
               layout.isEnabled = true
              layout.height = 60
            layout.width = 200
            layout.alignSelf = .center
               
              
           }
    contentview.addSubview(name)
    contentview.yoga.applyLayout(preservingOrigin: false)
    addSubview(contentview)
    }
     let contentview = UIView()
     let name = UILabel()
    
}
struct Friend: Codable {
    @DocumentID var id: String?
    var initial: String
    var isFriends: Bool
    var initialname: String
    var requesting: String
    var requestingname: String
    var users: [String]
    var isBlocked: Bool
    
}
struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var lowercasedname: String
    var steps: Int
    var dailygoal: Int
    var weeklysteps: Int
    var monthlysteps: Int
    var weeklygoal: Int
    var monthlygoal: Int
    var totalsteps: Int
    
}
extension UIView{
    
      func addGradientBackgroundhor(firstColor: UIColor, secondColor: UIColor){
          clipsToBounds = true
       
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
          gradientLayer.frame = self.bounds
          gradientLayer.startPoint = CGPoint(x: 0, y: 0)
          gradientLayer.endPoint = CGPoint(x: 1, y: 0)
          
        gradientLayer.name = "GRADIENT"
          self.layer.insertSublayer(gradientLayer, at: 0)
        
      }
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
             clipsToBounds = true
             let gradientLayer = CAGradientLayer()
             gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
      
             gradientLayer.frame = self.bounds
             gradientLayer.startPoint = CGPoint(x: 0, y: 0)
             gradientLayer.endPoint = CGPoint(x: 0, y: 1)
             
        gradientLayer.name = "GRADIENT"
             self.layer.insertSublayer(gradientLayer, at: 0)
         }
    func addsetgradientbackground(theme : String){
                clipsToBounds = true
                let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: theme + "-1")!.cgColor, UIColor(named: theme + "-2")!.cgColor]
         
                gradientLayer.frame = self.bounds
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
               
           gradientLayer.name = "GRADIENT"
                self.layer.insertSublayer(gradientLayer, at: 0)
            }
    func removeGradient(){
              self.layer.sublayers?.forEach {
                if ($0.name == "GRADIENT")
                { $0.removeFromSuperlayer()} }
            }
  }
extension UIPanGestureRecognizer {

    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        static let Up = PanGestureDirection(rawValue: 1 << 0)
        static let Down = PanGestureDirection(rawValue: 1 << 1)
        static let Left = PanGestureDirection(rawValue: 1 << 2)
        static let Right = PanGestureDirection(rawValue: 1 << 3)
    }

    private func getDirectionBy(velocity: CGFloat, greater: PanGestureDirection, lower: PanGestureDirection) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }

    public func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(velocity: velocity.y, greater: PanGestureDirection.Down, lower: PanGestureDirection.Up)
        let xDirection = getDirectionBy(velocity: velocity.x, greater: PanGestureDirection.Right, lower: PanGestureDirection.Left)
        return xDirection.union(yDirection)
    }
}
extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}
