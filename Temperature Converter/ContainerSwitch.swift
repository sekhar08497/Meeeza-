//
//  ContainerSwitch.swift
//  SMS Payroll
//
//  Created by admin on 4/29/18.
//  Copyright © 2018 Web In Dream. All rights reserved.
//

import UIKit

class ContainerSwitch: UIViewController {
    @IBOutlet var firstContainer: UIView!
    
    @IBOutlet var secondContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

       if (Singleton.sharedManager.Android=="1")
       {
        firstContainer.isHidden=false;
        secondContainer.isHidden=true;
        
        }
        else
       {
        
        firstContainer.isHidden=true;
        secondContainer.isHidden=false;
        
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
