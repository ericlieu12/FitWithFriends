//
//  GameViewController.swift
//  FitWithFriends
//
//  Created by user on 8/13/20.
//  Copyright © 2020 eric. All rights reserved.
//

/*import UIKit
import FirebaseAuth
import CropViewController
import FirebaseStorage
import CoreMotion
import YogaKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Hero
class GroupsViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let contentView: UIScrollView = UIScrollView(frame: .zero)
    //image shit
    var groups = [Group]()
    var change = false
    override func viewDidLayoutSubviews() {
          
          super.viewDidLayoutSubviews()
          // Calculate and set the content size for the scroll view
          var contentViewRect: CGRect = .zero
          for view in contentView.subviews {
              contentViewRect = contentViewRect.union(view.frame)
          }
          contentView.contentSize = contentViewRect.size
      }
    let defaults = UserDefaults.standard
     let groupslist: UICollectionView = {
               
               let view = UICollectionView(
                   frame: .zero,
                   collectionViewLayout: UICollectionViewFlowLayout())
               view.register(GroupsCell.self, forCellWithReuseIdentifier: "groupcell")
          
        view.backgroundColor = .clear
               return view
           }()
   let topbar: UIView = {
                
                let view = UIView()
              
         view.backgroundColor = .clear
                return view
            }()
    let logoview: UIImageView = {
                   
                   let view = UIImageView()
        view.image = UIImage(named: "groupslogo")
          
                   return view
               }()
    private var image: UIImage?
       private var croppingStyle = CropViewCroppingStyle.circular
       
       private var croppedRect = CGRect.zero
       private var croppedAngle = 0
    //end
   
   

private var authListener: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        
         contentView.configureLayout{ (layout) in
                    layout.isEnabled = true
                    // layout.justifyContent = .spaceBetween
                    
                    layout.width = YGValue(self.view.bounds.width)
                    layout.height = YGValue(self.view.bounds.height)
                }
        groupslist.configureLayout{ (layout) in
                           layout.isEnabled = true
            layout.flexGrow = 1
            layout.marginTop = 10
                           // layout.justifyContent = .spaceBetween
                           
        
                       }
        logoview.configureLayout{ (layout) in
                                layout.isEnabled = true
              layout.width = 200
                                layout.height = 200
            layout.alignSelf = .center
                                // layout.justifyContent = .spaceBetween
                                
             
                            }
        topbar.configureLayout{ (layout) in
                                  layout.isEnabled = true
                   layout.height = 50
                                  // layout.justifyContent = .spaceBetween
                                  
               
                              }
       let height = CGFloat(120)
         let width = (self.view.frame.size.width)-20
         let cellSize = CGSize(width:width,height:height)
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.itemSize = cellSize
         layout.minimumLineSpacing = 17
         self.groupslist.setCollectionViewLayout(layout, animated: true)
         
         self.groupslist.delegate = self
         self.groupslist.dataSource = self
     //  checklogin()
        
        contentView.addSubview(topbar)
         contentView.addSubview(logoview)
        contentView.addSubview(groupslist)
        contentView.yoga.applyLayout(preservingOrigin: false)
        self.view.addSubview(contentView)
      let theme = (defaults.value(forKey: "theme") ?? "healthy") as! String
      contentView.addsetgradientbackground(theme: theme)
               let db = Firestore.firestore()
        let listener =  db.collection("groups").whereField("uids", arrayContains:Auth.auth().currentUser!.uid)
                   .addSnapshotListener { //1
                      querySnapshot, error in
                       if let error = error {
                           print("Error getting documents: \(error)")
                       } else { //2
                           var x = 0
                           for document in querySnapshot!.documents {//3
                              
                               let result = Result {
                                   
                                   try document.data(as: Group.self)
                               }
                               switch result {//4
                               case .success(let city):
                                   if let city = city {//5
                                    
                                    if let groupindex = self.groups.firstIndex(where: { $0.id == city.id })
                                                                                                                                                                    {
                                    
                                                                             self.change = true
                                                                                                                                                                       self.groups[groupindex] = city
                                                         self.groupslist.reloadData()                                                                                                                }
                                                                                                                                                                       else
                                                                                                                                                                    {
                                                                                     
                                                                                                                                                                       self.change = true
                                                                                                                                                                       self.groups.append(city)
                                                                                                                                                                        print("Success")
                                                                                                                                                                        self.groupslist.reloadData()                                                                                                            }
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
        
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //image shit
    
  
    override func viewDidAppear(_ animated: Bool) {
          
         if (defaults.bool(forKey: "themechange2"))
           {  self.contentView.removeGradient()
             let theme = defaults.string(forKey: "theme") ?? "healthy"
                  
               self.contentView.addsetgradientbackground(theme: theme)
           defaults.set(false, forKey: "themechange2")
              
           }
           
          
       }
    func checklogin()
    {
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in

                          if let user = user {
                            
                          } else {
                           let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginvc") as? LoginViewController
                            
                            loginViewController!.modalTransitionStyle = .crossDissolve
                            
                            self.present(loginViewController!, animated: true, completion: nil)
                            
                            
            }
                      }
    }
}
extension GroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return groups.count}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "groupcell", for: indexPath) as! GroupsCell
        cella.layer.cornerRadius = 30
        cella.name.text = groups[indexPath[1]].name
        cella.backgroundColor = .white
        cella.memberlabel.text = String(groups[indexPath[1]].uids.count) + " members"
            return cella
        }
            

   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let cell = groupslist.cellForItem(at: indexPath) as! GroupsCell
       cell.alpha = 0.8
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                     cell.alpha = 1.0
                 }
        let vc = GroupViewController()
                        vc.hero.isEnabled = true
                        self.hero.isEnabled = true
        
                let group = groups[indexPath[1]]
        vc.uids = group.uids
        vc.name = group.name
        vc.id = group.id ?? ""
              
              vc.modalPresentationStyle = .fullScreen
              vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))

              // lastly, present the view controller like normal
              present(vc, animated: true, completion: nil)         }
    
    
    
}
class GroupsCell: UICollectionViewCell {




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
        layout.width = YGValue(self.frame.size.width-10)
        layout.height = 120
        layout.marginLeft = 10
        layout.marginRight = 10
        layout.flexDirection = .row
       // layout.justifyContent = .spaceBetween
       
         }
    image.image = UIImage(systemName: "person.circle")
    name.text = "The Sexy Tigers"

    name.font = UIFont(name: "GillSans", size: 30)
     memberlabel.font = UIFont(name: "GillSans-Light", size: 25)
    memberlabel.text = "38 members"
    arrow.image = UIImage(systemName: "chevron.right")
    image.configureLayout { (layout) in
                layout.isEnabled = true
        layout.height = 100
        layout.width = 100
        layout.alignSelf = .center
          
            }
    name.configureLayout { (layout) in
                   layout.isEnabled = true
        layout.height = 40
     
               }
    textview.configureLayout { (layout) in
                     layout.isEnabled = true
        layout.flexGrow = 1
        layout.justifyContent = .center
                 }
    memberlabel.configureLayout { (layout) in
                     layout.isEnabled = true
           layout.height = 40
                 }
    arrow.tintColor = .black
    arrow.configureLayout { (layout) in
              layout.isEnabled = true
    layout.width = 20
        layout.height = 20
        layout.alignSelf = .center
          }
    contentview.addSubview(image)
    textview.addSubview(name)
    textview.addSubview(memberlabel)
    contentview.addSubview(textview)
  //  contentview.addSubview(arrow)

    textview.yoga.applyLayout(preservingOrigin: false)
    contentview.yoga.applyLayout(preservingOrigin: false)
    addSubview(contentview)

     
}
  
    var image = UIImageView()
    var arrow = UIImageView()
    var name = UILabel()
    var memberlabel = UILabel()
    var textview = UIView()

    var contentview = UIView()
}
struct Group: Codable {
    @DocumentID var id: String?
    var uids: [String]
    var name: String
   
    
    
}
*/
