//
//  Login.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

import Fabric
import  Crashlytics


class Login: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate {
   
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    @IBOutlet var btnLog: UIButton!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
     var sarLogin = [String]();
    @IBOutlet var txtAccessCode: UITextField!

    @IBAction func btnLogin(_ sender:Any) {
      // Crashlytics.sharedInstance().crash()
        
        if Reachability.isConnectedToNetwork() == true
        {
          
        txtUserName.adjustsFontForContentSizeCategory=true;
        let strUserName=txtUserName.text;
        let strPassword=txtPassword.text;
        let strAccessCode=txtAccessCode.text?.lowercased();
            var strUrl = "";
            var urlString = "";
            var soapMessage = "";
        Singleton.sharedManager.Username=strUserName!;
        Singleton.sharedManager.AccessCode = strAccessCode!;
            if (strUserName?.isEmpty ?? true){
                
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Please Enter Username"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            else  if (strPassword?.isEmpty ?? true){
                
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Please Enter Password"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            else  if (strAccessCode?.isEmpty ?? true){
                
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Please Enter Access Code"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            
            else{
            if  (strAccessCode == "ah103") {
                
                strUrl="http://ahlan.smsgroupco.com";
                urlString =  "http://ahlan.smsgroupco.com/ahlanwebservice.asmx";
                
            }
            else if (strAccessCode == "em011") {
                
                strUrl="http://swppayroll.smsgroupco.com";
                urlString =  "http://swppayroll.smsgroupco.com/webservice2.asmx";
            }
            else if (strAccessCode == "swp027") {
                strUrl="http://swppayroll.smsgroupco.com";
                urlString =  "http://swppayroll.smsgroupco.com/webservice2.asmx";
                
            }
            else if (strAccessCode == "swpo673") {
                strUrl="http://swppayroll.smsgroupco.com";
                urlString =  "http://swppayroll.smsgroupco.com/webservice2.asmx";
                
                }
            else if (strAccessCode == "sms101") {
                strUrl="http://swppayroll.smsgroupco.com";
                urlString =  "http://swppayroll.smsgroupco.com/webservice2.asmx";
                }
            else{
                
                Alert();
                }
       soapMessage    = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><Login xmlns='\(strUrl)'><strEmployeeID>\(strUserName!)</strEmployeeID>  <strPassword>\(strPassword!)</strPassword><strAccessCode>\(strAccessCode!)</strAccessCode></Login></soap12:Body></soap12:Envelope>"
        
            
       
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        // if (connection == true) {
        var mutableData : Void = NSMutableData.initialize()
        //}
            }
        }
        else
        {
            Alert();
        }
        
         
        

       // performSegue(withIdentifier:"SWRevealViewController", sender:self);
        
    }

    @IBAction func btnCancel(_ sender: Any) {
        
       // txtUserName.text="";
        txtPassword.text="";
        //txtAccessCode.text="";
        txtUserName.text = Singleton.sharedManager.Username
        txtAccessCode.text = Singleton.sharedManager.AccessCode
        exit(0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
                self.navigationController?.isNavigationBarHidden = true
        //UserDefaults.standard.set("false", forKey: "isUserLoggedIn")
        
       
    txtUserName.text = Singleton.sharedManager.Username
        txtAccessCode.text = Singleton.sharedManager.AccessCode
       
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
     
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
            controller.dismiss(animated: true,completion: nil)
        }
        else
        {
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
                        controller.dismiss(animated: true, completion: nil)
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtUserName.delegate = self
        self.txtPassword.delegate=self
        self.txtAccessCode.delegate=self
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(textTag) as UIResponder!
        if(nextResponder != nil)
        {
            //textField.resignFirstResponder()
            nextResponder?.becomeFirstResponder()
        }
        else{
            // stop editing on pressing the done button on the last text field.
            
            self.view.endEditing(true)
        }
       // textField.resignFirstResponder()
        return true
    }
    
        
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        mutableData.append(data)
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        let response = NSString(data: mutableData as Data, encoding: String.Encoding.utf8.rawValue)
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self as! XMLParserDelegate
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    
    // NSXMLParserDelegate
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName as NSString
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
         var intValue:NSInteger=0;
        
        if currentElementName == "LoginResult" {
           
            //return "Success" + "," + strCompanyID+","+strDatabase+","+strWebPath+","+strWebsite+","+strColor+","+strLogo;
            
            var strLogin:String=string;
            sarLogin = strLogin.components(separatedBy:",");
            
            if(sarLogin[0]=="Success")
            {
                 print(sarLogin[1]);
               // print(sarLogin[2]);
               // print(sarLogin[3]);
                UserDefaults.standard.set(Singleton.sharedManager.Username, forKey:"Username")
                
                Singleton.sharedManager.EmployeeName=sarLogin[2];
                UserDefaults.standard.set(sarLogin[2], forKey:"EmployeeName")
                
                Singleton.sharedManager.CompanyID=sarLogin[3];
                UserDefaults.standard.set(sarLogin[3], forKey: "CompanyID")
                
                Singleton.sharedManager.Database=sarLogin[4];
                UserDefaults.standard.set(sarLogin[4], forKey: "Database")
                
                Singleton.sharedManager.WebServicePath=sarLogin[5];
                UserDefaults.standard.set(sarLogin[5], forKey:"WebServicePath" )
                
                Singleton.sharedManager.WebsitePath=sarLogin[6];
                UserDefaults.standard.set(sarLogin[6], forKey: "WebsitePath")
              
                Singleton.sharedManager.Color = hexStringToUIColor(hex: sarLogin[7]);
                UserDefaults.standard.set(sarLogin[7], forKey:"Color" )
                
                    var a = sarLogin[9];
                   Singleton.sharedManager.Logo=sarLogin[8];
                   UserDefaults.standard.set(sarLogin[8], forKey: "Logo")
                
            if(sarLogin[9]=="True")
            {
                Singleton.sharedManager.Android="1";
                UserDefaults.standard.set("1", forKey: "Android")
                
                }
                else
                {
            
                Singleton.sharedManager.Android="0";
                UserDefaults.standard.set("0", forKey: "Android")
                
                }
                
                //UserDefaults.standard.removeObject(forKey:"isUserLoggedIn")
                UserDefaults.standard.set("true", forKey: "isUserLoggedIn")
              
                UserDefaults.standard.synchronize()
            
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Main")
                self.present(vc, animated: true, completion: nil)
                
                 //self.performSegue(withIdentifier: "GOSI", sender: self)

            }
            else
            {
                
                             UserDefaults.standard.set("false", forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let alertController = UIAlertController(title: "Failure", message:
                    "Invalid Username Or Password Or Access Code, Try Again", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
           
        }
    }
    
    //===============
    
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
    
    func Alert()
    {
        
        let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection,Press Ok-to stay or Press Cancel- to Exit.", preferredStyle: UIAlertControllerStyle.alert)
        
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            exit(0);
        }))
        
        present(controller, animated: true, completion: nil)
        
    }
  
}

/*

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    var Controller=segue.destination as! ViewEmployeeProfile
    
    Controller.strEmployeeID=txtUserName.text!;
 
 */

/*
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
     if (segue.identifier == "showMyNewView") {
        
        SWRevealViewController *destination = [segue destinationViewController];
        [destination loadView];
        UINavigationController *navViewController = (UINavigationController *) [destination frontViewController];
        
        if ([navViewController.topViewController isKindOfClass:[HomeViewController class]]) {
            
            HomeViewController* homeVC = (HomeViewController*)navViewController.topViewController;
            homeVC.title = @"Test1";
        } 
    }
        SWRevealViewController *destination = [segue destinationViewController];
        [destination loadView];
        UINavigationController *navViewController = (UINavigationController *) [destination frontViewController];
        
        if ([navViewController.topViewController isKindOfClass:[HomeViewController class]]) {
            
            HomeViewController* homeVC = (HomeViewController*)navViewController.topViewController;
            homeVC.title = @"Test1";
        } 
    }}
 */

