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
import SwiftEntryKit
import SafariServices
import Hero
class SignupViewController: UIViewController, SFSafariViewControllerDelegate {
    fileprivate let contentView = UIView()
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    // Load shows from plist
    

    
    
    //username field, password field, and email field
    let userfield: MDCTextField = {
        let userfield = MDCTextField()
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
    let confirmpasswordfield: MDCTextField = {
        let userfield = MDCTextField()
        userfield.clearButtonMode = .unlessEditing
        userfield.isSecureTextEntry = true
        userfield.backgroundColor = .clear
        return userfield
    }()
    let emailfield: MDCTextField = {
        let userfield = MDCTextField()
        userfield.clearButtonMode = .unlessEditing
        userfield.backgroundColor = .clear
        return userfield
    }()
    let userfieldController: MDCTextInputControllerFilled
    let passwordfieldController: MDCTextInputControllerFilled
    let emailfieldController: MDCTextInputControllerFilled
    let confirmpasswordfieldController: MDCTextInputControllerFilled
    let backbutton: UIButton = {
        let userfield = UIButton()
        userfield.addTarget(self, action: #selector(goback), for: .touchUpInside)
        userfield.titleLabel?.font = UIFont(name: "Gill Sans", size: 10)
        userfield.setTitleColor(UIColor.blue, for: .normal)
        userfield.setTitle("Go back", for: .normal)
        
        return userfield
    }()
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
      @objc func goback(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
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
        userfield.text = "I agree to the "
         userfield.font = UIFont(name: "GillSans", size: 18)
        return userfield
    }()
    let termsandconbutton: UIButton = {
        let userfield = UIButton()
        userfield.titleLabel!.font = UIFont(name: "GillSans", size: 18)
        
        userfield.setTitleColor(UIColor.blue, for: .normal)
        userfield.setTitle("terms and conditions, ", for: .normal)
         userfield.addTarget(self, action: #selector(showtermsandcons), for: .touchUpInside)
        
        return userfield
    }()
    let termsandcon2: UILabel = {
          let userfield = UILabel()
          userfield.numberOfLines = 2
          userfield.text = "and "
           userfield.font = UIFont(name: "GillSans", size: 18)
          return userfield
      }()
    let privacypolicybutton: UIButton = {
        let userfield = UIButton()
        userfield.titleLabel!.font = UIFont(name: "GillSans", size: 18)
        userfield.titleLabel!.textAlignment = .left
        userfield.setTitleColor(UIColor.blue, for: .normal)
        userfield.setTitle("privacy policy.", for: .normal)
        userfield.addTarget(self, action: #selector(showprivacypolicy), for: .touchUpInside)
        return userfield
    }()
    let termsandconswitch: UISwitch = {
        let userfield = UISwitch()
        userfield.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        return userfield
    }()
    let signup: MDCButton = {
        let userfield = MDCButton()
        userfield.isEnabled = false
  
        userfield.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
      
      
        userfield.layer.cornerRadius = 25
          
        userfield.disabledAlpha = 0.7
                userfield.setTitleFont(UIFont(name: "GillSans", size: 18), for: .normal)
                userfield.setTitle("Signup", for: .normal)
              userfield.setTitleColor(.black, for: .normal)
              userfield.backgroundColor = .white
        return userfield
    }()
 
    @objc func didTapSignup(sender: Any) {
       
        let db = Firestore.firestore()
            let username = userfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let docRef = db.collection("userNames").document(username.lowercased())
            
            docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userfieldController.setErrorText("Username taken", errorAccessibilityValue: nil)            } else {
            
            
            
            
            // Create cleaned versions of the data
            let username = self.userfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = self.passwordfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
            
            // There was an error creating the user
            let alertController = MDCAlertController(title: "Error", message: "Try again")
            let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
            alertController.addAction(action)

                self.present(alertController, animated:true, completion:nil)

            }
            else {
            print("digbikc")
            // User was created successfully, now store the first name and last name
         
                db.collection("friendpairs").addDocument(data: ["initial":result!.user.uid, "isFriends": true, "initialname" : username, "requesting":result!.user.uid, "isBlocked": false, "requestingname":username, "users":[result!.user.uid,result!.user.uid]] )
                db.collection("users").document(result!.user.uid).setData(["username":username, "lowercasedname" : username.lowercased()])
            { (error) in
            
            if error != nil {
            // Show error message
            //     self.showError("Error saving user data")
            let alertController = MDCAlertController(title: "Error", message: "Try again")
            let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
            alertController.addAction(action)

                self.present(alertController, animated:true, completion:nil)
            }
            else {
                 var attributes2 = EKAttributes.topFloat
                  attributes2.entryBackground = .gradient(gradient: .init(colors: [EKColor(.white),EKColor(.white)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
                         attributes2.roundCorners = .all(radius: 25)
                          attributes2.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                          attributes2.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                          attributes2.statusBar = .dark
                         attributes2.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                        
                           attributes2.position = .bottom
                  let title = EKProperty.LabelContent(text: "Account Made", style: .init(font: UIFont(name: "GillSans-Bold", size: 20)!, color: EKColor(.black), alignment: .center))
                  
                      let description = EKProperty.LabelContent(text: ("Account successfully made! Login to get started!"), style: .init(font: UIFont(name: "GillSans-Light", size: 20)!, color: .black, alignment: .center))
                 
                         let simpleMessage = EKSimpleMessage(title: title, description: description)
                        let alertMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                attributes2.displayDuration = 2.0
                 
                 

                       let customView2 = EKNotificationMessageView(with: alertMessage)
                SwiftEntryKit.display(entry: customView2, using: attributes2)}
            }
            db.collection("userNames").document(username.lowercased()).setData([:])
            { (error) in
            
            if error != nil {
            // Show error message
            //     self.showError("Error saving user data")
           let alertController = MDCAlertController(title: "Error", message: "Try again")
            let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
            alertController.addAction(action)

                self.present(alertController, animated:true, completion:nil)

            }
                }}}}}
       

    
       
                }
    @objc func switchChanged(mySwitch: UISwitch) {
        if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                                     {
                                         self.signup.isEnabled = true
                                     }
        else { self.signup.isEnabled = false}
       
        // Do something
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        userfieldController = MDCTextInputControllerFilled(textInput: userfield)
        passwordfieldController = MDCTextInputControllerFilled(textInput: passwordfield)
        emailfieldController = MDCTextInputControllerFilled(textInput: emailfield)
        confirmpasswordfieldController = MDCTextInputControllerFilled(textInput: confirmpasswordfield)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let panGR = UIPanGestureRecognizer(target: self,
                                            action: #selector(self.leftSwipeDismiss(gestureRecognizer:)))
        
        contentView.addGestureRecognizer(panGR)
        
        //flexbox initial
        self.view.addsetgradientbackground(theme: "healthy")
        self.view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(self.view.bounds.height)
            layout.width = YGValue(self.view.bounds.width)
            layout.justifyContent = .center
            
        }
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.alignSelf = .center
            layout.width = YGValue(self.view.bounds.width-50)
           
        }
        self.view.addSubview(contentView)
        
        
        
        
        //for safe area bc im dumb
     
        backbutton.configureLayout{ (layout) in
            layout.isEnabled = true
            
            layout.alignSelf = .center
            
        }
        
        
        
      
        
        
        
        //sign up logo
        let signuplabel = UILabel()
        signuplabel.text = "SIGNUP"
        signuplabel.font = UIFont(name: "GillSans", size: 30)
        signuplabel.configureLayout{ (layout) in
            layout.isEnabled = true
            
            
            layout.alignSelf = .center
            
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
        contentView.addSubview(logoview)
        contentView.addSubview(signuplabel)
        contentView.addSubview(backbutton)
        
        //user pass and email fields
        userfield.configureLayout { (layout) in
            layout.isEnabled = true
            layout.margin = 5
            layout.height = 70
            
            
        }
        passwordfield.configureLayout { (layout) in
            layout.isEnabled = true
            layout.margin = 5
            layout.height = 70
            
            
        }
        emailfield.configureLayout { (layout) in
            layout.isEnabled = true
            layout.margin = 5
            layout.height = 70
            
            
        }
        confirmpasswordfield.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.margin = 5
            layout.height = 70
            
            
        }
        
        contentView.addSubview(emailfield)
        contentView.addSubview(userfield)
        
        contentView.addSubview(passwordfield)
        contentView.addSubview(confirmpasswordfield)
        
        
        
        
        userfieldController.placeholderText = "Username"
        userfield.delegate = self
        passwordfieldController.placeholderText = "Password"
        passwordfield.delegate = self
        emailfieldController.placeholderText = "Email"
        emailfield.delegate = self
        confirmpasswordfieldController.placeholderText = "Confirm Password"
        confirmpasswordfield.delegate = self
        
        
        termsandcon.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginLeft = 10
            
            
            
        }
        termsandconswitch.configureLayout { (layout) in
            layout.isEnabled = true
            
            layout.justifyContent = .center
            
            
        }
        termsandconbutton.configureLayout { (layout) in
            layout.isEnabled = true
            
            
            
            
        }
        
        
        
        
        
        let termsandconview = UIView()
        termsandconview.configureLayout{ (layout) in
            layout.isEnabled = true
            layout.width = YGValue(self.view.safeAreaLayoutGuide.layoutFrame.width)
            layout.flexWrap = .wrap
            layout.flexDirection = .row
            layout.marginTop = 10
            
            
            
            
        }
        termsandcon2.configureLayout{ (layout) in
                   layout.isEnabled = true
                  
                   
                   
                   
                   
               }
        privacypolicybutton.configureLayout{ (layout) in
                  layout.isEnabled = true
            
            layout.marginLeft = 10
                  
                  
              }
        termsandconview.addSubview(termsandcon)
        termsandconview.addSubview(termsandconbutton)
        termsandconview.addSubview(termsandcon2)
        termsandconview.addSubview(privacypolicybutton)
        termsandconview.addSubview(termsandconswitch)
        
        termsandconview.yoga.applyLayout(preservingOrigin: false)
        contentView.addSubview(termsandconview)
        
        
        
        //accept terms and conditions
        
        
        
        signup.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.marginTop = 10
            
            
        }
        contentView.addSubview(signup)
        contentView.yoga.applyLayout(preservingOrigin: false)
         view.yoga.applyLayout(preservingOrigin: false)
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
     func validateFields() -> String? {
     
     if ((acceptswitch.isOn) == false)
     {
     return "Please accept terms and conditions"
     }
     // Check that all fields are filled in
     if userfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
     emailfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
     passwordfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
     
     { return "Please fill in all fields."
     }
     let invalidChars = NSCharacterSet.alphanumerics.inverted
     
     // Attempt to find the range of invalid characters in the input string. This returns an optional.
     let range = userfield.text?.rangeOfCharacter(from: invalidChars)
     
     if range != nil {
     // We have found an invalid character, don't allow the change
     return "Invalid username. Only letters and numbers allowed"
     }
     // Check if the password is secure
     let cleanedPassword = passwordfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     
     if isPasswordValid(cleanedPassword) == false {
     // Password isn't secure enough
     return "Please make sure your password is at least 8 characters, contains a special character and a number."
     }
     
     
     return nil
     }
     func isPasswordValid(_ password : String) -> Bool {
     
     let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
     return passwordTest.evaluate(with: password)
     }
     
     }
     */}

extension SignupViewController: UITextFieldDelegate {
   func textFieldDidEndEditing(_ textField: UITextField) {
    
        if (textField == passwordfield) {
                   let textFieldCharacterCount = textField.text?.count ?? 0
                   if (textFieldCharacterCount < 8) {
                       passwordfieldController.setErrorText("Password is too short",
                                                            errorAccessibilityValue: nil)
                       
                   }
                   else  if (textField.text != confirmpasswordfield.text)
                   { passwordfieldController.setErrorText("Passwords do not match",
                                                          errorAccessibilityValue: nil)}
                   else {
                       passwordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                         if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                                       {
                                           self.signup.isEnabled = true
                                       }
                       else { self.signup.isEnabled = false}
                   }
               }
               if (textField == confirmpasswordfield) {
                   let textFieldCharacterCount = textField.text?.count ?? 0
                   if (textFieldCharacterCount < 8) {
                       confirmpasswordfieldController.setErrorText("Password is too short",
                                                                   errorAccessibilityValue: nil)
                   }
                   else  if (textField.text != passwordfield.text)
                   { confirmpasswordfieldController.setErrorText("Passwords do not match",
                                                                 errorAccessibilityValue: nil)}
                   else {
                       confirmpasswordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                   
                       if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                       {
                           self.signup.isEnabled = true
                       }
                       else { self.signup.isEnabled = false}
                   }
               }
            if (textField == userfield) {
               
               let invalidChars = NSCharacterSet.alphanumerics.inverted
               
               // Attempt to find the range of invalid characters in the input string. This returns an optional.
               let range = userfield.text?.rangeOfCharacter(from: invalidChars)
               
               if range != nil {
                   userfieldController.setErrorText("Usernames can only contain alphabet and numbers.",
                                                    errorAccessibilityValue: nil)
               } else {
                   if (userfield.text?.count ?? 0 < 4 || userfield.text?.count ?? 0 > 14)
                   {
                       
                       userfieldController.setErrorText("Usernames have to be 4-14 characters.",
                                                                              errorAccessibilityValue: nil)
                   }
                   else {
                   userfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                   if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                                  {
                                      self.signup.isEnabled = true
                                  }
                   else { self.signup.isEnabled = false}
                   }}}
               
               if (textField == emailfield) {
                   let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                   
                   let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
               
                   if !(emailPred.evaluate(with: emailfield.text))
                   {
                       emailfieldController.setErrorText("Not a valid email.",
                                                         errorAccessibilityValue: nil)
                   } else {
                       emailfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                      if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                                     {
                                         self.signup.isEnabled = true
                                     }
                       else { self.signup.isEnabled = false}
                   }}//delegate method
   
    }
    //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // TextField
        if (textField == passwordfield) {
            let textFieldCharacterCount = textField.text?.count ?? 0
            if (textFieldCharacterCount < 8) {
                passwordfieldController.setErrorText("Password is too short",
                                                     errorAccessibilityValue: nil)
                
            }
            else  if (textField.text != confirmpasswordfield.text)
            { passwordfieldController.setErrorText("Passwords do not match",
                                                   errorAccessibilityValue: nil)}
            else {
                passwordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                  if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                                {
                                    self.signup.isEnabled = true
                                }
                else { self.signup.isEnabled = false}
            }
        }
        if (textField == confirmpasswordfield) {
            let textFieldCharacterCount = textField.text?.count ?? 0
            if (textFieldCharacterCount < 8) {
                confirmpasswordfieldController.setErrorText("Password is too short",
                                                            errorAccessibilityValue: nil)
            }
            else  if (textField.text != passwordfield.text)
            { confirmpasswordfieldController.setErrorText("Passwords do not match",
                                                          errorAccessibilityValue: nil)}
            else {
                confirmpasswordfieldController.setErrorText(nil, errorAccessibilityValue: nil)
            
                if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                {
                    self.signup.isEnabled = true
                }
                else { self.signup.isEnabled = false}
            }
        }
        if (textField == userfield) {
            
            let invalidChars = NSCharacterSet.alphanumerics.inverted
            
            // Attempt to find the range of invalid characters in the input string. This returns an optional.
            let range = userfield.text?.rangeOfCharacter(from: invalidChars)
            
            if range != nil {
                userfieldController.setErrorText("Usernames can only contain alphabet and numbers.",
                                                 errorAccessibilityValue: nil)
            } else {
                if (userfield.text?.count ?? 0 < 4 || userfield.text?.count ?? 0 > 14)
                {
                    
                    userfieldController.setErrorText("Usernames have to be 4-14 characters.",
                                                                           errorAccessibilityValue: nil)
                }
                else {
                userfieldController.setErrorText(nil, errorAccessibilityValue: nil)
                if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                               {
                                   self.signup.isEnabled = true
                               }
                else { self.signup.isEnabled = false}
                }}}
        
        if (textField == emailfield) {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
            if !(emailPred.evaluate(with: emailfield.text))
            {
                emailfieldController.setErrorText("Not a valid email.",
                                                  errorAccessibilityValue: nil)
            } else {
                emailfieldController.setErrorText(nil, errorAccessibilityValue: nil)
               if (confirmpasswordfieldController.errorText == nil && passwordfieldController.errorText == nil && userfieldController.errorText == nil && emailfieldController.errorText == nil && termsandconswitch.isOn)
                              {
                                  self.signup.isEnabled = true
                              }
                else { self.signup.isEnabled = false}
            }}
        
        
        
        return false
    }
}
