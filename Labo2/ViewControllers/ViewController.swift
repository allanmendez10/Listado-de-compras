//
//  ViewController.swift
//  Labo2
//
//  Created by Allan Cordero Mendez on 7/11/20.
//  Copyright © 2020 Allan Cordero Mendez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //variables
    var array:[Article]?
    var articleSelected:Article?
    
    // commponents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCell: UIBarButtonItem!
    @IBOutlet weak var btnAddRow: UIBarButtonItem!
    @IBOutlet weak var txtCellMessaje: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array = [Article]()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.articleSelected = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "articleForm" {
            if let destinationViewController =  segue.destination as? ArticleFormViewController{
                destinationViewController.delegate = self
                
            }
        }
        
    }
    
    
}


extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let array = self.array{
            return array.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ArticleCell  = tableView.dequeueReusableCell(withIdentifier: "celdaIdentifier", for: indexPath) as! ArticleCell
        
        if self.array != nil {
            let article =  array![indexPath.row]
            cell.lblTitle.text = "Título: \(String(describing: article.title))"
            cell.lblName.text = "Nombre: \(String(describing: article.name))"
            cell.lblDescription.text = "Descripción: \(String(describing: article.description))"
            
            cell.imgArticle.image = article.image
            
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(index: indexPath.row)
    }
    
    
    func showAlert(index:Int) {
        
        let alert = UIAlertController(title: "Seleccione una opción", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: { action in
            
            self.articleSelected = self.array![index]
            
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "articleFormViewController") as? ArticleFormViewController
            
            vc?.articleSelected = self.articleSelected
            vc?.delegate = self
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { action in
            
            self.array?.remove(at: index)
            self.tableView.reloadData()
            
        }))
        

        present(alert,animated: true, completion:{
           alert.view.superview?.isUserInteractionEnabled = true
           alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
        
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ViewController :ArticleProtocol{
    func didCreateArticle(article: Article) {
        
        if let aSelected = self.articleSelected{
            
            if let i = self.array?.firstIndex(of: aSelected) {
                self.array?[i] = article
            }
        }else{
            self.array?.append(article)
        }
        
        self.tableView.reloadData()
    }
    
}

