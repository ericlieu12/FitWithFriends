//
//  StatsViewController.swift
//  FitWithFriends
//
//  Created by Eric Lieu on 9/1/20.
//  Copyright © 2020 eric. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet var popoverview: UIView!
    @IBOutlet weak var contentview: UIView!
    var vc = FriendStatsViewController()
    var vc2 = FeedViewController()
    var vc3 = ProfileViewController()
    @IBOutlet weak var goallabel: UILabel!
   
    @IBOutlet weak var picimage: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentview.layer.cornerRadius = 20
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.setprofilepic(_:)))
             
                           self.popoverview.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
        let drag = UIPanGestureRecognizer(target: self, action: #selector(self.setprofilepic(_:)))
        
                      self.popoverview.addGestureRecognizer(drag)

    }
    @objc func setprofilepic(_ sender: AnyObject)
           {
               dismiss(animated: true, completion: nil)
            vc.contentView.alpha = 1.0
            vc2.view.alpha = 1.0
            vc3.view.alpha = 1.0
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
