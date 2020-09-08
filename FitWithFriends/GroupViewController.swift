//
//  GroupViewController.swift
//  FitWithFriends
//
//  Created by Eric Lieu on 8/28/20.
//  Copyright © 2020 eric. All rights reserved.
//

/*import UIKit
import YogaKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import Hero
class GroupViewController: UIViewController {
    fileprivate let contentView: UIScrollView = UIScrollView(frame: .zero)
      var panGR: UIPanGestureRecognizer!
    let defaults = UserDefaults.standard
      // Load shows from plist
      let groupslist : UICollectionView = {
          
          let view = UICollectionView(
              frame: .zero,
              collectionViewLayout: UICollectionViewFlowLayout())
          view.register(CustomCell.self, forCellWithReuseIdentifier: "friendscell")
           view.register(CustomCell2.self, forCellWithReuseIdentifier: "addfriendcell")
          view.backgroundColor = .clear
          return view
      }()
      override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          // Calculate and set the content size for the scroll view
          var contentViewRect: CGRect = .zero
          for view in contentView.subviews {
              contentViewRect = contentViewRect.union(view.frame)
          }
          contentView.contentSize = contentViewRect.size
      }
      
    var id = ""
    var name = ""
    var uids = [String]()
    var users = [User]()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
       
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panGR = UIPanGestureRecognizer(target: self,
                                                           action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
        contentView.addGestureRecognizer(self.panGR)
        contentView.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            
            layout.width = YGValue(self.view.bounds.width)
            layout.height = YGValue(self.view.bounds.height)
        
        }
        groupslist.configureLayout{ (layout) in
            layout.isEnabled = true
            // layout.justifyContent = .spaceBetween
            
            layout.flexGrow = 1
        }

       let height = CGFloat(60)
                    let width = self.view.frame.size.width-10
                    let cellSize = CGSize(width:width,height:height)
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .vertical
                    layout.itemSize = cellSize
                    layout.minimumLineSpacing = 10
                    self.groupslist.setCollectionViewLayout(layout, animated: true)
                    
                    self.groupslist.delegate = self
                    self.groupslist.dataSource = self
        contentView.addSubview(groupslist)
        self.view.addSubview(contentView)
        contentView.yoga.applyLayout(preservingOrigin: false)
        // Do any additional setup after loading the view.
         let db = Firestore.firestore()
        for uid in uids
        {
        let listener =  db.collection("users").document(uid).addSnapshotListener{ //1
                             querySnapshot, error in
                              if let error = error {
                                  print("Error getting documents: \(error)")
                              } else { //2
                                  var x = 0
                                  //3
                                     
                                      let result = Result {
                                          
                                        try querySnapshot!.data(as: User.self)
                                      }
                                      switch result {//4
                                      case .success(let city):
                                          if let city = city {//5
                                                                      
                                                                                                                     if let userindex = self.users.firstIndex(where: { $0.id == city.id })
                                                                                                                                                                                                                                                     {
                                                                                                                     
                                                                                                                                                              
                                                                                                                                                                                                                                                        self.users[userindex] = city
                                                                                                                                                                                                                                                        self.groupslist.reloadData()                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                        else
                                                                                                                                                                                                                                                     {
                                                                                                                                                                      
                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                        self.users.append(city)
                                                                                                                                                                                                                                                        self.groupslist.reloadData()                                                                                                                                                                                                    }}
                                              
                                          //4
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
                                   
                              //1
                              
                              
                      
                      
                      
                 //0
               
           }
        }
        let theme = defaults.string(forKey: "theme") ?? "healthy"
                            
               self.contentView.addsetgradientbackground(theme: theme)
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
extension GroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return (users.count + 1)}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if (users.count == indexPath[1])
            {         let cellb = collectionView.dequeueReusableCell(withReuseIdentifier: "addfriendcell", for: indexPath) as! CustomCell2
                cellb.name.text = "+ Add Group Members"
                return cellb
            }
         let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "friendscell", for: indexPath) as! CustomCell
        let user = users[indexPath[1]]
        cella.name.text = user.username
        let storage = Storage.storage()
                   let storageRef = storage.reference()
                       let reference = storageRef.child("profilepics/"+user.id!)
                  cella.image.sd_setImage(with: reference)
         cella.stepscount.text = String(user.steps)
                     // saveprofilepic(uid: users[indexPath[1]].id!, data: (cella.image.image?.pngData())!)}
                   cella.rank.text = String(indexPath[1]+1)
                  
        
        return cella
        
        
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
     if (indexPath[1] == users.count)
            {
                let vc = AddFriendViewController()
                                vc.hero.isEnabled = true
                                self.hero.isEnabled = true
                vc.signuplabel.text = "Add Members"
                                vc.modalPresentationStyle = .fullScreen
                   vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
                 present(vc, animated: true, completion: nil)
            }
            else{
        let vc = FriendStatsViewController()
              vc.hero.isEnabled = true
              self.hero.isEnabled = true
    let cell = groupslist.cellForItem(at: indexPath) as! CustomCell
    cell.image.heroID = "profilepic"
    cell.name.heroID = "name"
    cell.stepscount.heroID = "stepscount"
    cell.contentview.heroID = "content"
        cell.alpha = 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            cell.alpha = 1.0
        }
    vc.profilepic.image = cell.image.image
    vc.namelabel.text = cell.name.text
    vc.stepscountlabel1.text = cell.stepscount.text
    vc.modalPresentationStyle = .fullScreen
    vc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))

    // lastly, present the view controller like normal
    present(vc, animated: true, completion: nil)

        }
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
}
}
*/
