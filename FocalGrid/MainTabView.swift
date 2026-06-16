//
//  MainTabView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: PageRoute = .home
    var body: some View {
        TabView(selection: $selectedTab){
            DashboardView()
                .tabItem {
                    Image(systemName: PageRoute.home.icon)
                    Text(PageRoute.home.title)
                }
                .tag(PageRoute.home)
            GalleryView()
                .tabItem {
                    Image(systemName: PageRoute.gallery.icon)
                    Text(PageRoute.gallery.title)
                }
                .tag(PageRoute.gallery)
        }
//        .tint(.themePrimary)
    }
}

#Preview {
    MainTabView()
}
