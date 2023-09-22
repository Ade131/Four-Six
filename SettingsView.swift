//
//  SettingsView.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel // Add this line

    var body: some View {
            List {
                Section(header: Text("Settings")) {
                    Toggle("Mute Sounds", isOn: $coffeeModel.audioEnabled)
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: FourSixMethodView()) {
                        Text("What is the Four Six Method?")
                    }
                    
                    NavigationLink(destination: FAQView()) {
                        Text("FAQ")
                    }
                }
                
                Section(header: Text("Feedback")) {
                    NavigationLink(destination: Text("Rate on App Store")) {
                        Text("Rate in the App Store")
                    }
                    
                    NavigationLink(destination: Text("Acknowledgements")) {
                        Text("Acknowledgements")
                    }
                }
                
                Section(footer: Text("Version 1.0.0\nThis app is in no way affiliated with Hario or Tetsu Kasuya")) {
                }
            }
        }
    }

struct FourSixMethodView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                   Text("The 4:6 Method")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                   
                   Text("Overview")
                       .font(.title)
                       .fontWeight(.bold)
                       .padding(.top, 10)
                   
                   Text("The 4:6 Method is a popular pour-over coffee brewing technique that was pioneered by Tetsu Kasuya, who won the World Brewers Cup in 2016 using this method. The name '4:6' comes from the way water is divided during the brewing process, with 40% of the water poured in the first stage and 60% in the second stage.")
                   
                   Text("Customizable Flavor")
                       .font(.title)
                       .fontWeight(.bold)
                       .padding(.top, 10)
                   
                   Text("What sets the 4:6 Method apart is its ability to give you control over the flavor and strength of your coffee. Instead of relying on trial and error or years of experience, this method allows you to adjust the taste of your coffee simply by changing the pour amounts in each stage. Whether you prefer a bolder or milder flavor, the 4:6 Method makes it easy to achieve.")
                   
                   Text("Barista-Approved")
                       .font(.title)
                       .fontWeight(.bold)
                       .padding(.top, 10)
                   
                   Text("The 4:6 Method has gained popularity among baristas and coffee shops worldwide. It's highly recommended for its consistency in producing great-tasting coffee, making it a favorite among coffee enthusiasts.")
               }
               .padding()
    }
}

struct FAQView: View {
    let faqData: [(String, String)] = [
            ("What equipment do I need?", "• V60 Dripper\n• Gooseneck kettle\n• Coffee grinder\n• Filter paper\n• Digital scale"),
            ("How should I grind my coffee?", "A coarser grind than a regular V60 setting is recommended, but you can experiment with what works best for you."),
            ("What temperature should the water be?", "Around 92-94 degrees, depending on the coffee."),
            ("How should I pour the water?", "Pour the water in circles going around the V60, starting from the middle and moving ourwards to the edge. Make sure that all of the grounds are covered on the first pour. Each pour should take 6-10 seconds."),
            ("What if there's still water draining when I start the next pour?", "Ideally the water should completely drain before you begin the next pour. You could try grinding coarser, pouring faster, or changing the filter. Bleached filters made in the Netherlands are known to have a slower drain time than the filters manufactured in Japan."),
        ]
    
    var body: some View {
        List(faqData, id: \.0) {question, answer in
            VStack(alignment: .leading, spacing: 8) {
                Text(question)
                    .font(.headline)
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CoffeeBrewingModel())
}
