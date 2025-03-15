//
//  ParkingLot.swift
//  Hospital
//
//  Created by 藤治仁 on 2025/03/15.
//
import SwiftUI
import MapKit

// 駐車場情報を保持するモデル
struct ParkingLot: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let statusImageURL: String
}
