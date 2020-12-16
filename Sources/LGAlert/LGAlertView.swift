//
//  LGAlertView.swift
//
//  Created by Ludovic Grimbert on 17/07/2020.
//  Copyright © 2020 ludovic grimbert. All rights reserved.
//

import Foundation
import SwiftUI

struct LGAlertView: View {
    
    static var currentAlertVCReference: LGAlertViewController?
    
    @Binding var visible: Bool
    @State var show: Bool = false
    
    let alert: LGAlert
    
    public var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.25))
                .edgesIgnoringSafeArea(.all)
            
            if show {
                alert.transition(self.alert.animation.transition)
            }
            
        }.onAppear{
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                withAnimation {
                    if self.visible {
                        self.show = true
                    }
                }
            }
        }
    }
}

extension View {
    
    public func LGalert(isPresented: Binding<Bool>, content: () -> LGAlert) -> some View {
        
        let alertView = LGAlertView(visible: isPresented, alert: content())
        let alertVC = LGAlertViewController(alertview: alertView, isPresented: isPresented)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.view.backgroundColor = UIColor.clear
        alertVC.modalTransitionStyle = .crossDissolve
                
        if isPresented.wrappedValue {
            if LGAlertView.currentAlertVCReference == nil {
                LGAlertView.currentAlertVCReference = alertVC
            }
            
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            rootVC?.present(alertVC, animated: true, completion: nil)
        } else {
            alertVC.dismiss(animated: true, completion: nil)
        }
        return self
    }
}
