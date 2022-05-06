//
//  UserSettings.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//
//  A settings file that stores basic user settings in the app
//
//

import Foundation


//TODO: isLoggedIn needs to be configured. Store a key for user login data?
//TODO: isValid function to determine if user info is valid


final class UserSettings : ObservableObject {
    
    private enum keys : String, CaseIterable {
        case name, firstName, lastName, email, isLoggedIn, registrationDate, isCheckinReminderApproved, checkinReminderTime, hasWatch
    }
    
    // Resets all user data
    func resetData(){
        keys.allCases.forEach{
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    // The displayed name for the user
    @Published var name : String {
        didSet{
            UserDefaults.standard.set(name, forKey: keys.name.rawValue)
        }
    }
    
    // The first name of the user
    @Published var firstName : String {
        didSet{
            UserDefaults.standard.set(firstName, forKey: keys.firstName.rawValue)
        }
    }
    
    // The last name of the user
    @Published var lastName : String {
        didSet{
            UserDefaults.standard.set(lastName, forKey: keys.lastName.rawValue)
        }
    }
    
    // The email of the user
    @Published var email: String {
        didSet{
            UserDefaults.standard.set(email, forKey: keys.email.rawValue)
        }
    }
    
    // The date that the user registered their account
    @Published var registrationDate : Date {
        didSet{
            UserDefaults.standard.set(registrationDate, forKey: keys.registrationDate.rawValue )
        }
    }
    
    // Does the user want to have routine checkin reminders
    @Published var isCheckinReminderApproved : Bool {
        didSet{
            UserDefaults.standard.set(isCheckinReminderApproved, forKey: keys.isCheckinReminderApproved.rawValue)
        }
    }
    
    // The time the user wants to have routine checkin reminders
    @Published var checkinReminderTime : Date {
        didSet{
            UserDefaults.standard.set(checkinReminderTime, forKey: keys.checkinReminderTime.rawValue)
        }
    }
    
    // Does the user have an apple watch
    @Published var hasWatch : Bool {
        didSet{
            UserDefaults.standard.set(hasWatch, forKey: keys.hasWatch.rawValue)
        }
    }
    
    init(){
        self.name = UserDefaults.standard.object(forKey: keys.name.rawValue) as? String ?? ""
        self.firstName = UserDefaults.standard.object(forKey: keys.firstName.rawValue) as? String ?? ""
        self.lastName = UserDefaults.standard.object(forKey: keys.firstName.rawValue) as? String ?? ""
        self.email = UserDefaults.standard.object(forKey: keys.email.rawValue) as? String ?? ""
        self.registrationDate = UserDefaults.standard.object(forKey: keys.registrationDate.rawValue) as? Date ?? Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
        self.isCheckinReminderApproved = UserDefaults.standard.object(forKey: keys.isCheckinReminderApproved.rawValue) as? Bool ?? false
        self.checkinReminderTime = UserDefaults.standard.object(forKey: keys.checkinReminderTime.rawValue) as? Date ?? Date()
        self.hasWatch = UserDefaults.standard.object(forKey: keys.hasWatch.rawValue) as? Bool ?? false
    }
    
}
