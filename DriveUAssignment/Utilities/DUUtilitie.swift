//
//  DUUtilitie.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit

// MARK: - DUUtilitie
class DUUtilitie {
    class func getGalleryPlaceholderImage() -> UIImage? {
        return UIImage(named: "GalleryPlaceholder")
    }
    
    static let defaultImgUrl = AssetExtractor.createLocalUrl(forImageNamed: "GalleryPlaceholder")?.absoluteString ?? ""
    
    class func getSocialMediaCellWidth() -> CGFloat {
        ((UIScreen.main.bounds.size.width - 52) / CGFloat(getNumberOfIcon()))
    }
    
    class func getNumberOfIcon() -> Int {
        4
    }
}

// MARK: - AlertUtility
class AlertUtility: NSObject {
    static let singleton = AlertUtility()
    var alert: UIAlertController?
    
    override init() {
        super.init()
    }
    
    func showAlert(withTitle title: String?, message: String?, actions: [UIAlertAction], viewController: UIViewController) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let alert = alert else { return }
        
        for action in actions {
            alert.addAction(action)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(withTitle title: String?, message: String?, actions: [UIAlertAction], viewController: UIViewController) {
        // Dismiss if there is active alert
        dismissActiveAlert()
        
        alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        guard let alert = alert else { return }
        
        for action in actions {
            alert.addAction(action)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func dismissActiveAlert() {
        guard let alert = alert else { return }
        alert.dismiss(animated: true, completion: nil)
    }
    
    func deallocAlert() {
        alert = nil
    }
}

// Below link will confirm to CellIdentifierProtocol for all cells in app
extension UITableViewCell: CellIdentifierProtocol {}
extension UICollectionViewCell: CellIdentifierProtocol {}

// MARK: - CellIdentifierProtocol
protocol CellIdentifierProtocol {
    static var reuseIdentifier: String { get }
    static var nib: String { get }
}

extension CellIdentifierProtocol where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: String {
        return String(describing: Self.self)
    }
}

// MARK: - Array extension
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - AssetExtractor
class AssetExtractor {
    static func createLocalUrl(forImageNamed name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")

        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }

        return url
    }

}

// MARK: - UIColor extension
extension UIColor {
    /*
     Notes: Call the initializer and append 0x at the beginning of hex color code
     */
    // Use below for adding Hex color codes
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    
    static var themeBlue: UIColor {
        return UIColor.init(rgb: 0x007AFF) // UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    }
}
