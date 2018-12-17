//
//  SplashController.swift
//  Temperature Converter
//
//  Created by admin on 1/17/18.
//  Copyright © 2018 Web In Dream. All rights reserved.
//

import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
   
        
        if((UserDefaults.standard.string(forKey: "isUserLoggedIn")) == "true")
        {
            
            if let Username = UserDefaults.standard.value(forKey: "Username") as? String
            {
                Singleton.sharedManager.Username=Username;
                
            }
            
            if let AccessCode = UserDefaults.standard.value(forKey: "AccessCode") as? String
            {
                Singleton.sharedManager.AccessCode=AccessCode;
                
            }
            
            if let EmployeeName = UserDefaults.standard.value(forKey: "EmployeeName") as? String
            {
                Singleton.sharedManager.EmployeeName=EmployeeName;
                
                
            }
            if let CompanyID = UserDefaults.standard.value(forKey: "CompanyID") as? String
            {
                Singleton.sharedManager.CompanyID=CompanyID;
                
                
            }
            if let Database = UserDefaults.standard.value(forKey: "Database") as? String
            {
                Singleton.sharedManager.Database=Database;
            }
            if let WebServicePath = UserDefaults.standard.value(forKey: "WebServicePath") as? String
            {
                
                Singleton.sharedManager.WebServicePath=WebServicePath;
                
            }
            if let WebsitePath = UserDefaults.standard.value(forKey: "WebsitePath") as? String
            {
                Singleton.sharedManager.WebsitePath=WebsitePath;
            }
            
            if let Color = UserDefaults.standard.value(forKey: "Color") as? String
            {
                Singleton.sharedManager.Color=hexStringToUIColor(hex: Color);
            }
            if let Logo = UserDefaults.standard.value(forKey: "Logo") as? String
            {
                Singleton.sharedManager.Logo=Logo;
            }
            if let Android = UserDefaults.standard.value(forKey: "Android") as? String
            {
                Singleton.sharedManager.Android=Android;
            }
            
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Main")
            self.present(vc, animated: true, completion: nil)
            
        }
        else
        {
            if let Username = UserDefaults.standard.value(forKey: "Username") as? String
            {
                Singleton.sharedManager.Username=Username;
                
            }
            
            if let AccessCode = UserDefaults.standard.value(forKey: "AccessCode") as? String
            {
                Singleton.sharedManager.AccessCode=AccessCode;
                
            }
              UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
