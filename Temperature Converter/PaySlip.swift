//
//  PaySlip.swift
//  Temperature Converter
//
//  Created by admin on 9/29/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics


class PaySlip: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate,UITableViewDataSource, UITableViewDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet var lblHeading: UILabel!
    
    @IBOutlet var lblEmployeeNameText: UILabel!
    @IBOutlet var lblEmployeeNoText: UILabel!
    @IBOutlet var lblEmployeeName: UILabel!
    @IBOutlet var btnPaySlip: UIButton!
    @IBOutlet var lblPayslipFor: UILabel!
    @IBOutlet var btnCurrent: UIButton!
    @IBOutlet var lblEmployeeID: UILabel!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    
    let monthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width:200, height: 170))
    let yearPicker = YearPicker(frame: CGRect(x: 0, y: 0, width:200, height: 170))
    var intMonth:NSInteger=0;
    
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var txtMonth: UITextField!
    
    @IBOutlet var txtYear: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var strSelectedMonth:NSString = ""
    var strSelectedYear:NSString = ""
    var sarPaySlip = [String]();
    
    var monthSymbol:NSString = ""
    var year:NSInteger=0
    
    
    @IBAction func menuButtonClick(_ sender: Any) {
        
        
    
    }
    
    
    @IBAction func btnPaySlip(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
        let strCompanyID=Singleton.sharedManager.CompanyID;
        let strEmployeeID=Singleton.sharedManager.Username;
        let strYear=txtYear.text;
        let strMonth=String(intMonth+1);
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
            if((txtMonth.text==""))
            {
                let alertController = UIAlertController(title: "Pay Slip", message:
                    "Enter Month", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
                else if(txtYear.text=="")
            {
                
                let alertController = UIAlertController(title: "Pay Slip", message:
                    "Enter Year", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><Payslip xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCompanyID)</strCompanyID><strEmployeeID>\(strEmployeeID)</strEmployeeID><strYear>\(strYear!)</strYear><intMonth>\(strMonth)</intMonth></Payslip></soap12:Body></soap12:Envelope>";
        
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
        
        year=Int(txtYear.text!)!
            }
         
        }
        else
        {
            Alert();
        }
        
    }
    @IBAction func btnPreviousData(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
       
        let date = Date()
        let calendar = Calendar.current
        
        year = calendar.component(.year, from: date)
        var month:NSInteger  = (calendar.component(.month, from: date)-1)
        
        if(month==0)
        {
            
            month=11;
        }
        
        var monthValue = (calendar.component(.month, from: date))
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        monthSymbol = months?[month-1] as! String as NSString
        
        if(monthValue==1)
        {
            
            monthValue=12;
            year-=1;
        }
        else
        {
            
            monthValue-=1;
        }
        LoadData(strYears: String(year),strMonths: String(monthValue));
        
        }
        else
        {
            Alert();
        }
        
        Crashlytics.sharedInstance().crash()

    }
    
    @IBAction func btnCurrentData(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        let date = Date()
        let calendar = Calendar.current
        
        year = calendar.component(.year, from: date)
        let month:NSInteger = (calendar.component(.month, from: date)-1)
        
        let monthValue = calendar.component(.month, from: date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        monthSymbol = months?[month] as! String as NSString
        
        LoadData(strYears: String(year),strMonths: String(monthValue));
        
        }
        else
        {
            Alert();
        }
        Crashlytics.sharedInstance().crash()

        
    }
    
    func LoadData(strYears: String,strMonths : String)
    {
        
        let strCompanyID=Singleton.sharedManager.CompanyID;
        let strEmployeeID=Singleton.sharedManager.Username;
        let strYear=strYears;
        let strMonth=strMonths;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
        
        txtYear.text="";
        txtMonth.text="";
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><Payslip xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCompanyID)</strCompanyID><strEmployeeID>\(strEmployeeID)</strEmployeeID><strYear>\(strYear)</strYear><intMonth>\(strMonth)</intMonth></Payslip></soap12:Body></soap12:Envelope>";
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnPrevious.layer.cornerRadius = 25
        // btnPrevious.layer.borderWidth = 1
        btnPrevious.layer.borderColor = UIColor.lightGray.cgColor
        btnPrevious.backgroundColor=Singleton.sharedManager.Color;
        
        btnCurrent.layer.cornerRadius = 25
        btnCurrent.layer.borderColor = UIColor.lightGray.cgColor
        btnCurrent.backgroundColor=Singleton.sharedManager.Color;
        
        btnPaySlip.layer.cornerRadius=5;
        btnPaySlip.backgroundColor=Singleton.sharedManager.Color;
        
        
        lblHeading.isHidden=true;
        lblEmployeeNoText.isHidden=true;
        lblEmployeeNameText.isHidden=true;
        
        showMonthPicker();
        
        showYearPicker();
        
        self.monthPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.yearPicker.translatesAutoresizingMaskIntoConstraints = false;
        
       
        
        //==
        
        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
        
        tableView.tableFooterView = UIView()
        
        
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
    
    
    
    private func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        mutableData.length = 0;
    }
    
    private func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
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
        
        
        if currentElementName == "PayslipResult" {
            
            let strPayslip:String=string;
            
            
            if(strPayslip=="-")
            {
                
                tableView.isHidden=true;
                lblEmployeeID.text="";
                lblEmployeeName.text="";
                
                lblEmployeeNoText.text="";
                lblEmployeeNameText.text="";
                
                lblHeading.text = "";
                
                let alertController = UIAlertController(title: "Pay Slip", message:
                    "Payslip does not processed for this month, Try Again Later !", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            else
            {
                
                sarPaySlip = strPayslip.components(separatedBy:",");
                lblEmployeeID.text=Singleton.sharedManager.Username;
                lblEmployeeName.text=Singleton.sharedManager.EmployeeName;
                
                lblHeading.text = "PaySlip for the month of "+(monthSymbol as String)+"-"+String(year);
                lblEmployeeNoText.text="Employee ID :";
                lblEmployeeNameText.text="Employee Name :";
                
                
                tableView.isHidden=false;
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    return
                })
                
            }
            //SELECT a.fEmpID,b.fEmpName,a.fMonth,c.fDeptName,d.fPositionName,f.fNationalityName,g.fBrName,
            //a.fDaysWorked,a.fDaysAbsent,a.fOTHours,a.fE_OTAmt,a.fE_Basic,a.fE_HRA,a.fE_Food,a.fE_Mobile,a.fE_Transp,a.fE_Bonus,a.fE_Loan,fE_Claim,a.fE_Others,a.fE_Tot,
            
            //a.fD_Absent,a.fD_Short,a.fD_EmpGOSI,a.fD_Advance,a.fD_Loan,(a.fD_Advance+a.fD_Loan)as fD_AdvLoan,fD_Phone,a.fD_Others,a.fD_Tot,a.fNetSalary,a.fBankAccountNo,e.fBankName,a.fNote,a.fFooterNote,h.fLogo,h.fLogoFileName,a.fM_OtherAllowance,a.fE_GOSIDiff,a.fD_GOSIDiff
            
            print(string);
            
        }
    }
    
    
    func showMonthPicker(){
        //Formate Date
        //monthPicker.datePickerMode = .date
        
        //ToolBar
        
        let toolbar = UIToolbar();
        toolbar.heightAnchor;
        toolbar.sizeToFit()
    
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneMonthPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelMonthPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated:true)
        
        // add toolbar to textField
         txtMonth.inputAccessoryView = toolbar
         
 
        
        // add datepicker to textField
        txtMonth.inputView = monthPicker
        
       
    }
    
    
    func showYearPicker(){
        //Formate Date
        //  yearPicker.datePickerMode = .date
        
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
    
    func doneMonthPicker(){
        //For date formate
        // let formatter = DateFormatter()
        //  formatter.dateFormat = "MMMM"
        
        txtMonth.text = monthPicker.months[monthPicker.selectedRow(inComponent:0)]
        
        //formatter.dateFormat = "MM"
        intMonth=Int(monthPicker.selectedRow(inComponent:0))
        
        //formatter.dateFormat = "MMM"
        monthSymbol=String(monthPicker.months[monthPicker.selectedRow(inComponent:0)])! as NSString
       self.view.endEditing(true)
    }
    
    func doneYearPicker(){
        //For date formate
        // let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy"
        
        txtYear.text = String(yearPicker.years[yearPicker.selectedRow(inComponent:0)])
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelMonthPicker(){
        
        //cancel button dismiss datepicker dialog
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
        
        var intCount:NSInteger=0;
        if(sarPaySlip.count>1)
        {
            if(Singleton.sharedManager.Database=="EKPayroll" || Singleton.sharedManager.Database=="TestDatabase" || Singleton.sharedManager.Database=="Ahlan")
            {
                intCount=sarPaySlip.count+2;
                
            }
            else if(Singleton.sharedManager.Database=="swppayroll")
            {
                intCount=21;
            }
            else if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
                intCount=sarPaySlip.count+2;
                
            }
            
            return intCount;
        }
        else
        {
            return 0;
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
    
        var currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.numberStyle = NumberFormatter.Style.decimal
        currencyFormatter.locale = Locale(identifier: "en_US")
        
     
    
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaySlipTableViewCell
        
        Cell.backgroundColor=Singleton.sharedManager.Color;
        
        if(sarPaySlip.count>1)
        {
            lblHeading.isHidden=false;
            lblEmployeeNoText.isHidden=false;
            lblEmployeeNameText.isHidden=false;
            
        }
        else
        {
            
            lblHeading.isHidden=true;
            lblEmployeeNoText.isHidden=true;
            lblEmployeeNameText.isHidden=true;
        }
        
        var i=0;
        
        var strSepartaor="   ";
        
        if(Singleton.sharedManager.Database=="EKPayroll" || Singleton.sharedManager.Database=="TestDatabase")
        {
            
            
            if (indexPath.row==0)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Entitlements";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                
            }
            
            if (indexPath.row==1)
            {
                
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.text="Basic"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==2)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="HRA"+strSepartaor;
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+1]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==3)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Transport"+strSepartaor;
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+2]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            
            
            if (indexPath.row==4)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="OT Amount"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+3]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            if (indexPath.row==5)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Laundry"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+4]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==6)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Bonus"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+5]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==7)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Loan"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+6]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==8)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Claim"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+7]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==9)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+8]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==10)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+9]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==11)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Deductions";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                //Cell.lblValue.text=sarPaySlip[i+13];
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                
            }
            
            if (indexPath.row==12)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+10]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==13)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Short"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+11]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==14)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Telephone"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+12]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==15)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="GOSI"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+13]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==16)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Advance / Loan"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+14]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            
            if (indexPath.row==17)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+15]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            //UIFont.boldSystemFont(ofSize: 16.0)
            
            if (indexPath.row==18)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+16]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                //Cell.backgroundColor=UIColor.lightGray
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==19)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Net Salary"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+17]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
            }
            
        }
        else  if( Singleton.sharedManager.Database=="Ahlan")
        {
            
            
            if (indexPath.row==0)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Entitlements";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                
            }
            
            if (indexPath.row==1)
            {
                
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.text="Basic"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==2)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="HRA"+strSepartaor;
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+1]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==3)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Transport"+strSepartaor;
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+2]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            
            
            if (indexPath.row==4)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="OT Amount"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+3]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            if (indexPath.row==5)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Shift Allowance"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+4]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==6)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Bonus"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+5]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==7)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Loan"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+6]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==8)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Claim"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+7]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==9)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Other Allowance"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+8]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==10)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+9]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==11)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+10]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
              
                
            }
            
            if (indexPath.row==12)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Deductions";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                //Cell.lblValue.text=sarPaySlip[i+13];
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
               
            }
            
            
            
            if (indexPath.row==13)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+11]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
               
            }
            
            if (indexPath.row==14)
            {
                
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Short"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+12]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
              
            }
            
            
            if (indexPath.row==15)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Telephone"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+13]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
               
            }
            
            
            
            if (indexPath.row==16)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="GOSI"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+14]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
               
            }
            
            
            
            
            if (indexPath.row==17)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Advance / Loan"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+15]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
               
            }
            
            //UIFont.boldSystemFont(ofSize: 16.0)
            
            if (indexPath.row==18)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+16]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
              
                
            }
            
            if (indexPath.row==19)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+17]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                //Cell.backgroundColor=UIColor.lightGray
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
          
            }
            if (indexPath.row==20)
            {
                
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Net Salary"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+18]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
            }
            
        }
        else if(Singleton.sharedManager.Database=="swppayroll")
        {
            if (indexPath.row==0)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                
                Cell.lblCellHeading.text="Gross Salary";
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i]) as! NSNumber)
                Cell.lblCellHeading.textAlignment = .center
                Cell.backgroundColor=Singleton.sharedManager.Color;
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 13.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 13.0)
                
                //Cell.lblCellValue.text=sarPaySlip[indexPath.row];
            }
            
            
            if (indexPath.row==1)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                
                Cell.lblSeparator.text="Entitlements";
                Cell.lblValue.text="";
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                
                
            }
            
            if (indexPath.row==2)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="O.T Hours"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+1]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==3)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="O.T Amount"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+2]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==4)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Bonus"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+3]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==5)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Loan"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+4]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==6)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Claim"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+5]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==7)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="GOSI Difference"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+6]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==8)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+7]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==9)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+8]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==10)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Deductions";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                //Cell.lblValue.text=sarPaySlip[i+13];
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                
            }
            
            if (indexPath.row==11)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent Days"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+9]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==12)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent Amount"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+10]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==13)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Violation"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+11]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==14)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="House/Transport Advance"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+12]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==15)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="GOSI"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+13]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==16)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Advance"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+14]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==17)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="GOSI Difference"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+15]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==18)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+16]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            //UIFont.boldSystemFont(ofSize: 16.0)
            
            if (indexPath.row==19)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+17]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                //Cell.backgroundColor=UIColor.lightGray
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==20)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Net Salary"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+18]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
            }
            
            
        }
        else if(Singleton.sharedManager.Database=="Swppayroll_Oman")
        {
            
            if (indexPath.row==0)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                
                Cell.lblCellHeading.text="Gross Salary";
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i]) as! NSNumber)
                Cell.lblCellHeading.textAlignment = .center
                Cell.backgroundColor=Singleton.sharedManager.Color;
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 13.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 13.0)
            }
            
            
            if (indexPath.row==1)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                
                Cell.lblSeparator.text="Entitlements";
                Cell.lblValue.text="";
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                
                
            }
            
            if (indexPath.row==2)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="O.T Amount"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+1]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==3)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Reimbursement"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+2]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==4)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Bonus"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+3]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==5)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Loan"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+4]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==6)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Claim"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+5]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==7)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="PASI Difference"+strSepartaor;
              Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+6]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==8)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+7]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==9)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+8]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==10)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:300, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="";
                Cell.lblValue.text="";
                
                
                Cell.lblSeparator.text="Deductions";
                Cell.lblCellHeading.textColor=UIColor.white;
                
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
                //Cell.lblValue.text=sarPaySlip[i+13];
                Cell.backgroundColor = Singleton.sharedManager.Color;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                
            }
            
            
            
            if (indexPath.row==11)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent Days"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+9]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==12)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Absent"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+10]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==13)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Short"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+11]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            if (indexPath.row==14)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Phone"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+12]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==15)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="PASI"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+13]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            if (indexPath.row==16)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Advance / Loan"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+14]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            
            
            if (indexPath.row==17)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="PASI Difference"+strSepartaor;
                Cell.backgroundColor = UIColor.white
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+15]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            
            if (indexPath.row==18)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Others"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = UIColor.white
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+16]) as! NSNumber)
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
            }
            
            //UIFont.boldSystemFont(ofSize: 16.0)
            
            if (indexPath.row==19)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Total"+strSepartaor;
                Cell.lblSeparator.text=":";
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+17]) as! NSNumber)
                Cell.backgroundColor = UIColor.white
                Cell.lblCellHeading.textColor=UIColor.darkGray;
                Cell.lblValue.textColor=UIColor.darkGray;
                //Cell.backgroundColor=UIColor.lightGray
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 10.0)
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 11.0)
                
            }
            
            if (indexPath.row==20)
            {
                Cell.lblCellHeading.frame = CGRect( x:Cell.lblCellHeading.frame.origin.x,  y:Cell.lblCellHeading.frame.origin.y, width:162, height:Cell.lblCellHeading.frame.height)
                Cell.lblCellHeading.text="Net Salary"+strSepartaor;
                Cell.lblValue.text = currencyFormatter.string(from: Float(sarPaySlip[i+18]) as! NSNumber)
                Cell.lblSeparator.text=":";
                Cell.backgroundColor = Singleton.sharedManager.Color
                Cell.lblCellHeading.textColor=UIColor.white;
                Cell.lblValue.textColor=UIColor.white;
                Cell.lblValue.font=UIFont.boldSystemFont(ofSize: 17.0)
                Cell.lblCellHeading.font=UIFont.boldSystemFont(ofSize: 17.0)
            }
            
            
            
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
