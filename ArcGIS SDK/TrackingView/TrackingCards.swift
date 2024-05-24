    //
    //  TrackingCards.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 21/05/2024.
    //

import SwiftUI

struct TrackingCards: View {
    let cards:[CardItem]
    
    let columns = [
        GridItem(.flexible(), spacing: -sw/3),
        GridItem(.flexible(), spacing:-sw/3)
    ]
    
    
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(cards, id: \.self.itemName) { card in
                CardView(cardItem: card)
            }
        }
        .padding()
    }
}

#Preview {
    TrackingCards(cards: CardItem.mockCardItems)
}
