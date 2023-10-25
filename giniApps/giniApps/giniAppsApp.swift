//
//  giniAppsApp.swift
//  giniApps
//
//  Created by yacov touati on 23/10/2023.
//

import SwiftUI

@main
struct giniAppsApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView(viewModel: PeopleViewModel())
        }
    }
}
