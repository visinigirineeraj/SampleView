//
//  ViewController.swift
//  CollectionCarosel
//
//  Created by byndr on 01/11/21.
//

import UIKit

class ImagePickerViewController: UIViewController {

    var viewModel:ImagePickerViewModelProtocol = ImagePickerViewModel()

    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        segue.destination.modalPresentationStyle = UIModalPresentationStyle.pageSheet

//        if let sheetPresentationController = segue.destination.presentationController as? UISheetPresentationController {
//            // Let's have the grabber always visible
//            sheetPresentationController.prefersGrabberVisible = true
//            // Define which heights are allowed for our sheet
//            sheetPresentationController.detents = [
//                UISheetPresentationController.Detent.medium(),
//                UISheetPresentationController.Detent.large()
//            ]
//        }
    }
    
    func setUpViewModel() {
        self.viewModel.data.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionview.reloadData()
            }
        }
    }
}

extension ImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdenttifier", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.swippedAction = {
            self.performSegue(withIdentifier: "DetailsIdentifier", sender: nil)
        }
        let obj = viewModel.getNASAModel(indexPath: indexPath)
        cell.imageView.downloadImageFrom(urlString: obj.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}

// MARK: Set the size of the cards
extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 230.0, height: 300.0)
    }
}
