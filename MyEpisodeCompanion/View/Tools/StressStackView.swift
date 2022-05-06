//
//  StressStackView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/21/22.
//

import SwiftUI

struct StressStackView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.weight, order: .reverse)]) var stressors : FetchedResults<Stressor>
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.weight)]) var stressors : FetchedResults<Stressor>
    
    @StateObject var viewModel : StressStackViewModel = StressStackViewModel()
    
    
    
    var body: some View {
        ZStack{
            
            // Stress Stack Layer ////////
            GeometryReader{geo in
                
                //Add a new stressor
                HStack{
                    Button{
                        
                        
                        //debug
                        withAnimation(){
                            viewModel.isStressorPromptEnabled = true
                            viewModel.isDeleteSelectorEnabled = false
                        }
                        
                    } label: {
                        
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding([.top, .leading])
                            .foregroundColor(viewModel.isStressorPromptEnabled ? .red : .blue)
                        
                    }
                    Spacer()
                    VStack{
                        Text("Total Stress:").bold()
                        //Text("30").bold()
                        Text("\(viewModel.totalWeight)")
                        // Text("Stressors \(stressors.count)")
                        // Text("Rows \(viewModel.rowCount)")
                        
                    }.padding(.top)
                    .font(.title2)
                    .foregroundColor(viewModel.getDensityTotalColor())
                    
                    Spacer()
                    //Remove Stressor
                    Button{
                        viewModel.isDeleteSelectorEnabled.toggle()
                    } label: {
                        
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding([.top, .trailing])
                        
                    }.foregroundColor(viewModel.isDeleteSelectorEnabled ? .red : .blue)
                }.frame(height: 50, alignment: .center).padding(.top, 100)
                
                if !stressors.isEmpty{
                    
                    //ForEach(0...stressors.endIndex, id:\.self){index in
                    ForEach(stressors, id:\.self){stressor in
                        if let index = stressors.lastIndex(of: stressor){
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.getDensityColor(stressor.weight))
                                .frame(
                                    width: geo.size.width/3,
                                    height: geo.size.width/6)
                                .overlay(
                                   // Text("row: \(viewModel.getRow(index)) wt: \(stressor.weight) idx: \(index)").foregroundColor(.black)
                                    //Text("\(stressor.name ?? "No Name") wt: \(stressor.weight)").foregroundColor(.black)
                                    
                                    Text(stressor.name ?? "No Name")
                                    
                                ).offset(
                                    x: viewModel.getXOffset(index: index),
                                    y: viewModel.getYOffset(geo.size, index)
                                ).onTapGesture {
                                    viewModel.selectedStressor = stressor
                                    if viewModel.isDeleteSelectorEnabled {
                                        viewModel.isDeleteConfirmationPresented = true
                                    }else{
                                        viewModel.isStressorViewEnabled = true
                                    }
                                }
                        }
                    }
                    
                }
                
            }
            .confirmationDialog("Are you sure you want to add stressor ",
                                isPresented: $viewModel.isAddEditConfirmationPresented,
                                titleVisibility: .visible){
                Button("Yes"){
                    withAnimation(){
                        
                        if let edit = stressors.first(where: {$0.id == viewModel.selectedStressor?.id}){
                            
                            viewModel.editStressor(stressor: edit, context: moc)
                            
                            
                        } else {
                            viewModel.addStressor(context: moc)
                            
                        }
                        viewModel.recalculate(Array(stressors))
                        viewModel.cancelButton()
                        
                    }
                }
                Button("No", role: .cancel){
                    viewModel.cancelButton()
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete \(viewModel.selectedStressor?.name ?? "")",
                isPresented: $viewModel.isDeleteConfirmationPresented,
                titleVisibility: .visible
            ){
                Button("Yes"){
                    withAnimation(){
                        //delete stressor
                        //viewModel.selectedStressor
                        
                        if let del = stressors.first(where: {$0.id == viewModel.selectedStressor?.id}){
                            withAnimation(){
                                moc.delete(del)
                                try? moc.save()
                                viewModel.recalculate(Array(stressors))
                            }
                        }
                        viewModel.cancelButton()
                    }
                }
                Button("No", role: .cancel){
                    viewModel.cancelButton()
                }
            }
            // End Stress Stack Layer /////////
            
            if(viewModel.isStressorPromptEnabled){
                StressEditView(viewModel: viewModel)
            }else if(viewModel.isStressorViewEnabled && viewModel.selectedStressor != nil){
                StressDescriptionView(viewModel: viewModel)
            }
            
            
        }.onAppear{
            viewModel.recalculate(Array(stressors))
        }
    }
}

struct StressDescriptionView : View {
    @StateObject var viewModel : StressStackViewModel
    
    var body: some View{
        if let selectedStressor = viewModel.selectedStressor{
            ZStack{
                Color.black.opacity(0.6).ignoresSafeArea()
                Form{
                    
                    Section(header: Text("Name & Weight")){
                        Text(selectedStressor.name ?? "No Name")
                        +
                        Text("   -   \(viewModel.selectedStressor?.weight ?? 0)")
                    }
                    
                    Section(header: Text("Description")){
                        Text(selectedStressor.stressDescription ?? "No description given")
                            .padding()
                            .foregroundColor(.indigo)
                            .frame(height: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                    
                    Section(header: Text("Date Added")){
                        if let unwrappedDate = selectedStressor.addDate {
                            HStack{
                                Spacer()
                                Text(unwrappedDate, style: .date)
                                
                                Text("-")
                                
                                Text(unwrappedDate, style: .time)
                                Spacer()
                            }.frame(alignment: .center)
                        }
                       // Text("\(selectedStressor.addDate ?? Date.distantPast, style: .date)")
                    }
                    
                    
                    HStack{
                        Button("Edit"){
                            withAnimation(){
                                viewModel.isStressorViewEnabled = false
                                viewModel.isStressorPromptEnabled = true
                            }
                        }.buttonStyle(NextButtonStyle())
                        
                        Button("Cancel", role: .cancel){
                            viewModel.cancelButton()
                        }.buttonStyle(NextButtonStyle())
                    }
                    
                }.frame(height: 500, alignment: .center).cornerRadius(20).padding()
            }
        }
    }
}

struct StressEditView : View {
    @StateObject var viewModel : StressStackViewModel
    
    @State var selectedInventoryStressor: StressInventory = StressInventory.custom10
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.6).ignoresSafeArea()
            Form{
                Section(header: Text("Choose a stress level or event")){
//                    HStack{
//                        Text("Stress Weight")
//                        Spacer()
//                        Text("Life Event")
//                    }
                    //Text("Choose a stress level or event")
                    Picker(selection: $selectedInventoryStressor, label: EmptyView()){
                        ForEach(StressInventory.allCases, id: \.self){item in
                            HStack{
//                                Text("\(item.weight)").padding(.leading)
//                                Spacer()
                                Spacer()
                                Text("\(item.weight) - \(item.rawValue)").padding(.trailing)
                                Spacer()
                            }
                        }
                    }.pickerStyle(.menu)
                        .onChange(of: selectedInventoryStressor){_ in
                            viewModel.stressWeight = selectedInventoryStressor.weight
                            if(!selectedInventoryStressor.rawValue.contains("Other")){
                                viewModel.stressName = selectedInventoryStressor.rawValue
                                viewModel.stressDescription = selectedInventoryStressor.description
                            }else if let unwrappedStressor = viewModel.selectedStressor{
                                viewModel.stressName = unwrappedStressor.name ?? ""
                                viewModel.stressDescription = unwrappedStressor.stressDescription ?? ""
                            }else{
                                viewModel.stressName = ""
                                viewModel.stressDescription = ""
                            }
                        }
                }.frame(alignment: .center)
                
                Section{
                    Text("\(selectedInventoryStressor.description)")
                        .padding()
                        .foregroundColor(.indigo)
                        .frame(height: 100, alignment: .center)
                        .multilineTextAlignment(.center)
                }
                
                Section{
                    TextField("Stress Name", text: $viewModel.stressName)
                    TextField("Stress Description", text: $viewModel.stressDescription)
                }
                
                HStack{
                    Button("Submit"){
                        if(viewModel.isValidStressor()){
                            viewModel.isAddEditConfirmationPresented = true
                        }
                    }.buttonStyle(NextButtonStyle())
                    
                    Button("Cancel", role: .cancel){
                        viewModel.cancelButton()
                    }.buttonStyle(NextButtonStyle())
                }
                
            }.frame(height: 500, alignment: .center).cornerRadius(20).padding()
                .onAppear{
                    if let unwrappedStressor = viewModel.selectedStressor {
                        if let unwrappedInventory = StressInventory.allCases.first(where: {
                            $0.rawValue == unwrappedStressor.name
                            ||
                            ($0.weight == unwrappedStressor.weight && $0.rawValue.contains("Other"))
                        }){
                            
                            selectedInventoryStressor = unwrappedInventory
                            viewModel.stressName = unwrappedStressor.name ?? ""
                            viewModel.stressDescription = unwrappedStressor.stressDescription ?? ""
                            
                        }
                    }
                }
        }
    }
}

struct StressStackView_Previews: PreviewProvider {
    static var previews: some View {
        //StressEditView(viewModel: StressStackViewModel())
        StressDescriptionView(viewModel : StressStackViewModel())
//        StressStackView()
//            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
