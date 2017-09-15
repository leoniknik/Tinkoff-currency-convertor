//
//  ViewController.swift
//  Currency convertor
//
//  Created by Кирилл Володин on 14.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var convertToLabel: UILabel!
    @IBOutlet weak var selectCurrencyLabel: UILabel!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerFrom: UIPickerView!
    @IBOutlet weak var pickerTo: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currencies: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.pickerFrom.dataSource = self
        self.pickerTo.dataSource = self
        
        self.pickerFrom.delegate = self
        self.pickerTo.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        updateData()
    }
    
    @IBAction func updatePressed(_ sender: UIBarButtonItem) {
        updateData()
    }

    func updateData() {
        currencies.removeAll()
        self.label.text = ""
        self.pickerFrom.isHidden = true
        self.pickerTo.isHidden = true
        self.convertToLabel.isHidden = true
        self.selectCurrencyLabel.isHidden = true
        
        self.retrieveListOfCurrencies() { [weak self] (value) in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    strongSelf.label.text = value
                    strongSelf.activityIndicator.stopAnimating()
                    if strongSelf.currencies.count > 2 {
                        strongSelf.pickerFrom.isHidden = false
                        strongSelf.pickerTo.isHidden = false
                        strongSelf.convertToLabel.isHidden = false
                        strongSelf.selectCurrencyLabel.isHidden = false
                        strongSelf.pickerFrom.reloadAllComponents()
                        strongSelf.pickerTo.reloadAllComponents()
                        strongSelf.requestCurrentCurrencyRate()
                    }
                }
            })
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === pickerTo {
            return self.currenciesExceptBase().count
        }
        return self.currencies.count
    }


    func requestCurrencyRates(baseCurrency: String, parseHandler: @escaping(Data?, Error?) -> Void) {

        let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        
        let dataTask = URLSession.shared.dataTask(with: url) {
            (dataReceived, response, error) in
            parseHandler(dataReceived, error)
        }
        
        dataTask.resume()
    }
    
    func parseCurrencyRatesResponse(data: Data?, toCurrency: String) -> String {
        var value: String = ""
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            
            if let parsedJSON = json {
                print("\(parsedJSON)")
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double> {
                    if let rate = rates[toCurrency] {
                        value = "\(rate)"
                    }
                    else {
                        value = "No rate for currency \"\(toCurrency)\" found"
                    }
                } else {
                    value = "No \"rates\" field found"
                }
            } else {
                value = "No JSON value"
            }
        } catch {
            value = error.localizedDescription
        }
        
        return value
    }
    
    func retrieveCurrencyRate(baseCurrency: String, toCurrency: String, completion: @escaping (String) -> Void) {
        self.requestCurrencyRates(baseCurrency: baseCurrency) { [weak self] (data, error) in
            var string = "No currency retrieved!"
        
            if let currentError = error {
                string = currentError.localizedDescription
            } else {
                if let strongSelf = self {
                    string = strongSelf.parseCurrencyRatesResponse(data: data, toCurrency: toCurrency)
                }
            }

            completion(string)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView === pickerFrom {
            self.pickerTo.reloadAllComponents()
        }
        
        requestCurrentCurrencyRate()
        
    }
    
    func currenciesExceptBase() -> [String] {
        
        var currenciesExceptBase = currencies
        if !currenciesExceptBase.isEmpty {
            currenciesExceptBase.remove(at: pickerFrom.selectedRow(inComponent: 0))
        }
        return currenciesExceptBase
        
    }
    
    func requestCurrentCurrencyRate() {
        if self.currencies.count > 2 {
            self.activityIndicator.startAnimating()
            self.label.text = ""
        
            let baseCurrencyIndex = self.pickerFrom.selectedRow(inComponent: 0)
            let toCurrencyIndex = self.pickerTo.selectedRow(inComponent: 0)
        
            let baseCurrency = self.currencies[baseCurrencyIndex]
            let toCurrency = self.currenciesExceptBase()[toCurrencyIndex]
        
            self.retrieveCurrencyRate(baseCurrency: baseCurrency, toCurrency: toCurrency) { [weak self] (value) in
                DispatchQueue.main.async(execute: {
                    if let strongSelf = self {
                        strongSelf.label.text = value
                        strongSelf.activityIndicator.stopAnimating()
                    }
                })
            }
        }
    }
    
    // MARK: getListOfCurrencies
    
    func retrieveListOfCurrencies(completion: @escaping (String) -> Void) {
        self.requestListOfCurrencies() { [weak self] (data, error) in
            var string = "No currency retrieved!"
            
            if let currentError = error {
                string = currentError.localizedDescription
            } else {
                if let strongSelf = self {
                    string = strongSelf.parseListOfCurrenciesResponse(data: data)
                }
            }
            
            completion(string)
        }
    }
    
    func requestListOfCurrencies(parseHandler: @escaping(Data?, Error?) -> Void) {
        
        let url = URL(string: "https://api.fixer.io/latest")!
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.timeoutIntervalForResource = TimeInterval(5)
        let session = URLSession(configuration: configuration)
        
        let dataTask = session.dataTask(with: url) {
            (dataReceived, response, error) in
            parseHandler(dataReceived, error)
        }
        
        dataTask.resume()
    }
    
    func parseListOfCurrenciesResponse(data: Data?) -> String {
        var value: String = ""
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            
            if let parsedJSON = json {
                if let base = parsedJSON["base"] as? String {
                    currencies.append(base)
                }
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double> {
                    for key in rates.keys {
                        currencies.append(key)
                    }
                } else {
                    value = "No \"rates\" field found"
                }
            } else {
                value = "No JSON value"
            }
        } catch {
            value = error.localizedDescription
        }
        
        return value
    }

    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let customView = Bundle.main.loadNibNamed("TBCurrencyPickerCell", owner: self, options: nil)?.first as? TBCurrencyPickerCell
        var currency = ""
        if pickerView === pickerTo {
            currency = currenciesExceptBase()[row]
        }
        else {
            currency = currencies[row]
        }
        let image = FlagManager.getFlagForCurrency(currency)
        customView?.imageView.image = image
        customView?.title.text = currency
        return customView!
    }
    
}

