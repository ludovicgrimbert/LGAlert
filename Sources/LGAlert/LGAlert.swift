//
//  LGAlert.swift
//
//  Created by Ludovic Grimbert on 17/07/2020.
//  Copyright © 2020 ludovic grimbert. All rights reserved.
//

import Foundation

import SwiftUI
import LGNeumorphism
import CustomFont

public struct LGAlert: View {
        
    /// Alert Fields
    var title: Text
    var fontName: String
    var style: UIFont.TextStyle
    var weight: Font.Weight
    var imageName: String?
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    var imagePaddingTop: CGFloat
    var buttonStack: [LGAlert.Button]
    
    /// Theme and Animation
    var theme = LGAlert.Theme()
    var animation = LGAlert.LGAnimation()
    
    public init(title: Text,
                fontName: String = "Avenir",
                style: UIFont.TextStyle = .title2,
                weight: Font.Weight = .light,
                imageName: String?,
                imageWidth: CGFloat = 55,
                imageHeight: CGFloat = 55,
                imagePaddingTop: CGFloat = 50,
                buttonStack: [LGAlert.Button] = [LGAlert.Button.default()],
                theme: LGAlert.Theme = LGAlert.Theme(),
                animation: LGAlert.LGAnimation = .defaultEffect()) {
        self.title = title
        self.fontName = fontName
        self.style = style
        self.weight = weight
        self.imageName = imageName
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.imagePaddingTop = imagePaddingTop
        self.buttonStack = buttonStack
        self.theme = theme
        self.animation = animation
    }
    
    public var body: some View {
        
        ZStack {
            VStack {
                Image(self.imageName ?? "")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
                    .padding(.top, imagePaddingTop)
                
                self.title.padding(.init(top: 35, leading: 25, bottom: 15, trailing: 25))
                    .multilineTextAlignment(.center)
                    .foregroundColor(theme.alertTextColor)
                     .customFont(name: fontName, style: style, weight: weight)
                if buttonStack.count < 3 {
                    HStack {
                        ForEach((0...(buttonStack.count)-1), id: \.self) {
                            self.buttonStack[$0]
                                .background(Color.clear)
                                .foregroundColor(self.theme.defaultButtonTextColor)
                        }
                    }.padding()
                } else {
                    VStack {
                        ForEach((0...(buttonStack.count)-1), id: \.self) {
                            self.buttonStack[$0]
                                .background(self.theme.defaultButtonColor)
                                .foregroundColor(self.theme.defaultButtonTextColor)
                                .padding(.bottom, 10)
                        }
                    }.padding()
                }
            }.background(LGAlert.Window(color: theme.windowColor, cornerRadius: theme.cornerRadius, opacity: theme.opacity))
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .padding()
            .cornerRadius(theme.cornerRadius)
        }
    }
}

//*******************

typealias SystemButton = Button
extension LGAlert {
    
    enum ButtonType {
        case `default`
    }
    public struct Button: View {
        
        let text: Text
        let width: CGFloat
        let height: CGFloat
        var isNeumorphism: Bool
        var fontName: String
        var style: UIFont.TextStyle
        var weight: Font.Weight
        var color: Color
        var buttonType: LGAlert.ButtonType = .default
        
        let dismissAction: () -> Void = {
            LGAlertView.currentAlertVCReference?.dismiss(animated: true, completion: nil)
            LGAlertView.currentAlertVCReference = nil
        }
        
        var buttonAction: (() -> Void)?
        
        private init(text: Text,
                     width: CGFloat,
                     height: CGFloat,
                     isNeumorphism: Bool,
                     fontName: String,
                     style: UIFont.TextStyle,
                     weight: Font.Weight,
                     color: Color,
                     buttonType: LGAlert.ButtonType,
                     action: (() -> Void)? = {}) {
            self.text = text
            self.width = width
            self.height = height
            self.isNeumorphism = isNeumorphism
            self.fontName = fontName
            self.style = style
            self.weight = weight
            self.color = color
            self.buttonType = buttonType
            self.buttonAction = action
        }
        
        public var body: some View {
            SystemButton(action: {
                if let action = self.buttonAction {
                    action()
                }
                self.dismissAction()
            }, label: {
                ZStack{
                    if isNeumorphism { LGNeumorphismView(style: .roundedRectangle(cornerRadius: 25),
                                                         level: .low,
                                                         vision: .shadow,
                                                         width: width,
                                                         height: height,
                                                         color: color) }
                    
                    text.frame(width: width, height: height, alignment: .center)
                        .customFont(name: fontName, style: style, weight: weight)
                        .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            })
        }
        public static func `default`(_ label: Text = Text("Ok"),
                                     width: CGFloat = 50,
                                     height: CGFloat = 50,
                                     isNeumorphism: Bool = false,
                                     fontName: String = "Helvetica Neue",
                                     style: UIFont.TextStyle = .body,
                                     weight: Font.Weight = .light,
                                     color: Color = Color.white,
                                     action: (() -> Void)? = {}) -> LGAlert.Button {
            return LGAlert.Button(text: label,
                                  width: width,
                                  height: height,
                                  isNeumorphism: isNeumorphism,
                                  fontName: fontName,
                                  style: style,
                                  weight: weight,
                                  color: color,
                                  buttonType: .default,
                                  action: action)
        }
    }
}

//***********************************

extension LGAlert {
    
    struct Window: View {
        
        var windowColor: Color
        var opacity: Double
        var cornerRadius: CGFloat
        
        public init(color: Color, cornerRadius: CGFloat, opacity: Double) {
            self.windowColor = color
            self.opacity = opacity
            self.cornerRadius = cornerRadius
        }
        
        var body: some View {
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .foregroundColor(windowColor.opacity(opacity))
                .cornerRadius(cornerRadius)
        }
    }
}

//*****************************

extension LGAlert {
    
    public struct LGAnimation {
        
        let transition: AnyTransition
        
        public init() {
            self = LGAlert.LGAnimation.defaultEffect()
        }
        
        private init(transition: AnyTransition) {
            self.transition = transition
        }
        
        public static func custom(withTransition transition: AnyTransition) -> LGAlert.LGAnimation {
            return LGAlert.LGAnimation(transition: transition)
        }
        
        public static func defaultEffect() -> LGAlert.LGAnimation {
            let transition = AnyTransition.scale(scale: 1.2).combined(with: .opacity).animation(.easeOut(duration: 0.15))
            return LGAlert.LGAnimation(transition: transition)
        }
        
        public static func classicEffect() -> LGAlert.LGAnimation {
            let spring = Animation.spring(response: 0.25, dampingFraction: 0.6, blendDuration: 0.25)
            let transition = AnyTransition.scale.combined(with: .opacity).animation(spring)
            return LGAlert.LGAnimation(transition: transition)
        }
        
        public static func zoomEffect() -> LGAlert.LGAnimation {
            let transition = AnyTransition.scale.combined(with: .opacity)
            return LGAlert.LGAnimation(transition: transition)
        }
        
        public static func fadeEffect() -> LGAlert.LGAnimation {
            let transition = AnyTransition.opacity
            return LGAlert.LGAnimation(transition: transition)
        }
        
        public static func slideUpEffect() -> LGAlert.LGAnimation {
            let transition = AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeOut)
            return LGAlert.LGAnimation(transition: transition)
        }
    }
}

//*********************************

extension LGAlert {
    
    public struct Theme {
        
        /// Default theme
        public static var defaultTheme: LGAlert.Theme = custom()
        
        /// General Properties
        var windowColor: Color
        var alertTextColor: Color
        var cornerRadius: CGFloat
        var opacity: Double
        
        /// Button Properties
        var defaultButtonColor: Color
        var defaultButtonTextColor: Color
        
        // Public init
        public init() {
            self = LGAlert.Theme.defaultTheme
        }
        
        // Private init
        private init(windowColor: Color, alertTextColor: Color, cornerRadius: CGFloat, opacity: Double, defaultButtonColor: Color, defaultButtonTextColor: Color) {
            self.windowColor = windowColor
            self.alertTextColor = alertTextColor
            self.cornerRadius = cornerRadius
            self.opacity = opacity
            self.defaultButtonColor = defaultButtonColor
            self.defaultButtonTextColor = defaultButtonTextColor
        }
        
        /// Predefined themes
        public static func custom(windowColor: Color = Color.white,
                                  alertTextColor: Color = Color.black,
                                  cornerRadius: CGFloat = 25,
                                  opacity: Double = 1.0,
                                  defaultButtonColor: Color = Color.clear,
                                  defaultButtonTextColor: Color = Color.black) -> LGAlert.Theme {
            let theme = LGAlert.Theme(windowColor: windowColor,
                                      alertTextColor: alertTextColor,
                                      cornerRadius: cornerRadius,
                                      opacity: opacity,
                                      defaultButtonColor: defaultButtonColor,
                                      defaultButtonTextColor: defaultButtonTextColor)
            return theme
        }
    }
}

