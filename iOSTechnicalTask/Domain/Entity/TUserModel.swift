//
//  TUserModel.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import SwiftUI

struct TUserModel: Codable {
    let results: [TUserItem]?
}

struct TUserItem: Codable, Identifiable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: TOrigin?
    let location: TLocation?
    let image: String
    let episode: [String]
    let url: String?
    let created: String?
}

struct TOrigin: Codable {
    let name: String?
    let url: String?
}

struct TLocation: Codable {
    let name: String?
    let url: String?
}
