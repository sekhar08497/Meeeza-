//
//  HolidayDetails.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class SalaryPackage: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate{
    
    @IBOutlet var lblGrossValue: UILabel!
    @IBOutlet var lblOtherValue: UILabel!
    @IBOutlet var lblMobileValue: UILabel!
    @IBOutlet var lblTransportValue: UILabel!
    @IBOutlet var lblHRAValue: UILabel!
    @IBOutlet var lblBasicValue: UILabel!
    @IBOutlet var lblGrossDescription: UILabel!
    @IBOutlet var lblOtherDescription: UILabel!
    @IBOutlet var lblMobileDescription: UILabel!
    @IBOutlet var lblHRADescription: UILabel!
    @IBOutlet var lblBasicDescription: UILabel!
    @IBOutlet var txtMonth: UITextField!
    
    @IBOutlet var lblTransportDescription: UILabel!
    
      @IBOutlet var txtYear: UITextField!
    @IBOutlet var btnViewPackage: UIButton!
    @IBOutlet var imgLine: UIImageView!
      
    @IBOutlet var lblEmployeeIDText: UILabel!
    @IBOutlet var lblHeading: UILabel!
  
  
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var lblEmployeeName: UILabel!
    @IBOutlet var lblEmployeeNameText: UILabel!
    @IBOutlet var lblEmployeeID: UILabel!
      
    @IBOutlet var menuButton: UIBarButtonItem!
    

   
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var strSelectedMonth:NSString=""
    var intMonth:NSInteger=0
    var sarSalaryPackage = [String]();
    let yearPicker = YearPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170))
    let monthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170))
    
    @IBAction func btnPackages(_ sender: Any) {

        if Reachability.isConnectedToNetwork() == true
        {
            
   
       let strCOID=Singleton.sharedManager.CompanyID;

        let strEmployeeID=Singleton.sharedManager.Username
        let strYear=txtYear.text;
       let strMonth=String(intMonth+1)
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
       
    let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body>  <Package xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCOID)</strCompanyID><strEmployeeID>\(strEmployeeID)</strEmployeeID><strYear>\(strYear!)</strYear><intMonth>\(strMonth)</intMonth></Package></soap12:Body></soap12:Envelope>";
        
        
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
        else
        {
            Alert();
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.monthPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.yearPicker.translatesAutoresizingMaskIntoConstraints = false;
        
          showYearPicker();
          showMonthPicker()
      
        
        
       // tableView.tableFooterView = UIView()
        
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
        
       // tableView.rowHeight = UITableViewAutomaticDimension
       //tableView.estimatedRowHeight = 20
        btnViewPackage.backgroundColor=Singleton.sharedManager.Color
        btnViewPackage.layer.cornerRadius = 5
       
        
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
        
        var currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.numberStyle = NumberFormatter.Style.decimal
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        if currentElementName == "PackageResult" {
            
             var strSalaryPackage:String=string;
            sarSalaryPackage = strSalaryPackage.components(separatedBy:",");
            
            //print(string);
            if(sarSalaryPackage.count>1)
            {
                
                lblBasicDescription.isHidden=false;
                lblHRADescription.isHidden=false;
                lblTransportDescription.isHidden=false;
                lblMobileDescription.isHidden=false;
                lblOtherDescription.isHidden=false;
                lblGrossDescription.isHidden=false;
                
                lblBasicValue.isHidden=false;
                lblHRAValue.isHidden=false;
                lblTransportValue.isHidden=false;
                lblMobileValue.isHidden=false;
                lblOtherValue.isHidden=false;
                lblGrossValue.isHidden=false;
                
                //tableView.isHidden=false;
            lblHeading.text = "Salary Package for the month of "+(strSelectedMonth as String)+"-"+txtYear.text!;
            lblEmployeeIDText.text="Employee ID:";
            lblEmployeeNameText.text="Employee Name:";
            lblEmployeeID.text=Singleton.sharedManager.Username;
            lblEmployeeName.text=Singleton.sharedManager.EmployeeName;
            lblBasicDescription.backgroundColor=Singleton.sharedManager.Color
            lblHRADescription.backgroundColor=Singleton.sharedManager.Color
            lblTransportDescription.backgroundColor=Singleton.sharedManager.Color
            lblMobileDescription.backgroundColor=Singleton.sharedManager.Color
            lblOtherDescription.backgroundColor=Singleton.sharedManager.Color
            lblGrossDescription.backgroundColor=Singleton.sharedManager.Color

                lblBasicDescription.text=" Basic";
                lblHRADescription.text=" HRA";
                lblTransportDescription.text=" Transport";
                lblMobileDescription.text=" Mobile Allowance";
                lblOtherDescription.text=" Other Allowance";
                lblGrossDescription.text=" Gross Salary";
                
                lblBasicValue.layer.borderWidth=0.4
                lblHRAValue.layer.borderWidth=0.4

                lblTransportValue.layer.borderWidth=0.4

                lblMobileValue.layer.borderWidth=0.4

                lblOtherValue.layer.borderWidth=0.4

                lblGrossValue.layer.borderWidth=0.4

                lblBasicValue.layer.borderColor=UIColor.lightGray.cgColor
                lblHRAValue.layer.borderColor=UIColor.lightGray.cgColor
                
                lblTransportValue.layer.borderColor=UIColor.lightGray.cgColor
                
                lblMobileValue.layer.borderColor=UIColor.lightGray.cgColor
                
                lblOtherValue.layer.borderColor=UIColor.lightGray.cgColor
                
                lblGrossValue.layer.borderColor=UIColor.lightGray.cgColor
                
                
                lblBasicValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[0]) as! NSNumber);
                lblHRAValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[1]) as! NSNumber);
                lblTransportValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[2]) as! NSNumber);
                lblMobileValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[3]) as! NSNumber);
                lblOtherValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[4]) as! NSNumber);
                lblGrossValue.text=currencyFormatter.string(from: Float(sarSalaryPackage[5]) as! NSNumber);
            
            }
            
            else
            {
                lblBasicDescription.isHidden=true;
                lblHRADescription.isHidden=true;
                lblTransportDescription.isHidden=true;
                lblMobileDescription.isHidden=true;
                lblOtherDescription.isHidden=true;
                lblGrossDescription.isHidden=true;
                
                lblBasicValue.isHidden=true;
                lblHRAValue.isHidden=true;
                lblTransportValue.isHidden=true;
                lblMobileValue.isHidden=true;
                lblOtherValue.isHidden=true;
                lblGrossValue.isHidden=true;
                
                //tableView.isHidden=true;
                lblHeading.text = "";
                lblEmployeeIDText.text="";
                lblEmployeeNameText.text="";
                lblEmployeeID.text="";
                lblEmployeeName.text="";
                
                let alertController = UIAlertController(title: "Salary Package", message:
                    "Salary Package does not processed for this month, Try Again Later !", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            /*
            DispatchQueue.main.async(execute: {
               self.tableView.reloadData()
                return
            })
*/
            
            print(string);
            // txtPassword.text = string
            //NSLog(string);
        }
    }
    
    
    
    func showMonthPicker(){
        //Formate Date
        //monthPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneMonthPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelMonthPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtMonth.inputAccessoryView = toolbar
        // add datepicker to textField
        txtMonth.inputView = monthPicker
        
    }

    func doneMonthPicker(){
        //For date formate
       // let formatter = DateFormatter()
       // formatter.dateFormat = "MMMM"
        
        txtMonth.text = monthPicker.months[monthPicker.selectedRow(inComponent:0)]

        
       // formatter.dateFormat = "MM"
        intMonth=Int(monthPicker.selectedRow(inComponent:0))
        
        //formatter.dateFormat = "MMM"
        strSelectedMonth=String(monthPicker.months[monthPicker.selectedRow(inComponent:0)])! as NSString
        

        
        self.view.endEditing(true)
    }

    func cancelMonthPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showYearPicker(){
        //Formate Date
        //yearPicker.datePickerMode = .date
        
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
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy"
        
        txtYear.text = String(yearPicker.years[yearPicker.selectedRow(inComponent:0)])
        //dismiss date picker dialog
        self.view.endEditing(true)
    }

    
    func cancelYearPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
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
    
/*
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //make sure you use the relevant array sizes
        if(sarSalaryPackage.count>0)
        {
        return sarSalaryPackage.count;
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
     
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PackageTableViewCell
        
        var i=0;
        
        
        Cell.lblDescription.backgroundColor=Singleton.sharedManager.Color
        

        
            if(indexPath.row==0)
            {
            Cell.lblDescription.text="Basic"
            Cell.lblValue.text=sarSalaryPackage[i];
            }
            
            
            
            
            if(indexPath.row==1)
            {
                Cell.lblDescription.text="HRA"
                Cell.lblValue.text=sarSalaryPackage[i+1];
            }
            
            
            if(indexPath.row==2)
            {
                Cell.lblDescription.text="Transport"
                Cell.lblValue.text=sarSalaryPackage[i+2];
            }
            
            
            if(indexPath.row==3)
            {
                Cell.lblDescription.text="Mobile"
                Cell.lblValue.text=sarSalaryPackage[i+3];
            }
            
            if(indexPath.row==4)
            {
                Cell.lblDescription.text="Other Allowance"
                Cell.lblValue.text=sarSalaryPackage[i+4];
            }
            
            if(indexPath.row==5)
            {
                Cell.lblDescription.text="Gross Salary"
                Cell.lblValue.text=sarSalaryPackage[i+5];
            }
            
           
 
        
        
        

        
        return Cell;
    }
*/
    
    
}

