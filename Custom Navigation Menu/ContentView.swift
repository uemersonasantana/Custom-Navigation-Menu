//
//  ContentView.swift
//  Custom Navigation Menu
//
//  Created by Uemerson A. Santana on 01/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var width = UIScreen.main.bounds.width
    @State var show = false
    @State var selectedIndex = ""
    @State var min: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 22))
                                .foregroundColor(.black)
                        })
                        Spacer(minLength: 0)
                        Button(action: {
                            withAnimation(.spring()){show.toggle()}
                        }, label: {
                            Image("pic")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 35, height: 35)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        })
                    }
                    
                    Text("Home")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
                // Since top edges are ignored
                .padding(.top,edges!.top)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                Text(selectedIndex)
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            
            // Side menu
            HStack(spacing:0) {
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                VStack {
                    HStack {
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        
                        Button(action: {
                            withAnimation(.spring()){show.toggle()}
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        })
                    }
                    .padding()
                    .padding(.top, edges!.top)
                    
                    HStack(spacing: 15) {
                        GeometryReader{reader in
                            Image("pic")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                            // for geting midPoint
                                .onAppear(perform: {
                                    self.min = reader.frame(in: .global).minY
                                })
                        }
                        .frame(width: 75, height: 75)
                        
                        VStack(alignment: .leading, spacing: 5, content:  {
                            Text("Joana")
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("cath@gmail.com")
                                .fontWeight(.semibold)
                        })
                        .foregroundColor(.white)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    
                    // Menu button
                    VStack(alignment: .leading, content: {
                        MenuButtons(image: "cart", title: "My Orders", selected: $selectedIndex,show: $show)
                        MenuButtons(image: "person", title: "My Profile", selected: $selectedIndex,show: $show)
                        MenuButtons(image: "mappin", title: "Delivery Address", selected: $selectedIndex,show: $show)
                        MenuButtons(image: "creditcard", title: "Payment Methods", selected: $selectedIndex,show: $show)
                        MenuButtons(image: "envelope", title: "Contact Us", selected: $selectedIndex,show: $show)
                        
                        MenuButtons(image: "gear", title: "Settings", selected: $selectedIndex,show: $show)
                        
                        MenuButtons(image: "info.circle", title: "Help & FAQs", selected: $selectedIndex,show: $show)
                    })
                    .padding(.top)
                    .padding(.leading,45)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .frame(width: width - 100)
                .background(Color("bg").clipShape(CustomShape(min: $min)))
                .offset(x: show ? 0 : width - 100)
                
            }
            .background(Color.black.opacity(show ? 0.3 : 0))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct MenuButtons: View {
    
    var image: String
    var title: String
    @Binding var selected: String
    @Binding var show: Bool
    
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()){
                selected = title
                show.toggle()
            }
        }, label: {
            HStack(spacing: 15) {
                Image(systemName: image)
                    .font(.system(size: 22))
                    .frame(width: 25, height: 25)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.vertical)
            .padding(.trailing)
        })
        // For smaller size iPhones
        .padding(.top,UIScreen.main.bounds.width < 750 ? 0 : 5)
        .foregroundColor(.white)
    }
}

struct CustomShape: Shape {
    
    @Binding var min: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 35, y: rect.height))
            path.addLine(to: CGPoint(x: 35, y: 0))
            
            path.move(to: CGPoint(x: 35, y: min - 15))
            // 90 - 15 = 75 // Image size
            // min + 90 => min = start => min + 90 = end point
            // Control or angle will be -35 to x and mid of min + 90
            path.addQuadCurve(to: CGPoint(x: 35, y: min + 90), control: CGPoint(x: -35, y: min + 35))
        }
    }
}
