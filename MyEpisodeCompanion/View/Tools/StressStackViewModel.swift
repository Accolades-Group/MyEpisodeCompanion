//
//  StressStackViewModel.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/21/22.
//

import Foundation
import CoreData
import SwiftUI

final class StressStackViewModel : ObservableObject {

    @Published var stressName : String = ""
    @Published var stressDescription : String = ""
    @Published var stressWeight : Int = 0
    @Published var addDate : Date = Date.now
    
    @Published var isStressorViewEnabled: Bool = false
    @Published var isStressorPromptEnabled : Bool = false
    @Published var isDeleteSelectorEnabled : Bool = false
    @Published var isDeleteConfirmationPresented : Bool = false
    @Published var isAddEditConfirmationPresented : Bool = false
    
    @Published var selectedStressor : Stressor? = nil
    

    @Published var totalWeight : Int = 0
    @Published var rowCount : Int = 0
    @Published var colCount : Int = 3
    @Published var stressCount : Int = 0
    
    func recalculate(_ stressors : [Stressor]){
        
        totalWeight = 0
        stressCount = stressors.count
        // 0-3 = 1 ; 4 = 2; 7 = 3;
        
        rowCount = stressCount / colCount
        
        if stressCount % colCount != 0 {
            rowCount += 1
        }
        //
        
       // rowCount = stressors.count < 3 ? 1 : Int(ceil(Double(stressors.count/3))) //TODO: Is this all necessary? lol
        
        stressors.forEach{ stress in
            totalWeight += Int(stress.weight)
        }
    }
    
    func cancelButton() {
        isStressorPromptEnabled = false
        isStressorViewEnabled = false
        selectedStressor = nil
    }
    
    
    // STRESSOR PLACEMENT /////////////////
    
    /** Returns the row that the stressor is in */
    func getRow(_ index : Int) -> Int {
        return 1 + Int(ceil(Double(index / colCount)))
        //return index/colCount
    }
    /** Returns the column that the stressor is in */
    func getColumn(_ index : Int) -> Int{
        return index % 3
    }
    
    /** Gets the Y offset position based on the height of the container (passed in from Geometry Reader) and the index of the stressor object */
    func getYOffset(_ size : CGSize, _ index : Int) -> CGFloat{
        
        let objectHeight = size.width/6
        let areaHeight = size.height
                // height of 1st row      minus      height of object * the row it's on
        return (areaHeight - objectHeight) - (objectHeight * CGFloat(getRow(index) + 1))    }
    
    /** Gets the X ofset based on the width of the screen and the given index of the stressor object. If the object is in the top row, it centers the object based on how many stressors are in that row. */
    func getXOffset(index : Int) -> CGFloat{
        
        let w:CGFloat = UIScreen.main.bounds.width/3//150//Stressor.init().width
        var offset = (CGFloat(getColumn(index)) * w)
        
        if(isTopRow(index: index)){
            let rem = stressCount % 3
            if(rem == 1){
                offset += w
            }else if(rem == 2){
                offset += w/2
            }
        }
        //else
        return offset
    }
    
    
    
    /** Returns true if the given object is in the top row of the stack */
    func isTopRow(index : Int) -> Bool {
        return getRow(index) == rowCount
    }
    
    // ////////////
    
    func getDensityColor(_ weight : Int16) -> Color{
        switch weight{
        case 0...20: return .blue
        case 21...40: return .green
        case 41...60: return .yellow
        case 61...80: return .orange
        case 80...101: return .red
        default: return .gray
        }
    }
    
    func getDensityTotalColor() -> Color{
        
        return totalWeight < 150 ? .green : totalWeight > 300 ? .red : .yellow
    }
    
    func resetStressor() {
        stressName = ""
        stressDescription = ""
        stressWeight = 0
    }
    
    func isValidStressor() -> Bool {
        return !stressName.isEmpty
        && !stressDescription.isEmpty
        && (1...100).contains(stressWeight)
    }
    
    
    func addStressor(context moc : NSManagedObjectContext){
        if isValidStressor() {
            
            let stressor = Stressor(context: moc)
            stressor.weight = Int16(stressWeight)
            stressor.stressDescription = stressDescription
            stressor.name = stressName
            stressor.addDate = addDate
            stressor.id = UUID()
            
            do {
                try moc.save()
                resetStressor()
            } catch {
                print(error)
            }
            
            cancelButton()
        }
    }
    
    func editStressor(stressor edit : Stressor, context moc : NSManagedObjectContext){
        
        if isValidStressor(){
        edit.stressDescription = stressDescription
        edit.name = stressName
        edit.weight = Int16(stressWeight)
            
            do{
                try moc.save()
                resetStressor()
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
}


//https://www.stress.org/wp-content/uploads/2019/04/stress-inventory-1.pdf
enum StressInventory : String, CaseIterable{
    //short versions TODO: More compassionatly worded?
    case
    DeathOfSpouse = "Death of Spouse",
    custom100 = "Other level 100",
    custom90 = "Other level 90",
    custom80 = "Other level 80",
    Divorce,
    custom70 = "Other level 70",
    MaritalSeperation = "Spouse Separation",
    DetentionInJail = "Jail Sentance",
    DeathOfCloseFamily = "Death in Family",
    custom60 = "Other level 60",
    MajorPersonalInjury = "Major Injury",
    Marriage,
    custom50 = "Other level 50",
    Fired,
    MaritalReconciliation = "Marital Reconciliation",
    Retirement,
    MajorChangeInHealthOfFamilyMember = "Family Sickness",
    Pregnancy,
    custom40 =  "Other level 40",
    SexualDifficulties = "Sexual Issues",
    GainingNewFamilyMember = "New Family Member",
    MajorBusinessReadjustment = "Business Change",
    MajorChangeInFinancialState = "Financial Change",
    DeathOfCloseFriend = "Death of Friend",
    ChangingLineOfWork = "Career Change",
    MajorChangeOfArgumentsWithSpouse = "Arguments with Spouse",
    TakingOnMortgage = "New Mortgage",
    ForclosureOnAMortgage = "Forclosure",
    custom30 = "Other level 30",
    MajorChangeInResponsibilitesAtWork = "Work Responsibilities",
    ChildLeavingHome = "Child Leaving Home",
    InLawTroubles = "In-Law Troubles",
    OutstandingPersonalAchievement = "Personal Achievement",
    SpouseWorkOutsideHome = "Spouse working",
    FormalSchoolingChange = "Formal School Change",
    MajorChangeInLivingCondition = "Living condition change",
    RevisionOfPersonalHabits = "Personal Habit Change",
    TroublesWithBoss = "Trouble with Boss",
    MajorChangesInWorkHoursConditions = "Work Condition Change",
    ChangeInResidence = "Move to New Home",
    ChangeToNewSchool = "New School",
    custom20 = "Other level 20",
    MajorChangeInRecreation = "Change in recreation",
    MajorChangeinChurchActivity = "Change at Church",
    MajorChangeinSocialActivity = "Change in Social Activity",
    TakingOnDebt = "New Debt",
    MajorChangeInSleepHabits = "Change in Sleep Habits",
    MajorChangeInFamilyGatherings = "Family Gatherings",
    MajorChangeInEatingHabits = "Change in Diet",
    Vacation,
    MajorHolidays = "Major Holiday",
    MinorViolationsOfLaw = "Minor Law Violation",
    custom10 = "Other level 10"

    var description : String {
        switch self{
            
        case .custom10, .custom20, .custom30, .custom40, .custom50, .custom60, .custom70, .custom80, .custom90, .custom100:
            return "Other stress item of value \(self.weight)"
        case .DeathOfSpouse:
            return "Death of Spouse or Significant Other"
        case .MaritalSeperation:
            return "Marital separation from spouse"
        case .DetentionInJail:
            return "Detention in Jail or other type of institution"
        case .DeathOfCloseFamily:
            return "Death of a close family member"
        case .MajorPersonalInjury:
            return "Major personal injury"
        case .Marriage:
            return "Stress of getting married"
        case .Fired:
            return "Fired from Job"
        case .MaritalReconciliation:
            return "Going through a Marriage Reconciliation with spouse"
        case .Retirement:
            return "Retiring from Job"
        case .MajorChangeInHealthOfFamilyMember:
            return "Major change in the health of a family member (i.e. cancer, heart attack, etc.)"
        case .SexualDifficulties:
            return "Problems with intimacy or other sexual difficulties"
        case .GainingNewFamilyMember:
            return "Gaining a new household family member (i.e. birth, adoption, grandparent moving in)"
        case .MajorBusinessReadjustment:
            return "Major change in business"
        case .MajorChangeInFinancialState:
            return "Major change in Financial State, i.e. gaining or losing a lot of money"
        case .DeathOfCloseFriend:
            return "Death of a close friend"
        case .ChangingLineOfWork:
            return "Change in Career or line of work"
        case .MajorChangeOfArgumentsWithSpouse:
            return "Major change in arguments with spouse, i.e. child raising, personal habits, etc."
        case .TakingOnMortgage:
            return "Taking on a mortgage for family or your business"
        case .ForclosureOnAMortgage:
            return "Forclosure on a mortgage or loan"
        case .MajorChangeInResponsibilitesAtWork:
            return "Major change in work responsibilities"
        case .ChildLeavingHome:
            return "Son or Daughter leaving home for college, military, etc."
        case .InLawTroubles:
            return "Troubles with In-Laws"
        case .OutstandingPersonalAchievement:
            return "Outstanding Personal Achievement"
        case .SpouseWorkOutsideHome:
            return "Spouse beginning or ceasing to work outside of the home"
        case .FormalSchoolingChange:
            return "Beginning or graduating College or some form of schooling"
        case .MajorChangeInLivingCondition:
            return "Major change in living condition, i.e. new home, remodeling, etc"
        case .RevisionOfPersonalHabits:
            return "Revision of personal habits, i.e. dress, manners, quitting smoking, etc."
        case .TroublesWithBoss:
            return "Trouble with Boss or a work superior"
        case .MajorChangesInWorkHoursConditions:
            return "Major changes in work hours, conditions, pay, etc."
        case .ChangeInResidence:
            return "Moving to a different apartment, or home"
        case .ChangeToNewSchool:
            return "Changing schools"
        case .MajorChangeInRecreation:
            return "Major change in the frequency and type of recreation i.e. less time to go golfing"
        case .MajorChangeinChurchActivity:
            return "Major change in church activity, i.e. a lot more participation or volunteering"
        case .MajorChangeinSocialActivity:
            return "Major change in social activities, i.e. joining a new club or friends group"
        case .TakingOnDebt:
            return "Taking on new debt, i.e. new car, freezer, tv, etc"
        case .MajorChangeInSleepHabits:
            return "Sleeping a lot more or less than usual"
        case .MajorChangeInFamilyGatherings:
            return "Major change in quantity of family gatherings"
        case .MajorChangeInEatingHabits:
            return "Major change in diet, or eating habits"
        case .MajorHolidays:
            return "Stress from Major Holiday traditions, events or responsibilities"
        case .MinorViolationsOfLaw:
            return "Minor violation of the law, i.e. traffic ticket, jaywalking, expired tabs"
            
        default:
            return self.rawValue
        }
    }
    
    var weight : Int {
        switch self{
        case .DeathOfSpouse:
            return 100
        case .Divorce:
            return 73
        case .MaritalSeperation:
            return 65
        case .DetentionInJail:
            return 63
        case .DeathOfCloseFamily:
            return 63

        case .MajorPersonalInjury:
            return 53
        case .Marriage:
            return 50
        case .Fired:
            return 47
        case .MaritalReconciliation:
            return 45
        case .Retirement:
            return 45
        case .MajorChangeInHealthOfFamilyMember:
            return 44
        case .Pregnancy:
            return 40
        case .SexualDifficulties:
            return 39
        case .GainingNewFamilyMember:
            return 39
        case .MajorBusinessReadjustment:
            return 39
        case .MajorChangeInFinancialState:
            return 38
        case .DeathOfCloseFriend:
            return 37
        case .ChangingLineOfWork:
            return 36
        case .MajorChangeOfArgumentsWithSpouse:
            return 35
        case .TakingOnMortgage:
            return 31
        case .ForclosureOnAMortgage:
            return 30
        case .MajorChangeInResponsibilitesAtWork:
            return 29
        case .ChildLeavingHome:
            return 29
        case .InLawTroubles:
            return 29
        case .OutstandingPersonalAchievement:
            return 28
        case .SpouseWorkOutsideHome:
            return 26
        case .FormalSchoolingChange:
            return 26
        case .MajorChangeInLivingCondition:
            return 25
        case .RevisionOfPersonalHabits:
            return 24
        case .TroublesWithBoss:
            return 23
        case .MajorChangesInWorkHoursConditions:
            return 20
        case .ChangeInResidence:
            return 20
        case .ChangeToNewSchool:
            return 20
        case .MajorChangeInRecreation:
            return 19
        case .MajorChangeinChurchActivity:
            return 19
        case .MajorChangeinSocialActivity:
            return 18
        case .TakingOnDebt:
            return 17
        case .MajorChangeInSleepHabits:
            return 16
        case .MajorChangeInFamilyGatherings:
            return 15
        case .MajorChangeInEatingHabits:
            return 15
        case .Vacation:
            return 13
        case .MajorHolidays:
            return 12
        case .MinorViolationsOfLaw:
            return 11
        case .custom10:
            return 10
        case .custom20:
            return 20
        case .custom30:
            return 30
        case .custom40:
            return 40
        case .custom50:
            return 50
        case .custom60:
            return 60
        case .custom70:
            return 70
        case .custom80:
            return 80
        case .custom90:
            return 90
        case .custom100:
            return 100
        }
    }
    
//    func toStressor() -> Stressor{
//        return Stressor(name: self.rawValue, description: self.description, weight: self.weight)
//    }
    
    
}
