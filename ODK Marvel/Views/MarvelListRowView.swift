//
//  MarvelListRowView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import SwiftUI

struct MarvelListRowView: View {
    @State var character: MarvelCharacterModel
    @State var image: UIImage = UIImage(named: "Not-Available")!
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(uiImage: image).resizable().scaledToFit().frame(width: 40, height: 40, alignment: .center)
            VStack(alignment: .leading, spacing: 0) {
                Text(character.name).font(.subheadline)
                Text(character.description).font(.caption).frame(maxHeight: 40)
            }
        }
        .onReceive(character.$image) { res in
            image = res 
        }
    }
}

struct MarvelListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelListRowView(character: MarvelCharacterModel(id: 0, name: "", description: "", imagePath: MVPath(path: "", extension: ""), imageVariant: .fullSize))
    }
}
