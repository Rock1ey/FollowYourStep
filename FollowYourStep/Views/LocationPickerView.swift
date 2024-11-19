//
//  LocationPickerView.swift
//  Test
//
//  Created by admin on 2024/11/19.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationPickerView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // 默认位置
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .onChange(of: region.center) { newCoordinate in
                    selectedCoordinate = newCoordinate
                }
                .edgesIgnoringSafeArea(.all)
            
            Button("Confirm Location") {
                selectedCoordinate = region.center
            }
            .padding()
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

