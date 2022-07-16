//
//  ChatSharedClass.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import Foundation
import UIKit

extension String {
    static func getstring(_ message: Any?) -> String {
        guard let strMessage = message as? String else {
            guard let doubleValue = message as? Double else {
                guard let intValue = message as? Int else {
                    guard let int64Value = message as? Int64 else{
                        return ""
                    }
                    return String(int64Value)
                }
                return String(intValue)
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
            guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                return ""
            }
            return formattedNumber
        }
        return strMessage.stringByTrimmingWhiteSpaceAndNewLine()
    }
    func stringByTrimmingWhiteSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
}
class ChatSharedClass: NSObject {
    static let sharedInstance = ChatSharedClass()
    private override init() { }
    func getDictionary(_ dictData: Any?) -> Dictionary<String, Any> {
        guard let dict = dictData as? Dictionary<String, Any> else {
            guard let arr = dictData as? [Any] else {
                return ["":""]
            }
            return getDictionary(arr.count > 0 ? arr[0] : ["":""])
        }
        return dict
    }
}

extension Int {
    static func getint(_ value: Any?) -> Int {
        guard let intValue = value as? Int else {
            let strInt = String.getstring(value)
            guard let intValueOfString = Int(strInt) else { return 0 }
            return intValueOfString
        }
        return intValue
    }
    func dateFromTimeStamp() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}

extension Date {
    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(date: Date())
    }
    
    func isTomorrow() -> Bool {
        return self.isEqualToDateIgnoringTime(date: Date.dateTomorrow())
    }
    
    func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(date: Date.dateYesterday())
    }
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        
        let dateFormatter         = DateFormatter()
        dateFormatter.locale      = Locale.current
        dateFormatter.timeZone    = TimeZone.init(abbreviation: "LOCAL")
        dateFormatter.dateFormat  = format
        let strMonth = dateFormatter.string(from: self)
        
        return strMonth
    }
    static func dateFromString(date: String, withCurrentFormat format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: date) ?? Date()
    }
    func toMillis() -> Int! {
        return Int(self.timeIntervalSince1970*1000)
    }
    func isEqualToDateIgnoringTime(date: Date) -> Bool {
        let dateComponent1 =  Date.currentCalendar().dateComponents([.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal], from: self)
        
        let dateComponent2 = Date.currentCalendar().dateComponents([.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal], from: date)
        
        return (dateComponent1.year == dateComponent2.year) && (dateComponent1.month == dateComponent2.month) && (dateComponent1.day == dateComponent2.day)
    }
    
    static func currentCalendar() -> Calendar {
        var sharedCalendar: Calendar? = nil
        if sharedCalendar == nil {
            sharedCalendar = Calendar.autoupdatingCurrent
        }
        return sharedCalendar!
    }
    static func dateTomorrow() -> Date {
        return Date.dateWithDaysFromNow(days: 1)
    }
    static func dateWithDaysFromNow(days: NSInteger) -> Date {
        return Date().dateByAddingDays(days: days)
    }
    static func dateYesterday() -> Date {
        return Date.dateWithDaysBeforeNow(days: 1)
    }
    static func dateWithDaysBeforeNow(days: NSInteger) -> Date {
        return Date().dateBySubstractingDays(days: days)
    }
    func dateBySubstractingDays(days: NSInteger) -> Date {
        return self.dateByAddingDays(days: days * -1)
    }
    func day1() -> NSInteger {
        let dateComponent = Date.currentCalendar().dateComponents([.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal], from: self)
        return dateComponent.day!
    }
    func month1() -> NSInteger {
        let dateComponent = Date.currentCalendar().dateComponents([.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal], from: self)
        return dateComponent.month!
    }
    func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount = dayRange?.count
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = dayCount
        return calendar.date(from: comp)!
    }
    func dateByAddingDays(days: NSInteger) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        if self.day1() == 1 && days < 0 {
            dateComponents.month = -1
        } else if self.day1() == self.lastDayOfMonth().day1() && days >= 1 {
            dateComponents.month = 1
            switch self.month1() {
            case 2:
                dateComponents.day = dateComponents.day! + 3
            case 4,6,9,11:
                dateComponents.day = dateComponents.day! + 1
            default:
                break
            }
        }
        
        let newDate = Calendar.current.date(byAdding: dateComponents, to: self, wrappingComponents: true)
        return newDate!
    }
}

extension Array {
    func uniqueArray<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
// MARK:- extension of userDetails to save info into UserDefaults
extension UserDefaults {
    func getuserDetails() -> Dictionary<String, Any> {
        guard let dataUser = self.object(forKey: "chatUserDetails") else {
            return ["":""]
        }
        
        guard let userData = dataUser as? Data else {
            return ["":""]
        }
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: userData)
        guard let userLoggedInDetails = unarchiver.decodeObject(forKey: "chatUserDetails") as? Dictionary <String, Any> else {
            unarchiver.finishDecoding()
            return ["":""]
        }
        unarchiver.finishDecoding()
        return userLoggedInDetails
    }
    
    func setuserDetials(loggedInUserDetails:UsersState?) {
        if  String.getstring(loggedInUserDetails?.userId) == "" {
            self.set(nil, forKey: "chatUserDetails")
            self.synchronize()
            return
        }
        let details = loggedInUserDetails?.createDictonary(objects: loggedInUserDetails)
        let userData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: userData)
        archiver.encode(details, forKey: "chatUserDetails")
        archiver.finishEncoding()
        self.set(userData, forKey: "chatUserDetails")
        self.synchronize()
    }
}



extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UITableView {
    func getNumberOfRow(numberofRow count:Int? ,message messages:String? , messageColor:UIColor = .black) -> Int {
        var noDataLbl : UILabel?
        noDataLbl = UILabel(frame: self.frame)
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.boldSystemFont(ofSize: 18)
        noDataLbl?.numberOfLines = 0
        noDataLbl?.text = messages
        noDataLbl?.center = self.center
        noDataLbl?.textColor = messageColor
        noDataLbl?.lineBreakMode = .byTruncatingTail
        self.backgroundView = Int.getint(count) != 0 ? nil : noDataLbl
        return Int.getint(count)
    }
}

extension AppStoryboard {
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    func viewController<T : UIViewController> (viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    class var storyboardID : String {
        return "\(self)"
    }
}

enum AppStoryboard : String {
    case Main
    case Chat
}

let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    //MARK:- Func for downlode image
    func downlodeImage(urlString:String , placeHolder: UIImage?) {
        self.image = placeHolder
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        //MARK:- Check image Store in Cache or not
        if let cachedImage = imageCache.object(forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString) {
            if  let image = cachedImage as? UIImage {
                self.image = image
                print("Find image on Cache : For Key" , urlString.replacingOccurrences(of: " ", with: "%20"))
                return
            }
        }
        print("Conecting to Host with Url:-> \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                    return
                }
            }
            if data == nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.image = image
                    imageCache.setObject(image, forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString)
                }
            }
        }).resume()
    }
}
