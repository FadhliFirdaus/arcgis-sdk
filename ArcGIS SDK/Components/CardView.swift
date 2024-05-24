//
//  CardView.swift
//  ArcGIS SDK
//
//  Created by Fadhli Firdaus on 21/05/2024.
//

import SwiftUI

struct CardView: View {
    let cardItem:CardItem
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundColor(.white)
            VStack{
                HStack{
                    Image(systemName: cardItem.icon)
                        .foregroundColor(cardItem.color)
                    Image(systemName: "waveform")
                        .foregroundColor(cardItem.color)
                }
                VStack{
                    HStack{
                        Text(cardItem.itemValue)
                            .foregroundColor(cardItem.color)
                        if(cardItem.metric != ""){
                            Text(cardItem.metric)
                                .foregroundColor(cardItem.color)
                        }

                    }
                    HStack{
                        Text(cardItem.itemName)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                            .foregroundColor(cardItem.color)
                    }
                }
            }
        }
        .frame(width: sw/4, height: sw/4, alignment: .center)
        .padding(3)
    }
}

#Preview {
    CardView(cardItem: CardItem.mockCard)
}
