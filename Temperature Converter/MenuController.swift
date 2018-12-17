

import UIKit
import CoreTelephony
class MenuController: UIViewController,UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var viContainer: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var lblEmployeeName: UILabel!
    
    var arrayTitle = [String]();
    var arrayIcon = [String]();

    var arrayHeading = [String]();
    var arrayLine = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // UIApplication.shared.statusBarStyle = .lightContent
        
        //UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        
        statusBar.backgroundColor = UIColor.lightGray
        
   var strInsurance="";
        if(Singleton.sharedManager.Database=="EKPayroll" || Singleton.sharedManager.Database=="TestDatabase" || Singleton.sharedManager.Database=="Ahlan")
        {
         arrayTitle = ["","View Employee Profile", "PaySlip", "Attendance","GOSI Details","Employee Payroll History","","","About Us","Change Password","Logout"]
         arrayIcon = ["","naccount2","nPaySlip2","nAttendance2","nGOSI2","nHistory2","","","nAboutUs2","nPassword2","nLogout2"]
        }
        else
        {
         
            if(Singleton.sharedManager.Database=="Swppayroll_Oman")
            {
                
                strInsurance="PASI Details"
            }
            else
            {
                strInsurance="GOSI Details"
                
            }
            arrayTitle = ["","View Employee Profile","Package", "PaySlip",strInsurance,"Employee Payroll History","","","About Us","Change Password","Logout"]
            arrayIcon = ["","naccount2","nPaySlip2","nPaySlip2","nGOSI2","nHistory2","","","nAboutUs2","nPassword2","nLogout2"]
        }
        arrayHeading = ["Services","", "", "", "","","","Settings","","",""]
        arrayLine = ["","","","","","","Line","","","",""]

        self.tableView.dataSource = self
        self.tableView.delegate = self
        viContainer.backgroundColor=Singleton.sharedManager.Color
        lblEmployeeName.text=Singleton.sharedManager.EmployeeName
        
        //self.view.endEditing(true);
        resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell

        Cell.lblEmployeeName.text = arrayTitle[indexPath.row]
        Cell.imgIcon.image = UIImage(named: arrayIcon[indexPath.row])
        Cell.imgSideHeading.text=arrayHeading[indexPath.row]
        Cell.imgLine.image=UIImage(named: arrayLine[indexPath.row])
        return Cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Singleton.sharedManager.Database=="EKPayroll" || Singleton.sharedManager.Database=="TestDatabase" || Singleton.sharedManager.Database=="Ahlan")
        {
        switch (indexPath.row) {
          
        case 1:
            
            
            if Reachability.isConnectedToNetwork() == true
            {
                self.performSegue(withIdentifier: "ViewEmployeeProfile", sender: self)
            }
            else
            {
                Alert();
            }
            
            break
        case 2:
            if Reachability.isConnectedToNetwork() == true
            {
                 self.performSegue(withIdentifier: "PaySlip", sender: self)
            }
            else
            {
                Alert();
            }
            
           
            break
        case 3:
            if Reachability.isConnectedToNetwork() == true
            {
               self.performSegue(withIdentifier: "Attendance", sender: self)
            }
            else
            {
                Alert();
            }
            
            break
     //   case 4:
       //     if Reachability.isConnectedToNetwork() == true
         //   {
           //    self.performSegue(withIdentifier: "VacationHistory", sender: self)
            //}
           // else
           // {
             //   Alert();
           // }
            
           // break
        case 4:
            
            if Reachability.isConnectedToNetwork() == true
            {
               self.performSegue(withIdentifier: "GOSI", sender: self)
            }
            else
            {
                Alert();
            }
            
            
            break
            
        case 5:
            if Reachability.isConnectedToNetwork() == true
            {
               self.performSegue(withIdentifier: "EmployeePayrollHistory", sender: self)
            }
            else
            {
                Alert();
            }
            
            break
        case 8:
            if Reachability.isConnectedToNetwork() == true
            {
                self.performSegue(withIdentifier: "AboutUs", sender: self)
            }
            else
            {
                Alert();
            }
            
            break
        case 9:
            if Reachability.isConnectedToNetwork() == true
            {
               self.performSegue(withIdentifier: "ChangePassword", sender: self)
            }
            else
            {
                Alert();
            }
            
            break
        case 10:
            
            UserDefaults.standard.set("false", forKey:"isUserLoggedIn")
            
           UserDefaults.standard.set(Singleton.sharedManager.Username, forKey:"Username")
            
            UserDefaults.standard.set(Singleton.sharedManager.AccessCode, forKey:"AccessCode")
            
            UserDefaults.standard.set("", forKey:"EmployeeName")
            
           
            UserDefaults.standard.set("", forKey: "CompanyID")
            
           
            UserDefaults.standard.set("", forKey: "Database")
            
           
            UserDefaults.standard.set("", forKey:"WebServicePath" )
            
            
            UserDefaults.standard.set("", forKey: "WebsitePath")
            
            
            UserDefaults.standard.set("", forKey:"Color" )
            
            
           
            UserDefaults.standard.set("", forKey: "Logo")
            UserDefaults.standard.set("0", forKey: "Android")
            
            
            
            UserDefaults.standard.synchronize()
            
            
            self.performSegue(withIdentifier: "Logout", sender: self)
            break
            
        default:
            break
        }
        }
       
        else
        {
            switch (indexPath.row) {
                
            case 1:
                if Reachability.isConnectedToNetwork() == true
                {
                   self.performSegue(withIdentifier: "ViewEmployeeProfile", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
            case 2:
                if Reachability.isConnectedToNetwork() == true
                {
                    self.performSegue(withIdentifier: "Package", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
            case 3:
                if Reachability.isConnectedToNetwork() == true
                {
                  self.performSegue(withIdentifier: "PaySlip", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
           // case 4:
                
             //   if Reachability.isConnectedToNetwork() == true
               // {
                 //  self.performSegue(withIdentifier: "VacationHistory", sender: self)
               // }
               // else
               // {
                 //   Alert();
               // }
                
              //  break
            case 4:
                
                if Reachability.isConnectedToNetwork() == true
                {
                   self.performSegue(withIdentifier: "GOSI", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
                
            case 5:
                if Reachability.isConnectedToNetwork() == true
                {
                  self.performSegue(withIdentifier: "EmployeePayrollHistory", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
            case 8:
                if Reachability.isConnectedToNetwork() == true
                {
                    self.performSegue(withIdentifier: "AboutUs", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
            case 9:
                if Reachability.isConnectedToNetwork() == true
                {
                    self.performSegue(withIdentifier: "ChangePassword", sender: self)
                }
                else
                {
                    Alert();
                }
                
                break
            case 10:
                
                UserDefaults.standard.set("false", forKey:"isUserLoggedIn")
                
                UserDefaults.standard.set(Singleton.sharedManager.Username, forKey:"Username")
                UserDefaults.standard.set(Singleton.sharedManager.AccessCode, forKey:"AccessCode")
                
                UserDefaults.standard.set("", forKey:"EmployeeName")
                
                
                UserDefaults.standard.set("", forKey: "CompanyID")
                
                
                UserDefaults.standard.set("", forKey: "Database")
                
                
                UserDefaults.standard.set("", forKey:"WebServicePath" )
                
                
                UserDefaults.standard.set("", forKey: "WebsitePath")
                
                
                UserDefaults.standard.set("", forKey:"Color" )
                
                
                
                UserDefaults.standard.set("", forKey: "Logo")
                
                 UserDefaults.standard.set("0", forKey: "Android")
                
                UserDefaults.standard.synchronize()
                

                self.performSegue(withIdentifier: "Logout", sender: self)
                break
                
            default:
                break
            }

            
        }
    }
    

    
}
