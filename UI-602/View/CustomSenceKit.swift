//
//  CustomSenceKit.swift
//  UI-602
//
//  Created by nyannyan0328 on 2022/06/30.
//

import SwiftUI
import SceneKit

struct CustomSenceKit: UIViewRepresentable {
    @Binding var scence : SCNScene?
    
    var isTopPortion : Bool = false
    func makeUIView(context: Context) -> SCNView {
        
        let view = SCNView()
        view.scene = scence
        view.backgroundColor = .clear
        view.isJitteringEnabled = false
        view.antialiasingMode = .multisampling4X
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
    
        
        return view
        
    }
    func updateUIView(_ uiView: SCNView, context: Context) {
        
        uiView.scene = scence
        uiView.pointOfView?.eulerAngles.x = -0.3
        uiView.scene?.rootNode.eulerAngles.x = 2.3
        
        if isTopPortion{
            
            uiView.scene?.rootNode.childNode(withName: "Closed_Box", recursively: true)?.isHidden = true
            
            
        }
        else{
            
            uiView.scene?.rootNode.childNode(withName: "Cover", recursively: true)?.isHidden = true
            
            
            
        }
        
        
    }
}


