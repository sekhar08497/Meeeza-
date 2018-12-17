//
//  AboutUs.swift
//  Temperature Converter
//


import UIKit

class AboutUs: UIViewController {

    //@IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //ScrollView.contentSize.height=500;
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
