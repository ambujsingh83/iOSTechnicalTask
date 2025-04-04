//
//  TBaseView.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import SwiftUI

struct TBaseView: View {
    var body: some View {
        ZStack {
            // Background Image
            Image(TAppImages.background)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Content Overlay
            VStack(spacing: 20) {
                Spacer()
                
                // Button
                NavigationLink(destination: TUserProfileView()) {
                    Text(TAppConstant.TAppStrings.buttonTitle)
                        .font(.headline)
                        .foregroundColor(TAppColors.buttonTextColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(TAppColors.buttonBackgroundColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                
                // Description Text
                Text(TAppConstant.TAppStrings.description)
                    .font(.subheadline)
                    .foregroundColor(TAppColors.descriptionTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}

struct TBaseView_Previews: PreviewProvider {
    static var previews: some View {
        TBaseView()
    }
}
