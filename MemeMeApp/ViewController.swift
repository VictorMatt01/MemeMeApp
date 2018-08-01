//
//  ViewController.swift
//  MemeMeApp
//
//  Created by Victor Matthijs on 24/04/2018.
//  Copyright © 2018 Victor Matthijs. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var isBottom = false
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.backgroundColor = UIColor.gray
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTextField(textField: topTextField)
        setTextField(textField: bottomTextField)
        shareButton.isEnabled = false
    }
    
    func setTextField(textField: UITextField){
        textField.delegate = self
        textField.placeholder = "type text"
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }

    @IBAction func pickAnImage(_ sender: Any) {
       pickImageFrom(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImageFrom(sourceType: .camera)
    }
    
    func pickImageFrom(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            imagePickerView.backgroundColor = .white
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isBottom = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        if(textField === bottomTextField){
            isBottom = true
        } else {
            isBottom = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if(isBottom){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }else {
            let test = self.navBar.frame.size.height
            view.frame.origin.y -= test
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedIamge())
        
        let object = UIApplication.shared.delegate as! AppDelegate
        
        object.memes.append(meme)
    }
    
    func generateMemedIamge() -> UIImage{
        configureBars(isHidden: true)
        
        topTextField.borderStyle = UITextBorderStyle.none
        bottomTextField.borderStyle = UITextBorderStyle.none
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(isHidden: false)
        
        return memedImage
    }
    
    func configureBars(isHidden: Bool){
        //toolBar.isHidden = isHidden
        navBar.isHidden = isHidden
    }
    
    @IBAction func clearImageView(_ sender: UIBarButtonItem) {
        topTextField.text = ""
        bottomTextField.text = ""
        imagePickerView.image = nil
        imagePickerView.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func shareMemedIamge(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [generateMemedIamge()], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {
            (activity, succes, items, error) in
            if(succes && error == nil){
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

