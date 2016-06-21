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
    struct Province {
        let name: String
        let cities: [City]
    }
    
    struct City {
        let name: String
        let districts: [String]
    }
    
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
    
    private var subdivisionsData: [Province] = []
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
            localData = NSArray(contentsOfFile: path) as? [[String: [[String: [String]]]]] else {
                assertionFailure("ChineseSubdivisionsPicker load data failed.")
                return
        }
        
        subdivisionsData = localData.map { provinceData in
            Province(name: provinceData.keys.first!, cities: provinceData.values.first!.map({ citiesData in
                City(name: citiesData.keys.first!, districts: citiesData.values.first!)
            }))
        }
        provinces = subdivisionsData.map({ $0.name })
        
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
            if __province != provinces[row] && pickerType != .Province {
                __province = provinces[row]
                
                let citiesInProvince = subdivisionsData[row].cities
                cities = citiesInProvince.map({ $0.name })

                reloadComponent(1)
                selectRow(0, inComponent: 1, animated: false)
            } else {
                pickerDelegate?.subdivisionsPickerDidUpdate(self)
            }
        case 1:
            if __city != cities[row] && pickerType != .City {
                __city = cities[row]
                
                guard let province = subdivisionsData.filter({ $0.name == __province }).first,
                    city = province.cities.filter({ $0.name == __city }).first else {
                        return
                }
                districts = city.districts
                
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
