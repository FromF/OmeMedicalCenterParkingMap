//
//  ContentView.swift
//  Hospital
//
//  Created by 藤治仁 on 2025/03/15.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // 地図の中心座標と表示範囲を設定
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.7826825, longitude: 139.2819988),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    @State private var refreshTrigger = UUID()
    @State private var infomationText: String?
    
    private let locationManager = CLLocationManager()
    
    // 駐車場リスト（各URLは駐車状況画像のURL）
    private let parkingLots: [ParkingLot] = [
        ParkingLot(name: "第２駐車場(65台)", coordinate: CLLocationCoordinate2D(latitude: 35.78160, longitude: 139.28233), statusImageURL: "http://cnt.parkingweb.jp/001/000000/000001/003287/001/0001parking_status.jpg"),
        ParkingLot(name: "第７駐車場(17台)", coordinate: CLLocationCoordinate2D(latitude: 35.78235, longitude: 139.28229), statusImageURL: "http://cnt.parkingweb.jp/001/000000/000001/003288/001/0001parking_status.jpg"),
        ParkingLot(name: "新棟地下駐車場(120台)", coordinate: CLLocationCoordinate2D(latitude: 35.78318, longitude: 139.28069), statusImageURL: "http://cnt.parkingweb.jp/001/000000/000001/003292/001/0001parking_status.jpg"),
        ParkingLot(name: "第５駐車場(54台)", coordinate: CLLocationCoordinate2D(latitude: 35.78381, longitude: 139.28036), statusImageURL: "http://cnt.parkingweb.jp/001/000000/000001/003290/001/0001parking_status.jpg"),
        ParkingLot(name: "第８駐車場(13台)", coordinate: CLLocationCoordinate2D(latitude: 35.78082, longitude: 139.28294), statusImageURL: "http://cnt.parkingweb.jp/001/000000/000001/003289/001/0001parking_status.jpg")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map viewに駐車場のアノテーションを追加
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: parkingLots) { lot in
                    MapAnnotation(coordinate: lot.coordinate) {
                        VStack {
                            AsyncImage(url: URL(string: lot.statusImageURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "parkingsign.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        Text(lot.name)
                            .font(.caption)
                    }
                }
                .mapStyle(.standard(elevation: .automatic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: true))
                .navigationTitle("駐車場空き状況")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            refreshTrigger = UUID()
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 35.7826825, longitude: 139.2819988),
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            )
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                VStack {
                    if let infomationText = infomationText {
                        Text(infomationText)
                            .bold()
                            .padding()
                            .background(Color.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            } // ZStack
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                infomationText = dateFormatter.string(from: Date.now)
            }
            .id(refreshTrigger)
        }
    }
}
#Preview {
    ContentView()
}
