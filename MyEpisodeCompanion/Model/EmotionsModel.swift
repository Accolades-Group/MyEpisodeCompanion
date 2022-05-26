//
//  EmotionsModel.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/29/22.
//

/**
    Sources:
    - https://www.mindful.org/meditation/mindfulness-getting-started/
 */

import Foundation
import SwiftUI



//Basic data that is attributed to most types
//NSObject?
class BasicData : Hashable, Identifiable {
    let id = UUID()
    let name: String
    let description : String
    
    static func == (lhs : BasicData, rhs: BasicData) -> Bool{
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
}

/**
 A core emotion such as Joy, Sadness, Anger, Disgust or Fear
 */
class CoreEmotion : BasicData {
    
    // The description of being in this emotional state
    let stateDescription : String
    
    // The description for how one might respond to this emotion
    let responseDescription: String
    
    // The color associated with this emotion
    let color : Color
    let colorSecondary : Color
    let colorTertiary : Color
    
    init(name: String, description : String, stateDescription : String, responseDescription: String){
        
        if(name.contains("Joy")){
            color = Color.Joy.Primary//EmotionConstants.Colors.JoyColor1
            colorSecondary = .Joy.Secondary
            colorTertiary = .Joy.Tertiary
        }else if(name.contains("Sad")){
            color = Color.Sadness.Primary//EmotionConstants.Colors.SadnessColor1
            colorSecondary = .Sadness.Secondary
            colorTertiary = .Sadness.Tertiary
        }else if(name.contains("Anger")){
            color = Color.Anger.Primary//EmotionConstants.Colors.AngerColor1
            colorSecondary = .Anger.Secondary
            colorTertiary = .Anger.Tertiary
        }else if(name.contains("Fear")){
            color = Color.Fear.Primary//EmotionConstants.Colors.FearColor1
            colorSecondary = .Fear.Secondary
            colorTertiary = .Fear.Tertiary
        }else if(name.contains("Disgust")){
            color = Color.Disgust.Primary //EmotionConstants.Colors.DisgustColor1
            colorSecondary = .Disgust.Secondary
            colorTertiary = .Disgust.Tertiary
        }else{
            color = .teal //Debug for times when something is wrong?
            colorSecondary = .pink
            colorTertiary = .indigo
        }
        
        
        
        
        self.stateDescription = stateDescription
        self.responseDescription = responseDescription
        super.init(name: name, description: description)
    }
}

/**
 A state of emotion that exists within a core emotion. A state of peace exists result of joy, and a state of fury exists as a result of anger
 */
class EmotionState: BasicData {
    // The core emotion associated with this state
    let core: CoreEmotion
    
    // The intensity that this state falls in, i.e. Terror -> 9-10; Frustration -> 0-10
    let intensity : ClosedRange<Int>
    
    // The usual responses to this state
    let responseActions : [EmotionResponseAction]
    
    // The suggested antidote for this emotional state
    let antidote : String
    
    init(name: String, description: String, antidote: String, intensity: ClosedRange<Int> = 0...10, responses: [EmotionResponseAction], core: CoreEmotion ){
        self.antidote = antidote
        self.intensity = intensity
        self.core = core
        self.responseActions = responses
        super.init(name: name, description: description)
    }
    
    func getColorGradient() -> [Color]{
        var colors : [Color] = []
        
        let min = intensity.lowerBound
        //let mid = ( intensity.lowerBound + intensity.upperBound ) / 2
        let max = intensity.upperBound
        
        for index in (1...10){
            if index < min || index > max {
                //colors.append(.white)
                //colors.append(core.colorTertiary)
                colors.append(core.colorTertiary.opacity(0.1))
            }else{
               // colors.append(index < 4 ? core.colorTertiary : index > 8 ? core.color : core.colorSecondary)
                colors.append(core.colorSecondary.opacity(Double(index) * 0.05))
                //colors.append(core.color)
                
            }
        }

        
   //     colors.append(min < 4 ? core.colorTertiary : min > 8 ? core.color : core.colorSecondary)
   //     colors.append(mid < 4 ? core.colorTertiary : mid > 8 ? core.color : core.colorSecondary)
   //     colors.append(max < 4 ? core.colorTertiary : max > 8 ? core.color : core.colorSecondary)
        
        if(colors.isEmpty){
            colors.append(core.color)
        }
        return colors
    }
    
    
}

/**
 The way we respond to an emotional state. Our responses to the same emotion may differ depending on the circumstances.
 */
class EmotionResponseAction  : BasicData{
    //the core emotion associated to the response
    let core : CoreEmotion
    //TODO: What does this do?
    let isIntentional : Bool
    
    init(name: String, description: String, isIntentional : Bool = false, core: CoreEmotion){
        self.isIntentional = isIntentional
        self.core = core
        super.init(name: name, description: description)
    }
}

/**
 Physical changes we experience during an emotion in response to a trigger
 */
class PhysicalChange: BasicData {
    
}

/**
 Psychological changes we experience during an emotion in response to a trigger
 */
class PsychologicalChange: BasicData{
    
}


class Trigger : BasicData{
    let category : triggerCategory
    
    init(name: String, description: String, category : triggerCategory){
        self.category = category
        super.init(name: name, description: description)
    }
}

enum triggerCategory: String, CaseIterable {
    case conflict = "Conflict",
    lossOfPower = "Loss Of Power",
    rejection = "Rejection",
    intimacy = "Intimacy",
    deciet = "Deciet",
    sensory = "Sensory",
    failure = "Failure",
    people = "People",
    medical = "Medical",
    other = "Other"
}

class CopingMethod : BasicData{
    
    let category : copingCategory
    
    init(name: String, description: String, category : copingCategory){
        self.category = category
        super.init(name: name, description: description)
    }
}

enum copingCategory : String, CaseIterable {
    // Source: https://www.goodtherapy.org/blog/psychpedia/coping-mechanisms
    
    case //positive methods
    support = "Support",
    relaxation = "Relaxation",
    problemsolving = "Problem-Solving",
    humor = "Humor",
    physicalActivity = "Physical Activity",
    //maladaptive coping methods (Maladaptive: not providing adequate or appropriate adjustment to the environment or situation)
    escape = "Escape",
    unhealthysoothing = "Unhealthy Self Soothing",
    numbing = "Numbing",
    compulsions = "Compulsive Behavior",
    risktaking = "Risk-Taking",
    harmSelf = "Self-Harm"
    
    var description : String {
        switch self{
            
        case .support:
           return "Talking about a stressful event with a supportive person can be an effective way to manage stress. Seeking external support instead of self-isolating and internalizing the effects of stress can greatly reduce the negative effects of a difficult situation."
            
        case .relaxation:
            return "Any number of relaxing activities can help people cope with stress. Relaxing activities may include practicing mindfulness, meditation, progressive muscle relaxation or other calming techniques, sitting in nature, or listening to soft music."
            
        case .problemsolving:
            return "This coping mechanism involves identifying a problem that is causing stress and then developing and putting into action some potential solutions for effectively managing it."
            
        case .humor:
            return "Making light of a stressful situation may help people maintain perspective and prevent the situation from becoming overwhelming."
            
        case .physicalActivity:
            return "Exercise can serve as a natural and healthy form of stress relief. Running, yoga, swimming, walking, dance, team sports, and many other types of physical activity can help people cope with stress and the aftereffects of traumatic events."
            
        case .escape:
            return "To cope with anxiety or stress, some people may withdraw from friends and become socially isolated. They may absorb themselves in a solitary activity such as watching television, reading, or spending time online."
            
        case .unhealthysoothing:
            return "Some self-soothing behaviors are healthy in moderation but may turn into an unhealthy addiction if it becomes a habit to use them to self-soothe. Some examples of unhealthy self-soothing could include overeating, binge drinking, or excessive use of internet or video games."
            
        case .numbing:
            return "Some self-soothing behaviors may become numbing behaviors. When a person engages in numbing behavior, they are often aware of what they are doing and may seek out an activity that will help them drown out or override their distress. People may seek to numb their stress by eating junk food, excessive alcohol use, or using drugs."
            
        case .compulsions:
            return "Stress can cause some people to seek an adrenaline rush through compulsive or risk-taking behaviors such as gambling, unsafe sex, experimenting with drugs, theft, or reckless driving."
            
        case .risktaking:
            return "Stress can cause some people to seek an adrenaline rush through compulsive or risk-taking behaviors such as gambling, unsafe sex, experimenting with drugs, theft, or reckless driving."
            
        case .harmSelf:
            return "People may engage in self-harming behaviors to cope with extreme stress or trauma."
        }
        
    }
    
}


class EmotionModel {
    
    /**
     Gets all possible emotion responses associated with a given core emotion
     */
    func getResponsesByCore(_ core : CoreEmotion) -> [EmotionResponseAction] {
        if(core == EmotionConstants.Cores.Anger){
            return [EmotionConstants.Responses.Dispute,
                    EmotionConstants.Responses.PassiveAggression,
                    EmotionConstants.Responses.Insult,
                    EmotionConstants.Responses.Quarrel,
                    EmotionConstants.Responses.SimmerBrood,
                    EmotionConstants.Responses.Suppress,
                    EmotionConstants.Responses.Undermine,
                    EmotionConstants.Responses.UsePhysicalForce,
                    EmotionConstants.Responses.ScreamYellAnger,
                    //Intentional Responses
                    
                    EmotionConstants.Responses.SetLimits,
                    EmotionConstants.Responses.BeFirm,
                    EmotionConstants.Responses.WalkAwayAnger,
                    EmotionConstants.Responses.TakeTimeOut,
                    EmotionConstants.Responses.BreatheAnger,
                    EmotionConstants.Responses.PracticePatience,
                    EmotionConstants.Responses.ReframeAnger,
                    EmotionConstants.Responses.DistractAnger,
                    EmotionConstants.Responses.AvoidAnger,
                    EmotionConstants.Responses.RemoveInterference
                     
            ]
        }else if(core == EmotionConstants.Cores.Joy){
            return [
                EmotionConstants.Responses.Exclaim,
                EmotionConstants.Responses.EngageConnect,
                EmotionConstants.Responses.Gloat,
                EmotionConstants.Responses.Indulge,
                EmotionConstants.Responses.Maintain,
                EmotionConstants.Responses.Savor,
                EmotionConstants.Responses.SeekMore]
        }else if(core == EmotionConstants.Cores.Sadness){
            return[
                EmotionConstants.Responses.FeelShame,
                EmotionConstants.Responses.Mourn,
                EmotionConstants.Responses.Protest,
                EmotionConstants.Responses.RuminateSadness,
                EmotionConstants.Responses.SeekComfort,
                EmotionConstants.Responses.WithdrawSadness,
                
                //Intentional
                //TODO: Allow user to select if it was intentional or not, both of these are intentional and responsive(intrinsic)
                EmotionConstants.Responses.WithdrawSadnessIntentional,
                EmotionConstants.Responses.DistractSadness
            
            ]
        }else if(core == EmotionConstants.Cores.Disgust){
            return [
                EmotionConstants.Responses.AvoidDisgust,
                EmotionConstants.Responses.Dehumanize,
                EmotionConstants.Responses.Vomit,
                EmotionConstants.Responses.WithdrawDisgust,
            
                //Intentional
                //TODO: Allow user to select if it was intentional or not, both of these are intentional and responsive(intrinsic)
                EmotionConstants.Responses.WithdrawDisgustIntentional,
                EmotionConstants.Responses.AvoidDisgustIntentional,
            
            ]
        }else if(core == EmotionConstants.Cores.Fear){
            return [
                EmotionConstants.Responses.Freeze,
                EmotionConstants.Responses.Hesitate,
                EmotionConstants.Responses.ScreamFear,
                EmotionConstants.Responses.Worry,
                EmotionConstants.Responses.RuminateFear,
                EmotionConstants.Responses.AvoidFear,
                EmotionConstants.Responses.WithdrawFear,
            
                //Intentional
                EmotionConstants.Responses.ReframeFear,
                EmotionConstants.Responses.BeMindful,
                EmotionConstants.Responses.BreatheFear,
                EmotionConstants.Responses.DistractFear
            
            ]
        }
        return []
    }
    
    /**
     Returns emotion states that usually trigger the given response action.
     */
    func getStatesByResponses(_ responses : [EmotionResponseAction]) -> [EmotionState]{
        //TODO: Test this as guard let method
        if let unwrappedCore = responses.first?.core {
            var states = getStatesByCore(unwrappedCore)
            
            responses.forEach{response in
                states = states.filter({
                    $0.responseActions.contains(response)
                })
            }
            
            return states
        }
        //failed to get core emotion, responses is likely empty
        return []
        
    }
    
    /**
     Returns all of the states associated to a core emotion
     */
    func getStatesByCore(_ core : CoreEmotion) -> [EmotionState]{
        
        if(core == EmotionConstants.Cores.Anger){
            return[
                EmotionConstants.States.Annoyance,
                EmotionConstants.States.Frustration,
                EmotionConstants.States.Exasperation,
                EmotionConstants.States.Argumentativeness,
                EmotionConstants.States.Bitterness,
                EmotionConstants.States.Vengefulness,
                EmotionConstants.States.Fury
            ]
        }else if(core == EmotionConstants.Cores.Fear){
            return[
                EmotionConstants.States.Trepidation,
                EmotionConstants.States.Nervousness,
                EmotionConstants.States.Anxiety,
                EmotionConstants.States.Dread,
                EmotionConstants.States.Desperation,
                EmotionConstants.States.Panic,
                EmotionConstants.States.Horror,
                EmotionConstants.States.Terror]
        }else if(core == EmotionConstants.Cores.Sadness){
            return[
                EmotionConstants.States.Disappointment,
                EmotionConstants.States.Discouragement,
                EmotionConstants.States.Distraughtness,
                EmotionConstants.States.Resignation,
                EmotionConstants.States.Helplessness,
                EmotionConstants.States.Hopelessness,
                EmotionConstants.States.Misery,
                EmotionConstants.States.Despair,
                EmotionConstants.States.Grief,
                EmotionConstants.States.Sorrow,
                EmotionConstants.States.Anguish
            ]
        }else if(core == EmotionConstants.Cores.Disgust){
            return[
                EmotionConstants.States.Dislike,
                EmotionConstants.States.Aversion,
                EmotionConstants.States.Distaste,
                EmotionConstants.States.Repugnance,
                EmotionConstants.States.Abhorrence,
                EmotionConstants.States.Loathing
            ]
        }else if(core == EmotionConstants.Cores.Joy){
            return [
                EmotionConstants.States.SensoryPleasure,
                EmotionConstants.States.Rejoicing,
                EmotionConstants.States.CompassionateJoy,
                EmotionConstants.States.Amusement,
                EmotionConstants.States.Schadenfreude,
                EmotionConstants.States.Relief,
                EmotionConstants.States.Peace,
                EmotionConstants.States.Fiero,
                EmotionConstants.States.Pride,
                EmotionConstants.States.Naches,
                EmotionConstants.States.Wonder,
                EmotionConstants.States.Excitement,
                EmotionConstants.States.Ecstasy
            ]
        }
        return []
        
    }
    
    /**
     Returns all default triggers
     */
    func getAllTriggers() -> [Trigger] {
        
        return [
            EmotionConstants.Triggers.Disagreement,
            EmotionConstants.Triggers.Criticism,
            EmotionConstants.Triggers.Yelling,
            EmotionConstants.Triggers.Violence,
            EmotionConstants.Triggers.Abuse,
            EmotionConstants.Triggers.Discrimination,
            
            EmotionConstants.Triggers.EnclosedSpace,
            EmotionConstants.Triggers.Coercion,
            EmotionConstants.Triggers.Possessiveness,
            EmotionConstants.Triggers.CrossedBoundary,
            EmotionConstants.Triggers.Authority,
            EmotionConstants.Triggers.Invalidation,
            EmotionConstants.Triggers.BeingIgnored,
            EmotionConstants.Triggers.Lonliness,
            EmotionConstants.Triggers.BeingMisunderstood,
            EmotionConstants.Triggers.Rejection,
            EmotionConstants.Triggers.Abandonment,
            
            EmotionConstants.Triggers.BeingTouched,
            EmotionConstants.Triggers.Sex,
            EmotionConstants.Triggers.BeingDependedOn,
            EmotionConstants.Triggers.ExpressingNeeds,
            
            EmotionConstants.Triggers.Lies,
            EmotionConstants.Triggers.Accusations,
            EmotionConstants.Triggers.Gaslighting,
            EmotionConstants.Triggers.PassiveAggression,
            EmotionConstants.Triggers.Inconsistency,
            EmotionConstants.Triggers.Manipulation,
            
            EmotionConstants.Triggers.SuddenMovements,
            EmotionConstants.Triggers.Lights,
            EmotionConstants.Triggers.Noise,
            
            EmotionConstants.Triggers.Responsibility,
            EmotionConstants.Triggers.Pressure,
            EmotionConstants.Triggers.Mistakes,
            
            EmotionConstants.Triggers.Crowd,
            EmotionConstants.Triggers.Family,
            EmotionConstants.Triggers.LikeAbuser,
            
            EmotionConstants.Triggers.Hospitals,
            EmotionConstants.Triggers.Illness,
            EmotionConstants.Triggers.Doctors,
            EmotionConstants.Triggers.BloodGore,
            EmotionConstants.Triggers.Therapy,
            
            EmotionConstants.Triggers.Positivity,
            EmotionConstants.Triggers.Holidays,
            EmotionConstants.Triggers.Religion,
            EmotionConstants.Triggers.Money,
            EmotionConstants.Triggers.Object
            
        ]
    }
    
    //TODO: Joy & Disgust physical changes
    /**
     Returns all possible physical changes
     */
    func getAllPhysicalChanges() ->[PhysicalChange]{
        return [
            EmotionConstants.PhysicalChanges.HighBP,
            EmotionConstants.PhysicalChanges.HighHR,
            EmotionConstants.PhysicalChanges.RapidBreathing,
            EmotionConstants.PhysicalChanges.Headache,
            EmotionConstants.PhysicalChanges.TremblingMuscles,
            EmotionConstants.PhysicalChanges.Sweating,
            EmotionConstants.PhysicalChanges.TunnelVision,
            EmotionConstants.PhysicalChanges.LossOfControl,
            EmotionConstants.PhysicalChanges.GooseBumps,
            EmotionConstants.PhysicalChanges.Butterflies,
            EmotionConstants.PhysicalChanges.Crying,
            EmotionConstants.PhysicalChanges.LumpInThroat,
            EmotionConstants.PhysicalChanges.ShakyVoice,
            EmotionConstants.PhysicalChanges.EmotionalPain,
            EmotionConstants.PhysicalChanges.StomachPain,
            EmotionConstants.PhysicalChanges.Headache
        ]
    }
    
    
    func getAllPhysicalChangesForEmotion(_ core: CoreEmotion) -> [PhysicalChange]{
        if(core == EmotionConstants.Cores.Anger){
            return [
                EmotionConstants.PhysicalChanges.HighBP,
                EmotionConstants.PhysicalChanges.HighHR,
                EmotionConstants.PhysicalChanges.RapidBreathing,
                EmotionConstants.PhysicalChanges.Headache,
                EmotionConstants.PhysicalChanges.TremblingMuscles,
                EmotionConstants.PhysicalChanges.Sweating,
                EmotionConstants.PhysicalChanges.TunnelVision,
                EmotionConstants.PhysicalChanges.LossOfControl
            ]
        }else if(core == EmotionConstants.Cores.Fear){
            return [
                EmotionConstants.PhysicalChanges.HighBP,
                EmotionConstants.PhysicalChanges.HighHR,
                EmotionConstants.PhysicalChanges.RapidBreathing,
                EmotionConstants.PhysicalChanges.GooseBumps,
                EmotionConstants.PhysicalChanges.Sweating,
                EmotionConstants.PhysicalChanges.TremblingMuscles,
                EmotionConstants.PhysicalChanges.Butterflies
            ]
        }else if(core == EmotionConstants.Cores.Sadness){
            return[
                EmotionConstants.PhysicalChanges.Crying,
                EmotionConstants.PhysicalChanges.LumpInThroat,
                EmotionConstants.PhysicalChanges.HighHR,
                EmotionConstants.PhysicalChanges.ShakyVoice,
                EmotionConstants.PhysicalChanges.TremblingMuscles,
                EmotionConstants.PhysicalChanges.EmotionalPain,
                EmotionConstants.PhysicalChanges.StomachPain,
                EmotionConstants.PhysicalChanges.HeartAche
            ]
        }
        return []
    }
    
    func getAllPsychologicalChanges() -> [PsychologicalChange]{
        return[
            EmotionConstants.PsychologicalChanges.FeltAttacked,
            EmotionConstants.PsychologicalChanges.FeltThreatened,
            EmotionConstants.PsychologicalChanges.ExpectedPersonToLeave,
            EmotionConstants.PsychologicalChanges.FeltSick,
            EmotionConstants.PsychologicalChanges.FeltEmpty,
            EmotionConstants.PsychologicalChanges.FeltWronged,
            EmotionConstants.PsychologicalChanges.FeltRighteous,
            EmotionConstants.PsychologicalChanges.FeltSurprised,
            EmotionConstants.PsychologicalChanges.FeltSelfLoathing,
            EmotionConstants.PsychologicalChanges.FeltLoved,
            EmotionConstants.PsychologicalChanges.FeltBetrayed,
            EmotionConstants.PsychologicalChanges.FeltInsecure,
            EmotionConstants.PsychologicalChanges.FeltHatred,
            EmotionConstants.PsychologicalChanges.WantedToBeAlone,
            EmotionConstants.PsychologicalChanges.FeltLonely
        ]
    }
    
}

// New Emotion Model Using Enums ///////
enum CoreEmotions : String, CaseIterable {
    case Joy, Anger, Disgust, Fear, Sadness
    
    /** Name of the core emotion */
    var name : String{
        return self.rawValue
    }
    
    /** Description of the core emotion */
    var description : String {
        switch self{
            
        case .Joy:
            return "Enjoyment describes the many good feelings that arise from experiences both novel and familiar."
        case .Anger:
            return "We get angry when something blocks us or when we think we're being treated unfairly."
        case .Disgust:
            return "Feeling disgusted by what is toxic helps us to avoid being poisoned, physically or socially."
        case .Fear:
            return "We get angry when something blocks us or when we think we're being treated unfairly."
        case .Sadness:
            return "Sadness is a response to loss, and feeling sad allows us to take a timeout and show others that we need support."
        }
    }
    
    
    
    // The description of being in this emotional state
    var stateDescription : String {
        switch self{
            
        case .Joy:
            return "Enjoyment contains both peace and ecstasy. The intensity of these states varies: We can feel mild or strong peacefulness, but we can only feel intense ecstasy. All states of enjoyment are triggered by feeling connection and/or sensory pleasure."
        case .Anger:
            return "Anger contains both annoyance and fury. The intensity of these states varies: We can feel mild or strong annoyance, but we can only feel intense fury. All states of anger are triggered by a feeling of being blocked in our progress."
        case .Disgust:
            return "Disgust contains both dislike and loathing. The intensity of these states varies: We can feel mild or strong dislike, but we can only feel intense loathing. All states of disgust are triggered by the feeling that something is toxic."
        case .Fear:
            return "Fear contains both anxiety and terror. The intensity of these states varies: We can feel mild or strong anxiety, but we can only feel intense terror. All states of fear are triggered by feeling a threat of harm."
        case .Sadness:
            return "Sadness contains both disappointment and despair. The intensity of these states varies: We can feel mild or strong disappointment, but we can only feel intense despair. All states of sadness are triggered by a feeling of loss."
        }
    }
    
    // The description for how one might respond to this emotion
    var responseDescription : String {
        switch self{
            
        case .Joy:
            return "For example, we might exclaim to express our feeling of amusement among friends, but experience our amusement quietly while alone. Expressing amusement by exclaiming can be constructive as means of sharing enjoyment, but destructive if it's in response to making fun of someone."
        case .Anger:
            return "For example, we might suppress our feelings of frustration at work, but scream and yell to express our frustration with a family member. Suppressing our frustration can be constructive in cases where it helps us avoid arguments, but destructive if we are being hurt by not speaking up for ourselves."
        case .Disgust:
            return "For example, we might avoid feeling aversion towards others at work, but find ourselves feeling aversion towards individuals we read about in the news. Avoiding aversion can be constructive in overcoming bias, but can be destructive if it leads us to get involved with a harmful person."
        case .Fear:
            return "For example, we might avoid feeling anxiety at work, but ruminate on our anxiety at home. Avoiding anxiety can be constructive if it helps us give a presentation to a room full of colleagues, but destructive if it prevents us from confronting our difficult relationship with our boss."
        case .Sadness:
            return "For example, we might withdraw from feeling helpless in public, but seek comfort at home. Withdrawing from feeling helpless can be constructive to overcoming intense grief, but destructive if we don't seek support when we need it."
        }
    }
    
    var colorPrimary : Color {
        switch self{
        case .Joy:
            return Color.Joy.Primary
        case .Anger:
            return Color.Anger.Primary
        case .Disgust:
            return Color.Disgust.Primary
        case .Fear:
            return Color.Fear.Primary
        case .Sadness:
            return Color.Sadness.Primary
        }
    }
    
    var colorSecondary : Color {
        switch self{
        case .Joy:
            return Color.Joy.Secondary
        case .Anger:
            return Color.Anger.Secondary
        case .Disgust:
            return Color.Disgust.Secondary
        case .Fear:
            return Color.Fear.Secondary
        case .Sadness:
            return Color.Sadness.Secondary
        }
    }
    
    var colorTertiary : Color {
        switch self{
        case .Joy:
            return Color.Joy.Tertiary
        case .Anger:
            return Color.Anger.Tertiary
        case .Disgust:
            return Color.Disgust.Tertiary
        case .Fear:
            return Color.Fear.Tertiary
        case .Sadness:
            return Color.Sadness.Tertiary
        }
    }
    
    //get State Emotions
    
    
}

enum EmotionStates : String, CaseIterable {
    
    case sensoryPleasure, rejoicing, compassionateJoy, amusement, schadenfreude, relief, peace, fiero, pride, naches,wonder, excitement, extasy,
    
    disappointment, discouragement, distraughtness, resignation, helplessness, hopelessness, misery, despair, grief, sorrow, anguish,
    
    dislike, aversion, distaste, repugnance, revulsion, abhorrence, loathing,
    
    trepidation, nervousness, anxiety, dread, desperation, panic, horror, terror,
    
    annoyance, frustration, exasperation, argumentativeness, bitterness, vengefulness, fury
    
    
    var name: String{
        switch self {
        case .sensoryPleasure : return "Sensory Pleasure"
        case .compassionateJoy: return "Compassionate Joy"
            
        default : return self.rawValue.capitalized
        }
    }
    
    var description: String{
        switch self{
        case .sensoryPleasure: return "Enjoyment derived through one of the five physical senses: sight, sound, touch, taste and smell"
        case .rejoicing: return "A warm, uplifting or elevated feeling that people experience when they see acts of human goodness, kindness and compassion."
        case .compassionateJoy: return "Enjoyment of helping to relieve another person's suffering."
        case .amusement: return "Light, playful feelings of enjoyment and good humor."
        case .schadenfreude:
            return "Enjoyment of the misfortunes of another person, usually a rival."
        case .relief:
            return "When something expected to be unpleasant, especially the threat of harm, is avoided or comes to an end."
        case .peace:
            return "An experience of ease and contentment."
        case .fiero:
            return "Enjoyment of meeting a difficult challenge (an Italian Word)."
        case .pride:
            return "Deep pleasure and satisfaction derived from one's own achevements or the achievements of an associate."
        case .naches:
            return "Joyful pride in the accomplishments of one's children or mentees (a Yiddish word)."
        case .wonder:
            return "An experience of something that is very surprising, beautiful, amazing or hard to believe."
        case .excitement:
            return "A powerful enthusiasm."
        case .extasy:
            return "Rapturous delight. A state of very great happiness, nearly overwhelming."
            
        case .disappointment:
            return "A feeling that expectations are not being met."
        case .discouragement:
            return "A response to repeated failures to accomplish something: the belief that it can't be done."
        case .distraughtness:
            return "Sadness that makes it hard to think clearly."
        case .resignation:
            return "The belief that nothing can be done."
        case .helplessness:
            return "The realization that one cannot make as situation better or easier."
        case .hopelessness:
            return "The belief that nothing good will happen."
        case .misery:
            return "Strong suffering or unhappiness."
        case .despair:
            return "The loss of hope that a bad situation will improve or change."
        case .grief:
            return "Sadness over a deep loss."
        case .sorrow:
            return "A feeling of distress and sadness, often caused by a loss."
        case .anguish:
            return "Intense sadness or suffering"
            
        case .dislike:
            return "A strong preference against something."
        case .aversion:
            return "An impulse to avoid something disgusting."
        case .distaste:
            return "Reaction to a bad taste, smell, thing or idea. Can be literal or metaphorical."
        case .repugnance:
            return "String distaste for something often a concept or idea."
        case .revulsion:
            return "A mixture of disgust and loathing"
        case .abhorrence:
            return "A mixture of intense disgust and hatred."
        case .loathing:
            return "Intense disgust focused on a person. Intense disgust focused on oneself is referred to as self-loathing."
            
        case .trepidation:
            return "Anticipation of the possibility of danger."
        case .nervousness:
            return "Uncertainty as to whether there is danger."
        case .anxiety:
            return "Fear of an anticipated or actual threat and uncertainty about one's ability to cope with it."
        case .dread:
            return "Anticipation of severe danger."
        case .desperation:
            return "A response to the inability to reduce danger."
        case .panic:
            return "Sudden uncontrollable fear."
        case .horror:
            return "A mixture of fear, disgust, and shock."
        case .terror:
            return "Intense, overpowering fear."
            
        case .annoyance:
            return "Very mild anger caused by a nuisance or inconvenience."
        case .frustration:
            return "A response to repeated failures to overcome an obstacle."
        case .exasperation:
            return "Anger caused by a repeated or strong nuisance."
        case .argumentativeness:
            return "A tendency to engage in disagreements."
        case .bitterness:
            return "Anger after unfair treatment."
        case .vengefulness:
            return "Desire to retaliate after one is hurt."
        case .fury:
            return "Uncontrolled and often violent anger."
        }
    }
    
    // The core emotion associated with this state
    var core : CoreEmotions {
        switch self{
        case .sensoryPleasure, .rejoicing, .compassionateJoy, .amusement, .schadenfreude, .relief, .peace, .fiero, .pride, .naches, .wonder, .excitement, .extasy : return .Joy
            
        case .disappointment, .discouragement, .distraughtness, .resignation, .helplessness, .hopelessness, .misery, .despair, .grief, .sorrow, .anguish: return .Sadness
            
        case .dislike, .aversion, .distaste, .repugnance, .revulsion, .abhorrence, .loathing : return .Disgust
            
        case .trepidation, .nervousness, .anxiety, .dread, .desperation, .panic, .horror, .terror: return .Fear
            
        case .annoyance, .frustration, .exasperation, .argumentativeness, .bitterness, .vengefulness, .fury: return .Anger
        }
    }

    // The intensity that this state falls in, i.e. Terror -> 9-10; Frustration -> 0-10
    var intensity : ClosedRange<Int>{
        switch self{
        case .sensoryPleasure : return 0...5
        case .rejoicing, .amusement: return 1...8
        case .compassionateJoy: return 3...7
        case .schadenfreude: return 2...8
        case .relief, .peace:
            return 1...10
        case .fiero:
            return 2...10
        case .pride:
            return 3...9
        case .naches:
            return 2...10
        case .wonder:
            return 4...10
        case .excitement:
            return 5...10
        case .extasy:
            return 8...10
            
        case .disappointment:
            return 0...5
        case .discouragement, .distraughtness:
            return 1...8
        case .resignation:
            return 0...10
        case .helplessness:
            return 4...10
        case .hopelessness, .misery:
            return 5...10
        case .despair, .grief, .sorrow:
            return 6...10
        case .anguish:
            return 9...10
            
        case .dislike:
            return 0...5
        case .aversion, .distaste:
            return 1...7
        case .repugnance:
            return 1...9
        case .abhorrence, .revulsion:
            return 7...10
        case .loathing:
            return 8...10
            
        case .trepidation:
            return 0...3
        case .nervousness:
            return 1...7
        case .anxiety:
            return 0...10
        case .dread:
            return 5...10
        case .desperation:
            return 8...10
        case .terror, .horror, .panic:
            return 9...10
            
        case .annoyance:
            return 0...2
        case .frustration:
            return 0...10
        case .exasperation:
            return 3...7
        case .argumentativeness:
            return 1...10
        case .bitterness:
            return 2...10
        case .vengefulness:
            return 5...10
        case .fury:
            return 9...10
        }
    }
    
    // The usual responses to this state
    var responseActions : [EmotionResponses]{
        switch self {
            
        case .sensoryPleasure:
            return [.savor, .seekMore]
        case .rejoicing:
            return [.engageConnect, .exclaim, .savor, .seekMore, .indulge]
        case .compassionateJoy:
            return [.engageConnect, .exclaim, .savor, .seekMore]
        case .amusement:
            return [.engageConnect, .exclaim, .maintain, .seekMore, .indulge]
        case .schadenfreude:
            return [.engageConnect, .exclaim, .gloat, .maintain, .seekMore]
        case .relief:
            return [.engageConnect, .exclaim, .savor, .indulge]
        case .peace:
            return [.engageConnect, .maintain]
        case .fiero:
            return [.maintain, .seekMore, .engageConnect, .indulge, .savor, .gloat]
        case .pride:
            return [.seekMore, .engageConnect, .exclaim, .indulge, .savor]
        case .naches:
            return [.engageConnect, .exclaim, .savor, .gloat]
        case .wonder:
            return [.engageConnect, .exclaim, .savor, .seekMore, .indulge]
        case .excitement:
            return [.engageConnect, .exclaim, .maintain, .seekMore, .indulge]
        case .extasy:
            return [.maintain, .savor, .indulge]
            
        case .disappointment:
            return [.feelShame, .mourn, .ruminateSadness, .seekComfort, .withdrawSadness]
        case .discouragement:
            return [.protest, .seekComfort, .mourn, .ruminateSadness, .withdrawSadness]
        case .distraughtness:
            return [.seekComfort, .protest, .feelShame, .withdrawSadness]
        case .resignation:
            return [.seekComfort, .protest, .withdrawSadness, .feelShame, .mourn, .ruminateSadness]
        case .helplessness:
            return [.seekComfort, .protest, .feelShame, .ruminateSadness, .withdrawSadness]
        case .hopelessness:
            return [.seekComfort, .mourn, .feelShame, .ruminateSadness, .withdrawSadness]
        case .misery:
            return [.seekComfort, .mourn, .protest, .ruminateSadness, .withdrawSadness]
        case .despair:
            return [.seekComfort, .mourn, .ruminateSadness, .withdrawSadness]
        case .grief:
            return [.seekComfort, .mourn, .protest, .feelShame, .ruminateSadness, .withdrawSadness]
        case .sorrow:
            return [.seekComfort, .mourn, .feelShame, .ruminateSadness, .withdrawSadness]
        case .anguish:
            return [.seekComfort, .mourn, .protest, .ruminateSadness, .withdrawSadness]
            
        case .dislike:
            return [.withdrawDisgust, .avoidDisgust, .dehumanize]
        case .aversion:
            return [.avoidDisgust, .withdrawDisgust, .dehumanize]
        case .distaste:
            return [.avoidDisgust, .vomit, .withdrawDisgust]
        case .repugnance:
            return [.withdrawDisgust, .avoidDisgust, .dehumanize]
        case .revulsion:
            return [.avoidDisgust, .vomit, .withdrawDisgust, .dehumanize]
        case .abhorrence:
            return [.avoidDisgust, .withdrawDisgust, .dehumanize]
        case .loathing:
            return [.withdrawDisgust, .avoidDisgust, .dehumanize]
            
        case .trepidation:
            return [.hesitate, .ruminateFear, .worry]
        case .nervousness:
            return [.hesitate, .ruminateFear, .worry]
        case .anxiety:
            return [.hesitate, .freeze, .withdrawFear, .ruminateFear, .worry]
        case .dread:
            return [.freeze, .withdrawFear, .ruminateFear, .screamFear, .worry]
        case .desperation:
            return [.avoidFear, .freeze, .hesitate, .ruminateFear, .screamFear]
        case .panic:
            return [.freeze, .screamFear, .withdrawFear, .ruminateFear, .worry]
        case .horror:
            return [.freeze, .screamFear, .withdrawFear]
        case .terror:
            return [.freeze, .screamFear, .withdrawFear]
            
        case .annoyance:
            return [.suppress, .passiveAggression, .simmerBrood]
        case .frustration:
            return [.suppress, .passiveAggression, .insult, .quarrel, .screamAnger, .simmerBrood, .undermine]
        case .exasperation:
            return [.suppress, .passiveAggression, .dispute, .insult, .quarrel, .screamAnger, .simmerBrood, .undermine]
        case .argumentativeness:
            return [.suppress, .insult, .quarrel, .simmerBrood, .undermine]
        case .bitterness:
            return [.suppress, .passiveAggression, .dispute, .insult, .screamAnger, .simmerBrood, .undermine]
        case .vengefulness:
            return [.dispute, .insult, .quarrel, .screamAnger, .simmerBrood, .suppress, .undermine, .usePhysicalForce]
        case .fury:
            return [.insult, .quarrel, .screamAnger, .simmerBrood, .suppress, .undermine, .usePhysicalForce]
        }

    }
    
    // The suggested antidote for this emotional state
    var antidote : String {
        switch self{
        case .sensoryPleasure: return "Being unable to appreciate the quality of the present moment."
        case .rejoicing: return "Envy, jealousy, pride."
        case .compassionateJoy: return "Regret at having done something good at the cost of some personal efforts. Narrow-mindedness when caring only for a limited number of people who are close."
        case .amusement: return "Tending to see things in negative ways"
        case .schadenfreude: return "TODO?"
        case .relief:
            return "Persisting in worrying unnecessarily."
        case .peace:
            return "None/TODO"
        case .fiero:
            return "Vanity, narcissism, failing to acknowledge with gratitude all those who contributed to make an achievement possible."
        case .pride:
            return "None/TODO"
        case .naches:
            return "Pride mixed with arrogance and with partiality that makes one feel contemptuous about others’ achievements."
        case .wonder:
            return "Grasping. Unease."
        case .excitement:
            return "Feeling pessimism."
        case .extasy:
            return "Grasping, attachment and any other afflictive mental state (animosity, envy, arrogance, etc.)."
            
        case .disappointment:
            return "Understanding that sadness is natural in appropriate circumstances, but also that experiencing loss is part of life and that one should not let oneself be overwhelmed. Trying to find a place of peace within oneself and thinking of constructive things that could be done instead."
        case .discouragement:
            return "Understanding that a permanent state of sadness will not bring any real benefit. In the case of mourning someone, falling into long-term sadness and despair should not be seen as an homage paid to that person. It is better to pay homage by doing meaningful and altruistic acts."
        case .distraughtness:
            return "Understanding that a permanent state of sadness will not bring any real benefit. In the case of mourning someone, falling into long-term sadness and despair should not be seen as an homage paid to that person. It is better to pay homage by doing meaningful and altruistic acts."
        case .resignation:
            return "TODO"
        case .helplessness:
            return "TODO"
        case .hopelessness:
            return "TODO"
        case .misery:
            return "TODO"
        case .despair:
            return "TODO"
        case .grief:
            return "TODO"
        case .sorrow:
            return "TODO"
        case .anguish:
            return "Realizing that things and people are impermanent by nature. Revolting against this cannot lead to a fulfilled life."
            
        case .dislike:
            return "While evaluating impartially the ethical issues, generating compassion so as to find the best way to remedy the causes and conditions that triggered dislike."
        case .aversion:
            return "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting aversion dissolve in a space of mindful awareness."
        case .distaste:
            return "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting distaste dissolve in a space of mindful awareness."
        case .repugnance:
            return "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting repugnance dissolve in a space of mindful awareness."
        case .revulsion:
            return "Adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions."
        case .abhorrence:
            return "In the case of toxic substances or situations, doing the best one can to calmly avoid them. In the case of actions, adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions."
        case .loathing:
            return "Adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions."
            
        case .trepidation:
            return "Trying to ponder what can be done. Calming the mind gives the best chance to find the appropriate solution to what caused the trepidation in the first place."
        case .nervousness:
            return "Trying to ponder what can be done. Calming the mind gives the best chance to find the appropriate solution to what caused the nervousness in the first place."
        case .anxiety:
            return "Making a special effort of letting go of ruminations about the past and anticipations of the future."
        case .dread:
            return "Remaining as calm as as possible. Seeing what can be done for yourself and for others as well."
        case .desperation:
            return "TODO: Research an antidote"
        case .panic:
            return "Making an effort to see if anything can act as a mitigating factor (depending on the causes involved)."
        case .horror:
            return "Trying to see if anything can be done immediately. If that is not the case, creating distance to see if something can be done from afar. Responding with firmness and compassion, never with hatred."
        case .terror:
            return "Instilling some calmness in the mind in order to take most appropriate decision."
            
        case .annoyance:
            return "Patience, open-mindedness, concern for others."
        case .frustration:
            return "Letting go, letting go of grasping, putting things in a larger perspective."
        case .exasperation:
            return "Letting go of grasping. Patience, inner calm. Trying to understand the causes and conditions that brought about the undesirable situation."
        case .argumentativeness:
            return "Making effort to understand the other’s perspective, cognitive empathy, benevolence, wishing to solve the problem through a mutually agreeable solution."
        case .bitterness:
            return "TODO: Research an antidote"
        case .vengefulness:
            return "Contemplating the negative effects of taking revenge, in the short and long term; forgiveness not as condoning harmful behavior but as breaking the cycle of resentment and hatred."
        case .fury:
            return "Taking a break, physically and mentally, from the circumstances that brought fury about. Looking at fury itself with the eye of awareness as if gazing at a raging fire and slowly letting it calm down."
        }
    }
    
    func getColorGradient() -> [Color]{
        var colors : [Color] = []
        
        let min = intensity.lowerBound
        //let mid = ( intensity.lowerBound + intensity.upperBound ) / 2
        let max = intensity.upperBound
        
        for index in (1...10){
            if index < min || index > max {
                //colors.append(.white)
                //colors.append(core.colorTertiary)
                colors.append(core.colorTertiary.opacity(0.1))
            }else{
               // colors.append(index < 4 ? core.colorTertiary : index > 8 ? core.color : core.colorSecondary)
                colors.append(core.colorSecondary.opacity(Double(index) * 0.05))
                //colors.append(core.color)
                
            }
        }

        
   //     colors.append(min < 4 ? core.colorTertiary : min > 8 ? core.color : core.colorSecondary)
   //     colors.append(mid < 4 ? core.colorTertiary : mid > 8 ? core.color : core.colorSecondary)
   //     colors.append(max < 4 ? core.colorTertiary : max > 8 ? core.color : core.colorSecondary)
        
        if(colors.isEmpty){
            colors.append(core.colorPrimary)
        }
        return colors
    }
    
}

enum EmotionResponses : String, CaseIterable {
    
    case exclaim, engageConnect, gloat, indulge, maintain, savor, seekMore,
    
    feelShame, mourn, protest, ruminateSadness, seekComfort, withdrawSadness, distractSadness, //TODO: Intentional withdrawSadness?
    
    avoidDisgust, dehumanize, vomit, withdrawDisgust, //todo; Intentional withdraw/avoid disgust
    
    freeze, hesitate, screamFear, worry, ruminateFear, avoidFear, withdrawFear,
         //intentional
         reframeFear, beMindful, breatheFear, distractFear,
    
    dispute, passiveAggression, insult, quarrel, simmerBrood, suppress, undermine, usePhysicalForce, screamAnger,
    //intentional
    setLimits, beFirm, walkAway, takeTimeOut, breatheAnger, practicePatience, reframeAnger, distractAnger, avoidAnger, removeInterference
    
    var name: String {
        switch self{
        case .engageConnect: return "Engage/Connect"
        case .seekMore: return "Seek More"
        case .feelShame: return "Feel Shame"
        case .ruminateSadness, .ruminateFear: return "Ruminate"
        case .seekComfort: return "Seek Comfort"
        case .withdrawFear, .withdrawDisgust, .withdrawSadness: return "Withdraw"
        case .distractFear, .distractAnger, .distractSadness: return "Distract"
        case .avoidFear, .avoidAnger, .avoidDisgust: return "Avoid"
        case .screamFear, .screamAnger: return "Scream/Yell"
        case .beMindful: return "Being Mindful"
        case .breatheFear, .breatheAnger: return "Breathe"
        case .passiveAggression: return "Passive Aggression"
        case .simmerBrood: return "Simmer/Brood"
        case .usePhysicalForce: return "Physical Force"
        case .setLimits: return "Set Limits"
        case .beFirm: return "Be Firm"
        case .walkAway: return "Walk Away"
        case .takeTimeOut: return "Time Out"
        case .practicePatience: return "Practice Patience"
        case .reframeFear, .reframeAnger: return "Reframe"
        case .removeInterference: return "Remove Interference"
            
            
        default : return self.rawValue.capitalized
        }
    }
    
    var description: String{
        switch self {
        case .exclaim:
            return "Vocally express enjoyment to others."
        case .engageConnect:
            return "Share one's feelings of enjoyment with others without a desire to cause jealousy."
        case .gloat:
            return "Enjoy others’ envy of your state of enjoyment."
        case .indulge:
            return "Allow oneself to fully experience the pleasure of good feelings."
        case .maintain:
            return "Continue to do what is necessary to continue the enjoyable feelings."
        case .savor:
            return "Appreciate the good feelings around an experience completely, especially by dwelling on them."
        case .seekMore:
            return "Attempt to increse the enjoyable feelings."
            
        case .feelShame:
            return "Feel embarrassed by one's feelings about not being good enough."
        case .mourn:
            return "Express grief for one's loss through actions, dress and spech."
        case .protest:
            return "Object to the loss"
        case .ruminateSadness:
            return "Obsessively think about the emotoinal experience"
        case .seekComfort:
            return "Seek help or support from others"
        case .withdrawSadness:
            return "Either physically stay away from what is triggering the sadness or keep oneself from thinking about it."
        case .distractSadness:
            return "Distract yourself by thinking of, or doing something different from what is triggering the sadness."
            
        case .avoidDisgust:
            return "Either physically stay away from whatever is triggering the emotion, or keep oneself from thinking about it."
        case .dehumanize:
            return "Treat someone as though he or she is not a human being; deprive someone of human qualities, personality or spirit."
        case .vomit:
            return "Respond to feelings of disgust by throwing up."
        case .withdrawDisgust:
            return "Physically or mentally leave the scene of what is triggering the disgust."
            
        case .freeze:
            return "Become incapable of acting or speaking"
        case .hesitate:
            return "Hold back in doubt or indecision, often momentarily."
        case .screamFear:
            return "Lose control of one's speech; speak or cry out in a loud and high voice."
        case .worry:
            return "Anticipate the possibility of harm."
        case .ruminateFear:
            return "Obsessively think about a past emotional experience."
        case .avoidFear:
            return "Either physically stay away from the threat or keep oneself from thinking about it."
        case .withdrawFear:
            return "Physically or mentally leave the scene of the threat."
        case .reframeFear:
            return "//TODO:"
        case .beMindful:
            return "//TODO:"
        case .breatheFear:
            return "//TODO:"
        case .distractFear:
            return "Distract yourself by thinking of, or doing something different from what is triggering the fear."
            
        case .dispute:
            return "Disagree in a manner that may escalate the conflict."
        case .passiveAggression:
            return "Take indirect actions that have an angry undercurrent."
        case .insult:
            return "Disparage the other person in an offensive or hurtful way that is likely to escalate the conflict rather than resolve it."
        case .quarrel:
            return "Verbally oppose in a manner intended to escalate the disagreement."
        case .simmerBrood:
            return "Express anger by sulking."
        case .suppress:
            return "Try to avoid feeling or acting upon the emotion that is being experienced."
        case .undermine:
            return "Take action to make someone or something weaker or less effective, usually in a secret or gradual way."
        case .usePhysicalForce:
            return "Trap or physically harm someone or something."
        case .screamAnger:
            return "Lose control of one's speech; speak loudly and possibly at a higher pitch."
        case .setLimits:
            return "//TODO:"
        case .beFirm:
            return "//TODO:"
        case .walkAway:
            return "//TODO:"
        case .takeTimeOut:
            return "//TODO:" //Sometimes the best solution is to take a step back and walk away for a few moments. This not only helps to ease the tension of a tough situation, it allows you to catch your breath, organize your thoughts, and gain your composure. This can also be useful if you are by yourself and the thoughts in your head are starting to make you angry. Close your eyes and take a deep breath and think of something pleasant that you like and enjoy.
        case .breatheAnger:
            return "//TODO:"
        case .practicePatience:
            return "//TODO:"
        case .reframeAnger:
            return "//TODO:"
        case .distractAnger:
            return "//TODO:"
        case .avoidAnger:
            return "//TODO:"
        case .removeInterference:
            return "//TODO:"
        }
    }
    
}

enum CoreFears : String, CaseIterable {

    
    case extinction, mutilation, autonomyLoss, separation, egoDeath
    
    var tier: Int {
        switch self{
        case .extinction: return 1
        case .mutilation: return 2
        case .autonomyLoss: return 3
        case .separation: return 4
        case .egoDeath: return 5
        }
    }
    
    var name: String{
        switch self{
        case .autonomyLoss: return "Autonomy Loss"
        case .egoDeath: return "Ego Death"
        default: return self.rawValue.capitalized
        }
    }
    
    var description: String{
        switch self{
        case .extinction: return "The fear of annihilation, of ceasing to exist. This is a more fundamental way to express it than just 'fear of death.' The idea of no longer being arouses a primary existential anxiety in all normal humans. Consider that panicky feeling you get when you look over the edge of a high building."
            
        case .mutilation: return "The fear of losing any part of our precious bodily structure; the thought of having our body's boundaries invaded, or of losing the integrity of any organ, body part, or natural function. Anxiety about animals, such as bugs, spiders, snakes, and other creepy things arises from fear of mutilation."
            
        case .autonomyLoss: return "The fear of being immobilized, paralyzed, restricted, enveloped, overwhelmed, entrapped, imprisoned, smothered, or otherwise controlled by circumstances beyond our control. In physical form, it's commonly known as claustrophobia, but it also extends to our social interactions and relationships."
            
        case .separation: return "The fear of abandonment, rejection, and loss of connectedness; of becoming a non-person—not wanted, respected, or valued by anyone else. The 'silent treatment,' when imposed by a group, can have a devastating effect on its target."
            
        case .egoDeath: return "The fear of humiliation, shame, or any other mechanism of profound self-disapproval that threatens the loss of integrity of the self; the fear of the shattering or disintegration of one's constructed sense of lovability, capability, and worthiness."
        }
    }
    
    
}

enum CopingMethods: String, CaseIterable{
    case mindfulness, meditation, tobacco, marijuana, eating, venting, electronics, alcohol, sexualActivity, exercise, walking, hardDrugs, recklessness, gambling, selfHarm, humor, shopping, junkfood, music, attentionSeeking, caffeine, working, sleeping
    
    var name : String{
        switch self{
        case .sexualActivity: return "Sexual Activity"
        case .hardDrugs: return "Hard Drugs"
        case .selfHarm: return "Self Harm"
        case .attentionSeeking: return "Attention Seeking"
            
        default: return self.rawValue.capitalized
        }
    }
    
    var description: String{
        return "TODO!"
    }
}
//test 2
// End New Emotion Model Using Enums /////


struct EmotionConstants {
    
    struct Cores {
        
       static func getAll() -> [CoreEmotion]{
            return [
                Cores.Joy,
                Cores.Anger,
                Cores.Disgust,
                Cores.Fear,
                Cores.Sadness,
                //Cores.Other
                
            ]
        }
        
        static func getEpisodeCores() -> [CoreEmotion]{
            return [
                Cores.Anger,
                //Cores.Disgust,
                Cores.Fear,
                Cores.Sadness
            ]
        }
        
        static func getCoreByNameStr(_ name : String) -> CoreEmotion{
            if name.contains(Joy.name) { return Joy }
            else if name.contains(Anger.name) {return Anger}
            else if name.contains(Sadness.name) {return Sadness}
            else if name.contains(Fear.name) {return Fear}
            else if name.contains(Disgust.name) {return Disgust}
            else{
                return Other
            }
        }
        

        
        
        
        //Remove?
        static let Other = CoreEmotion(name: "Other", description: "A an emotion that doesn't if into these other categories", stateDescription: "", responseDescription: "")
        
        static let Joy = CoreEmotion(
            name: "Joy",
            description: "Enjoyment describes the many good feelings that arise from experiences both novel and familiar.",
            stateDescription: "Enjoyment contains both peace and ecstasy. The intensity of these states varies: We can feel mild or strong peacefulness, but we can only feel intense ecstasy. All states of enjoyment are triggered by feeling connection and/or sensory pleasure.",
            responseDescription: "For example, we might exclaim to express our feeling of amusement among friends, but experience our amusement quietly while alone. Expressing amusement by exclaiming can be constructive as means of sharing enjoyment, but destructive if it's in response to making fun of someone."
        )
        
        static let Disgust = CoreEmotion(
            name: "Disgust",
            description: "Feeling disgusted by what is toxic helps us to avoid being poisoned, physically or socially.",
            stateDescription: "Disgust contains both dislike and loathing. The intensity of these states varies: We can feel mild or strong dislike, but we can only feel intense loathing. All states of disgust are triggered by the feeling that something is toxic.",
            responseDescription: "For example, we might avoid feeling aversion towards others at work, but find ourselves feeling aversion towards individuals we read about in the news. Avoiding aversion can be constructive in overcoming bias, but can be destructive if it leads us to get involved with a harmful person."
        )
        
        static let Fear = CoreEmotion(
            name: "Fear",
            description: "Our fear of danger lets us anticipate threats to our safety.",
            stateDescription: "Fear contains both anxiety and terror. The intensity of these states varies: We can feel mild or strong anxiety, but we can only feel intense terror. All states of fear are triggered by feeling a threat of harm.",
            responseDescription: "For example, we might avoid feeling anxiety at work, but ruminate on our anxiety at home. Avoiding anxiety can be constructive if it helps us give a presentation to a room full of colleagues, but destructive if it prevents us from confronting our difficult relationship with our boss."
        )
        
        static let Anger = CoreEmotion(
            name: "Anger",
            description: "We get angry when something blocks us or when we think we're being treated unfairly.",
            stateDescription: "Anger contains both annoyance and fury. The intensity of these states varies: We can feel mild or strong annoyance, but we can only feel intense fury. All states of anger are triggered by a feeling of being blocked in our progress.",
            responseDescription: "For example, we might suppress our feelings of frustration at work, but scream and yell to express our frustration with a family member. Suppressing our frustration can be constructive in cases where it helps us avoid arguments, but destructive if we are being hurt by not speaking up for ourselves."
        )
        
        static let Sadness = CoreEmotion(
            name: "Sadness",
            description: "Sadness is a response to loss, and feeling sad allows us to take a timeout and show others that we need support.",
            stateDescription: "Sadness contains both disappointment and despair. The intensity of these states varies: We can feel mild or strong disappointment, but we can only feel intense despair. All states of sadness are triggered by a feeling of loss.",
            responseDescription: "For example, we might withdraw from feeling helpless in public, but seek comfort at home. Withdrawing from feeling helpless can be constructive to overcoming intense grief, but destructive if we don't seek support when we need it."
        )
    }
    
    struct States {
        
        //Joy
        static let SensoryPleasure  = EmotionState(
            name: "Sensory Pleasure",
            description: "Enjoyment derived through one of the five physical senses: sight, sound, touch, taste and smell",
            antidote: "Being unable to appreciate the quality of the present moment.",
            intensity: 0...5,
            responses: [
                Responses.Savor,
                Responses.SeekMore
            ],
            core: Cores.Joy)
        
        static let Rejoicing  = EmotionState(
            name: "Rejoicing",
            description: "A warm, uplifting or elevated feeling that people experience when they see acts of human goodness, kindness and compassion.",
            antidote: "Envy, jealousy, pride.",
            intensity: 1...8,
            responses: [
                Responses.EngageConnect,
                Responses.Exclaim,
                Responses.Savor,
                Responses.SeekMore,
                Responses.Indulge
            ],
            core: Cores.Joy)
        
        static let CompassionateJoy  = EmotionState(
            name: "Compassionate Joy",
            description: "Enjoyment of helping to relieve another person's suffering.",
            antidote: "Regret at having done something good at the cost of some personal efforts. Narrow-mindedness when caring only for a limited number of people who are close.",
            intensity: 3...7,
            responses: [
                    Responses.EngageConnect,
                    Responses.Exclaim,
                    Responses.Savor,
                    Responses.SeekMore
            ],
            core: Cores.Joy)
        
        static let Amusement  = EmotionState(
            name: "Amusement",
            description: "Light, playful feelings of enjoyment and good humor.",
            antidote: "Tending to see things in negative ways",
            intensity: 1...8,
            responses: [
                    Responses.EngageConnect,
                    Responses.Exclaim,
                    Responses.Maintain,
                    Responses.SeekMore,
                    Responses.Indulge
            ],
            core: Cores.Joy)
        
        static let Schadenfreude  = EmotionState(
            name: "Schadenfreude",
            description: "Enjoyment of the misfortunes of another person, usually a rival.",
            antidote: "TODO",
            intensity: 2...8,
            responses: [
                Responses.EngageConnect,
                Responses.Exclaim,
                Responses.Gloat,
                Responses.Maintain,
                Responses.SeekMore
            ],
            core: Cores.Joy)
        
        static let Relief  = EmotionState(
            name: "Relief",
            description: "When something expected to be unpleasant, especially the threat of harm, is avoided or comes to an end.",
            antidote: "Persisting in worrying unnecessarily.",
            intensity: 1...10,
            responses: [
                Responses.EngageConnect,
                Responses.Exclaim,
                Responses.Savor,
                Responses.Indulge
            ],
            core: Cores.Joy)
        
        static let Peace  = EmotionState(
            name: "Peace",
            description: "An experience of ease and contentment.",
            antidote: "",
            intensity: 1...10,
            responses: [
                Responses.EngageConnect,
                Responses.Maintain
            ],
            core: Cores.Joy)
        
        static let Fiero  = EmotionState(
            name: "Fiero",
            description: "Enjoyment of meeting a difficult challenge (an Italian Word).",
            antidote: "Vanity, narcissism, failing to acknowledge with gratitude all those who contributed to make an achievement possible.",
            intensity: 2...10,
            responses: [
                Responses.Maintain,
                Responses.SeekMore,
                Responses.EngageConnect,
                Responses.Indulge,
                Responses.Savor,
                Responses.Gloat
            ],
            core: Cores.Joy)
        
        static let Pride  = EmotionState(
            name: "Pride",
            description: "Deep pleasure and satisfaction derived from one's own achevements or the achievements of an associate.",
            antidote: "",
            intensity: 3...9,
            responses: [
                Responses.SeekMore,
                Responses.EngageConnect,
                Responses.Exclaim,
                Responses.Indulge,
                Responses.Savor
            ],
            core: Cores.Joy)
        
        static let Naches  = EmotionState(
            name: "Naches",
            description: "Joyful pride in the accomplishments of one's children or mentees (a Yiddish word).",
            antidote: "Pride mixed with arrogance and with partiality that makes one feel contemptuous about others’ achievements.",
            intensity: 2...10,
            responses: [
                    Responses.EngageConnect,
                    Responses.Exclaim,
                    Responses.Savor,
                    Responses.Gloat
            ],
            core: Cores.Joy)
        
        static let Wonder  = EmotionState(
            name: "Wonder",
            description: "An experience of something that is very surprising, beautiful, amazing or hard to believe.",
            antidote: "Grasping. Unease.",
            intensity: 4...10,
            responses: [
                    Responses.EngageConnect,
                    Responses.Exclaim,
                    Responses.Savor,
                    Responses.SeekMore,
                    Responses.Indulge],
            core: Cores.Joy)
        
        static let Excitement  = EmotionState(
            name: "Excitement",
            description: "A powerful enthusiasm.",
            antidote: "Feeling pessimism.",
            intensity: 5...10,
            responses: [
                Responses.EngageConnect,
                Responses.Exclaim,
                Responses.Maintain,
                Responses.SeekMore,
                Responses.Indulge],
            core: Cores.Joy)
        
        static let Ecstasy  = EmotionState(
            name: "Ecstasy",
            description: "Rapturous delight. A state of very great happiness, nearly overwhelming.",
            antidote: "Grasping, attachment and any other afflictive mental state (animosity, envy, arrogance, etc.).",
            intensity: 8...10,
            responses: [
                Responses.Maintain,
                Responses.Savor,
                Responses.Indulge
            ],
            core: Cores.Joy)
        
        //Sadness
        //TODO: Come up with better antidotes for sadness. They all use the same thing
        static let Disappointment = EmotionState(
            name: "Disappointment",
            description: "A feeling that expectations are not being met.",
            antidote: "Understanding that sadness is natural in appropriate circumstances, but also that experiencing loss is part of life and that one should not let oneself be overwhelmed. Trying to find a place of peace within oneself and thinking of constructive things that could be done instead.",
            intensity: 0...5,
            responses: [
                Responses.FeelShame,
                Responses.Mourn,
                Responses.RuminateSadness,
                Responses.SeekComfort,
                Responses.WithdrawSadness
            ],
            core: Cores.Sadness)
        
        static let Discouragement = EmotionState(
            name: "Discouragment",
            description: "A response to repeated failures to accomplish something: the belief that it can't be done.",
            antidote: "Understanding that a permanent state of sadness will not bring any real benefit. In the case of mourning someone, falling into long-term sadness and despair should not be seen as an homage paid to that person. It is better to pay homage by doing meaningful and altruistic acts.",
            intensity: 1...8,
            responses: [
                Responses.Protest,
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.RuminateSadness,
                Responses.WithdrawSadness
            ],
            core: Cores.Sadness)
        
        static let Distraughtness = EmotionState(
            name: "Distraughtness",
            description: "Sadness that makes it hard to think clearly.",
            antidote: "Understanding that a permanent state of sadness will not bring any real benefit. In the case of mourning someone, falling into long-term sadness and despair should not be seen as an homage paid to that person. It is better to pay homage by doing meaningful and altruistic acts.",
            intensity: 1...8,
            responses: [
                Responses.SeekComfort,
                Responses.Protest,
                Responses.FeelShame,
                Responses.WithdrawSadness
            ],
            core: Cores.Sadness)
        
        static let Resignation = EmotionState(
            name: "Resignation",
            description: "The belief that nothing can be done.",
            antidote: "TODO",
            intensity: 0...10,
            responses: [
                Responses.SeekComfort,
                Responses.Protest,
                Responses.WithdrawSadness,
                Responses.FeelShame,
                Responses.Mourn,
                Responses.RuminateSadness
            ],
            core: Cores.Sadness)
        
        static let Helplessness = EmotionState(
            name: "Helplessness",
            description: "The realization that one cannot make as situation better or easier.",
            antidote: "TODO",
            intensity: 4...10,
            responses: [
                Responses.SeekComfort,
                Responses.Protest,
                Responses.FeelShame,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Hopelessness = EmotionState(
            name: "Hopelessness",
            description: "The belief that nothing good will happen.",
            antidote: "TODO",
            intensity: 5...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.FeelShame,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Misery = EmotionState(
            name: "Misery",
            description: "Strong suffering or unhappiness.",
            antidote: "TODO",
            intensity: 5...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.Protest,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Despair = EmotionState(
            name: "Despair",
            description: "The loss of hope that a bad situation will improve or change.",
            antidote: "TODO",
            intensity: 6...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Grief = EmotionState(
            name: "Grief",
            description: "Sadness over a deep loss.",
            antidote: "TODO",
            intensity: 6...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.Protest,
                Responses.FeelShame,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Sorrow = EmotionState(
            name: "Sorrow",
            description: "A feeling of distress and sadness, often caused by a loss.",
            antidote: "TODO",
            intensity: 6...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.FeelShame,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        static let Anguish = EmotionState(
            name: "Anguish",
            description: "Intense sadness or suffering",
            antidote: "Realizing that things and people are impermanent by nature. Revolting against this cannot lead to a fulfilled life.",
            intensity: 9...10,
            responses: [
                Responses.SeekComfort,
                Responses.Mourn,
                Responses.Protest,
                Responses.RuminateSadness,
                Responses.WithdrawSadness],
            core: Cores.Sadness)
        
        
        //Disgust
        static let Dislike = EmotionState(
            name: "Dislike",
            description: "A strong preference against something.",
            antidote: "While evaluating impartially the ethical issues, generating compassion so as to find the best way to remedy the causes and conditions that triggered dislike.",
            intensity: 0...5,
            responses: [
                Responses.WithdrawDisgust,
                Responses.AvoidDisgust,
                Responses.Dehumanize],
            core: Cores.Disgust)
        
        static let Aversion  = EmotionState(
            name: "Aversion",
            description: "An impulse to avoid something disgusting.",
            antidote: "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting aversion dissolve in a space of mindful awareness.",
            intensity: 1...7,
            responses: [
                Responses.AvoidDisgust,
                Responses.WithdrawDisgust,
                Responses.Dehumanize],
            core: Cores.Disgust)
        
        static let Distaste  = EmotionState(
            name: "Distaste",
            description: "Reaction to a bad taste, smell, thing or idea. Can be literal or metaphorical.",
            antidote: "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting distaste dissolve in a space of mindful awareness.",
            intensity: 1...7,
            responses: [Responses.AvoidDisgust,
                        Responses.Vomit,
                        Responses.WithdrawDisgust],
            core: Cores.Disgust)
        
        static let Repugnance  = EmotionState(
            name: "Repugnance",
            description: "String distaste for something often a concept or idea.",
            antidote: "Evaluating impartially the degree of harmfulness, taking appropriate measures, and then letting repugnance dissolve in a space of mindful awareness.",
            intensity: 1...9,
            responses: [Responses.WithdrawDisgust,
                        Responses.AvoidDisgust,
                        Responses.Dehumanize],
            core: Cores.Disgust)
        
        static let Revulsion  = EmotionState(
            name: "Revulsion",
            description: "A mixture of disgust and loathing",
            antidote: "Adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions.",
            intensity: 7...10,
            responses: [Responses.AvoidDisgust,
                        Responses.Vomit,
                        Responses.WithdrawDisgust,
                        Responses.Dehumanize],
            core: Cores.Disgust)
        
        static let Abhorrence  = EmotionState(
            name: "Abhorrence",
            description: "A mixture of intense disgust and hatred.",
            antidote: "In the case of toxic substances or situations, doing the best one can to calmly avoid them. In the case of actions, adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions.",
            intensity: 7...10,
            responses: [Responses.AvoidDisgust,
                        Responses.WithdrawDisgust,
                        Responses.Dehumanize],
            core: Cores.Disgust)
        //TODO: Self vs Other
        static let Loathing = EmotionState(
            name: "Loathing",
            description: "Intense disgust focused on a person. Intense disgust focused on oneself is referred to as self-loathing.",
            antidote: "Adopting the outlook of a caring physician, who might deeply disapprove certain behaviors but will focus on doing all that is possible to cure a person of their afflictions.",
            intensity: 8...10,
            responses: [Responses.WithdrawDisgust,
                        Responses.AvoidDisgust,
                        Responses.Dehumanize],
            core: Cores.Disgust)
        
        //Fear
        static let Trepidation  = EmotionState(
            name: "Trepidation",
            description: "Anticipation of the possibility of danger.",
            antidote: "Trying to ponder what can be done. Calming the mind gives the best chance to find the appropriate solution to what caused the trepidation in the first place.",
            intensity: 0...3,
            responses: [Responses.Hesitate,
                        Responses.RuminateFear,
                        Responses.Worry],
            core: Cores.Fear)
        
        static let Nervousness  = EmotionState(
            name: "Nervousness",
            description: "Uncertainty as to whether there is danger.",
            antidote: "Trying to ponder what can be done. Calming the mind gives the best chance to find the appropriate solution to what caused the nervousness in the first place.",
            intensity: 1...7,
            responses: [Responses.Hesitate,
                        Responses.RuminateFear,
                        Responses.Worry],
            core: Cores.Fear)
        
        static let Anxiety  = EmotionState(
            name: "Anxiety",
            description: "Fear of an anticipated or actual threat and uncertainty about one's ability to cope with it.",
            antidote: "Making a special effort of letting go of ruminations about the past and anticipations of the future.",
            intensity: 0...10,
            responses: [Responses.Hesitate,
                        Responses.Freeze,
                        Responses.WithdrawFear,
                        Responses.RuminateFear,
                        Responses.Worry],
            core: Cores.Fear)
        
        static let Dread  = EmotionState(
            name: "Dread",
            description: "Anticipation of severe danger.",
            antidote: "Remaining as calm as as possible. Seeing what can be done for yourself and for others as well.",
            intensity: 5...10,
            responses: [Responses.Freeze,
                        Responses.WithdrawFear,
                        Responses.RuminateFear,
                        Responses.ScreamFear,
                        Responses.Worry],
            core: Cores.Fear)
        
        static let Desperation  = EmotionState(
            name: "Desperation",
            description: "A response to the inability to reduce danger.",
            antidote: "TODO: Research an antidote",
            intensity: 8...10,
            responses: [
                Responses.AvoidFear,
                Responses.Freeze,
                Responses.Hesitate,
                Responses.RuminateFear,
                Responses.ScreamFear],
            core: Cores.Fear)
        
        static let Panic  = EmotionState(
            name: "Panic",
            description: "Sudden uncontrollable fear.",
            antidote: "Making an effort to see if anything can act as a mitigating factor (depending on the causes involved).",
            intensity: 9...10,
            responses: [Responses.Freeze,
                        Responses.ScreamFear,
                        Responses.WithdrawFear,
                        Responses.RuminateFear,
                        Responses.Worry],
            core: Cores.Fear)
        
        static let Horror  = EmotionState(
            name: "Horror",
            description: "A mixture of fear, disgust, and shock.",
            antidote: "Trying to see if anything can be done immediately. If that is not the case, creating distance to see if something can be done from afar. Responding with firmness and compassion, never with hatred.",
            intensity: 9...10,
            responses: [Responses.Freeze,
                        Responses.ScreamFear,
                        Responses.WithdrawFear],
            core: Cores.Fear)
        
        static let Terror  = EmotionState(
            name: "Terror",
            description: "Intense, overpowering fear.",
            antidote: "Instilling some calmness in the mind in order to take most appropriate decision.",
            intensity: 9...10,
            responses: [Responses.Freeze,
                        Responses.ScreamFear,
                        Responses.WithdrawFear],
            core: Cores.Fear)
        
        //Anger
        static let Annoyance = EmotionState(
            name: "Annoyance",
            description: "Very mild anger caused by a nuisance or inconvenience.",
            antidote: "Patience, open-mindedness, concern for others.",
            intensity: 0...2,
            responses: [
                Responses.Suppress,
                Responses.PassiveAggression,
                Responses.SimmerBrood
            ],
            core: Cores.Anger)
        
        static let Frustration = EmotionState(
            name: "Frustration",
            description: "A response to repeated failures to overcome an obstacle.",
            antidote: "Letting go, letting go of grasping, putting things in a larger perspective.",
            intensity: 0...10,
            responses: [
                Responses.Suppress,
                Responses.PassiveAggression,
                Responses.Insult,
                Responses.Quarrel,
                Responses.ScreamYellAnger,
                Responses.SimmerBrood,
                Responses.Undermine
            ],
            core: Cores.Anger)
        
        static let Exasperation = EmotionState(
            name: "Exasperation",
            description: "Anger caused by a repeated or strong nuisance.",
            antidote: "Letting go of grasping. Patience, inner calm. Trying to understand the causes and conditions that brought about the undesirable situation.",
            intensity: 3...7,
            responses: [
                Responses.Suppress,
                Responses.PassiveAggression,
                Responses.Dispute,
                Responses.Insult,
                Responses.Quarrel,
                Responses.ScreamYellAnger,
                Responses.SimmerBrood,
                Responses.Undermine
            ],
            core: Cores.Anger)
        
        static let Argumentativeness = EmotionState(
            name: "Argumentativeness",
            description: "A tendency to engage in disagreements.",
            antidote: "Making effort to understand the other’s perspective, cognitive empathy, benevolence, wishing to solve the problem through a mutually agreeable solution.",
            intensity: 1...10,
            responses: [
                Responses.Suppress,
                Responses.Insult,
                Responses.Quarrel,
                Responses.SimmerBrood,
                Responses.Undermine],
            core: Cores.Anger)
        
        static let Bitterness = EmotionState(
            name: "Bitterness",
            description: "Anger after unfair treatment.",
            antidote: "TODO: Research an antidote",
            intensity: 2...10,
            responses: [
                Responses.Suppress,
                Responses.PassiveAggression,
                Responses.Dispute,
                Responses.Insult,
                Responses.ScreamYellAnger,
                Responses.SimmerBrood,
                Responses.Undermine
            ],
            core: Cores.Anger)
        
        static let Vengefulness = EmotionState(
            name: "Vengefulness",
            description: "Desire to retaliate after one is hurt.",
            antidote: "Contemplating the negative effects of taking revenge, in the short and long term; forgiveness not as condoning harmful behavior but as breaking the cycle of resentment and hatred.",
            intensity: 5...10,
            responses: [
                Responses.Dispute,
                Responses.Insult,
                Responses.Quarrel,
                Responses.ScreamYellAnger,
                Responses.SimmerBrood,
                Responses.Suppress,
                Responses.Undermine,
                Responses.UsePhysicalForce],
            core: Cores.Anger)
        
        static let Fury = EmotionState(
            name: "Fury",
            description: "Uncontrolled and often violent anger.",
            antidote: "Taking a break, physically and mentally, from the circumstances that brought fury about. Looking at fury itself with the eye of awareness as if gazing at a raging fire and slowly letting it calm down.",
            intensity: 9...10,
            responses: [
                Responses.Insult,
                Responses.Quarrel,
                Responses.ScreamYellAnger,
                Responses.SimmerBrood,
                Responses.Suppress,
                Responses.Undermine,
                Responses.UsePhysicalForce],
            core: Cores.Anger)
        
    }
    
    struct Responses {
        
        static func getAllResponsesByCore(_ core: CoreEmotion) -> [EmotionResponseAction]{
            if(core == Cores.Anger){
                return [
                    Dispute,
                    PassiveAggression,
                    Insult,
                    Quarrel,
                    SimmerBrood,
                    Suppress,
                    Undermine,
                    UsePhysicalForce,
                    ScreamYellAnger,
                    //Intentional Responses
                    
                    SetLimits,
                    BeFirm,
                    WalkAwayAnger,
                    TakeTimeOut,
                    BreatheAnger,
                    PracticePatience,
                    ReframeAnger,
                    DistractAnger,
                    AvoidAnger,
                    RemoveInterference
                        
                ]
            }else if(core == Cores.Joy){
                return [
                    Exclaim,
                    EngageConnect,
                    Gloat,
                    Indulge,
                    Maintain,
                    Savor,
                    SeekMore
                ]
            }else if(core == Cores.Sadness){
                return[
                    FeelShame,
                    Mourn,
                    Protest,
                    RuminateSadness,
                    SeekComfort,
                    WithdrawSadness,
                    
                    //Intentional
                    //TODO: Allow user to select if it was intentional or not, both of these are intentional and responsive(intrinsic)
                    WithdrawSadnessIntentional,
                    DistractSadness
                    
                ]
            }else if(core == Cores.Disgust){
                return [
                    AvoidDisgust,
                    Dehumanize,
                    Vomit,
                    WithdrawDisgust,
                    
                    //Intentional
                    //TODO: Allow user to select if it was intentional or not, both of these are intentional and responsive(intrinsic)
                    WithdrawDisgustIntentional,
                    AvoidDisgustIntentional,
                    
                ]
            }else if(core == Cores.Fear){
                return [
                    Freeze,
                    Hesitate,
                    ScreamFear,
                    Worry,
                    RuminateFear,
                    AvoidFear,
                    WithdrawFear,
                    
                    //Intentional
                    ReframeFear,
                    BeMindful,
                    BreatheFear,
                    DistractFear
                    
                ]
            }
            return []
        }
        
        //Joy
        static let Exclaim = EmotionResponseAction(
            name: "Exclaim",
            description: "Vocally express enjoyment to others.",
            core: Cores.Joy)
        
        static let EngageConnect = EmotionResponseAction(
            name: "Engage or Connect",
            description: "Share one's feelings of enjoyment with others without a desire to cause jealousy.",
            core: Cores.Joy)
        
        static let Gloat = EmotionResponseAction(
            name: "Gloat",
            description: "Enjoy others’ envy of your state of enjoyment.",
            core: Cores.Joy)
        
        static let Indulge = EmotionResponseAction(
            name: "Indulge",
            description: "Allow oneself to fully experience the pleasure of good feelings.",
            core: Cores.Joy)
        
        static let Maintain = EmotionResponseAction(
            name: "Maintain",
            description: "Continue to do what is necessary to continue the enjoyable feelings.",
            core: Cores.Joy)
        
        static let Savor = EmotionResponseAction(
            name: "Savor",
            description: "Appreciate the good feelings around an experience completely, especially by dwelling on them.",
            core: Cores.Joy)
        
        static let SeekMore = EmotionResponseAction(
            name: "Seek More",
            description: "Attempt to increse the enjoyable feelings.",
            core: Cores.Joy)
        
        //Intentional Joy
        //TODO: Practice Gratitude(savor? is savor intentional? are they all intentional?), Practice Humility, Share with Others
        
        //Sadness
        static let FeelShame = EmotionResponseAction(
            name: "Feel Shame",
            description: "Feel embarrassed by one's feelings about the loss.",
            core: Cores.Sadness)
        
        static let Mourn = EmotionResponseAction(
            name: "Mourn",
            description: "Express grief for one's loss through actions, dress and spech.",
            core: Cores.Sadness)
        
        static let Protest = EmotionResponseAction(
            name: "Protest",
            description: "Object to the loss",
            core: Cores.Sadness)
        
        static let RuminateSadness = EmotionResponseAction(
            name: "Ruminate",
            description: "Obsessively think about the emotoinal experience",
            core: Cores.Sadness)
        
        static let SeekComfort = EmotionResponseAction(
            name: "Seek Comfort",
            description: "Seek help or support from others",
            core: Cores.Sadness)
        
        static let WithdrawSadness = EmotionResponseAction(
            name: "Withdraw",
            description: "Either physically stay away from what is triggering the sadness or keep oneself from thinking about it.",
            core: Cores.Sadness)
        
        //Intentional
        static let WithdrawSadnessIntentional = EmotionResponseAction(
            name: "Withdraw",
            description: "Intentionally and mindfully walk away from what is triggering the sadness, and keep yourself from thinking about it.",
            isIntentional: true,
            core: Cores.Sadness)
        
        static let DistractSadness = EmotionResponseAction(
            name: "Distract",
            description: "Distract yourself by thinking of, or doing something different from what is triggering the sadness.",
            isIntentional: true,
            core: Cores.Sadness)
        
        
        //Disgust
        static let AvoidDisgust = EmotionResponseAction(
            name: "Avoid",
            description: "Either physically stay away from whatever is triggering the emotion, or keep oneself from thinking about it.",
            core: Cores.Disgust)
        
        static let Dehumanize = EmotionResponseAction(
            name: "Dehumanize",
            description: "Treat someone as though he or she is not a human being; deprive someone of human qualities, personality or spirit.",
            core: Cores.Disgust)
        
        static let Vomit = EmotionResponseAction(
            name: "Vomit",
            description: "Respond to feelings of disgust by throwing up.",
            core: Cores.Disgust)
        
        static let WithdrawDisgust = EmotionResponseAction(
            name: "Withdraw",
            description: "Physically or mentally leave the scene of what is triggering the disgust.",
            core: Cores.Disgust)
        
        //Disgust Intentional
        static let WithdrawDisgustIntentional = EmotionResponseAction(
            name: "Withdraw",
            description: "Intentionally and mindfully leave the scene or ignore the thought of what is triggering the disgust.",
            isIntentional: true,
            core: Cores.Disgust)
        
        static let AvoidDisgustIntentional = EmotionResponseAction(
            name: "Avoid",
            description: "Intentionally and mindfully stay away from whatever is triggering the emotion.",
            isIntentional: true,
            core: Cores.Disgust)
        
        //Fear
        static let Freeze = EmotionResponseAction(
            name: "Freeze",
            description: "Become incapabl of acting or speaking",
            core: Cores.Fear)
        
        static let Hesitate = EmotionResponseAction(
            name: "Hesitate",
            description: "Hold back in doubt or indecision, often momentarily.",
            core: Cores.Fear)
        
        static let ScreamFear = EmotionResponseAction(
            name: "Scream",
            description: "Lose control of one's speech; speak or cry out in a loud and high voice.",
            core: Cores.Fear)
        
        static let Worry = EmotionResponseAction(
            name: "Worry",
            description: "Anticipate the possibility of harm.",
            core: Cores.Fear)
        
        static let RuminateFear = EmotionResponseAction(
            name: "Ruminate",
            description: "Obsessively think about a past emotional experience.",
            core: Cores.Fear)
        
        static let AvoidFear = EmotionResponseAction(
            name: "Avoid",
            description: "Either physically stay away from the threat or keep oneself from thinking about it.",
            core: Cores.Fear)
        
        static let WithdrawFear = EmotionResponseAction(
            name: "Withdraw",
            description: "Physically or mentally leave the scene of the threat.",
            core: Cores.Fear)
        
        //Fear Intentional
        static let ReframeFear = EmotionResponseAction(
            name: "Reframe",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Fear)
        
        static let BeMindful = EmotionResponseAction(
            name: "Be Mindful",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Fear)
        
        static let BreatheFear = EmotionResponseAction(
            name: "Breathe",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Fear)
        
        static let DistractFear = EmotionResponseAction(
            name: "Distract",
            description: "Distract yourself by thinking of, or doing something different from what is triggering the fear.",
            isIntentional: true,
            core: Cores.Fear)
        
        //Anger
        static let Dispute = EmotionResponseAction(
            name: "Dispute",
            description: "Disagree in a manner that may escalate the conflict.",
            core: EmotionConstants.Cores.Anger)
        
        static let PassiveAggression = EmotionResponseAction(
            name: "Passive-Aggression",
            description: "Take indirect actions that have an angry undercurrent.",
            core: Cores.Anger)
        
        static let Insult = EmotionResponseAction(
            name: "Insult",
            description: "Disparage the other person in an offensive or hurtful way that is likely to escalate the conflict rather than resolve it.",
            core: Cores.Anger)
        
        static let Quarrel = EmotionResponseAction(
            name: "Quarrel / Argue",
            description: "Verbally oppose in a manner intended to escalate the disagreement.",
            core: Cores.Anger)
        
        static let SimmerBrood = EmotionResponseAction(
            name: "Simmer / Brood",
            description: "Express anger by sulking.",
            core: Cores.Anger)
        
        static let Suppress = EmotionResponseAction(
            name: "Suppress",
            description: "Try to avoid feeling or acting upon the emotion that is being experienced.",
            core: Cores.Anger)
        
        static let UsePhysicalForce = EmotionResponseAction(
            name: "Physical Force",
            description: "Trap or physically harm someone or something.",
            core: Cores.Anger)
        
        static let Undermine = EmotionResponseAction(
            name: "Undermine",
            description: "Take action to make someone or something weaker or less effective, usually in a secret or gradual way.",
            core: Cores.Anger)
        
        static let ScreamYellAnger = EmotionResponseAction(
            name: "Scream / Yell",
            description: "Lose control of one's speech; speak loudly and possibly at a higher pitch.",
            core: Cores.Anger)
        
        //Anger Intentional
        static let SetLimits = EmotionResponseAction(
            name: "Set Limits",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let BeFirm = EmotionResponseAction(
            name: "Be Firm",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let WalkAwayAnger = EmotionResponseAction(
            name: "Walk Away",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let TakeTimeOut = EmotionResponseAction(
            name: "Time Out",
            description: "//TODO:", //Sometimes the best solution is to take a step back and walk away for a few moments. This not only helps to ease the tension of a tough situation, it allows you to catch your breath, organize your thoughts, and gain your composure. This can also be useful if you are by yourself and the thoughts in your head are starting to make you angry. Close your eyes and take a deep breath and think of something pleasant that you like and enjoy.
            isIntentional: true,
            core: Cores.Anger)
        
        static let BreatheAnger = EmotionResponseAction(
            name: "Breathe",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let PracticePatience = EmotionResponseAction(
            name: "Use Patience",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let ReframeAnger = EmotionResponseAction(
            name: "Reframe",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let DistractAnger = EmotionResponseAction(
            name: "Distract",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let AvoidAnger = EmotionResponseAction(
            name: "Avoid",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
        static let RemoveInterference = EmotionResponseAction(
            name: "Remove Interference",
            description: "//TODO:",
            isIntentional: true,
            core: Cores.Anger)
        
    }
    
    // TODO: Trigger Descriptions
    struct Triggers {
       // static let Violence = Trigger(name: "Violence", category: "Conflict")
        //conflict
        static let Disagreement = Trigger(
            name: "Disagreement",
            description: "Was a part of, or witnessed a disagreement or argument //TODO",
            category: .conflict)//
        
        static let Criticism = Trigger(
            name: "Criticism",
            description: "When we hear criticism, it often triggers deep feelings of shame, embarrassment, frustration, anger, inadequacy, hopelessness, etc. making it difficult for them to perceive the whole picture",
            category: .conflict)//
        
        static let Yelling = Trigger(
            name: "Yelling",
            description: "Witnessed, or was the subject of yelling //TODO",
            category: .conflict)//
        
        static let Violence = Trigger(
            name: "Violence",
            description: "Witnessed or was subject to an act of violence //TODO",
            category: .conflict)//
        
        static let Abuse = Trigger(
            name: "Abuse",
            description: "Witnessed, or was subject to an act of abuse //TODO",
            category: .conflict)//
        
        static let Discrimination = Trigger(
            name: "Discrimination",
            description: "Witnessed discrimination or was discriminated against //TODO",
            category: .conflict)//
        
        //powerlessness
        static let EnclosedSpace = Trigger(
            name: "Enclosed Space",
            description: "Witnessed or experienced an enclosed space //TODO",
            category: .lossOfPower)//
        
        static let Coercion = Trigger(
            name: "Coercion",
            description: "Was pursuaded into doing something by threat or by force //TODO",
            category: .lossOfPower)//
        
        static let Possessiveness = Trigger(
            name: "Possessiveness",
            description: "//TODO",
            category: .lossOfPower)//
        
        static let CrossedBoundary = Trigger(
            name: "Crossed Boundaries",
            description: "//TODO",
            category: .lossOfPower)//
        
        static let Authority = Trigger(
            name: "Authority",
            description: "//TODO",
            category: .lossOfPower)//
        
        //rejection/dismissal
        static let Invalidation = Trigger(
            name: "Invalidation",
            description: "//TODO",
            category: .rejection)//
        
        static let BeingIgnored = Trigger(
            name: "Being Ignored",
            description: "Was ignored or disregarded by another person //TODO",
            category: .rejection)//
        
        static let Lonliness = Trigger(
            name: "Loneliness",
            description: "Witnessed or experienced a form of lonliness //TODO",
            category: .rejection)//
        
        static let BeingMisunderstood = Trigger(
            name: "Being Misunderstood",
            description: "Failed to have your intentions, thoughts, actions or ideas interpreted properly//TODO",
            category: .rejection)//
        
        static let Rejection = Trigger(
            name: "Rejection",
            description: "Had your emotions, ideas, feelings or affections refused or dismissed //TODO",
            category: .rejection)//
        
        static let Abandonment = Trigger(
            name: "Abandonment",
            description: "Was refused support, love, or care by a caretaker //TODO",
            category: .rejection)//
        
        //Intimacy
        static let BeingTouched = Trigger(
            name: "Being Touched",
            description: "Was touched physically in an unwanted way //TODO",
            category: .intimacy)
        
        static let Sex = Trigger(
            name: "Sex",
            description: "Witnessed or was apart of a sexual act //TODO",
            category: .intimacy)//
        
        static let BeingDependedOn = Trigger(
            name: "Being Depended On",
            description: "//TODO",
            category: .intimacy)//
        
        static let ExpressingNeeds = Trigger(
            name: "Expressing Needs",
            description: "//TODO  ...(Or opinions)",
            category: .intimacy)//
        
        //Deciet
        static let Lies = Trigger(
            name: "A Lie",
            description: "Was lied to, discovered, or witnessed a lie being told //TODO",
            category: .deciet)//
        
        static let Accusations = Trigger(
            name: "Accusations",
            description: "Was accused of doing something //TODO (that you didn't do??)",
            category: .deciet)//
        
        static let Gaslighting = Trigger(
            name: "Gaslighting",
            description: "//TODO",
            category: .deciet)//
        static let PassiveAggression = Trigger(
            name: "Passive-Aggression",
            description: "Witnessed, or was subject to an act of passive-aggression (\(EmotionConstants.Responses.PassiveAggression.description))//TODO",
            category: .deciet) //TODO: Multiple Categories?
        static let Inconsistency = Trigger(
            name: "Inconsistency",
            description: "//TODO",
            category: .deciet)//
        static let Manipulation = Trigger(
            name: "Manipulation",
            description: "//TODO",
            category: .deciet)//
        
        //sensory
        static let SuddenMovements = Trigger(
            name: "Sudden Movements",
            description: "//TODO",
            category: .sensory)//
        static let Lights = Trigger(
            name: "Lights",
            description: "//TODO (Bright, Flashing, etc)",
            category: .sensory)//
        static let Noise = Trigger(
            name: "Noise",
            description: "//TODO Loud Noise, Familiar Noise, etc",
            category: .sensory)//
        
        //failure
        static let Responsibility = Trigger(
            name: "Responsibility",
            description: "//TODO",
            category: .failure)//
        
        static let Pressure = Trigger(
            name: "Pressure",
            description: "//TODO",
            category: .failure)//
        
        static let Mistakes = Trigger(
            name: "Mistakes",
            description: "//TODO",
            category: .failure)//
        
        //People
        static let Crowd = Trigger(
            name: "Crowd of People",
            description: "//TODO",
            category: .people)
        static let Family = Trigger(
            name: "Family",
            description: "//TODO",
            category: .people)
        static let LikeAbuser = Trigger(
            name: "Somone Like your Abuser",
            description: "//TODO",
            category: .people)//
        
        //Medical
        static let Hospitals = Trigger(
            name: "Hospitals",
            description: "//TODO",
            category: .medical)//
        static let Illness = Trigger(
            name: "Illness",
            description: "//TODO",
            category: .medical)//
        static let Doctors = Trigger(
            name: "Doctors",
            description: "//TODO",
            category: .medical)//
        static let BloodGore = Trigger(
            name: "Blood/Gore",
            description: "//TODO",
            category: .medical)//
        
        //Other
        static let Positivity = Trigger(
            name: "Positivity",
            description: "//TODO ... Somoene else's positivity, such as people who have it easier, compliments, or seeing other's healthy relationships.",
            category: .other)//
        static let Holidays = Trigger(
            name: "Holidays",
            description: "//TODO",
            category: .other)//
        static let Therapy = Trigger(
            name: "Therapists",
            description: "//TODO",
            category: .other)//
        static let Religion = Trigger(
            name: "Religion",
            description: "//TODO",
            category: .other)//TODO: Powerlessness? :(
        static let Money = Trigger(
            name: "Money",
            description: "//TODO",
            category: .other)//
        static let Object = Trigger(
            name: "An Object",
            description: "//TODO",
            category: .other)
        
        /*
        What was the source of the trigger?
         
         Sight,
         Sound,
         Interaction with someone
         Internal Thought
         
         
         [Interaction with someone]
            WHO?
            Family,
                Mom,
                Dad,
                Sibling,
                Child,
                Other,
            Significant Other,
            Friend,
            Stranger
         
         Sound
         Smell
         Place
         Thing
         
         Internal Thoughts
            About:
                Person
         
         Noun
            Person
            Sight
            Smell
            Touch
         
         
         [Person's Action]
            Conflict: disagreement, criticism, anger, yelling, violence, others being abused, discrimination

         
         Powerlessness:
            [Place]
                enclosed spaces,
            [Person's Action]
                coercion, possessiveness, crossed boundaries, authority

         [Person's Action]
         Dismissal: invalidation, being ignored, loneliness, being misunderstood, rejection, abandonment

         [Person's Action]
         Intimacy: being touched, sex, romance, being depended on, expressing needs and opinions

         []
         Deceit: lies, accusations, gaslighting, passive-aggression, inconsistency, manipulation

         []
         Sensory overload: sudden movements, bright lights, loud noises

         Addictions: drugs, cigarettes, alcohol

         Failure: resting, responsibility, pressure, accidental rudeness, mistakes

         People: crowds, family, people similar to abusers

         Your body: mirrors, injuries

         Positivity: people who have it easier, compliments, healthy relationships

         Medical: hospitals, illness, doctors

         Others: holidays, incompetent therapists, religion, money, bad hygiene, objects
         
         
            
        //, Sound, Event, Thought, Smell
        
        
        //Trigger sources
        // Person ->
        //
        
        */
        
    }
    
    //TODO: Changes descriptions
    struct PhysicalChanges {
        //Adrenaline removed because physical affects of adrenaline are listed?
            //TODO: Rapid thinking? Uncontrollable thought patterns?
        static let HighBP = PhysicalChange(
            name: "High Blood Pressure",
            description: "//TODO")
        
        static let HighHR = PhysicalChange(
            name: "High Heart Rate",
            description: "//TODO")
        
        static let RapidBreathing = PhysicalChange(
            name: "Rapid Breathing",
            description: "//TODO shallow breathing, shortness of breath")
        
        
        
        static let Headache = PhysicalChange(
            name: "Headache",
            description: "//TODO")
        
        static let TremblingMuscles = PhysicalChange(
            name: "Trembling Muscles",
            description: "//TODO")
        
        static let Sweating = PhysicalChange(
            name: "Sweating",
            description: "//TODO")
        
        static let TunnelVision = PhysicalChange(
            name: "Tunnel Vision",
            description: "//TODO")
        
        static let LossOfControl = PhysicalChange(
            name: "Loss of Control",
            description: "//TODO")
        
        static let GooseBumps = PhysicalChange(
            name: "Chills / Shivers",
            description: "//TODO (goosebumps)")
        
        static let Butterflies = PhysicalChange(
           name: "Uneasy Stomach / 'Butterflies'",
           description: "//TODO")
        
        static let Crying = PhysicalChange(
            name: "Crying",
            description: "//TODO")
        static let LumpInThroat = PhysicalChange(
            name: "Lump in Throat",
            description: "//TODO")
        static let ShakyVoice = PhysicalChange(
            name: "Shaky Voice",
            description: "//TODO")
        static let EmotionalPain = PhysicalChange(
            name: "Emotional Pain",
            description: "//TODO")
        static let StomachPain = PhysicalChange(
            name: "Stomach Pain",
            description: "//TODO")
        static let HeartAche = PhysicalChange(
            name: "Heart Ache",
            description: "//TODO")
  
    }
    
    struct PsychologicalChanges {

        static let FeltAttacked = PsychologicalChange(
            name: "Felt Attacked",
            description: "//TODO")
        static let FeltThreatened = PsychologicalChange(
            name: "Felt Threatened",
            description: "//TODO")
        static let ExpectedPersonToLeave = PsychologicalChange(
            name: "Expected Person to Leave",
            description: "//TODO")
        static let FeltSick = PsychologicalChange(
            name: "Felt Sick",
            description: "//TODO")
        static let FeltEmpty = PsychologicalChange(
            name: "Felt Empty",
            description: "//TODO")
        static let FeltWronged = PsychologicalChange(
            name: "Felt Wronged",
            description: "//TODO")
        static let FeltRighteous = PsychologicalChange(
            name: "Felt Righteous",
            description: "//TODO")
        static let FeltSurprised = PsychologicalChange(
            name: "Felt Surprised",
            description: "//TODO")
        static let FeltSelfLoathing = PsychologicalChange(
            name: "Felt Self-Loathing",
            description: "//TODO")
        static let FeltLoved = PsychologicalChange(
            name: "Felt Loved",
            description: "//TODO")
        static let FeltBetrayed = PsychologicalChange(
            name: "Felt Betrayed",
            description: "//TODO")
        static let FeltInsecure = PsychologicalChange(
            name: "Felt Insecure",
            description: "//TODO")
        static let FeltHatred = PsychologicalChange(
            name: "Felt Hatred",
            description: "//TODO")
        static let WantedToBeAlone = PsychologicalChange(
            name: "Wanted to be Alone",
            description: "//TODO")
        static let FeltLonely = PsychologicalChange(
            name: "Felt Lonely",
            description: "//TODO")
    }
    
    struct CopingMethods {
        
        static func getAllMethods() -> [CopingMethod] {
            return [
                mindfulness,
                meditation,
                tobacco,
                marijuana,
                eating,
                venting,
                electronics,
                alcohol,
                sexualActivity,
                exercise,
                walk,
                hardDrugs,
                recklessness,
                gambling,
                selfHarm,
                humor,
                shopping,
                junkFood,
                music,
                progressiveRelaxation,
                attentionSeeking,
                caffeine,
                working,
                sleeping
            ]
        }
        
        //Support
        
        //Relaxation
        static let mindfulness = CopingMethod(
            name: "Practice Mindfulness",
            description: "Mindfulness is the basic human ability to be fully present, aware of where we are and what we’re doing, and not overly reactive or overwhelmed by what’s going on around us.",
            category: .relaxation)
        
        
        static let meditation = CopingMethod(
            name: "Meditation",
            description: "Meditation is exploring. When we meditate we venture into the workings of our minds: our sensations, our emotions and thoughts.",
            category: .relaxation)
        
        static let exercise = CopingMethod(name: "Exercise", description: "Exercise can serve as a natural and healthy form of stress relief. This can include things such as running, swimming, yoga or going to the gym", category: .physicalActivity)
        
        static let walk = CopingMethod(name: "Walk", description: "Going for a walk can help change your environment, and clear your head.", category: .physicalActivity)
        
        static let humor = CopingMethod(name: "Humor", description: "Making light of a stressful situation may help people maintain perspective and prevent the situation from becoming overwhelming.", category: .humor)
        
        static let music = CopingMethod(name: "Music", description: "Listening to music can help remove you from stressful situations and focus your mind", category: .relaxation)// + Escape?
        
        static let progressiveRelaxation = CopingMethod(name: "Progressive Relaxation", description: "A relaxation technique that focues on relaxing various parts of the body one by one", category: .relaxation)
        
        // TODO: revisit category descriptions below
        // TODO: revisit categories. Some fall into multiple categories
        static let tobacco = CopingMethod(
            name: "Tobacco Use",
            description: "Use of tobacco by smoking, dipping, is often used to relief stress",
            category: .unhealthysoothing)
        
        static let marijuana = CopingMethod(
            name: "Marijuana Use",
            description: "Use of marijuana by smoking or ingesting can help numb emotions, relieve stress and disassociate from current circumstances.",
            category: .unhealthysoothing)
        
        static let eating = CopingMethod(
            name: "Over-Eating",
            description: "TODO",
            category: .unhealthysoothing)
        
        static let venting = CopingMethod(
            name: "Venting",
            description: "TODO: Venting to a friend, family member, or therapist about the stressful situation.",
            category: .support)
        
        static let electronics = CopingMethod(
            name: "Electronics Use", description: "TODO: ... Dissociating into electronics such as tv, video games, or the internet can help us forget ", category: .unhealthysoothing) // + Escape
        
        static let alcohol = CopingMethod(
            name: "Alcohol Use",
            description: "Alcohol is often used as a coping mechanism to numb physical and emotional pain",
            category: .numbing)
        
        static let sexualActivity = CopingMethod(name: "Sexual Activity", description: "Various forms of sexual activity including masturbation, looking at pornogrophy, sex or seeking of these things", category: .compulsions)
        
        static let hardDrugs = CopingMethod(name: "Hard Drugs", description: "Using hard drugs can help us escape or numb the pain we feel inside.", category: .numbing)//TODO: Multiple categories?
        
        static let recklessness = CopingMethod(name: "Recklessness", description: "Engaging in unsafe or risky behavior.", category: .risktaking)
        
        static let gambling = CopingMethod(name: "Gambling", description: "Gambling often rewards us with the feeling of victory or the pain of loss.", category: .risktaking) //TODO: Better description
        
        static let selfHarm = CopingMethod(name: "Self Harm", description: "People may engage in self-harming behaviors to cope with extreme stress or trauma.", category: .harmSelf)
        
        static let junkFood = CopingMethod(name: "Junk Food", description: "Eating unhealthy food can give us a sugar rush and a feeling of comfort", category: .numbing)//TODO: Category?
        
        static let shopping = CopingMethod(name: "Shopping", description: "TODO: ", category: .unhealthysoothing)//TODO: Description and category? RESEARCH THESE MORE
        
        static let attentionSeeking = CopingMethod(name: "Attention Seeking", description: "Seeking attention can be a way to validate yourself and feel better by having the attention of people that matter to you", category: .support) //Negaive way to recieve support?  maybe category also includes
        
        static let caffeine = CopingMethod(name: "Caffeine", description: "Caffeine is addictive because of the way that the drug affects the human brain and produces the alert feeling that people crave.", category: .compulsions) //TODO: Category wrong
        
        static let working = CopingMethod(name: "Working", description: "Overworking can be a way to escape... //TODO: ", category: .escape) //TODO: Category wrong
        
        static let sleeping = CopingMethod(name: "Sleeping", description: "Going to bed or sleeping as a way to escape things in life you don't want to face", category: .escape)
        
        
        //TODO: Napping? Didn't Cope?
    }
    
    struct Colors {
        
        static let AngerColor1 : Color = Color(red: 0.969, green: 0.384, blue: 0.384)
        static let AngerColor2 : Color = Color(red: 0.839, green: 0.733, blue: 0.733)
        
        
        static let SadnessColor1 = Color(red: 0, green: 0.733, blue: 0.941)
        static let SadnessColor2 = Color(red: 0.762, green: 0.86, blue: 0.887)
        
        
        static let DisgustColor1 = Color(red: 0.137, green: 0.639, blue: 0.578)
        static let DisgustColor2 = Color(red: 0.692, green: 0.754, blue: 0.746)
        
        
        static let FearColor1 = Color(red: 0.589, green: 0.325, blue: 0.655)
        static let FearColor2 = Color(red: 0.826, green: 0.795, blue: 0.833)
        
        
        static let JoyColor1 = Color(red: 0.98, green: 0.737, blue: 0.255)
        static let JoyColor2 = Color(red: 0.842, green: 0.801, blue: 0.719)
        
    }
    
    //todo: Put these in a struct?
    static func getStatesByResponses(_ responses : [EmotionResponseAction]) -> [EmotionState]{
        
        var retArr : [EmotionState] = []
        
        if let unwrappedCore = responses.first?.core {
            
            retArr = getStatesByCore(unwrappedCore)
            
            responses.forEach{response in
                retArr.forEach{state in
                    if !state.responseActions.contains(response){
                        retArr.removeAll(where: {$0 == state})
                    }
                }
            }
            
            
        }
        
        
        
        //get all by core,
        //filter by state contains repsonses
        
        
        
        
        
        return retArr
    }
    
    /**
     Returns all of the states associated to a core emotion
     */
    static func getStatesByCore(_ core : CoreEmotion) -> [EmotionState]{
        
        if(core == Cores.Anger){
            return[
                States.Annoyance,
                States.Frustration,
                States.Exasperation,
                States.Argumentativeness,
                States.Bitterness,
                States.Vengefulness,
                States.Fury
            ]
        }else if(core == Cores.Fear){
            return[
                States.Trepidation,
                States.Nervousness,
                States.Anxiety,
                States.Dread,
                States.Desperation,
                States.Panic,
                States.Horror,
                States.Terror]
        }else if(core == Cores.Sadness){
            return[
                States.Disappointment,
                States.Discouragement,
                States.Distraughtness,
                States.Resignation,
                States.Helplessness,
                States.Hopelessness,
                States.Misery,
                States.Despair,
                States.Grief,
                States.Sorrow,
                States.Anguish
            ]
        }else if(core == Cores.Disgust){
            return[
                States.Dislike,
                States.Aversion,
                States.Distaste,
                States.Repugnance,
                States.Abhorrence,
                States.Loathing
            ]
        }else if(core == Cores.Joy){
            return [
                States.SensoryPleasure,
                States.Rejoicing,
                States.CompassionateJoy,
                States.Amusement,
                States.Schadenfreude,
                States.Relief,
                States.Peace,
                States.Fiero,
                States.Pride,
                States.Naches,
                States.Wonder,
                States.Excitement,
                States.Ecstasy
            ]
        }
        return []
        
    }
    
}


//TODO: Control fallacies - Internal / External locus of control? (external: blaming, ...)
//TODO: Needing to be right?
enum CognitiveDistortions : String, CaseIterable {
    
    case Filtering, Polarization, Overgeneralization, DiscountingThePositive, Catastrophizing, Personalization, FallacyOfFairness, ShouldStatements, EmotionalReasoning, Labeling
    
    var SimpleText : String {
        switch self{
            
            
        case .DiscountingThePositive:
            return "Discounting the Positive"
            
        case .FallacyOfFairness:
            return "Fallacy of Fairness"
            
        case .ShouldStatements:
            return "Should Statements"
            
        case .EmotionalReasoning:
            return "Emotional Reasoning"
            
        default: return self.rawValue
        }
    }
    
    var Description : AttributedString {
        switch self{
            
        case .Filtering :
            return "The tendency to ignore the positives of a situion and focus solely on the negatives.\n\nInterpreting circumstances using a negative mental filter gives you an inaccurate perception of a situation, which can lead to false beliefs about ones self and bring about anxiety and depression symptoms\n\nThis negative perspective of yourself and your future can cause feelings of hopelessness, and may become extreme enough to spiral into suicidal thoughts."
            
        case .Polarization:
            return "Also called 'All-Or-Nothing, or 'Black and White' thinking, this distortion happens when people think in extremes. When you engage in polarized thinking, everything is put into 'either/or' categories, which makes you miss the true complexity of most people and situations. This leads to extremely unrealistic standards for yourself and others that can affect relationships or motivation. Not anything, including yourself, is completely good or bad, most of the time, reality exists somewhere between the two extremes."
            
        case .Overgeneralization:
            return "When people overgeneralize, they tend to reach a conclusion about one event, then incorrectly apply that conclusion across the board. This turns a negative event into a never-ending pattern of loss and defeat. Overgeneralization can also manifest into your thoughts about the world and its events. Someone who overgeneralizes tends to frequently speak in absolutes, using words like 'always', 'never', 'everything', and 'nothing'. Overgeneralization has also been associated with PTSD and other anxiety disorders."
            
        case .DiscountingThePositive:
            return "Similar to Mental Filtering, discounting the positive involves a negative bias in thinking. Instead of overlooking positives, you dismiss positives as something of no value to you, such as a 'fluke', or 'luck'. This cognitive distortion prevents you from seeing the good in yourself or others, leading to a lowered sense of self-esteem or self-value, reducing motivation and cultivating a sense of 'learned helplessness'."
            
        case .Catastrophizing:
            return "Jumping to conclusions to the worst possible conclusion in every scenario, no matter how improbably it is. This distortion often comes with 'what if' questions. What if he is late because he doesn't want to spend time with me? What if she didn't call because she got in an accident? Often dismessed as a 'hysterical over-reaction', this distortion may be developed from an experience of repeated adverse events - like chronic pain or childhood trauma."
            
        case .Personalization:
            return "The belief that you are responsible for events that, in reality, are completely (or partially) out of your control or even not connected to you at all. This often results in feeling guilty, or assigning blame without contemplating all factors involved. Taking things personally has been associated with heightened anxiety and depression."
            
        case .FallacyOfFairness:
            return "Measuring every behavior and situation on a scale of fairness. Finding that other people don't assign the same value of fairness to an event or situation, resulting in resentment. This cognitive distortion will lead you to face conflict with certain people an situations because you feel the need for everything to be 'fair' according to your own perspective. Fairness is rarely absolute and can often be self serving."
            
        case .ShouldStatements:
            return "Statements that are subjective ironcald rules you set for yourself and others without considering the specifics of a circumstance. You tell yourself things *should* be a certain way with no exceptions. These types of thoughts are often rooted in internalied family or cultural expectations which might not be appropriate for an individual or a situation. When these 'should' events don't happen, you feel guilty, disappointed, let down or frustrated. This type of thinking can diminish your self-esteem and raise anxiety levels."
            
        case .EmotionalReasoning:
            return "The false belief that your emotions are the truth and that the way you feel about a situation is a reliable indicator of reality. The thought process 'I feel this way about this situation, hence it must be a fact' defines this distortion. While it's important to listen to, validate, and feel your emotions, it's also important to judge reality based on rational evidence. Our emotions tell us a lot, but they are also often rooted in subconcious past experiences." //TODO: Rewrite last sentance?
            
        case .Labeling:
            return "Labeling is a cognitive distortion in which people reduce themselves or others to a single - usually negative - characteristic or descriptor such as 'failure', 'addict' or 'stupid'. This extreme form of overgeneralization leads you to judge an action without taking the context into account. Assigning labels can impact how you view yourself, and how you interact with others. It can hurt your self-esteem and confidence, leading to insecurity and anxiety."
            
            
            
        }
    }
    
    var Example : AttributedString {
        switch self{
        case .Filtering :
            return "It’s performance review time at your company, and your manager compliments your hard work several times. In the end, they make one improvement suggestion. You leave the meeting feeling miserable and dwell on that one suggestion all day long."
        case .Polarization:
            return "You generally eat healthy foods, but today, you didn't have time to prepare a meal, so you eat a bacon burger. This immediately leads you to conclude that you've ruined your healthy eating routine, and you give up on it entirely."
            
        case .Overgeneralization:
            return "You are running late for work, and on your way there you hit a red light. You think, 'NOTHING EVER goes my way!'"
            
        case .DiscountingThePositive:
            return "Someone compliments the way you look today, and you think they are just being nice. Your boss tells you that you did a good job on a project, but you discount it as something anyone else could do."
            
        case .Catastrophizing:
            return "An expected check doesn't arrive in the mail, and you think it will never arrive, and now you won't be able to pay rent and your family will get evicted."
            
        case .Personalization:
            return "Your child had an accident at a birthday party, and you blame yourself for allowing them to go. If your partner had woken up earlier, you wouldn't have been late for work. Your friend is talking about their personal beliefs, and you take their words as an atack against *your* beliefs."
            
        case .FallacyOfFairness:
            return "You expect your partner to come home from work and massage your feet. It's only 'fair' since you spent all afternoon cooking them dinner. However, they are exhausted and only want to take a bath. They believe it's 'fair' to take a moment to relax and decompress from the day's chaos, before they can give you their full attention and enjoy dinner."
            
        case .ShouldStatements:
            return "You believe you're trying to motivate yourself with statements such as 'I should go to the gym every day', however, you got out of work late and couldn't get there in time. You feel negatively about yourself because you didn't do what you _should_ have."
            
        case .EmotionalReasoning:
            return "Someone says something that makes you angry, and you immediately conclude that the person is treating you poorly."
            
        case .Labeling:
            return "You see a new teammate applying makeup before a meeting, and call them 'shallow'. Your partner doesn't do a chore you expect them to do and you label them as 'useless'. You forget to turn off the oven after baking and you label yourself as 'stupid'."
        }
    }
    var NegativeThought : AttributedString {
        switch self{
            
        case .Filtering:
            return "I recieved my employee review but I can't stop thinking about one negative comment my manager made about me."
        case .Polarization:
            return "I recieved an A- on an exam when I usually only get A+. I feel like a failure."
        case .Overgeneralization:
            return "I failed on this exam, I feel like such a failure. I don't think I'm smart enough to take this calss and I will probably just fail it."
        case .DiscountingThePositive:
            return "I recieved a good mark on my assignment, but I don't think I should have. I'm pretty sure it was just good luck."
        case .Catastrophizing:
            return "There is a lot of traffic on my way to work and I'm never going to get there on time."
        case .Personalization:
            return "My partner and I show up late to a dinner party. Everyone seemed mad at me and not having a good time becase we were late."
        case .FallacyOfFairness:
            return "A friend makes more money at their job doing something similar to me. Why don't I make the same amount? It's not fair."
        case .ShouldStatements:
            return "I should stop being lazy and exercise today."
        case .EmotionalReasoning:
            return "I feel alone and uncared for because my partner does not want to spend time with me, and instead is working overtime."
        case .Labeling:
            return "Someone at work made a mistake that had severe consequences. Now I have to do extra work. Why are they so stupid?!"
        }
    }
    var ReframingThought : AttributedString {
        switch self{
            
        case .Filtering:
            return "I was lacking in one area of my review, but I performed well in all other aspects. My manager praised me for great work ethic."
        case .Polarization:
            return "I didn't do as well as hoped, but an A- is sitll a really good grade and I'm grateful."
        case .Overgeneralization:
            return "I didn't pass this examp, but in the past I have found a way to overcome a failure. I will work harder next time."
        case .DiscountingThePositive:
            return "I recieved a good grade on my assignment. I am grateful to recieve this grade and I'm proud of what I accomplished."
        case .Catastrophizing:
            return "I may be late, but I can still focus on getting there safely. In the meantime I can listen to some music on the radio."
        case .Personalization:
            return "I cannot control how people feel. There could be other factors that contributed to people not enjoying the party before arriving."
        case .FallacyOfFairness:
            return "I might not make as much money, but I am grateful for the job I have. There could be many reasons why I don't make as much."
        case .ShouldStatements:
            return "I would prefer to exercise today if I find the time and energy. If I don't exercise today, I can try again tomorrow."
        case .EmotionalReasoning:
            return "My partner is working overtime because they are busy with their work, not because they don't care for me. They spend time with me when they are free, and I'm grateful for that."
        case .Labeling:
            return "I understand that mistakes can happen. I will spend extra effort to fix it. I know they are capable of doing a better job next time."
            
        }
    }
    
}




//Name -> Acceptance?
fileprivate struct Love {
    static let love : CoreEmotion = CoreEmotion(name: "Love", description: "TODO", stateDescription: "TODO", responseDescription: "TODO")
    
    //states
    let states : [EmotionState] = [
        //Opposite of Dislike
        EmotionState(name: "Like", description: "A strong preference for something", antidote: "TODO", intensity: 0...10, responses: [], core: love),
        
        //Opposite of distaste
        //Name?
        //?? EmotionState(name: "Savory", description: "Reaction to a pleasent taste, smell, thing or idea. Can be literal or metaphorical", antidote: "TODO", intensity: 0...10, responses: [], core: love),
        
        //Opposite of abhorrence
        EmotionState(name: "Admiration", description: "A mixture of intense love and appreciation", antidote: "TODO", intensity: 0...10, responses: [], core: love),
        
        //Opposite of aversion (attraction?)
        EmotionState(name: "Attraction", description: "An impulse to seek or approach something not necessarily physical", antidote: "TODO", intensity: 0...10, responses: [], core: love),
        
        //Opposite of repugnance
        EmotionState(name: "Acceptance", description: "String taste or approval of something, often a concept, idea or person.", antidote: "", intensity: 0...10, responses: [], core: love),
        
        EmotionState(name: "Compassion", description: "A desire to want to offer caring support in order to help relieve the suffering of another", antidote: "", intensity: 0...10, responses: [], core: love),
        
        //TODO: Romantic love?
        EmotionState(name: "Infatuation", description: "An intense, romantic, passionate feeling of attraction that causes one to want to create a relationship bond or partnership", antidote: "", intensity: 0...10, responses: [], core: love)
        
        
        //compassion, opposite of loathing
        
    ]
}

/*
 
 Core: Love
 
 States: like,
        savory,
        admiration,
        accept
 
 
 
 */


