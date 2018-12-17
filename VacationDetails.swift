//
//  VacationDetails.swift


import UIKit

class VacationDetails: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate,XMLParserDelegate,UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var rr: UILabel!
    
    @IBOutlet var imgLine: UIImageView!
    @IBOutlet var lblVacationYearText: UILabel!
    @IBOutlet var lblJoinDateText: UILabel!
    @IBOutlet var lblEmployeeNameText: UILabel!
    @IBOutlet var lblEmployeeIDText: UILabel!
    @IBOutlet var lblVacationAsText: UILabel!
    
    @IBOutlet var btnVacation: UIButton!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var sarVacationDetails = [String]();
    let datePicker = UIDatePicker()
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var txtAsOnDate: UITextField!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblJoinDate: UILabel!
    //var strCOID=String();
    @IBOutlet var lblVacationPerYear: UILabel!
    @IBOutlet var lblEmployeeName: UILabel!
    @IBOutlet var lblEmployeeID: UILabel!
    
    var strEmployeeID=String();
    
    @IBAction func btnViewVacationDetails(_ sender:AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true
        {
        
        let strCOID=Singleton.sharedManager.CompanyID;
        let strEmployeeID=Singleton.sharedManager.Username;
        let strAsOnDate=txtAsOnDate.text;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body> <VacationDetails xmlns='"+(strWebSitePath)+"'><strCompanyID>\(strCOID)</strCompanyID><strEmployeeID>\(strEmployeeID)</strEmployeeID><strAsOnDate>\(strAsOnDate!)</strAsOnDate></VacationDetails></soap12:Body></soap12:Envelope>";
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {
      
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker();
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false;
        
        btnVacation.layer.cornerRadius=5;
        btnVacation.backgroundColor=Singleton.sharedManager.Color;
        tableView.tableFooterView = UIView()

        imgLine.isHidden=true;
        //==
        
        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
       
        tableView.tableFooterView = UIView();

        
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
       
        if currentElementName == "VacationDetailsResult" {
            
            var strVacationDetails:String=string;
            sarVacationDetails = strVacationDetails.components(separatedBy:",");
            
            if(strVacationDetails=="-")
            {
                
                let alertController = UIAlertController(title: "Records Not Found", message:
                    "Vacation Records Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            else
            {
            lblEmployeeID.text=Singleton.sharedManager.Username;
            lblEmployeeName.text=Singleton.sharedManager.EmployeeName;
            lblJoinDate.text=sarVacationDetails[0];
            lblVacationPerYear.text=sarVacationDetails[1];
            lblVacationAsText.text="Vacation History As On Date ";
            lblEmployeeIDText.text="Employee ID         :";
            lblEmployeeNameText.text="Employee Name  :";
            lblJoinDateText.text="Join Date              :";
            lblVacationYearText.text="Vac Per Year :";
             imgLine.isHidden=false;
            
            }
          
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
            
            
            //print(string);
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(sarVacationDetails.count>0)
        {
        return 1;
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
    
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VacationTableViewCell
        
        
        Cell.lblCDaysDescription.backgroundColor=Singleton.sharedManager.Color
        Cell.lblEVDaysDescription.backgroundColor=Singleton.sharedManager.Color
       
        Cell.lblCDaysDescription.text=" Consumed Vacation Days";
        Cell.lblEVDaysDescription.text=" Available Vacation Days";
        
        Cell.lblCDaysDescription.isHidden=false;
        
        Cell.lblCDaysValue.layer.borderColor=UIColor.lightGray.cgColor;
        Cell.lblEVDaysValue.layer.borderColor=UIColor.lightGray.cgColor;
        
    
        Cell.lblCDaysValue.layer.borderWidth=0.4;
        Cell.lblEVDaysValue.layer.borderWidth=0.4;
        
        var i=0,j=0;
        
        
            Cell.lblCDaysValue.text=sarVacationDetails[i+2];
            Cell.lblEVDaysValue.text=sarVacationDetails[i+3];
        
          
        
        return Cell;
    }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(VacationDetails.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(VacationDetails.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtAsOnDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtAsOnDate.inputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtAsOnDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
}
