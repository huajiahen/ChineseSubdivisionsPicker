//
//  ChineseSubdivisionsPicker.swift
//  ChineseSubdivisionsPickerExample
//
//  Created by huajiahen on 12/7/15.
//  Copyright © 2015 huajiahen. All rights reserved.
//

import UIKit

public protocol ChineseSubdivisionsPickerDelegate {
    func subdivisionsPickerDidUpdate()
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
    private(set) public var province: String?
    private(set) public var city: String?
    private(set) public var district: String?
    
    private var subdivisionsData = [String: [[String: [String]]]]()
    private var provinces = [String]()
    private var cities = [String]()
    private var districts = [String]()
    
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
        
        if pickerType == .District {
            district = districts[0]
        }
        pickerDelegate?.subdivisionsPickerDidUpdate()
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
        
        guard let path = podBundle.pathForResource("ChineseSubdivisions", ofType: "plist") else {
            assertionFailure("ChineseSubdivisionsPicker load data failed.")
            return
        }
        
        guard let localData = NSDictionary(contentsOfFile: path) as? [String: [[String: [String]]]] else {
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
            let selectedProvince = selectedRowInComponent(0)
            guard selectedProvince != -1 && selectedProvince < provinces.count else {
                return 0
            }
            province = provinces[selectedProvince]
            cities = Array(Array(subdivisionsData.values)[selectedProvince][0].keys)
            return cities.count
        case 2:
            let selectedProvince = selectedRowInComponent(0)
            guard selectedProvince != -1 && selectedProvince < subdivisionsData.count else {
                return 0
            }
            let selectedCity = selectedRowInComponent(1)
            let selectedProvinceData = Array(subdivisionsData.values)[selectedProvince][0]
            guard selectedCity != -1 && selectedCity < selectedProvinceData.count else {
                return 0
            }
            city = cities[selectedCity]
            districts = Array(selectedProvinceData.values)[selectedCity]
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
            let reloadFlag = province != newProvince
            province = newProvince
            if reloadFlag && pickerType != .Province {
                reloadComponent(1)
                selectRow(0, inComponent: 1, animated: false)
            } else {
                pickerDelegate?.subdivisionsPickerDidUpdate()
            }
        case 1:
            let newCity = cities[row]
            let reloadFlag = city != newCity
            city = newCity
            if reloadFlag && pickerType != .City {
                reloadComponent(2)
                selectRow(0, inComponent: 2, animated: false)
            } else {
                pickerDelegate?.subdivisionsPickerDidUpdate()
            }
        case 2:
            district = districts[row]
            pickerDelegate?.subdivisionsPickerDidUpdate()
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
