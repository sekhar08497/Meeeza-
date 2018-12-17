

import UIKit

class ViewEmployeeProfile: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate,UITableViewDataSource, UITableViewDelegate,XMLParserDelegate {
    
    @IBOutlet var lblLabel: UILabel!
    @IBOutlet var lblEmployeeName: UILabel!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var imgProfilePhoto: UIImageView!
   
    @IBOutlet var tableView: UITableView!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var sarEmployeeProfile = [String]();
   
    var strEmployeeID=String()
    
  
    @IBOutlet var lblEmployeeID: UILabel!
    
    @IBOutlet var lblDepartment: UILabel!
    
    @IBOutlet var lblPosition: UILabel!
    
    @IBOutlet var lblEmailID: UILabel!
    
    @IBOutlet var lblDateOfJoin: UILabel!
    
    @IBOutlet var lblDateOfBirth: UILabel!
    
    @IBOutlet var lblNationality: UILabel!
    
    @IBOutlet var lblAddress1: UILabel!
    
    @IBOutlet var lblAddress2: UILabel!
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
           
            if revealViewController() != nil {
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        //==
        
        //let image: UIImage = UIImage(named: "User")!
        //imgProfilePhoto.layer.borderWidth = 1.0
        //imgProfilePhoto.layer.masksToBounds = false
        //imgProfilePhoto.layer.borderColor = UIColor.white.cgColor
        //imgProfilePhoto.layer.cornerRadius = image.size.width/2
        //imgProfilePhoto.clipsToBounds = true
        
        
        let strLogoName=Singleton.sharedManager.Logo;
        let urls = URL(string:"http://smsp.smsgroupco.com/Images/Logo/"+strLogoName);
        let strLogo = try? Data(contentsOf: urls!);
        
        //==
        
        
         let logo = UIImage(data:strLogo!)
         let imageView = UIImageView(image:logo)
         self.navigationItem.titleView = imageView
        
        let strEmployeeID=Singleton.sharedManager.Username;
        let strWebSitePath=Singleton.sharedManager.WebsitePath;

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeProfiles xmlns='"+(strWebSitePath)+"'><strEmployeeID>\(strEmployeeID)</strEmployeeID></EmployeeProfiles></soap12:Body></soap12:Envelope>";
        
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
        
        tableView.tableFooterView = UIView()
            
        }
        else
        {
            Alert();
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
        
        if currentElementName == "EmployeeProfilesResult" {
            
            let strEmployeeProfile:String=string;
            
            sarEmployeeProfile = strEmployeeProfile.components(separatedBy:",");
            print(strEmployeeProfile)
          
            
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
      
        return (sarEmployeeProfile.count-2);
    }
    
    
    //"select a.fEmpID,a.fEmpName,a.fAddress1,a.fAddress2,a.fEmail," +
    //"a.fDOB,a.fDOJ,b.fDeptName,c.fPositionName," +
    //"d.fBrName,e.fNationalityName,a.fLastLoginDate,a.fPhotoFileName from
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
        
        Cell.lblDescription.backgroundColor=Singleton.sharedManager.Color
        
        if (indexPath.row==0)
        {
            
            Cell.lblDescription.text=" Employee Name";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            Cell.lblValue.numberOfLines=2;
            Cell.lblValue.lineBreakMode=NSLineBreakMode.byWordWrapping;
            
        }
        if (indexPath.row==1)
        {
            Cell.lblDescription.text=" Employee ID";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
        }
        if (indexPath.row==2)
        {
            Cell.lblDescription.text=" Department";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
        }
        
        if (indexPath.row==3)
        {
            Cell.lblDescription.text=" Position";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            Cell.lblValue.numberOfLines=2;
            Cell.lblValue.lineBreakMode=NSLineBreakMode.byWordWrapping;
            
        }
        
        
        if (indexPath.row==4)
        {
            Cell.lblDescription.text=" Branch";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];        }
        
        if (indexPath.row==5)
        {
            Cell.lblDescription.text=" Email ID";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];        }
        
        if (indexPath.row==6)
        {
            Cell.lblDescription.text=" Date Of Join";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];        }
        

        if (indexPath.row==7)
        {
            Cell.lblDescription.text=" Date Of Birth";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
        }
        
        if (indexPath.row==8)
        {
            Cell.lblDescription.text=" Nationality";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
        }
        
        if (indexPath.row==9)
        {
            Cell.lblDescription.text=" Bank Name";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
        }
        
        if (indexPath.row==10)
        {
            Cell.lblDescription.text=" Bank Account No";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            
        }
        
        if (indexPath.row==11)
        {
            Cell.lblDescription.text=" Address1";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            Cell.lblValue.numberOfLines=2;
            Cell.lblValue.lineBreakMode=NSLineBreakMode.byWordWrapping;
        }
        
        if (indexPath.row==12)
        {
            Cell.lblDescription.text=" Address2";
            Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            Cell.lblValue.numberOfLines=2;
            Cell.lblValue.lineBreakMode=NSLineBreakMode.byWordWrapping;
            
        }
        
       // if (indexPath.row==13)
       // {
         //   Cell.lblDescription.text="";
           // Cell.lblValue.text=sarEmployeeProfile[indexPath.row];
            
       // }

    
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
