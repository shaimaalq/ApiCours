//
//  CoursePage.swift
//  ApiCours
//
//  Created by shaima on 10/11/1444 AH.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
                .background(Color.gray)
            
        } else{
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .onAppear{
                    fetchData()
                }
        }
        
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            self.data = data
            
        }
        task.resume()
    }
}

struct Course: Hashable, Codable {
    let name: String
    let image: String
    
}

class ViewModel: ObservableObject {
    
    @Published var courses: [Course] = []
    
    func fetch() {
        
        guard let url = URL(string: "https:/iosacademy.io/api/v1/courses/index.php") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.courses = courses
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct CoursePage: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationView {
            
            List{
                
                ForEach(viewModel.courses, id: \.self) { course in
                    
                    HStack {
                        URLImage(urlString: course.image)
                        
                        Text(course.name)
                            .bold()
                    }
                    .padding(3)
                }
                
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetch()
            }
            
        }
    }
}

struct CoursePage_Previews: PreviewProvider {
    static var previews: some View {
        CoursePage()
    }
}
