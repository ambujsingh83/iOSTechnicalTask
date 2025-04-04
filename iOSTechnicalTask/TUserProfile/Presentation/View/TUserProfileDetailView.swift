//
//  TUserProfileDetailView.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import SwiftUI

struct TUserProfileDetailView: View {
    let user: TUserItem

    var body: some View {
        VStack {
            // User Image
            AsyncImage(url: URL(string: user.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .clipped()
            } placeholder: {
                ProgressView()
            }

            // User Details
            VStack(alignment: .leading, spacing: 16) {
                Text("Name: \(user.name ?? "NA")")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Status: \(user.status ?? "NA")")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("Species: \(user.species ?? "NA")")
                    .font(.subheadline)

                Text("Gender: \(user.gender ?? "NA")")
                    .font(.subheadline)

                Text("Origin: \(user.origin?.name ?? "NA")")
                    .font(.subheadline)

                Text("Location: \(user.location?.name ?? "NA")")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .navigationTitle(user.name ?? "NA")
        .navigationBarTitleDisplayMode(.inline)
    }
}
