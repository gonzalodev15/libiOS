//
//  SignUpViewController.swift
//  libiOS
//
//  Created by Gonzalo Leon Suarez on 11/23/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(phoneTextField)
        Utilities.styleFilledButton(signUpButton)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let name = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let parameters = ["name": name, "lastname": lastName, "email": email, "password": password, "phone": phone]
        Alamofire.AF.request(libiOSApi.registerUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {
            response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    repository.savedToken = json["token"].stringValue
                    self.run(after: 2){
                            self.executeSegue()
                    }
                case .failure(let error):
                    print("Response Error: \(error.localizedDescription)")
                }
            
        })
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    func executeSegue(){
        self.performSegue(withIdentifier: "loginSegue", sender: self)
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
