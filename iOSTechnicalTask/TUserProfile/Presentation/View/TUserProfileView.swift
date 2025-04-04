//
//  TUserProfileView.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//
import SwiftUI
import iOS_Task_Frmwrk

struct TUserProfileView: View {
    @StateObject private var viewModel = TUserProfileViewModel()
    @State private var selectedUser: TUserItem?
    @State private var shouldNavigateToDetail = false // Used for navigation to detail view

    var body: some View {
        VStack {
            if let userProfileData = viewModel.userProfileData?.results, !userProfileData.isEmpty {
                // Create a ListWithLabelModel from the user profile data
                let listWithLabelModel = createListWithLabelModel(from: userProfileData)
                
                // Display the list using WidgetView
                WidgetContainerView(widgetModel: WidgetDataModel(
                    title: TAppConstant.TAppStrings.title,
                    subtitle: TAppConstant.TAppStrings.subtitle,
                    widgetContent: listWithLabelModel
                )) { selectedIndex in
                    handleSelection(of: selectedIndex, from: userProfileData)
                }
                .padding(.horizontal)
            } else {
                loadingView
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(TAppConstant.TAppStrings.title)
        .navigationDestination(isPresented: $shouldNavigateToDetail) {
            if let user = selectedUser {
                TUserProfileDetailView(user: user)
            }
        }
        .onAppear {
            viewModel.getUserProfileDetails()
        }
    }
    
    // MARK: - Helper Methods
    
    private func createListWithLabelModel(from userProfileData: [TUserItem]) -> TableWithLabelModel {
        TableWithLabelModel(
            contentType: .table,
            tableTitle: TAppConstant.TAppStrings.title,
            tableData: userProfileData.map { user in
                TableWithLabelItem(
                    label1: user.name ?? "NA",
                    label2: user.status ?? "NA"
                )
            },
            labelTitle: TAppConstant.TAppStrings.name,
            labelValue: TAppConstant.TAppStrings.status
        )
    }
    
    private func handleSelection(of index: Int, from userProfileData: [TUserItem]) {
        selectedUser = userProfileData[index]
        shouldNavigateToDetail = true
    }
    
    private var loadingView: some View {
        Text(TAppConstant.TAppStrings.loading)
            .foregroundColor(.gray)
            .padding()
    }
}
