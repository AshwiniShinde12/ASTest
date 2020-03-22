//
//  ViewController.swift
//  ASTest
//
//  Created by Ashwini on 20/03/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData

class UserProfile: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var textName: SkyFloatingLabelTextField!
    @IBOutlet weak var textEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textPhone: SkyFloatingLabelTextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imageData = Data()
    var emailArr = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    override func viewWillAppear(_ animated: Bool) {
//        let profimg = UIImage(named: Constants.image)
//        let image = profimg?.resizeImage(200, opaque: true)
//        profileImgView.image = image
        profileImgView.roundImage()
        textEmail.delegate = self
        textEmail.addTarget(self, action: #selector(EditingStarted(_:)), for: .editingChanged)
        getAllUsersData()
    
    }
    @objc func EditingStarted(_ textField:UITextField)
    {
        if(textField == textEmail)
        {
            if(!textField.isValidEmail())
            {
                textEmail.errorMessage = Constants.isValidEmail
            }else{
                textEmail.errorMessage = Constants.emptyStr
            }
        }
        
        if(textField == textPhone)
             {
                 if(!textField.isValidPhone())
                 {
                      textEmail.errorMessage = Constants.isValidPhone
                    
                 }else{
                     textEmail.errorMessage = Constants.emptyStr
                 }
             }
    }
    @IBAction func btnUploadProfileClicked(_ sender: Any) {
        requestToUploadPhoto()
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if(textName.text != nil)
        {
            textName.errorMessage = Constants.emptyStr
            if(textEmail.isValidEmail()){
                textEmail.errorMessage = Constants.emptyStr
                if(textPhone.isValidPhone())
                {
                    textPhone.errorMessage = Constants.emptyStr
                    if(!self.imageData.isEmpty)
                    {
                     self.saveUserData()
                        
                    }else{
                        self.view.makeToast(Constants.isImgValid)
                    }
                  
                }else{
                    
                    textPhone.errorMessage = Constants.isValidPhone
                }
                
            }else{
                textEmail.errorMessage = Constants.isValidEmail
            }
        }else{
            textName.errorMessage = Constants.isValidName
        }
    }
    
    func saveUserData()
    {
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entity = NSEntityDescription.entity(forEntityName: Constants.entity, in: context)
       let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(textName.text!, forKey: Constants.name)
        newUser.setValue(textEmail.text!, forKey: Constants.email)
        newUser.setValue(textPhone.text!, forKey: Constants.phone)
        newUser.setValue(self.imageData, forKey: Constants.img)


        if context.hasChanges {
        do {
        
            if(self.emailArr.contains(textEmail.text!))
            {
                self.view.makeToast(Constants.emailExist)
            }else{
                try context.save()
                self.view.makeToast(Constants.savedSuccess)
            }
                
          } catch {
          
            self.view.makeToast(Constants.savedFailed)
        }
        }else{
            self.view.makeToast(Constants.savedFailed)
        }
    }
    func getAllUsersData(){
       
         let context = appDelegate.persistentContainer.viewContext
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entity)
         request.returnsObjectsAsFaults = false
         do {
             let result = try context.fetch(request)
             print(result)
             for data in result as! [NSManagedObject] {
                 print(data.value(forKey: Constants.name) as! String)
                 let email = data.value(forKey: Constants.email) as! String
                 self.emailArr.append(email)
             }
             
         } catch {
             
             print(Constants.savedFailed)
         }
     }
    
    
    
    
    
}

extension UserProfile:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func requestToUploadPhoto()
    {
        let alert = UIAlertController(title: "Choose Attachment", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func camDenied()
    {
        DispatchQueue.main.async
            {
                var alertText = "It looks like your privacy settings are preventing us from accessing your camera to do change your profile image. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
                
                var alertButton = "OK"
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                
                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                {
                    alertText = "It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                    
                    alertButton = "Go"
                    
                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }
                
                let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
       let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
               let image1 = image.resizeImage(200, opaque: true)
        
        imageData = image1.pngData()!
        self.profileImgView.image = image1
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

