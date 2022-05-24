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
                            
                          //  myUserSettings.email = credential.email ?? ""
                            
                          //  myUserSettings.firstName = credential.fullName?.givenName ?? ""
                            
                         //   myUserSettings.lastName = credential.fullName?.familyName ?? ""
                            
                            //User apple id
                            let userID = credential.user
                            
                            let email : String = credential.email ?? "No Email Given"
                            
                            let firstName : String = credential.fullName?.givenName ?? "No First Name"
                            
                            let lastName : String  = credential.fullName?.familyName ?? "No Lastname"
                            
                            print("userID: \(userID)")
                            print("email: \(email)")
                            print("firstname: \(firstName)")
                            print("lastName: \(lastName)")
                            
                            //credential.user
                            //    "001108.4616045feab6456eb317c34119985faf.2113"    
                            
                            print("")
                            
                            
                        default:
                            break
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }).frame(height: 50, alignment: .center)
                    .padding()
                    .cornerRadius(8)
                
            }.navigationTitle("")
        }
    }
}







//Preview
struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
