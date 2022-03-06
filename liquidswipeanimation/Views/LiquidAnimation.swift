//
//  HomeView.swift
//  LiquidSwipeAnimation
//
//  Created by Shameem Reza on 6/3/22.
//

import SwiftUI

struct LiquidAnimation: View {
    @State var offset: CGSize = .zero
    @State var showHome = false
    var body: some View {
        ZStack {
            Color("bg")
                .overlay(
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("Shameem Reza")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Text("I am a Self-taught iOS Developer and Blogger based in Khulna, Bangladesh. I loves to work with Swift, SwiftUI, Flutter & WordPress.")
                            .font(.caption)
                            .fontWeight(.bold)
                    })
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .offset(x: -15)
                
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ (value) in
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                offset = value.translation
                            }
                        }).onEnded({ (value) in
                            
                            let screen = UIScreen.main.bounds
                            
                            withAnimation(.spring()){
                                if -offset.width > screen.width / 2 {
                                    offset.width = -screen.height
                                    showHome.toggle()
                                } else {
                                    offset = .zero
                                }
                            }
                            
                        }))
                        .offset(x: 15, y:58)
                        .opacity(offset == .zero ? 1: 0)
                    
                    ,alignment: .topTrailing
                
                )
                .padding(.trailing)
            
            if showHome{
                Text("Liquid Swipe Animation")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .onTapGesture {
                        withAnimation(.spring()){
                            offset = .zero
                            showHome.toggle()
                        }
                    }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        LiquidAnimation()
    }
}

// MARK: - SHAPE

struct LiquidSwipe: Shape {
    // MARK: - GET OFFSET VALUE
    var offset: CGSize
    
    // MARK: - PATH ANIMATION
    var animatableData: CGSize.AnimatableData{
        get{return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            // MARK: - FROM
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            // MAR: - TO
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            
            let mid : CGFloat = 80 + ((to - 80) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
            
        }
    }
}
