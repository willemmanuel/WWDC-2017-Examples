//
//  ViewController.swift
//  Recognizer
//
//  Created by Will Emmanuel on 6/8/17.
//  Copyright © 2017 Will Emmanuel. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = ""
        }
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.show(picker, sender: self)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            let model = try! VNCoreMLModel(for: Resnet50().model)
            let request = VNCoreMLRequest(model: model, completionHandler: vnResultHandler)
            
            let handler = VNImageRequestHandler(cgImage: pickedImage.cgImage!, orientation: 0, options: [:])
            try? handler.perform([request])
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func vnResultHandler(request: VNRequest, error: Error?) {
        guard let result = request.results as? [VNClassificationObservation] else {
            label.text = "¯\\_(ツ)_/¯"
            return
        }
        
        label.text = result.first?.identifier
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}
