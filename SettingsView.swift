//
//  SettingsView.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    //Saved settings
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = 0 //Appearance Selection
    
    var body: some View {
        List {
            Section(header: Text("Settings")) {
                Toggle("Sounds", isOn: $coffeeModel.audioEnabled)
                    .toggleStyle(CoffeeToggleStyle())
                
                    .listRowSeparatorTint(.listSeparator)
                
                Toggle("Vibrate", isOn: $coffeeModel.vibrateEnabled)
                    .toggleStyle(CoffeeToggleStyle())
                
                
                    .listRowSeparatorTint(.listSeparator)
                
                Picker(selection: $appearanceSelection) {
                    Text("System")
                        .tag(0)
                    Text("Light")
                        .tag(1)
                    Text("Dark")
                        .tag(2)
                } label: {
                    Text("Appearance")
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.listColour)
            
            Section(header: Text("About")) {
                NavigationLink(destination: FourSixMethodView()) {
                    Text("What is the Four Six Method?")
                }
                
                .listRowSeparatorTint(.listSeparator)
                
                NavigationLink(destination: FAQView()) {
                    Text("FAQ")
                }
            }
            .listRowBackground(Color.listColour)
            
            Section(header: Text("Feedback")) {
                NavigationLink(destination: Text("Rate on App Store")) {
                    Text("Rate in the App Store")
                }
                
                .listRowSeparatorTint(.listSeparator)
                
                NavigationLink(destination: AcknowledgementsView()) {
                    Text("Acknowledgements")
                }
            }
            .listRowBackground(Color.listColour)
            
            Section(footer: Text("Version 1.0.0")) {
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundColour)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
            .foregroundColor(Color.linkColour)
        })
    }
}

struct FourSixMethodView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
        
                Text("Overview")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text("The 4:6 Method is a popular pour-over coffee brewing technique that was pioneered by Tetsu Kasuya, who won the World Brewers Cup in 2016. The name '4:6' comes from the way water is divided during the brewing process, with 40% of the water poured in the first stage and 60% in the second stage.")
                
                Text("Customizable Flavor")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text("What sets the 4:6 Method apart is its ability to give you control over the flavor and strength of your coffee. Instead of relying on trial and error or years of experience, this method allows you to adjust the taste of your coffee simply by changing the pour amounts in each stage. Whether you prefer a bolder or milder flavor, the 4:6 Method makes it easy to achieve.")
                
                Text("Barista-Approved")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text("The 4:6 Method has gained popularity among baristas and coffee shops worldwide. It's highly recommended for its consistency in producing great-tasting coffee, making it a favourite among coffee enthusiasts.")
            }
            .navigationTitle("The 4:6 Method")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
                .foregroundColor(Color.linkColour)
            })
            .padding()
        }
    }
}

struct FAQView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let faqData: [(String, String)] = [
        ("What equipment do I need?", "• V60 Dripper\n• Gooseneck kettle\n• Coffee grinder\n• Filter paper\n• Digital scale"),
        ("How should I grind my coffee?", "A coarser grind than a regular V60 setting is recommended, but you can experiment with what works best for you."),
        ("What temperature should my water be?", "It depends on the coffee! Lighter roasts can stand higher temperatures, up to 96 degrees, whereas darker roasts can be extracted as low as 80 degrees. Try different temparatures and see what tastes best. We recommend around 94 degrees as a starting point."),
        ("How should I pour the water?", "Pour the water in circles, starting from the middle and moving ourwards to the edge. Make sure that all of the grounds are covered on the first pour. Each pour should take 6-10 seconds."),
        ("What do the options do?", "Balance\nLets you fine-tune the water ratio in the initial stage of brewing. Opting for more water upfront enhances the brightness of the flavor, while reducing it yields a sweeter cup.\n\nStrength\nAllows you to control the intensity by altering the number of pours in the second stage: 'Light' for a subtler brew in 2 pours, 'Strong' for a bolder experience with 4 pours.\n\nRatio\nSets the ratio of coffee:water you want to brew, with lower ratio resulting in a more concentrated, but less extracted, cup.\n\nWe recommend starting with the defaults, and adjusting the balance and strength from there. These options are saved, so once you find a cup you like, you can set and forget!"),
        ("What if there's still water draining when I start the next pour?", "Ideally the water should completely drain before you begin the next pour. You could try grinding coarser, pouring faster, or changing the filter.\n\nBleached filters made in the Netherlands are known to have a slower drain time than the filters manufactured in Japan. 45 seconds between pours is just a guideline, and you can always pause the brew timer while you wait for the water to drain."),
        ("How long does it usually take to brew using the 4:6 method?", "It depends on your strength setting. Stronger coffee requires more pours, which will increase the brewing time. On average, a finished cup will take around 4 minutes from the first pour."),
        ("Why is my final weight more/less than what I assigned?", "The pour size measurements are rounded to make brewing easier, which may mean a few extra ml of water at the end of the process")
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
            .listRowBackground(Color.listColour)
            .padding()
        }
        .navigationTitle("FAQ")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
            .foregroundColor(Color.linkColour)
        })
        .scrollContentBackground(.hidden)
        .background(Color.backgroundColour)
    }
}

struct AcknowledgementsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Sound effects used in this app are licensed from Zapsplat under their standard attribution license. For more details, see https://www.zapsplat.com")
                    .font(.footnote)
                    .padding(.top, 50)
                
                Text("Thanks to Sander, Dec, Conor, & Sam")
                    .font(.footnote)
                    .padding(.top, 15)
                
                Text("This application is in no way affiliated with Hario or Tatsu Kasuya")
                    .font(.footnote)
                    .padding(.top, 15)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Acknowledgements")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
            .foregroundColor(Color.linkColour)
        })
    }
        
}

#Preview {
    SettingsView()
        .environmentObject(CoffeeBrewingModel())
}
