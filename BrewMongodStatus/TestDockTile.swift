//
//  TestDockTile.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 31.08.2024.
//

import SwiftUI

struct TestDockTile: View {

    @State var isActive: Bool = false

    var body: some View {
        ZStack {
//            Image(nsImage: NSApp.applicationIconImage)
            VStack {
                Spacer()
                HStack {
                    Image(systemName: isActive ? "play.fill" : "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(isActive ? Color.green : Color.red)
                        .cornerRadius(50)
                    Spacer()
                }

            }

        }
    }

    func setActive(_ active: Bool) {
        self.isActive = active
    }
}

#Preview {
    TestDockTile()
}
