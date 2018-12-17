//
//  GOSIDetails.swift
//  Temperature Converter


import UIKit

class GOSIDetails: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate,UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var btnGOSI: UIButton!
    @IBOutlet var lblMonthDetails: UILabel!
    
    @IBOutlet var btnCurrent: UIButton!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var strEmployeeID:NSString = ""
    var strEmployeeName:NSString = ""
    var intMonth:NSInteger=0;
    let monthPicker = MonthPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170))
    let yearPicker = YearPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 170))
    var strShortMonth:NSString=""
    var sarGOSI = [String]();

    @IBOutlet var txtMonth: UITextField!
    
    @IBOutlet var txtYear: UITextField!
    
    @IBOutlet var lblHeading: UILabel!
  
    @IBAction func btnGOSIDetails(_ sender: AnyObject) {
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        strEmployeeID=Singleton.sharedManager.Username as NSString;
        strEmployeeName=Singleton.sharedManager.EmployeeName as NSString;
        
        let strMonth=String(intMonth+1);
        let strYear=txtYear.text;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body> <GOSI xmlns='"+(strWebSitePath)+"'> <strEmployeeID>\(strEmployeeID)</strEmployeeID><strYear>\(strYear!)</strYear><intMonth>\(strMonth)</intMonth></GOSI></soap12:Body></soap12:Envelope>";
        
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
            
        if(txtYear.text=="" || txtMonth.text=="")
        {
            lblMonthDetails.text="";
        }
        else
        {
            if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
                lblMonthDetails.text="PASI For The Month of "+String(strShortMonth)+"-"+txtYear.text!;
            }
            else
            {
                lblMonthDetails.text="GOSI For The Month of "+String(strShortMonth)+"-"+txtYear.text!;
                
            }
            
        }
            
        }
        else
        {
            Alert();
        }

    }
    
    
    @IBAction func btnPrevious(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
        let date = Date()
        let calendar = Calendar.current
        
        var year = calendar.component(.year, from: date)
        var month:NSInteger  = (calendar.component(.month, from: date)-1)
        
        if(month==0)
        {
            
            month=11;
        }
        
        var monthValue = (calendar.component(.month, from: date))
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        if(monthValue==1)
        {
            
            monthValue=12;
            year-=1;
        }
        else
        {
            
            monthValue-=1;
        }

        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month-1] as! String
        
        if(Singleton.sharedManager.Database=="Swppayroll_Oman")
        {
            lblMonthDetails.text = "PASI for the month of "+monthSymbol+"-"+String(year);
        }
        else
        {
            lblMonthDetails.text = "GOSI for the month of "+monthSymbol+"-"+String(year);
            
        }
        LoadData(strYears: String(year),strMonths: String(monthValue));
        
        }
        else
        {
            Alert();
        }
        
    }
    @IBAction func btnCurrent(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month:NSInteger = (calendar.component(.month, from: date)-1)
        
        let monthValue = calendar.component(.month, from: date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month] as! String
       
        if(Singleton.sharedManager.Database=="Swppayroll_Oman")
        {
        lblMonthDetails.text = "PASI for the month of "+monthSymbol+"-"+String(year);
        }
        else
        {
            lblMonthDetails.text = "GOSI for the month of "+monthSymbol+"-"+String(year);
            
        }
        LoadData(strYears: String(year),strMonths: String(monthValue));

        }
        else
        {
            Alert();
        }
        
        
    }
    
    func LoadData(strYears: String,strMonths : String)
    {
        strEmployeeID=Singleton.sharedManager.Username as NSString;
        strEmployeeName=Singleton.sharedManager.EmployeeName as NSString;
        
        txtMonth.text="";
        txtYear.text="";
        
        let strYear=strYears;
        let strMonth=strMonths;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body> <GOSI xmlns='"+(strWebSitePath)+"'> <strEmployeeID>\(strEmployeeID)</strEmployeeID><strYear>\(strYear)</strYear><intMonth>\(strMonth)</intMonth></GOSI></soap12:Body></soap12:Envelope>";
        
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
        
        showMonthPicker();
        showYearPicker();

        self.monthPicker.translatesAutoresizingMaskIntoConstraints = false;
        self.yearPicker.translatesAutoresizingMaskIntoConstraints = false;
        
        tableView.tableFooterView = UIView()
        
        btnPrevious.backgroundColor=Singleton.sharedManager.Color
        btnCurrent.backgroundColor=Singleton.sharedManager.Color
        
        btnCurrent.layer.cornerRadius=25
        btnPrevious.layer.cornerRadius=25
        
        if(Singleton.sharedManager.Database=="Swppayroll_Oman")
        {
            lblHeading.text="PASI DETAIL";
        }
        else
        {
          lblHeading.text="GOSI DETAIL";
            
        }
        
        
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
        
        btnGOSI.backgroundColor=Singleton.sharedManager.Color;
        btnGOSI.layer.cornerRadius=5
        
    

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
        print(xmlParser)
    }
    
    
    // NSXMLParserDelegate
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName as NSString
        
        print(currentElementName);
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        var strGOSI:String="";
        if currentElementName == "GOSIResult"
        {
            
            strGOSI=string;
            sarGOSI = strGOSI.components(separatedBy:",");
         
            if(strGOSI=="-")
            {
                lblMonthDetails.text = "";
                let alertController = UIAlertController(title: "No Records", message:
                    "Records Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            //print(string);
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
        }
        
        
       
    }
    
    func showMonthPicker(){
        //Formate Date
       // monthPicker.datePickerMode = .date
        
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
    
    
    func showYearPicker(){
        //Formate Date
       // yearPicker.datePickerMode = .date
        
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
      //  let formatter = DateFormatter()
      //  formatter.dateFormat = "MMMM"
        
        txtMonth.text = monthPicker.months[monthPicker.selectedRow(inComponent:0)]
        
       // formatter.dateFormat = "MM"
        intMonth=Int(monthPicker.selectedRow(inComponent:0))
        
       // formatter.dateFormat = "MMM"
        strShortMonth=String(monthPicker.months[monthPicker.selectedRow(inComponent:0)]) as! NSString

        
        //dismiss date picker dialog
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
        //make sure you use the relevant array sizes
        if(sarGOSI.count>1)
        {
            
                return (sarGOSI.count+1);
            
        
        }
        else{
            
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
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GOSITableViewCell
        Cell.lblDescription.backgroundColor=Singleton.sharedManager.Color


        Cell.lblDescription.text="";
        Cell.lblValue.text="";
        
        if (indexPath.row==0)
        {
            Cell.lblDescription.text=" Employee ID";
            Cell.lblValue.text=strEmployeeID as String;
        }
        if (indexPath.row==1)
        {
            Cell.lblDescription.text=" Employee Name";
            Cell.lblValue.text=strEmployeeName as String;
        }
        
        if (indexPath.row==2)
        {
            if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
            Cell.lblDescription.text=" PASI Basic";
            }
            else
            {
                Cell.lblDescription.text=" GOSI Basic";
                
            }
            Cell.lblValue.text=currencyFormatter.string(from: Float(sarGOSI[0]) as! NSNumber);
        }
        
        if (indexPath.row==3)
        {
            if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
                Cell.lblDescription.text=" Employee PASI";
            }
            else
            {
                Cell.lblDescription.text=" Employee GOSI";
                
            }
           
             Cell.lblValue.text=currencyFormatter.string(from: Float(sarGOSI[1]) as! NSNumber);
        }
        
        /*
        if (indexPath.row==4)
        {
            if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
                Cell.lblDescription.text=" Company PASI";
                Cell.lblValue.text=currencyFormatter.string(from: Float(sarGOSI[2]) as! NSNumber);
            }
            if(Singleton.sharedManager.Database=="Swppayroll")
            {
                Cell.lblDescription.text=" Company GOSI";
                Cell.lblValue.text=currencyFormatter.string(from: Float(sarGOSI[2]) as! NSNumber);
            }
            if(Singleton.sharedManager.Database=="EKPayroll")
            {
            Cell.lblValue.isHidden=true;
            Cell.lblDescription.isHidden=true;
            
            }
        }
    */
        
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



