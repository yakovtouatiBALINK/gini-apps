//
//  PeopleViewModel.swift
//  giniApps
//
//  Created by yacov touati on 23/10/2023.
//

import SwiftUI
import Combine

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var favoritePerson: Person?
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    
    init() {
        fetchPeople()
    }
    
    func fetchPeople() {
        isLoading = true
        guard let url = URL(string: "https://swapi.dev/api/people/?page=\(currentPage)") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PeopleResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.people.append(contentsOf: response.results)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    //functions
    func shouldLoadMoreData() -> Bool {
        if let lastPerson = people.last {
            return !isLoading && lastPerson == people.last
        }
        return false
    }
    
    func sortPeopleByHeight() {
        people.sort { (Float($0.height) ?? 0) < (Float($1.height) ?? 0) }
    }
    
    func setFavoritePerson(_ person: Person) {
        if favoritePerson == nil {
            favoritePerson = person
        }
    }
}
