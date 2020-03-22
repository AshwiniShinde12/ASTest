//
//  UserProfileListViewController.swift
//  ASTest
//
//  Created by Ashwini on 21/03/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit
import CoreData

class UserProfileListViewController: UIViewController {
    
    @IBOutlet weak var TableUserList: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrData = [DataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        TableUserList.tableFooterView = UIView()
        arrData.removeAll()
        getAllUsersData()
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
                let image = data.value(forKey: Constants.img) as! Data
                let name = data.value(forKey: Constants.name) as! String
                let email = data.value(forKey: Constants.email) as! String
                let phone = data.value(forKey: Constants.phone) as! String
                let userData = DataModel.init(image: image, name: name, email: email, phone: phone)
                arrData.append(userData)
            }
            print(arrData)
            if(arrData.count != 0)
            {
                self.TableUserList.reloadData()
            }else{
                self.view.makeToast(Constants.noData)
            }
            
        } catch {
            
            print(Constants.savedFailed)
        }
    }
    
    @IBAction func btnCreateUserClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UserProfileListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableUserList.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath) as! ListTableViewCell
        let ref:DataModel
        ref = arrData[indexPath.row]
        cell.backView.addShadow(radius: 10)
        let imageData = ref.image
        cell.profImgView.roundImage()
        if(!(imageData?.isEmpty ?? false))
        {
        cell.profImgView.image = UIImage(data: imageData!)
        }else{
            cell.profImgView.image = UIImage(named: Constants.image)
        }
        cell.lblName.text = ref.name
        cell.lblEmail.text = ref.email
        cell.lblPhone.text = ref.phone
        return cell
    }
}
