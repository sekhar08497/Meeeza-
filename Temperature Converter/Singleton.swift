//
//  Singleton.swift
//  Temperature Converter
//
//  Created by admin on 10/21/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//



public class Singleton {

    var Username: String="";
    var AccessCode: String="";
    var EmployeeName : String="";
    
    var CompanyID: String="";
    
    var Database: String="";
    var WebServicePath: String="";
    var WebsitePath: String="";
    var Color=UIColor(red: 0, green:0, blue: 0, alpha: 0);
    var Logo: String="";
    var isUserLoggedIn :String="false";
    var Android : String="";
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: Singleton {
        struct Static {
            static let instance = Singleton()
        }
        return Static.instance
    }

}
