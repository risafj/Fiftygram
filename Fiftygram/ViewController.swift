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

        let filter = CIFilter(name: "CISepiaTone")
        // Converting the original image (which is an instance of UIImage) to a CIImage.
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
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

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        // Core graphics image (CGImage) is an intermediary image format.
        // "output!.extent" is just the size of the image, which we need to provide as a param.
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
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
