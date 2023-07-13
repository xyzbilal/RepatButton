//
//  ContentView.swift
//  RepatButton
//
//  Created by Bilal SIMSEK on 13.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var count:Int = 0
    @State private var count1:Int = 0
    var body: some View {
        VStack {
        Text("My Cart")
                .font(.title.bold())
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .overlay (alignment:.leading){
                    Button {
                        
                    }label: {
                        Image(systemName: "arrow.left")
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.black)
                }.padding()
          
            ScrollView{
                
                VStack(spacing:15){
                    HStack(spacing: 12, content: {
                        Image(.iphone)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("iPhone 12")
                                .fontWeight(.semibold)
                            Text("Black- 512GB")
                                .font(.caption)
                            
                            Text("$1399")
                                .fontWeight(.bold)
                        })
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment:.leading)
                        
                        IncrementerView(count: $count)
                            .scaleEffect(0.9,anchor: .center)
                        
                    })
                    .background(.white.shadow(.drop(color:.black.opacity(0.05),radius:8,x:5,y:5)),in:.rect(cornerRadius:20))
                  
                }
                .padding(15)
                .padding(.top,10)
                
                
                
                
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background {
                    Rectangle()
                        .fill(.BG)
                        .clipShape(.rect(topLeadingRadius: 35,topTrailingRadius: 35))
                        .ignoresSafeArea()
                }
        
        }
        
    }
    
  
 
}



struct IncrementerView:View {
    @Binding var count:Int
    @State private var buttonFrames:[ButtonFrame] = []
    var body: some View {
        HStack{
            Button {
                if count > 0 {
                    let frame = ButtonFrame(value: count)
                    buttonFrames.append(frame)
                    toggleAnimation(frame.id,false)
                }
            } label: {
                 Image(systemName: "minus")
                
            }
            .buttonRepeatBehavior(.enabled)
            
            Text("\(count)")
              
                .frame(width: 45   ,height: 45)
                .background(.white.shadow(.drop(color:.black.opacity(0.15),radius: 5)),in:.rect(cornerRadius: 10))
                .overlay {
                    ForEach(buttonFrames){btFrame in
                        KeyframeAnimator(initialValue: ButtonFrame(value: 0),
                                         trigger: btFrame.triggerKeyFrame) { frame in
                            
                            
                            Text("\(btFrame.value)")
                                .background(.black.opacity(0.6 - frame.opacity))
                                .offset(frame.offset)
                                .opacity(frame.opacity)
                                .blur(radius: (1 - frame.opacity) * 10)
                            
                            
                        } keyframes: { _ in
                            KeyframeTrack(\.offset){
                                LinearKeyframe(CGSize(width: 0, height: -20), duration: 0.2)
                                
                                LinearKeyframe(CGSize(width: .random(in: -2...2), height: -40), duration: 0.2)
                                
                                LinearKeyframe(CGSize(width: .random(in: -2...2), height: -70), duration: 0.2)
                            }
                            KeyframeTrack(\.opacity){
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(0.7, duration: 0.2)
                                LinearKeyframe(0, duration: 0.2)
                            }
                        }

                    }
                }
            
            Button {
              
                let frame = ButtonFrame(value: count)
                buttonFrames.append(frame)
                toggleAnimation(frame.id)
              
            } label: {
                 Image(systemName: "plus")
            }
            .buttonRepeatBehavior(.enabled)

        }.fontWeight(.bold)
    }
    
    func toggleAnimation(_ id:UUID, _ increment:Bool = true){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
            if let index = buttonFrames.firstIndex(where: {$0.id == id}){
                buttonFrames[index].triggerKeyFrame = true
                if increment {
                    count += 1
                }else{
                    count -= 1
                }
                removeAnimation(id)
            }
        }
    }
    
    func removeAnimation(_ id:UUID){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
          buttonFrames.removeAll(where: {$0.id == id})
              
              
            }
        }
}



struct ButtonFrame:Identifiable,Equatable{
    var id:UUID = .init()
    var value:Int
    var offset:CGSize = .zero
    var opacity:CGFloat = 1
    var triggerKeyFrame:Bool = false
}

#Preview {
    ContentView()
}
