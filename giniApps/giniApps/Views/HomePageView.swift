//
//  ContentView.swift
//  giniApps
//
//  Created by yacov touati on 23/10/2023.
//

import SwiftUI

struct HomePageView: View {
    
    @ObservedObject var viewModel: PeopleViewModel
    @State private var isFinalPageFetched = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orderedPeople, id: \.name) { person in
                    PersonView(person: person, isFavorite: person == viewModel.favoritePerson) {
                        viewModel.setFavoritePerson(person)
                    }
                }
                .onAppear {
                    if viewModel.shouldLoadMoreData() {
                        viewModel.fetchPeople()
                    } else if !isFinalPageFetched {
                        viewModel.sortPeopleByHeight()
                        isFinalPageFetched = true
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle("Star Wars People")
        }
    }
    var orderedPeople: [Person] {
        return viewModel.people
    }
}

struct PersonView: View {
    let person: Person
    var isFavorite: Bool
    let favoriteAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Name: \(person.name)")
            if let height = Float(person.height) {
                Text("Height: \(height) cm")
            } else {
                Text("Height: N/A")
            }
        }
        .background(isFavorite ? Color.yellow.opacity(0.5) : Color.clear)
        .onTapGesture {
            favoriteAction()
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(viewModel: PeopleViewModel())
    }
}
