//
//  MonsterDetailView.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/9/25.
//

import SwiftUI

struct MonsterDetailView: View {
    @State var monster: Monster  // parameter passed to this struct
    @State private var monsterDetailVM = MonsterDetailViewModel()
    
    
    var body: some View {
        VStack {
            Text(monster.name)
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Type:").bold()
                    Text(monsterDetailVM.type.capitalized)
                        .padding(.bottom)
                    
                    Text("Alignment:").bold()
                    Text(monsterDetailVM.alignment.capitalized)
                        .padding(.bottom)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Size:").bold()
                    Text(monsterDetailVM.size.capitalized)
                        .padding(.bottom)
                    
                    Text("Hit Points:").bold()
                    Text("\(monsterDetailVM.hitPoints)")
                        .padding(.bottom)
                }
            }
            .font(.title)

//            To gain more control over the loading process, use the init(url:scale:transaction:content:) initializer, which takes a content closure that receives an AsyncImagePhase to indicate the state of the loading operation. Return a view that’s appropriate for the current phase:
//            AsyncImage(init(url:scale:transaction:content:))
//            Loads and displays a modifiable image from the specified URL in phases.
            
            AsyncImage(url: URL(string: monsterDetailVM.imageURL)) { phase in
                if let image = phase.image {  // we have a valid image
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 16)
                } else if phase.error != nil {  // we had an error
                    Image(systemName: "questionmark.square.dashed")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 16)
                } else {  // use a placeholder while image is loading
                   ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        
        .task {
            monsterDetailVM.urlString = monsterDetailVM.baseURL + monster.url
            await monsterDetailVM.getData()
            
        }
    }
}

#Preview {
    MonsterDetailView(monster: Monster (
        index: "adult-gold-dragon",
        name: "Adult Gold Dragon",
        url: "/api/2014/monsters/adult-gold-dragon"
    ))
}
