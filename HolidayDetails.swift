//
//  HolidayDetails.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class HolidayDetails: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var lblToDate: UILabel!
    
    @IBOutlet var lblFromDate: UILabel!
    
    @IBOutlet var btnHoliday: UIButton!
    
    @IBOutlet var lblNotes: UILabel!
    @IBOutlet var lblDays: UILabel!
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var sarHolidayDetails = [String]();
    let yearPicker = UIDatePicker()
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var txtYear: UITextField!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func btnViewHolidayDetails(_ sender:AnyObject) {
        
        let strCOID=Singleton.sharedManager.CompanyID;
        let strYear=txtYear.text;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body> <HolidayDetails xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCOID)</strCompanyID><strYear>\(strYear!)</strYear></HolidayDetails></soap12:Body></soap12:Envelope>";
        
        
        let urlString =  Singleton.sharedManager.WebServicePath;
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          showYearPicker();
    
        lblFromDate.backgroundColor=Singleton.sharedManager.Color
        lblToDate.backgroundColor=Singleton.sharedManager.Color
        lblDays.backgroundColor=Singleton.sharedManager.Color
        lblNotes.backgroundColor=Singleton.sharedManager.Color
        btnHoliday.backgroundColor=Singleton.sharedManager.Color;
        
        tableView.tableFooterView = UIView()
        
        //==
        
        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
        //==
        
        
        let logo = UIImage(data:strLogo!)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        
        btnHoliday.layer.cornerRadius = 5
       
        
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
        if currentElementName == "HolidayDetailsResult" {
            
             var strHolidayDetails:String=string;
            sarHolidayDetails = strHolidayDetails.components(separatedBy:",");
            
            //print(string);
            
            DispatchQueue.main.async(execute: {
               self.tableView.reloadData()
                return
            })

            
            print(string);
            // txtPassword.text = string
            //NSLog(string);
        }
    }
    
    
    func showYearPicker(){
        //Formate Date
        yearPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneYearPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelYearPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtYear.inputAccessoryView = toolbar
        // add datepicker to textField
        txtYear.inputView = yearPicker
        
    }
    
    func doneYearPicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        txtYear.text = formatter.string(from: yearPicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }

    
    func cancelYearPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //make sure you use the relevant array sizes
        if(sarHolidayDetails.count>0)
        {
        return ((sarHolidayDetails.count/4));
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Cell=UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:"Cell");
      //  let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell");
        
       // if (indexPath.row % 2 == 0)
        //{           //Cell.backgroundColor =  UIColor(red: 0.1059, green: 0.5216, blue: 0.4118, alpha:1)
            
          //  Cell.backgroundColor=Singleton.sharedManager.Color;
            
        //} else {
          //  Cell.backgroundColor = UIColor.white
       // }
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HolidayTableViewCell
        
        var i=0;
        
        Cell.lblFromDate.layer.backgroundColor=UIColor.black.cgColor
        Cell.lblToDate.layer.backgroundColor=UIColor.black.cgColor
        Cell.lblDays.layer.backgroundColor=UIColor.black.cgColor
        Cell.lblNotes.layer.backgroundColor=UIColor.black.cgColor
        
        
        
        Cell.lblFromDate.layer.borderWidth=0.5
        Cell.lblToDate.layer.borderWidth=0.5
        Cell.lblDays.layer.borderWidth=0.5
        Cell.lblNotes.layer.borderWidth=0.5
        
        while (i<sarHolidayDetails.count-1)
        {
       
            Cell.lblFromDate.text=sarHolidayDetails[i];
            Cell.lblToDate.text=sarHolidayDetails[i+1];
            Cell.lblDays.text=sarHolidayDetails[i+2];
            Cell.lblNotes.text=sarHolidayDetails[i+3];
       
            i+=4;
        }
        return Cell;
    }

    
}

