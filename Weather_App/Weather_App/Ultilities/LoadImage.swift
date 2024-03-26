//
//  LoadImage.swift
//  Weather_App
//
//  Created by ho.bao.an on 26/03/2024.
//

import UIKit

extension UIImageView {
    func loadImage(withIcon icon: String) {
        let imgURLString = "\(Urls.domain)/img/w/\(icon).png"
        guard let imageURL = URL(string: imgURLString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}


