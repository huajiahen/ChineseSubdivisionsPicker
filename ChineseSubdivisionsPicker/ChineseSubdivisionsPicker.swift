//
//  ChineseSubdivisionsPicker.swift
//  ChineseSubdivisionsPickerExample
//
//  Created by huajiahen on 12/7/15.
//  Copyright © 2015 huajiahen. All rights reserved.
//

import UIKit

public protocol ChineseSubdivisionsPickerDelegate {
    func subdivisionsPickerDidUpdate(sender: ChineseSubdivisionsPicker)
}

public class ChineseSubdivisionsPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    public enum ChineseSubdivisionsPickerType {
        case Province
        case City
        case District
    }
    
    public var pickerType: ChineseSubdivisionsPickerType = .District {
        didSet {
            province = nil
            city = nil
            district = nil
            reloadAllComponents()
            selectRow(0, inComponent: 0, animated: false)
            if pickerType != .Province {
                selectRow(0, inComponent: 1, animated: false)
            }
            if pickerType == .District {
                selectRow(0, inComponent: 2, animated: false)
            }
        }
    }
    public var pickerDelegate: ChineseSubdivisionsPickerDelegate?
    public var province: String? {
        get { return __province }
        set {
            guard !provinces.isEmpty && newValue != nil else {
                return
            }
            
            let index = provinces.indexOf(newValue!) ?? 0
            if selectedRowInComponent(0) != index {
                selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    public var city: String? {
        get { return __city }
        set {
            guard !cities.isEmpty && pickerType != .Province && newValue != nil else {
                return
            }
            let index = cities.indexOf(newValue!) ?? 0
            if selectedRowInComponent(1) != index {
                selectRow(index, inComponent: 1, animated: false)
            }
        }
    }
    
    public var district: String? {
        get { return __district }
        set {
            guard !districts.isEmpty && pickerType == .District && newValue != nil else {
                return
            }
            let index = districts.indexOf(newValue!) ?? 0
            if selectedRowInComponent(2) != index {
                selectRow(index, inComponent: 2, animated: false)
            }
        }
    }
    
    private var subdivisionsData: [String: [[String: [String]]]] = [:]
    private var provinces: [String] = []
    private var cities: [String] = []
    private var districts: [String] = []
    private var __province: String?
    private var __city: String?
    private var __district: String?
    
    override public weak var delegate: UIPickerViewDelegate? {
        didSet {
            if delegate !== self {
                delegate = self
            }
        }
    }

    override public weak var dataSource: UIPickerViewDataSource? {
        didSet {
            if dataSource !== self {
                dataSource = self
            }
        }
    }

    //MARK: view life cycle
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        if __province == nil {
            selectRow(0, inComponent: 0, animated: false)
        }
        pickerDelegate?.subdivisionsPickerDidUpdate(self)
    }
    
    //MARK: init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPicker()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupPicker()
    }
    
    func setupPicker() {
        let podBundle = NSBundle(forClass: self.classForCoder)
        
        guard let path = podBundle.pathForResource("ChineseSubdivisions", ofType: "plist"),
            localData = NSDictionary(contentsOfFile: path) as? [String: [[String: [String]]]] else {
                assertionFailure("ChineseSubdivisionsPicker load data failed.")
                return
        }
        
        subdivisionsData = localData
        provinces = Array(subdivisionsData.keys)
        
        delegate = self
        dataSource = self
    }
    
    //MARK: - Picker view data source
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerType {
        case .Province:
            return 1
        case .City:
            return 2
        case .District:
            return 3
        }
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinces.count
        case 1:
            return cities.count
        case 2:
            return districts.count
        default:
            return 0
        }
    }
    
    //MARK: - Picker view delegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return provinces[row]
        case 1:
            guard row != -1 && row < cities.count else {
                return nil
            }
            return cities[row]
        case 2:
            guard row != -1 && row < districts.count else {
                return nil
            }
            return districts[row]
        default:
            return nil
        }
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let newProvince = provinces[row]
            let reloadFlag = __province != newProvince
            __province = newProvince
            if reloadFlag && pickerType != .Province {
                guard let citiesInProvince = subdivisionsData[newProvince]?[0] else {
                    return
                }
                cities = Array(citiesInProvince.keys)

                reloadComponent(1)
                selectRow(0, inComponent: 1, animated: false)
            } else {
                pickerDelegate?.subdivisionsPickerDidUpdate(self)
            }
        case 1:
            let newCity = cities[row]
            let reloadFlag = __city != newCity
            __city = newCity
            if reloadFlag && pickerType != .City {
                guard let province = __province,
                    districtsInCity = subdivisionsData[province]?[0][newCity] else {
                        return
                }
                districts = districtsInCity
                
                reloadComponent(2)
                selectRow(0, inComponent: 2, animated: false)
            } else {
                pickerDelegate?.subdivisionsPickerDidUpdate(self)
            }
        case 2:
            __district = districts[row]
            pickerDelegate?.subdivisionsPickerDidUpdate(self)
        default:
            break
        }
    }
    
    //MARK: - Other
    override public func selectRow(row: Int, inComponent component: Int, animated: Bool) {
        super.selectRow(row, inComponent: component, animated: animated)
        
        self.pickerView(self, didSelectRow: row, inComponent: component)
    }
}
