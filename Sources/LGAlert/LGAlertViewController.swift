//
//  LGAlertViewController.swift
//
//  Created by Ludovic Grimbert on 17/07/2020.
//  Copyright © 2020 ludovic grimbert. All rights reserved.
//

import Foundation
import SwiftUI

class LGAlertViewController: UIHostingController<LGAlertView> {
    
    var alertview: LGAlertView
    var isPresented: Binding<Bool>
    
    init(alertview: LGAlertView, isPresented: Binding<Bool>) {
        self.alertview = alertview
        self.isPresented = isPresented
        super.init(rootView: self.alertview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.isPresented.wrappedValue =  false
    }
    
}

