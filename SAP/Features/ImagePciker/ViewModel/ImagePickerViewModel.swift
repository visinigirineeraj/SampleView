//
//  ImagePickerViewModel.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation

protocol ImagePickerViewModelProtocol {
    var data: Box<[NASAModel]> { get }
    func downloadAPOD()
    func getNASAModel(indexPath: IndexPath) -> NASAModel
}

class ImagePickerViewModel: ImagePickerViewModelProtocol {
    var data: Box<[NASAModel]> = Box([])
        
    func downloadAPOD() {
        let serviceManager = ServiceManager<[NASAModel]>()
        serviceManager.request(endPoint:NASAEndPoint.getAPODs(count: 5)) { model, error in
            if let model = model {
                self.data.value = model
            } else {
                
            }
        }
    }
    
    func getNASAModel(indexPath: IndexPath) -> NASAModel {
        return data.value[indexPath.row]
    }
}
