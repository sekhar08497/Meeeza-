//
//  EmployeePayroll.swift
//  Temperature Converter
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class EmployeePayroll: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var lblFromToValue: UILabel!
    
    @IBOutlet var lblMonth: UILabel!
    
    @IBOutlet var btnViewPayroll: UIButton!
    var sarPayrollHistory = [String]();
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    @IBOutlet var lblHeaderText: UILabel!
    
    @IBOutlet var txtFromYear: UITextField!
    @IBOutlet var txtFromMonth: UITextField!
    @IBOutlet var txtToYear: UITextField!
    @IBOutlet var txtToMonth: UITextField!
    @IBOutlet var lblNetSalary: UILabel!
    @IBOutlet var lblDeduction: UILabel!
    @IBOutlet var lblEntitlement: UILabel!
    @IBOutlet var lblGrossSalary: UILabel!
    
    let fromMonthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170));
    //let fromMonthPicker = UIDatePicker()
    let fromYearPicker = YearPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170));
    let toMonthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170));

   
    let toYearPicker = YearPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170));
    
    var intFromMonth:NSInteger=0;
    var intToMonth:NSInteger=0;

    
    @IBAction func btnViewEmployeePayroll(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true
        {
           
        let strCompanyID=Singleton.sharedManager.CompanyID;
        let strEmployeeID=Singleton.sharedManager.Username;
        let strFromYear=txtFromYear.text;
        let strFromMonth=String(intFromMonth)
        let strToYear=txtToYear.text;
        let strToMonth=String(intToMonth)
        let strWebSitePath=Singleton.sharedManager.WebsitePath;

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><PayrollHistory xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCompanyID)</strCompanyID><strEmployeeID>\(strEmployeeID)</strEmployeeID><strFromYear>\(strFromYear!)</strFromYear><strFromMonth>\(strFromMonth)</strFromMonth><strToYear>\(strToYear!)</strToYear><strToMonth>\(strToMonth)</strToMonth></PayrollHistory></soap12:Body></soap12:Envelope>";
        
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
            Alert();
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //fromMonthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 170))
        showFromMonthPicker();
        showFromYearPicker();
        
        showToMonthPicker();
        showToYearPicker();
        
        self.fromMonthPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.fromYearPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.toMonthPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.toYearPicker.translatesAutoresizingMaskIntoConstraints = false;
        
        lblMonth.backgroundColor=Singleton.sharedManager.Color;
        lblEntitlement.backgroundColor=Singleton.sharedManager.Color;
        lblDeduction.backgroundColor=Singleton.sharedManager.Color;
        lblGrossSalary.backgroundColor=Singleton.sharedManager.Color;
        lblNetSalary.backgroundColor=Singleton.sharedManager.Color;

        
        lblMonth.isHidden=true;
        lblEntitlement.isHidden=true;
        lblDeduction.isHidden=true;
        lblGrossSalary.isHidden=true;
        lblNetSalary.isHidden=true;
        
        btnViewPayroll.backgroundColor=Singleton.sharedManager.Color;
            btnViewPayroll.layer.cornerRadius=5
            tableView.tableFooterView = UIView()
        
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
        // Dispose of any resources that can be recreated.
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
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    
    // NSXMLParserDelegate
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName as NSString
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElementName == "PayrollHistoryResult" {
            
            var strPayrollHistory:String=string;
            var strFromTo:String;
            
            if(strPayrollHistory=="-")
            {
                //strFromTo=txtFromMonth.text!+"-"+txtFromYear.text!+" To "+txtToMonth.text!+"-" + txtToYear.text!;
                //lblFromToValue.text=strFromTo;
                lblHeaderText.text="";
                lblFromToValue.text="";
                
                lblMonth.backgroundColor=UIColor.white;
                lblEntitlement.backgroundColor=UIColor.white;
                lblDeduction.backgroundColor=UIColor.white;
                lblGrossSalary.backgroundColor=UIColor.white;
                lblNetSalary.backgroundColor=UIColor.white;

                tableView.isHidden=true;
                
                
                let alertController = UIAlertController(title: "Not Processed", message:
                    "Payroll does not processed for this Period,Check previous month payroll", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                
                lblMonth.backgroundColor=Singleton.sharedManager.Color;
                lblEntitlement.backgroundColor=Singleton.sharedManager.Color;
                lblDeduction.backgroundColor=Singleton.sharedManager.Color;
                lblGrossSalary.backgroundColor=Singleton.sharedManager.Color;
                lblNetSalary.backgroundColor=Singleton.sharedManager.Color;
                
                sarPayrollHistory = strPayrollHistory.components(separatedBy:",");
                tableView.isHidden=false;
                strFromTo=txtFromMonth.text!+"-"+txtFromYear.text!+" To "+txtToMonth.text!+"-" + txtToYear.text!;
                lblHeaderText.text="Payroll History for the month of ";
                lblFromToValue.text=strFromTo;

                
            }
            //print(string);
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
       if(sarPayrollHistory.count>1)
       {
        return (sarPayrollHistory.count/5);
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
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PayrollTableViewCell
        
        /*
        Cell.lblMonth.layer.borderWidth=1;
        Cell.lblMonth.layer.borderColor=UIColor.lightGray.cgColor;
        Cell.lblGrossSalary.layer.borderWidth=1;
        Cell.lblGrossSalary.layer.borderColor=UIColor.lightGray.cgColor;
        Cell.lblEntitlement.layer.borderWidth=1;
        Cell.lblEntitlement.layer.borderColor=UIColor.lightGray.cgColor;
        Cell.lblDeduction.layer.borderWidth=1;
        Cell.lblDeduction.layer.borderColor=UIColor.lightGray.cgColor;
        Cell.lblNetSalary.layer.borderWidth=1;
        Cell.lblNetSalary.layer.borderColor=UIColor.lightGray.cgColor;
 */
        
        if(sarPayrollHistory.count>1)
        {
            
            lblMonth.isHidden=false;
            lblEntitlement.isHidden=false;
            lblDeduction.isHidden=false;
            lblGrossSalary.isHidden=false;
            lblNetSalary.isHidden=false;

        }
        
        var i=0;
        var j=0;
        
        while (i<(sarPayrollHistory.count/5))
        {
            if (indexPath.row==i)
            {
                Cell.lblMonth.text = sarPayrollHistory[j];
                Cell.lblGrossSalary.text=String(format: "%.2f" , Float(sarPayrollHistory[j+1])!);
                Cell.lblEntitlement.text=String(format: "%.2f" ,Float(sarPayrollHistory[j+2])!);
                Cell.lblDeduction.text=String(format: "%.2f" ,Float(sarPayrollHistory[j+3])!);
                Cell.lblNetSalary.text=String(format: "%.2f" ,Float(sarPayrollHistory[j+4])!);
            }
            i+=1;
            j=j+5;
         }
        return Cell;
        
    }
    
    func showFromMonthPicker(){
        //Formate Date
        //fromMonthPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneFromMonthPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelFromMonthPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtFromMonth.inputAccessoryView = toolbar
        // add datepicker to textField
        txtFromMonth.inputView = fromMonthPicker
        
    }
    
    
    /*
    func showFromMonthPicker(){
        //Formate Date
        fromMonthPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneFromMonthPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelFromMonthPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtFromMonth.inputAccessoryView = toolbar
        // add datepicker to textField
        txtFromMonth.inputView = fromMonthPicker
        
    }
    */
    
    func showFromYearPicker(){
        
        //Formate Date
        //fromYearPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
         toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneFromYearPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelYearPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtFromYear.inputAccessoryView = toolbar
        // add datepicker to textField
        txtFromYear.inputView = fromYearPicker
    }
    
    
    func showToMonthPicker(){
        //Formate Date
        //toMonthPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneToMonthPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelToMonthPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtToMonth.inputAccessoryView = toolbar
        // add datepicker to textField
        txtToMonth.inputView = toMonthPicker
        
    }
    
    
    func showToYearPicker(){
        
        //Formate Date
        //toYearPicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneToYearPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelToYearPicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtToYear.inputAccessoryView = toolbar
        // add datepicker to textField
        txtToYear.inputView = toYearPicker
        
    }
    
    
    func doneFromMonthPicker(){
        
        
            //fromMonthPicker.onDateSelected = { (month: Int) in
            self.txtFromMonth.text = fromMonthPicker.months[fromMonthPicker.selectedRow(inComponent:0)]
        //}
        
        
        //txtFromMonth.text = String(describing: fromMonthPicker) //formatter.string(for: fromMonthPicker.month)
       
        //formatter.dateFormat = "MM"
        intFromMonth=Int(fromMonthPicker.selectedRow(inComponent:0))+1
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func doneFromYearPicker(){
       
        
        txtFromYear.text = String(fromYearPicker.years[fromYearPicker.selectedRow(inComponent:0)])
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    func doneToMonthPicker(){
        
        toMonthPicker.resignFirstResponder()
        txtToMonth.text = toMonthPicker.months[toMonthPicker.selectedRow(inComponent:0)]

        //formatter.dateFormat = "MM"
        intToMonth=Int(toMonthPicker.selectedRow(inComponent:0))+1
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func doneToYearPicker(){
        
        txtToYear.text = String(toYearPicker.years[toYearPicker.selectedRow(inComponent:0)])
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelFromMonthPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    func cancelFromYearPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func cancelToMonthPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    func cancelToYearPicker(){
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

    
    
}

