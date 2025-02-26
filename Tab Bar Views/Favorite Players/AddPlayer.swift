//
//  AddPlayer.swift
//  HoopIQ
//
//  Created by CS3714 Team 6 on 12/7/24.
//  Copyright © 2024 CS3714 Project Group 6. All rights reserved.
//  Created by Osman Balci and Jiham Park on 11/5/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//


import SwiftUI
import SwiftData

struct AddPlayer: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Team>(sortBy: [SortDescriptor(\Team.name, order: .forward)])) private var listOfAllTeamsInDatabase: [Team]
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    //----------------
    // Player Attributes
    //----------------
    @State private var playerNameFieldValue = ""
    @State private var selectedTeam: Team? = nil
    
    let playerPositionChoices = ["Guard", "Forward", "Center"]
    @State private var selectedPositionIndex = 1
    
    @State private var date = Date()
    @State private var selectedHeightFeet = 6
    @State private var selectedHeightInches = 0
    @State private var playerCollegeFieldValue = ""
    @State private var playerNumberFieldValue: Int = 0
    @State private var playerNationalityFieldValue = ""
    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        Form {
            Section(header: Text("Player Name")) {
                TextField("Enter player name", text: $playerNameFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            
            Section(header: Text("Player Team")) {
                Picker("Select Team", selection: $selectedTeam) {
                    ForEach(listOfAllTeamsInDatabase, id: \.self) { team in
                        Text(team.name).tag(team as Team?)
                    }
                }
            }
            Section(header: Text("Take or Pick Photo")) {
                VStack {
                    Toggle("Use Camera", isOn: camera)
                    Toggle("Use Photo Library", isOn: photoLibrary)
                    
                    Button("Get Photo") {
                        showImagePicker = true
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
            if pickedImage != nil {
                Section(header: Text("Taken or Picked Photo")) {
                    pickedImage?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
            }
            Section(header: Text("Player Position")) {
                Picker("Select Position", selection: $selectedPositionIndex) {
                    ForEach(0 ..< playerPositionChoices.count, id: \.self) {
                        Text(playerPositionChoices[$0])
                    }
                }
            }
            
            Section(header: Text("Player Birth Date")) {
                DatePicker(
                        "Birth Date\n",
                        selection: $date,
                        displayedComponents: [.date]
                    )
            }
            
            Section(header: Text("Player Height")) {
                HStack {
                    Picker("Feet", selection: $selectedHeightFeet) {
                        ForEach(4...7, id: \.self) {
                            Text("\($0) ft").tag($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Picker("Inches", selection: $selectedHeightInches) {
                        ForEach(0..<12, id: \.self) {
                            Text("\($0) in").tag($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
            Section(header: Text("Player College")) {
                TextField("Enter College", text: $playerCollegeFieldValue)
            }
            
            Section(header: Text("Jersey Number")) {
                TextField("Enter Jersey Number", value: $playerNumberFieldValue, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Player Nationality")) {
                TextField("Enter Nationality", text: $playerNationalityFieldValue)
            }
            
            Section {
                Button(action: saveNewPlayerToDatabase) {
                    Text("Save Player")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .onAppear {
                if selectedTeam == nil, !listOfAllTeamsInDatabase.isEmpty {
                    selectedTeam = listOfAllTeamsInDatabase.first
                }
            }
        .navigationTitle("Add New Player")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if inputDataValidated() {
                        saveNewPlayerToDatabase()
                        alertTitle = "Player Added!"
                        alertMessage = "The new player has been added successfully."
                        showAlertMessage = true
                    }
                }) {
                    Text("Save")
                }
            }
        }
        .onChange(of: pickedUIImage) {
            guard let uiImagePicked = pickedUIImage else { return }
            
            // Convert UIImage to SwiftUI Image
            pickedImage = Image(uiImage: uiImagePicked)
        }
        .sheet(isPresented: $showImagePicker) {
            /*
             For storage and performance efficiency reasons, we scale down the photo image selected from the
             photo library or taken by the camera to a smaller size with imageWidth and imageHeight in points.
             
             For retina displays, 1 point = 3 pixels
             
             // Example: For HD aspect ratio of 16:9
             width  = 500.00 points --> 1500.00 pixels
             height = 281.25 points -->  843.75 pixels
             
             500/281.25 = 16/9 = 1500.00/843.75 = HD aspect ratio
             
             imageWidth =  500.0 points and imageHeight = 281.25 points will produce an image with
             imageWidth = 1500.0 pixels and imageHeight = 843.75 pixels which is about 600 KB in JPG format.
             */
            
            ImagePicker(
                uiImage: $pickedUIImage,
                sourceType: useCamera ? .camera : .photoLibrary,
                imageWidth: 500.0,
                imageHeight: 281.25
            )
        }
        .alert(alertTitle, isPresented: $showAlertMessage) {
            Button("OK") {
                if alertTitle == "New Player Added!" {
                    dismiss()
                }
            }
        }
    }
    
    func inputDataValidated() -> Bool {
        if (playerNameFieldValue.isEmpty) {
            showAlertMessage = true
            alertTitle = "Invalid Player Name!"
            alertMessage = "Please enter a player name."
            return false
        }
        if (selectedTeam == nil) {
            showAlertMessage = true
            alertTitle = "Invalid Team!"
            alertMessage = "Please select a team."
            return false
        }
        if (playerCollegeFieldValue.isEmpty) {
            showAlertMessage = true
            alertTitle = "Invalid College!"
            alertMessage = "Please enter a college."
            return false
        }
        if (playerNumberFieldValue < 0 || playerNumberFieldValue > 99) {
            showAlertMessage = true
            alertTitle = "Invalid Player Number!"
            alertMessage = "Please enter a player number between 0 and 99."
            return false
        }
        if (playerNationalityFieldValue.isEmpty) {
            showAlertMessage = true
            alertTitle = "Invalid Nationality!"
            alertMessage = "Please enter a nationality."
            return false
        }
        if (pickedImage == nil) {
            showAlertMessage = true
            alertTitle = "Invalid Photo!"
            alertMessage = "Please select a photo."
            return false
        }
        
        return true
    }
    
    func saveNewPlayerToDatabase() {
        guard let selectedTeam = selectedTeam else {
            alertTitle = "Error"
            alertMessage = "Please select a team."
            showAlertMessage = true
            return
        }
        
        let photoFullFilename = UUID().uuidString + ".jpg"
        
        if let photoData = pickedUIImage {
            if let jpegData = photoData.jpegData(compressionQuality: 1.0) {
                let fileUrl = documentDirectory.appendingPathComponent(photoFullFilename)
                try? jpegData.write(to: fileUrl)
            }
        } else {
            fatalError("Picked or taken photo is not available!")
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthDate = dateFormatter.string(from: date)
        
        let playerHeight = "\(selectedHeightFeet) ft \(selectedHeightInches) in"
        
        let newPlayer = Player(
            name: playerNameFieldValue,
            team: selectedTeam.name,
            photoFilename: photoFullFilename,
            position: playerPositionChoices[selectedPositionIndex],
            birthDate: birthDate,
            height: playerHeight,
            college: playerCollegeFieldValue,
            number: playerNumberFieldValue,
            nationality: playerNationalityFieldValue
        )
        
        modelContext.insert(newPlayer)
        dismiss()
    }
}
