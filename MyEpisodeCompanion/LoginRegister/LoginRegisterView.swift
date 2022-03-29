//
//  LoginRegisterView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI
import AuthenticationServices

struct LoginRegisterView: View {
    var body: some View {
        //Text("Hello, Login Registration!")
        //ASAuthorizationAppleID
        NavigationView {
            VStack{
                SignInWithAppleButton(.continue,
                                      onRequest: { request in
                    
                    request.requestedScopes = [.email, .fullName]
                    
                }, onCompletion: { result in
                    
                    switch result {
                    case .success(let auth):
                        
                        switch auth.credential {
                        case let credential as ASAuthorizationAppleIDCredential:
                            
                            myUserSettings.email = credential.email ?? ""
                            
                            myUserSettings.firstName = credential.fullName?.givenName ?? ""
                            
                            myUserSettings.lastName = credential.fullName?.familyName ?? ""
                            
                            //User apple id
                            let userID = credential.user
                        default:
                            break
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }).frame(height: 50, alignment: .center)
                    .padding()
                    .cornerRadius(8)
                
            }.navigationTitle("Sign In")
        }
    }
}







//Preview
struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
