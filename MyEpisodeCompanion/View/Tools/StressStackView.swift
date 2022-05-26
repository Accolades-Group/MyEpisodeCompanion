//
//  StressStackView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/21/22.
//

import SwiftUI

struct StressStackView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.weight, order: .reverse)], predicate: NSPredicate(format: "removeDate == nil")) var stressors : FetchedResults<Stressor>
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.weight)]) var stressors : FetchedResults<Stressor>
    
   // @State var stressors : [Stressor] = [Stressor(), Stressor(), Stressor()]
    
    @StateObject var viewModel : StressStackViewModel = StressStackViewModel()
    
    
    //TODO: Zstack causes buttons to appear over top of menubar
    //      On checkin view, spacing between question and top of stress total + buttons
    var body: some View {
      //  VStack{
        ZStack{
            
            VStack{
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
                        Text("\(viewModel.totalWeight)").foregroundColor(viewModel.getDensityTotalColor())

                    }.padding(.top)
                        .font(.title2)
                        
                    
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
                }.frame(height: 50, alignment: .center).padding(.bottom, 10)
                
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing:1){
                    
                    let rowCount = (stressors.count % viewModel.colCount == 0) ? (stressors.count / 2) : (stressors.count / 2) + 1
                            
                    
                    ForEach(0..<rowCount){row in
                        
                        HStack(spacing:1){
                            Spacer()
                            ForEach(0..<2){col in
                                
                                let index = (row * 2) + col
                                
                                if index < stressors.count{
                                    let stressor = stressors[index]
                                    
                                    StressShape(color: viewModel.getDensityColor(stressor.weight), width: viewModel.stressW - 10, height: viewModel.stressH, stressor: stressor).onTapGesture{
                                    
                                        
                                        viewModel.selectedStressor = stressor
                                        if viewModel.isDeleteSelectorEnabled {
                                            viewModel.isDeleteConfirmationPresented = true
                                        }else{
                                            viewModel.isStressorViewEnabled = true
                                        }
                                    }
                                    
                                }

                            }
                            Spacer()
                        }.rotationEffect(.radians(.pi))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                        
                    }
                    
                    }.onAppear{
                        viewModel.recalculate(Array(stressors))
                    }

                    //.rotationEffect(.radians(.pi))
                    //.scaleEffect(x: -1, y: 1, anchor: .center)
                    
                //   ForEach(0..<rows){row in
                        

                   // }
//                    ForEach(0..<rows){row in
//                        HStack{
//                            Spacer()
//                            ForEach(0..<cols){col in
//                                if let stressor = stressors[row + col]{
//                                    //StressShape(color: .blue, width: 50, height: 50, stressor: stressor)
//                                    Text("HI!")
//                                }
//                            }
//                            Spacer()
//                        }
//                    }
                    
                    
                    // Stress Stack Layer ////////
                    /*
                     GeometryReader{geo in
                     
                     //Add a new stressor
                     
                     HStack{
                     
                     }.onAppear{
                     //TODO: Messy? Move?
                     viewModel.stressW = CGFloat(geo.size.width / 2) - viewModel.stackPadding
                     viewModel.areaBottom = geo.size.height
                     }
                     
                     
                     if !stressors.isEmpty{
                     
                     
                     //ForEach(0...stressors.endIndex, id:\.self){index in
                     
                     ForEach(stressors, id:\.self){stressor in
                     
                     if let index = stressors.lastIndex(of: stressor){
                     
                     
                     
                     StressShape(color: viewModel.getDensityColor(stressor.weight), width: viewModel.stressW, height: viewModel.stressH, stressor: stressor)
                     .offset(
                     x: viewModel.getXOffset(index: index),
                     y: viewModel.getYOffset(index)
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
                     }//.frame(width: geo.size.width, height: geo.size.height - 50, alignment: .center)
                     */
                    
                }
                    .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
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
                                viewModel.deleteStressor(stressor: del, context: moc)
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
            .confirmationDialog("Are you sure you want to add stressor ",
                                isPresented: $viewModel.isAddEditConfirmationPresented,
                                titleVisibility: .visible){
                Button("Yes"){
                    withAnimation(){
                        viewModel.cancelButton()
                        
                        if let edit = stressors.first(where: {$0.id == viewModel.selectedStressor?.id}){
                            
                            viewModel.editStressor(stressor: edit, context: moc)
                            
                        } else {
                            withAnimation(){
                                viewModel.addStressor(context: moc)
                            }
                            
                        }
                        viewModel.recalculate(Array(stressors))
                        
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
            
            
        }
        //}
        .onAppear{
            
            viewModel.recalculate(Array(stressors))
            
        }
    }
}

struct StressDescriptionView : View {
    @StateObject var viewModel : StressStackViewModel
    
    var body: some View{
        if let selectedStressor = viewModel.selectedStressor{
            ZStack{
                Color.black.opacity(0.6)//.ignoresSafeArea()
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
                    
                    VStack{
                        
                    HStack{
                        Spacer()
                        Button("Edit"){
                                viewModel.isStressorViewEnabled = false
                                viewModel.isStressorPromptEnabled = true
                        }.buttonStyle(NextButtonStyle())
                        Spacer()
                        Button("Cancel", role: .cancel){
                            viewModel.cancelButton()
                        }.buttonStyle(NextButtonStyle())
                        Spacer()
                    }
                        Button("Delete"){
                            //viewModel.cancelButton()
                            viewModel.isDeleteConfirmationPresented = true
                        }.buttonStyle(DeleteButtonStyle())
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
            Color.black.opacity(0.6)//.ignoresSafeArea()
            Form{
                Section(header: Text("Choose a stress level or event")){

                    Picker(selection: $selectedInventoryStressor, label: EmptyView()){
                        ForEach(StressInventory.allCases, id: \.self){item in
                            HStack{
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
                    Spacer()
                    Button("Submit"){
                        if(viewModel.isValidStressor()){
                            viewModel.isAddEditConfirmationPresented = true
                        }
                    }.buttonStyle(NextButtonStyle())
                    Spacer()
                    Button("Cancel", role: .cancel){
                        viewModel.cancelButton()
                    }.buttonStyle(NextButtonStyle())
                    Spacer()
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
        //StressDescriptionView(viewModel : StressStackViewModel())
        StressStackView()
            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
