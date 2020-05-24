import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    // The Core Image library requires you to instantiate this.
    let context = CIContext()
    var original: UIImage!

    @IBAction func applySepia() {
        if original == nil {
            return
        }

        if let filter = CIFilter(name: "CISepiaTone") {
            filter.setValue(1.0, forKey: kCIInputIntensityKey)
            display(filter: filter)
        }
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            display(filter: filter)
        }
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        if let filter = CIFilter(name: "CIPhotoEffectProcess") {
            display(filter: filter)
        }
    }

    @IBAction func applyGlow() {
        if original == nil {
            return
        }

        if let filter = CIFilter(name: "CIBloom") {
            display(filter: filter)
        }
    }

    @IBAction func applyPixellate() {
        if original == nil {
            return
        }

        if let filter = CIFilter(name: "CIHexagonalPixellate") {
            display(filter: filter)
        }
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            // A delegate is a way for one class to delegate behavior to another.
            // We want the picker to delegate responding to a user picking an image to this class.
            picker.delegate = self
            picker.sourceType = .photoLibrary
            // Making our navigation controller actually display the image picker.
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    @IBAction func savePhoto(_ sender: UIBarButtonItem) {
        if let imageToSave = imageView.image {
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        }
    }

    func display(filter: CIFilter) {
        // Converting the original image (which is an instance of UIImage) to a CIImage.
        filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)

        // Core graphics image (CGImage) is an intermediary image format. After filtering, we're converting the image like CIImage -> CGImage -> UIImage.
        if let output = filter.outputImage {
            let cgImage = self.context.createCGImage(output, from: CIImage(image: original)!.extent)
            let uiImage = UIImage(cgImage: cgImage!)
            imageView.image = uiImage
        } else {
            print("Couldn't convert image")
        }
    }

    // Runs after user is done choosing an image in the imagePicker.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
}
