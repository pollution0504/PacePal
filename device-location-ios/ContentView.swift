//
//  ContentView.swift
//  device-location-ios
//
//  Created by Kilo Loco on 12/7/21.
//

import Combine
import SwiftUI
import Foundation

struct ContentView: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    @State var showDetails = false
    @State var start_latit=""
    @State var start_longit=""
    @State var end_latit=""
    @State var end_longit=""
    @State var intstart_latit = (0.0)
    @State var intstart_longit = (0.0)
    @State var intend_latit = (0.0)
    @State var intend_longit = (0.0)
    @State var myLabel1: UILabel!
    @State var number: Double = 60
    @State var message=""
    @State var distance = (0.0)
    @State var strdistance = ""
    @State var isMeters = true
    var body: some View {
        ZStack(){
            Color(red: 0, green: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, blue: 0.2)
                .ignoresSafeArea()
        VStack() {
            Button{
                
            } label: {
                
            }
            Spacer()
            Text("Welcome to PacePal!")
                .font(.title)
                .padding(.bottom, 10.0)
            HStack() {
                Button {
                    start_latit = ("\(coordinates.lat)")
                    start_longit = ("\(coordinates.lon)")
                    intstart_latit = coordinates.lat
                    intstart_longit = coordinates.lon
                    end_latit=("")
                    end_longit=("")
                    strdistance=""
                    message = ("RUN!!")
                    
                } label: {
                    Text("Start")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 10)
                        .background(
                            Color.green
                                .cornerRadius(10)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        )
                        .font(.title3)
                }
                
                Button
                {
                    end_latit=("\(coordinates.lat)")
                    end_longit=("\(coordinates.lon)")
                    intend_latit=(coordinates.lat)
                    intend_longit=(coordinates.lon)
                    start_latit=("")
                    start_longit=("")
                    message = ("STOP!")
                    distance = findDistance(lat1: intstart_latit, lon1: intstart_longit, lat2: intend_latit, lon2: intend_longit)
                    if isMeters==true{
                        strdistance = ("You have ran around \(distance*1000) meters!")
                    }
                    if isMeters==false{
                        strdistance = ("You have ran around \(distance*1000*3.28084) feet!")
                    }
                } label: {
                    Text("Stop")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 10)
                        .background(
                            Color.green
                                .cornerRadius(10)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        )
                        .font(.title3)
                }
                //Button("Show details") {
                //    showDetails.toggle()
                //
                //}
                Button{
                    start_latit=("")
                    start_longit=("")
                    end_latit=("")
                    end_longit=("")
                    message=("")
                    strdistance=""
                    
                    
                } label: {
                    Text("Reset")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 10)
                        .background(
                            Color.green
                                .cornerRadius(10)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        )
                        .font(.title3)
                }
            }
                
                    Text("Current Location: \(coordinates.lat) \(coordinates.lon)")
                    Text(message)
                    Text(strdistance)
                    
                    
            HStack{
                VStack{
                    Button {
                        if isMeters==false{
                            isMeters=true
                            message="Changed to Meters!"
                        }
                        else{
                            message="Already was Meters!"
                        }
                    } label: {
                        Image("ukflag (1)")
                    }
                    Text("Meters")
                }
                VStack{
                    Button {
                        if isMeters==true{
                            isMeters=false
                            message="Changed to Feet!"
                        }
                        else{
                            message="Already was Feet!"
                        }
                    } label: {
                        Image("usflag (2)")
                    }
                    Text("Feet")
                }
            }
                Spacer()
            }
            if showDetails {
                Text("To Start just press start")
                    .font(.largeTitle)
            }
        }
        
    
//        VStack {
//
//            Text("\(coordinates.lat)")
//            Text("Latitude: \(coordinates.lat)")
//                .font(.largeTitle)
//            Text("Longitude: \(coordinates.lon)")
//                .font(.largeTitle)
//        }
        .onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
        
        
    }
    func findDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthRadius: Double = 6371.0 // Radius of the Earth in kilometers

        let lat1Radians = lat1 * .pi / 180.0
        let lon1Radians = lon1 * .pi / 180.0
        let lat2Radians = lat2 * .pi / 180.0
        let lon2Radians = lon2 * .pi / 180.0

        let dLat = lat2Radians - lat1Radians
        let dLon = lon2Radians - lon1Radians

        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1Radians) * cos(lat2Radians) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        let distance = earthRadius * c // Distance in kilometers

        return distance
    }
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
