//
//  S1.swift
//  ApiCours
//
//  Created by shaima on 12/11/1444 AH.
//

import SwiftUI

struct Quote1: Codable {
    
    var location_type : String
    var category: String
 
}


struct S1: View {
    @State private var quotes1 = [Quote1]()
    
    var body: some View {
        NavigationView {
            
            List(quotes1, id: \.category) { quote1 in
                
                VStack(alignment: .leading){
                    Text(quote1.category)
                        .font(.headline)
                   Text(quote1.location_type)
                 
                }
            }
            
            .navigationTitle("")
            .task{
                await fetchData()
            }
            
        }
    }
    
    func fetchData() async{
        
        
        guard let url = URL(string: "https://data.police.uk/api/crimes-street/all-crime?lat=52.629729&lng=-1.131592&date=2023-01") else {
            
            print("hey man THIS URL DOES NOT WORK")
            
            return
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Quote2].self, from: data) {
                quotes1  = decodedResponse
            }
        } catch {
            print("bod news... this data isn't valid ")
        }
    }
    
    
}
struct S1_Previews: PreviewProvider {
    static var previews: some View {
        S1()
    }
}
