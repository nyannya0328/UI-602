//
//  Home.swift
//  UI-515
//
//  Created by nyannyan0328 on 2022/03/21.
//

import SwiftUI
import SceneKit

struct Home: View {
    @State var currentSize : PizzaSize = .Midium
    
    @State var pizzas : [Pizza] = [
    
      

            Pizza(breadName: "Bread_1"),
            Pizza(breadName: "Bread_2"),
            Pizza(breadName: "Bread_3"),
            Pizza(breadName: "Bread_4"),
            Pizza(breadName: "Bread_5"),


        ]
    
    @State var currentPizza : String = "Bread_1"
    
    @Namespace var animation
    
    let toppings : [String] = ["Basil","Onion","Broccoli","Mushroom","Sausage"]
    
    
    @State var pizzaTop : SCNScene? = .init(named: "Pizza_Box.scn")
    @State var pizzaBottom : SCNScene? = .init(named: "Pizza_Box.scn")
    
    @State var movePlate : Bool = false
    @State var showBox : Bool = false
    @State var disableControl : Bool = false
    
    @State var additemToCart : Bool = false
    @State var cartItems : [Pizza] = []
    @State var shirnkPizza : Bool = false
    var body: some View {
        VStack{
            
            
            
            HStack{
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                }
                
                Spacer()
                
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "cart")
                        .font(.title3)
                        .overlay(alignment:.topTrailing){
                            
                            Text("\(cartItems.count)")
                                .foregroundColor(.black)
                                .padding(5)
                                .background{

                                    Circle()
                                        .fill(.red)
                                }
                                .offset(x:10,y:-15)
                                .foregroundColor(.white)
                                .opacity(cartItems.isEmpty ? 0 : 1)
                        }
                    
                    
                    
                }
                

                
            }
            .overlay(content: {
                
                Text("Pizza")
                    .font(.title.weight(.semibold))
            })
            
            
        
            .foregroundColor(.black)
            .padding([.horizontal,.top],15)
            
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                
                ZStack{
                    
                    Image("Plate")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                        .padding(.horizontal)
                    
                    
                    
                    ZStack{
                        
                        CustomSenceKit(scence: $pizzaBottom)
                            .frame(width: size.width, height: size.height)
                            .rotationEffect(.init(degrees: 180))
                            .scaleEffect(showBox ? 1.1 : 0.9)
                            .opacity(showBox ? 1 : 0)
                        
                        
                        TabView(selection: $currentPizza) {
                            
                            
                            
                            ForEach(pizzas){pizza in
                                
                                
                                ZStack{
                                    
                                    
                                    Image(pizza.breadName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(40)
                                    
                                    ToopingView(toppings: pizza.toppings, pizza: pizza, width: (size.width / 2) - 50)
                                }
                                .tag(pizza.breadName)
                            
                                
                                
                            }
                            
                            
                            
                            
                        }
                        .scaleEffect(currentSize == .Large ? 1 : (currentSize == .Midium ? 0.95 : 0.9))
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .scaleEffect(movePlate ? 0.7 : 1)
                        .scaleEffect(shirnkPizza ? 0.8 : 1,anchor:.top)
                        .rotation3DEffect(.init(degrees: showBox ? -40 : 0), axis: (x:1, y:0, z:0), anchorZ: showBox ? 120 : 0)
                        .offset(y:showBox ? 120 : 0)
                     
                        
                        
                        CustomSenceKit(scence: $pizzaTop,isTopPortion:true)
                            .frame(width: size.width, height: size.height)
                            .rotationEffect(.init(degrees: 180))
                            .scaleEffect(showBox ? 1.1 : 0.9)
                            .opacity(showBox ? 1 : 0)
                        
                        
                    }
                    .scaleEffect(additemToCart ? 0.01 : 1,anchor:.topTrailing)
                    .offset(x:additemToCart ? -30 : 0,y:additemToCart ? -35 : 0)
                    
                    
                    
                    
                    
                    
                
                    
                    
                
                    
                }
                .frame(maxWidth:.infinity)
                
                
                
            }
            .frame(height:300)
            
            Text("$20")
                .font(.title.weight(.semibold))
                .padding(.top,10)
            
            
            HStack(spacing:20){
                
                
                ForEach(PizzaSize.allCases,id:\.rawValue){pizza in
                    
                    
                    Button {
                        
                    } label: {
                        
                        Text(pizza.rawValue)
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(10)
                            .background{
                                
                                if currentSize == pizza{
                                    
                                    
                                    Color.white
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
                                        .shadow(color: .black.opacity(0.3), radius: -5, x: -15, y: -5)
                                    
                                }
                                
                                
                                
                            }
                            .onTapGesture {
                                
                                
                                withAnimation{
                                    
                                    currentSize = pizza
                                }
                            }
                            
                        
                    }

                }
                
            }
            
            
            CustomTopping()
            
            
            Button {
                
                addToCart()
                
            } label: {
                
                Label {
                    
                    Image(systemName: "cart.fill")
                    
                } icon: {
                    
                    Text("Add to Cart")
                }
                .foregroundColor(.white)
                .padding(.vertical,10)
                .padding(.horizontal,30)
                .background(Color("Brown"))
                .cornerRadius(20)
                

            }
            .frame(maxHeight:.infinity)
        

            
            
            
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
    }
    
    func addToCart(){
        
        disableControl = true
        
        withAnimation(.easeInOut){
            
            movePlate = true
        }
        
        withAnimation(.interactiveSpring(response: 0.7,dampingFraction: 0.7,blendDuration: 0.7).delay(0.5)){
            
            showBox = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
            
            withAnimation(.easeInOut){
                
                shirnkPizza = true
            }
            
            SCNTransaction.animationDuration = 0.5
            
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.position.y = 33
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.position.z = 108
            
            
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.eulerAngles.x = 0
            pizzaBottom?.rootNode.childNode(withName: "Closed_Box", recursively: true)?.eulerAngles.x = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                withAnimation(.easeInOut(duration: 0.6)){
                    
                    
                    additemToCart = true
                    
                    
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    
                    cartItems.append(pizzas[getIndex(breadName:currentPizza)])
                    clearAnimation()
                    
                    
                    
                }
                
                
            }
        }
        
        
    }
    
    func clearAnimation(){
        
        
        shirnkPizza = false
        showBox = false
        
        withAnimation{
            
            movePlate = false
        }
        
        additemToCart = false
        
        pizzaTop = .init(named: "Pizza_Box.scn")
        pizzaBottom = .init(named: "Pizza_Box.scn")
        
        pizzas[getIndex(breadName: currentPizza)].toppings.removeAll()
        
        disableControl = false
        
        
    }
    @ViewBuilder
    func CustomTopping()->some View{
        
        
        Group{
            
            
            Text("Custom Size Pizza")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding(.top,10)
                .padding(.leading,10)
            
            
            ScrollViewReader{proxy in
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                    HStack(spacing:-15){
                        
                        
                        ForEach(toppings,id:\.self){topping in
                            
                            
                            Image("\(topping)_3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .background{
                                    
                                    
                                    Color.green
                                        .opacity(isAdded(topping: topping) ? 0.15 : 0)
                                        .clipShape(Circle())
                                        
                                }
                                .padding()
                                .contentShape(Circle())
                                .onTapGesture {
                                    
                                    
                                    
                                    if isAdded(topping: topping){
                                        
                                        if let index = pizzas[getIndex(breadName: currentPizza)].toppings.firstIndex(where: { currentTopping in
                                            
                                            
                                            return topping == currentTopping.toppingName
                                        }){
                                            
                                            
                                            pizzas[getIndex(breadName: currentPizza)].toppings.remove(at: index)
                                            
                                            
                                        }
                                        
                                        return
                                        
                                        
                                    }
                                    
                                    var positions : [CGSize] = []
                                    
                                    
                                    
                                    for _ in 1...20{
                                        
                                        positions.append(.init(width: .random(in: -20...60), height: .random(in: -45...45)))
                                        
                                        
                                    }
                                    
                                    let toppingObject = Topping(toppingName: topping,randomTopicPosticion:positions)
                                    
                                    
                                    withAnimation{
                                        
                                        pizzas[getIndex(breadName: currentPizza)].toppings.append(toppingObject)
                                        
                                        
                                    }
                                    
                                    
                                }
                                .tag(topping)
                            
                            
                        }
                    }
                    
                    
                }
                .onChange(of: currentPizza) { newValue in
                    
                    withAnimation {
                        
                        proxy.scrollTo(toppings.first ?? "" ,anchor: .leading)
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
    }
    
    @ViewBuilder
    func ToopingView(toppings : [Topping],pizza : Pizza,width : CGFloat)->some View{
        
        
        Group{
            
            ForEach(toppings.indices,id:\.self){index in
                
                
                let topping = toppings[index]
               
                
                
                ZStack{
                    
                    ForEach(1...20,id:\.self){subeIndex in
                        
                        
                        let rotaion = Double(subeIndex) * 36
                        let cartIndex = (subeIndex > 10 ? (subeIndex - 10) : subeIndex)
                        
                        Image("\(topping.toppingName)_\(cartIndex)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .offset(x: (width / 2) - topping.randomTopicPosticion[subeIndex - 1].width,y:topping.randomTopicPosticion[subeIndex - 1].height)
                            .rotationEffect(.init(degrees: rotaion))
                        
                        
                        
                        
                    }
                }
                .scaleEffect(topping.isAdded ? 1 : 10,anchor: .bottom)
                .onAppear {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        
                        withAnimation{
                            
                            
                            pizzas[getIndex(breadName: pizza.breadName)].toppings[index].isAdded = true
                        }
                        
                        
                    }
                }
            }
            
            
            
            
        }
        
    }
    
    
    func isAdded(topping : String) -> Bool{
        
        
        let staus = pizzas[getIndex(breadName:currentPizza)].toppings.contains { currentTopping in
            
            
            return currentTopping.toppingName == topping
        }
        return staus
        
    }
    
    func getIndex(breadName : String) -> Int{
        
        let index = pizzas.firstIndex { pizza in
            
            return pizza.breadName == breadName
        } ?? 0
        
        return index
        
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

enum PizzaSize : String,CaseIterable{
    
    case Small = "S"
    case Midium = "M"
    case Large = "L"
}
