//
//  MonsterListView.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/8/25.
//

import SwiftUI

struct MonsterListView: View {
    @State private var monstersVM = MonstersViewModel()
    
    var body: some View {
        NavigationStack {
            // use list since this data is viewed, not edited
            ZStack {
                List(monstersVM.monsters) { monster in
//  struct NavigationLink<Label, Destination> where Label : View, Destination : View
                    NavigationLink {  // use destination viewLabel option
                        MonsterDetailView(monster: monster)
                    } label: {
                        Text(monster.name)
                            .font(.title2)
                    }
                }
                .listStyle(.plain)
                
                if monstersVM.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
             }
            .navigationTitle("Monsters:")  // must be within the NavigationStack
            .toolbar {
                Text("\(monstersVM.monsters.count) monsters")  // must be within the NavigationStack
            }

        }
        .task {
            await monstersVM.getData()
        }
        
    }
}

#Preview {
    MonsterListView()
}
