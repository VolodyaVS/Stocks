//
//  ViewController.swift
//  Stocks
//
//  Created by Vladimir Stepanchikov on 31.01.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    
    // MARK: - Private Properties
    private lazy var companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "Facebook": "FB",
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        companyPickerView.setValue(UIColor.black, forKey: "backgroundColor")
        companyPickerView.setValue(UIColor.white, forKey: "textColor")
        
        activityIndicator.hidesWhenStopped = true
        
        requestQuoteUpdate()
    }
    
    // MARK: - Private Methods
    private func displayStockInfo(companyName: String,
                                  companySymbol: String,
                                  price: Double,
                                  priceChange: Double,
                                  ImageData: Data) {
        activityIndicator.stopAnimating()
        
        companyNameLabel.text = companyName
        companySymbolLabel.text = companySymbol
        priceLabel.text = "\(price)"
        priceChangeLabel.text = "\(priceChange)"
        companyImage.image = UIImage(data: ImageData)
        
        if priceChange == 0 {
            priceChangeLabel.textColor = .white
        } else {
            priceChangeLabel.textColor = priceChange > 0 ? .systemGreen : .systemRed
        }
    }
    
    private func requestQuoteUpdate() {
        activityIndicator.startAnimating()
        
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        
        priceChangeLabel.textColor = .white
        
        companyImage.image = UIImage(systemName: "square.and.arrow.down")
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        
        NetworkManager.shared.requestQuote(for: selectedSymbol) { stock in
            DispatchQueue.main.async {
                self.displayStockInfo(
                    companyName: stock.companyName,
                    companySymbol: stock.companySymbol,
                    price: stock.price,
                    priceChange: stock.priceChange,
                    ImageData: stock.imageData
                )
            }
        }
    }
    
}

// MARK: - UIPickerViewDataSourse
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return companies.keys.count
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        Array(companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }
}
