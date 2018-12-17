//
//  ChangePassword.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//
import UIKit


class ChangePassword: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate {
    
    
    @IBOutlet var menuButton: UIBarButtonItem!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    @IBOutlet var txtOldPassword: UITextField!
    
    @IBOutlet var txtNewPassword: UITextField!
    
    @IBOutlet var txtConfirmNewPassword: UITextField!
    
    @IBOutlet var btnChange: UIButton!
    
    
    
    @IBAction func btnChangePassword(_ sender: Any)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
        if(txtNewPassword.text=="" || txtOldPassword.text=="" || txtConfirmNewPassword.text == "")
        {
            
                       let alertController = UIAlertController(title: "Does not Update", message:
                "All Fields are Mendatory", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if(txtNewPassword.text != txtConfirmNewPassword.text) {
            let alertController = UIAlertController(title: "Does not Update", message:
                "New Password and Confirm Password Not Match", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
        let strEmployeeID=Singleton.sharedManager.Username;
        let strOldPassword = txtOldPassword.text;
        let strNewPassword=txtNewPassword.text;
        let strConfirmNewPassword=txtConfirmNewPassword.text;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body> <ChangePassword xmlns='"+(strWebSitePath)+"'><strEmployeeID>\(strEmployeeID)</strEmployeeID><strOldPassword>\(strOldPassword!)</strOldPassword><strPassword>\(strNewPassword!)</strPassword></ChangePassword></soap12:Body></soap12:Envelope>";
            

        let urlString = Singleton.sharedManager.WebServicePath
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //==
        btnChange.layer.cornerRadius = 5
        btnChange.backgroundColor = Singleton.sharedManager.Color;

        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
        
        let logo = UIImage(data:strLogo!)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.txtOldPassword.delegate=self
        self.txtNewPassword.delegate=self
        self.txtConfirmNewPassword.delegate=self
        
        //==
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // NSURLConnectionDelegate
    
    // NSURL
    
    
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        mutableData.append(data)
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        let response = NSString(data: mutableData as Data, encoding: String.Encoding.utf8.rawValue)
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    
    // NSXMLParserDelegate
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName as NSString
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
       var strPasswordStatus="";
        if currentElementName == "ChangePasswordResult" {
            print(currentElementName);
            if(string=="Updated")
            {
                
                Singleton.sharedManager.Android="1";
                UserDefaults.standard.set("1", forKey: "Android")
                
                let controller = UIAlertController(title: "Updated", message: "Password Updated Successfully !!!", preferredStyle: UIAlertControllerStyle.alert)
                
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Main")
                    self.present(vc, animated: true, completion: nil)
                    
                }))
                
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                strPasswordStatus="";
                let alertController = UIAlertController(title: "Does not Update", message:
                    "Password not updated, is Old Password Or Confirm Password Correct ? Try Again!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            
          //  txtFahrenheit.text = string
        }
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


