//
//  ThemeManager.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import UIKit
import Foundation


public protocol ThemeManagerProtocol {
    var backgroundColor: UIColor?{ get set }
    var userBackgroundColor: UIColor?{ get set }
    var headerBackgroundColor: UIColor?{ get set }
    
}


class ThemeManager {
    
    static var manager: ThemeManagerProtocol? = {
#if ChatApplication
        return ChatApplication()
#else
        return ChatApplication1()
#endif
    }()
    
    public class var backgroundColor: UIColor? {
        return self.manager?.backgroundColor
    }
    public class var userBackgroundColor: UIColor? {
        return self.manager?.userBackgroundColor
    }
    
    public class var headerBackgroundColor: UIColor? {
        return self.manager?.headerBackgroundColor
    }
}

class ChatApplication: ThemeManagerProtocol {
    var backgroundColor: UIColor? =  .white
    var userBackgroundColor: UIColor? = .yellow
    var headerBackgroundColor: UIColor? = #colorLiteral(red: 0.660077095, green: 0.7782509923, blue: 0.2477290034, alpha: 1)
}

class ChatApplication1: ThemeManagerProtocol {
    var backgroundColor: UIColor? =  .black
    var userBackgroundColor: UIColor? = .systemPurple
    var headerBackgroundColor: UIColor? = .red
}
