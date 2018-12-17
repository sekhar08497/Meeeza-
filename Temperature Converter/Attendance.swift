//
//  Attendance.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//


import UIKit

class Attendance: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate,UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet var lblBreakOut: UILabel!
    @IBOutlet var lblCheckOut: UILabel!
    @IBOutlet var lblCheckIn: UILabel!
    @IBOutlet var lblBreakIn: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var btnAttendances: UIButton!
  
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    let datePicker = UIDatePicker()
    let todatePicker = UIDatePicker()
    var sarAttendance = [String]();
    
    
    @IBAction func btnAttendance(_ sender: Any)
    {
    
        if Reachability.isConnectedToNetwork() == true
        {
            
        if(Singleton.sharedManager.Database=="EKPayroll" || Singleton.sharedManager.Database=="TestDatabase" || Singleton.sharedManager.Database=="Ahlan")
        {
     let strEmployeeID=Singleton.sharedManager.Username;
     let strFromDate=txtFromDate.text;
     let strToDate=txtToDate.text;
     let strWebSitePath=Singleton.sharedManager.WebsitePath;
   
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><Attendance xmlns='"+(strWebSitePath)+"'><strEmployeeID>\(strEmployeeID)</strEmployeeID><strFromDate>\(strFromDate!)</strFromDate><strToDate>\(strToDate!)</strToDate></Attendance></soap12:Body></soap12:Envelope>";
        
        
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
        else
        {
            
            let alertController = UIAlertController(title: "Attendance Details", message:
                "Attendance Data not Available ! Try Again Later", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
            
        }
        else
        {
            Alert();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker();
        showDatePickerTo();
        
        tableView.tableFooterView = UIView()

         btnAttendances.layer.cornerRadius = 5
         btnAttendances.backgroundColor=Singleton.sharedManager.Color;
        
        lblDate.backgroundColor=Singleton.sharedManager.Color;
        lblBreakIn.backgroundColor=Singleton.sharedManager.Color
        lblBreakOut.backgroundColor=Singleton.sharedManager.Color
        lblCheckIn.backgroundColor=Singleton.sharedManager.Color
        lblCheckOut.backgroundColor=Singleton.sharedManager.Color
        
        //==
        
        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
        
        let logo = UIImage(data:strLogo!)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        //==
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
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
        
        if currentElementName == "AttendanceResult" {
            
            var strAttendance:String=string;
            
            
            if(strAttendance=="-")
            {
                tableView.isHidden=true;
                let alertController = UIAlertController(title: "Attendance", message:
                    "Attendance Details does not available", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
            
            sarAttendance = strAttendance.components(separatedBy:",");
                tableView.isHidden=false;
            }
            print(string);
            
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
            
        }
    }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtFromDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtFromDate.inputView = datePicker
        
    }
    
    func showDatePickerTo(){
        //Formate Dated
        todatePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePickerTo")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePickerTo")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtToDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtToDate.inputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtFromDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func donedatePickerTo(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtToDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }

    
    func cancelDatePicker(){
       
        self.view.endEditing(true)
    }

    
    func cancelDatePickerTo(){
              self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  return UITableViewCell()
    //}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if(sarAttendance.count>1)
       {
        return (sarAttendance.count/5);
        }
        else
       {
        
        return 0;
        
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttendanceTableViewCell
        

        var i = 0;
        var j=0;
        
        
        
        
        while (i<(sarAttendance.count/5))
        {
        
            if (indexPath.row==i)
            {

            Cell.lblDate.text=sarAttendance[j];
            Cell.lblCheckIn.text=sarAttendance[j+1];
            Cell.lblBreakIn.text=sarAttendance[j+2];
            Cell.lblBreakOut.text=sarAttendance[j+3];
            Cell.lblCheckOut.text=sarAttendance[j+4];
            }
            i+=1;
            j+=5;
        }
        
    return Cell;
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
