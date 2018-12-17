import UIKit

class YearPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var years: [Int]!
    
    
    
    var year: Int = 0 {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 0, animated: true)
        }
    }
    
    var onDateSelected: ((_ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...200 {
                years.append(year-8)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        
        self.delegate = self
        self.dataSource = self
        
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        self.selectRow((currentYear-2010), inComponent: 0, animated: false)
        
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            
        case 0:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let year = years[self.selectedRow(inComponent: 0)]
        if let block = onDateSelected {
            block(year)
        }
        
        self.year = year
    }
    
}
