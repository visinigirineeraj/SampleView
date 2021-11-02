//
//  Box.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation

class Box<T>{
    typealias Listener = (T) -> ()
    
    var listeners:[Listener] = []
    var value:T {
        didSet{
            listeners.forEach{
                $0(value)
            }
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    func bind(_ listener: @escaping Listener){
        self.listeners.append(listener)
    }
}
