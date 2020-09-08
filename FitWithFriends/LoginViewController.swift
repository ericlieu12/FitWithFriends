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
import SafariServices
class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    fileprivate let contentView = UIView()
    let defaults = UserDefaults.standard
    
    // Load shows from plist
    

    
    
    //username field, password field, and email field
    let userfield: MDCTextField = {
        let userfield = MDCTextField()
        userfield.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        userfield.clearButtonMode = .unlessEditing
        userfield.backgroundColor = .clear
        
        return userfield
    }()
    let passwordfield: MDCTextField = {
        let userfield = MDCTextField()
        userfield.clearButtonMode = .unlessEditing
        userfield.backgroundColor = .clear
        userfield.isSecureTextEntry = true
        return userfield
    }()
  
  
    let userfieldController: MDCTextInputControllerFilled
    let passwordfieldController: MDCTextInputControllerFilled
   
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
      let termsandcon: UILabel = {
          let userfield = UILabel()
          userfield.numberOfLines = 2
        userfield.font = UIFont(name: "GillSans", size: 15)
          userfield.text = "By logging in, I agree to the "
          
          return userfield
      }()
      let termsandconbutton: UIButton = {
          let userfield = UIButton()
          
        userfield.titleLabel!.font = UIFont(name: "GillSans", size: 15)
          userfield.setTitleColor(UIColor.blue, for: .normal)
          userfield.setTitle("terms and conditions ", for: .normal)
           userfield.addTarget(self, action: #selector(showtermsandcons), for: .touchUpInside)
          
          return userfield
      }()
      let termsandcon2: UILabel = {
            let userfield = UILabel()
            userfield.numberOfLines = 2
            userfield.text = "and "
            userfield.font = UIFont(name: "GillSans", size: 15)
        
            return userfield
        }()
      let privacypolicybutton: UIButton = {
          let userfield = UIButton()
        userfield.titleLabel!.font = UIFont(name: "GillSans", size: 15)
          
          userfield.setTitleColor(UIColor.blue, for: .normal)
          userfield.setTitle("privacy policy.   ", for: .normal)
          userfield.addTarget(self, action: #selector(showprivacypolicy), for: .touchUpInside)
          return userfield
      }()
    
    
    let signup2: MDCButton = {
          let userfield = MDCButton()
        userfield.layer.cornerRadius = 25
    
          userfield.addTarget(self, action: #selector(launchsignup), for: .touchUpInside)
          userfield.setTitleFont(UIFont(name: "GillSans", size: 15), for: .normal)
          userfield.setTitle("Signup", for: .normal)
        userfield.setTitleColor(.black, for: .normal)
        userfield.backgroundColor = .white
          return userfield
      }()
   
    let signup: MDCButton = {
        let userfield = MDCButton()
        userfield.isEnabled = false
        userfield.disabledAlpha = 0.7
         userfield.layer.cornerRadius = 25
        userfield.backgroundColor = .white
        userfield.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
        userfield.setTitleColor(.black, for: .normal)
        userfield.setTitleFont(UIFont(name: "GillSans", size: 15), for: .normal)
        userfield.setTitle("Login", for: .normal)
        
        return userfield
    }()

    
        @objc func launchsignup(sender: Any) {
        
       let signvc = SignupViewController()
            signvc.modalPresentationStyle = .fullScreen
            signvc.heroModalAnimationType = .push(direction: .left)
      
               
                  signvc.hero.isEnabled = true

                  // this configures the built in animation
                  //    vc2.hero.modalAnimationType = .zoom
                  //    vc2.hero.modalAnimationType = .pageIn(direction: .left)
                  //    vc2.hero.modalAnimationType = .pull(direction: .left)
                  //    vc2.hero.modalAnimationType = .autoReverse(presenting: .pageIn(direction: .left))
                  signvc.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))

                  // lastly, present the view controller like normal
                  present(signvc, animated: true, completion: nil)
                }
          
          
    @objc func didTapSignup(sender: Any) {
        
        let email = userfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              let password = passwordfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                  if error != nil
                  {
                     let alertController = MDCAlertController(title: "Error", message: "Invalid email/password")
                      let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
                      alertController.addAction(action)

                          self.present(alertController, animated:true, completion:nil)
                  }
                  else {
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.defaults.set(document.get("username"), forKey: "username")
                           
                             let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           
                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)

                                          // Instantiate the desired view controller from the storyboard using the view controllers identifier
                                          // Cast is as the custom view controller type you created in order to access it's properties and methods
                            
                                          let customViewController = storyboard.instantiateViewController(withIdentifier: "tabvc") as! UITabBarController
                                
                                          appDelegate.window?.rootViewController = customViewController
                                          appDelegate.window?.makeKeyAndVisible()
                        } else {
                            print("Document does not exist")
                        }
                    }
                  
                  }
              }
              
          }
          
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        userfieldController = MDCTextInputControllerFilled(textInput: userfield)
        passwordfieldController = MDCTextInputControllerFilled(textInput: passwordfield)
       
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let appDomain = Bundle.main.bundleIdentifier {
                          UserDefaults.standard.removePersistentDomain(forName: appDomain)
                      }
                       self.navigationController?.viewControllers = [self]
        print(self.navigationController?.viewControllers)
      
        //flexbox initial
        let termsandconview = UIView()
               termsandconview.configureLayout{ (layout) in
                   layout.isEnabled = true
                   layout.width = YGValue(self.view.safeAreaLayoutGuide.layoutFrame.width)
                   layout.flexWrap = .wrap
                   layout.flexDirection = .row
                   layout.marginTop = 10
                   
                   
                   
                   
               }
        self.view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(self.view.bounds.height)
            layout.width = YGValue(self.view.bounds.width)
            
            layout.justifyContent = .center
        }
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            //layout.height = YGValue(self.view.bounds.height/1.5)
    
            layout.width = YGValue(self.view.bounds.width-50)
            layout.alignSelf = .center
          
        }
        self.view.addSubview(contentView)
        
        self.view.addsetgradientbackground(theme: "healthy")
        
        
        //for safe area bc im dumb
        let topview = UIView()
        topview.configureLayout{ (layout) in
            layout.isEnabled = true
            
            
            
            layout.height = 35
        }
       
        
        
        contentView.layer.cornerRadius = 25
        contentView.backgroundColor = .clear
        
       
        
        
        
     
      
        
        
        
        let logoview = UIImageView(frame: .zero)
       
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
            layout.marginBottom = 5
            
        }
        contentView.addSubview(logoview)
      
        
        //user pass and email fields
        userfield.configureLayout { (layout) in
            layout.isEnabled = true
            layout.margin = 5
            
            
            layout.alignSelf = .center
            
        }
        passwordfield.configureLayout { (layout) in
            layout.isEnabled = true
            layout.margin = 5
          
            
            layout.alignSelf = .center
        }
      
            
            
        
        
       

     contentView.addSubview(userfield)
        contentView.addSubview(passwordfield)
        
        
        
        
        
        userfieldController.placeholderText = "Email"
        userfield.delegate = self
        passwordfieldController.placeholderText = "Password"
        passwordfield.delegate = self
       
        
        
        
        
        
      
        let buttonview = UIView()
      buttonview.configureLayout { (layout) in
          layout.isEnabled = true
        layout.width = YGValue(self.view.bounds.width - 10)
            //  layout.flexDirection = .row
        layout.marginTop = 10
         
          
      }
    
        
        contentView.addSubview(buttonview)
        signup.configureLayout { (layout) in
            layout.isEnabled = true
           layout.width = YGValue(self.view.bounds.width-50)
            layout.height = 50
            
        }

            signup2.configureLayout { (layout) in
                layout.isEnabled = true
                layout.height = 50
                layout.marginTop = 25
        layout.width = YGValue(self.view.bounds.width-50)
               
     
                                }
                
            
            termsandconview.configureLayout { (layout) in
                       layout.isEnabled = true
                layout.flexDirection = .row
                layout.flexWrap = .wrap
                      
            
                                       }
            termsandcon.configureLayout { (layout) in
                       layout.isEnabled = true
             
                      
            
                                       }
        termsandconbutton.configureLayout { (layout) in
                   layout.isEnabled = true
         
                  
        
                                   }
        termsandcon2.configureLayout { (layout) in
                   layout.isEnabled = true
         
                  
        
                                   }
        privacypolicybutton.configureLayout { (layout) in
                         layout.isEnabled = true
               
                        
              
                                         }

        buttonview.addSubview(signup)
         buttonview.addSubview(signup2)
        buttonview.yoga.applyLayout(preservingOrigin: false)
         
        contentView.yoga.applyLayout(preservingOrigin: false)
       
        termsandconview.addSubview(termsandcon)
              termsandconview.addSubview(termsandconbutton)
              termsandconview.addSubview(termsandcon2)
              termsandconview.addSubview(privacypolicybutton)
             
              
              termsandconview.yoga.applyLayout(preservingOrigin: false)
              contentView.addSubview(termsandconview)
         self.view.yoga.applyLayout(preservingOrigin: false)
              
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
               
                
                // TextField
                if (textField == passwordfield) {
                  
                 
                    
                     
                        passwordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                          if ( passwordfieldController.errorText == nil && userfieldController.errorText == nil)
                                        {
                                            self.signup.isEnabled = true
                                        }
                        else { self.signup.isEnabled = false}
                    
                }
              
              
                if (textField == userfield) {
                    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    
                    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                    
                    if !(emailPred.evaluate(with: userfield.text)) {
                        userfieldController.setErrorText("Not a valid email.",
                                                          errorAccessibilityValue: nil)
                    } else {
                        userfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                       if ( passwordfieldController.errorText == nil && userfieldController.errorText == nil )
                                      {
                                          self.signup.isEnabled = true
                                      }
                        else { self.signup.isEnabled = false}
                    }}
                
                
                
    
            }
        
    
    //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // TextField
        if (textField == passwordfield) {
            
             
                passwordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                  if ( passwordfieldController.errorText == nil && userfieldController.errorText == nil)
                                {
                                    self.signup.isEnabled = true
                                }
                else { self.signup.isEnabled = false}
            
        }

      
        if (textField == userfield) {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if !(emailPred.evaluate(with: userfield.text)) {
                userfieldController.setErrorText("Not a valid email.",
                                                  errorAccessibilityValue: nil)
            } else {
                userfieldController.setErrorText(nil, errorAccessibilityValue: nil)
               if ( passwordfieldController.errorText == nil && userfieldController.errorText == nil )
                              {
                                  self.signup.isEnabled = true
                              }
                else { self.signup.isEnabled = false}
            }}
        
        
        
        return false
    }
}

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
