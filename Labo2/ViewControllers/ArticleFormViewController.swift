//
//  ArticleFormViewController.swift
//  Labo2
//
//  Created by Allan Cordero Mendez on 7/21/20.
//  Copyright © 2020 Allan Cordero Mendez. All rights reserved.
//

import UIKit

class ArticleFormViewController: UIViewController , UINavigationControllerDelegate {
    
    var article:Article?
    @IBOutlet weak var edTitle: UITextField!
    @IBOutlet weak var edName: UITextField!
    @IBOutlet weak var edDescription: UITextField!
    @IBOutlet weak var btnArticle: UIButton!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imgArticle: UIImageView!
    var delegate:ArticleProtocol?
    
    var articleSelected:Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        //  delegate =
        
        // Do any additional setup after loading the view.
    }
    
    func configView() {
        
        if  let articleSele = self.articleSelected{
            
            btnArticle.setTitle("Editar", for: .normal)
            edTitle.text = articleSele.title
            edName.text = articleSele.name
            edDescription.text = articleSele.description
            imgArticle.image = articleSele.image
            viewTitle.title = "Editar Registro"
            btnArticle.isEnabled = true
            btnArticle.alpha = 1.0;

            
        }else{
            btnArticle.alpha = 0.5;
        }
        
    }
    
    
    @IBAction func deleteImage(_ sender: Any) {
        
        // if UIImage(named: "cart.badge.plus")!.isEqual( imgArticle.image) {
        let image2 = UIImage(systemName: "cart.badge.plus")
        
        if compare() {
            
            imgArticle.image = image2
            
        }
        
    }
    
    func compare() -> Bool {
        
        let image1 = imgArticle.image
        
        let identi = image1?.accessibilityIdentifier
        
        if (identi == "selected"){
            imgArticle.image?.accessibilityIdentifier = nil
            return true
        }
        
        
        return false
    }
    
    @IBAction func addArticle(_ sender: Any) {
        self.article = Article(title:edTitle.text!,name:edName.text!,description: edDescription.text!,image:imgArticle.image)
        
        
        if(validateData()){
            delegate?.didCreateArticle(article:article!)
            self.navigationController?.popViewController(animated: true)
        }
            
        
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        
        customButton()
        
    }
    
    func validateData() -> Bool {
        
        return (!edTitle.text!.isEmpty && !edName.text!.isEmpty && !edDescription.text!.isEmpty)
            
    }
    
    func customButton(){
        
        let flag = validateData()
        
        btnArticle.isEnabled = flag

        if flag {
            btnArticle.alpha = 1.0
        }else{
            btnArticle.alpha = 0.5
        }
        
    }
     
    
    @IBAction func selectImageMethod(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
        
    }
    
    
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
            case .camera:
                imagePicker.sourceType = .camera
            case .photoLibrary:
                imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = imgArticle.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}


extension ArticleFormViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imgArticle.image = selectedImage
        imgArticle.image?.accessibilityIdentifier = "selected"
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


