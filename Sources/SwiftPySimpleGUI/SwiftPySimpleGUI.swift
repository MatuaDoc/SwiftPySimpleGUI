// PSG
//
// Created by Matua Doc (https://matuadoc.co.nz/)
// Created on 2024-02-29

import Foundation
import PythonKit

fileprivate let sg = Python.import("PySimpleGUIWeb")

public class PSG {
    public init() {}
    
    fileprivate static func pythonize(layout: [[PSGControl]]) -> [[PythonObject]] {
        return layout.map { $0.map { $0.pythonObject } }
    }
}

public struct PSGSize : PythonConvertible {
    public var pythonObject: PythonObject {
        return Python.tuple([self.width, self.height])
    }
    
    let width: Int?
    let height: Int?
    
    public init(_ width: Int?, _ height: Int?) {
        self.width = width
        self.height = height
    }
}

public struct PSGPadding : PythonConvertible {
    let top: Int?
    let right: Int?
    let bottom: Int?
    let left: Int?
    
    public var pythonObject: PythonObject {
        let sides = Python.tuple([left, right])
        let topBottom = Python.tuple([top, bottom])
        return Python.tuple([sides, topBottom])
    }
    
    init(top: Int?, right: Int?, bottom: Int?, left: Int?) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
    init(fromPadding padding: ((Int, Int), (Int, Int))) {
        self.top = padding.1.0
        self.right = padding.0.1
        self.bottom = padding.1.1
        self.left = padding.0.0
    }
}

///
public class PSGWindow {
    private let window: PythonObject
    
    public var title: String {
        get { return String(self.window.title)! }
        set { self.window.title = PythonObject(newValue) }
    }
    
    public init(title: String, layout: [[PSGControl]]) {
        self.window = sg.Window(title, layout: PSG.pythonize(layout: layout))
    }

    public func read() -> (String, [String: String]?) {
        let (event, values): (PythonObject, PythonObject) = self.window.read().tuple2
        
        guard let eventStr = String(event), let valuesDict = Dictionary<String, String>(values) else {
            return ("", nil)
        }
        
        return (eventStr, valuesDict)
    }

    public func close() {
        self.window.close()
    }
}

public protocol PSGControl {
    var pythonObject: PythonObject { get }
}

public class PSGLabel: PSGControl {
    public var text: String
    public var pythonObject: PythonObject {
        sg.Text(self.text)
    }

    public init(_ text: String) {
        self.text = text
    }
}

public class PSGTextField: PSGControl {
    public var defaultText: String
    public var key: String
    public var pythonObject: PythonObject {
        sg.InputText(default_text: self.defaultText, key: self.key)
    }

    public init(defaultText: String = "", key: String) {
        self.defaultText = defaultText
        self.key = key
    }
}

public class PSGButton: PSGControl {
    private var _pythonObject: PythonObject
    
    public var pythonObject: PythonObject {
        get {
            self._pythonObject
        }
    }
    
    public var buttonText: String {
        get { return String(self._pythonObject.button_text)! }
        set { self._pythonObject.button_text = PythonObject(newValue) }
    }
    
    public var toolTip: String? {
        get { return String(self._pythonObject.tooltip) }
        set { self._pythonObject.tooltip = PythonObject(newValue) }
    }
    
    public var disabled: Bool {
        get { return Bool(self._pythonObject.disabled)! }
        set { self._pythonObject.disabled = PythonObject(newValue) }
    }
    
    public var imageFilename: String? {
        get { return String(self._pythonObject.image_filename) }
        set { self._pythonObject.image_filename = PythonObject(newValue) }
    }
    
    public var imageSize: PSGSize {
        get {
            let tuple = self._pythonObject.image_size.tuple2
            return PSGSize(Int(tuple.0), Int(tuple.1))
        }
        set { self._pythonObject.image_size = Python.tuple([newValue.width, newValue.height]) }
    }
    
    public var borderWidth: Int? {
        get { return Int(self._pythonObject.border_width) }
        set { self._pythonObject.border_width = PythonObject(newValue) }
    }
    
    public var size: PSGSize {
        get {
            let tuple = self._pythonObject.size.tuple2
            return PSGSize(Int(tuple.0), Int(tuple.1))
        }
        set { self._pythonObject.size = Python.tuple([newValue.width, newValue.height]) }
    }
    
    public var autoSize: Bool? {
        get { return Bool(self._pythonObject.auto_size) }
        set { self._pythonObject.auto_size = PythonObject(newValue) }
    }
    
    public var focus: Bool {
        get { return Bool(self._pythonObject.focus)! }
        set { self._pythonObject.focus = PythonObject(newValue) }
    }
    
    private var padding: ((Int, Int), (Int, Int)) {
        get {
            let tuple = self._pythonObject.padding.tuple2
            let sides = tuple.0.tuple2
            let topBottom = tuple.1.tuple2
            return (((Int(sides.0)!, Int(sides.1)!), (Int(topBottom.0)!, Int(topBottom.1)!)))
        }
    }
    
    public var paddingTop: Int? {
        get { return self.padding.1.0 }
        set {
            var newPadding = self.padding
            newPadding.1.0 = newValue!
            self._pythonObject.pad = PSGPadding(fromPadding: newPadding).pythonObject
        }
    }
    
    public var paddingRight: Int? {
        get { return self.padding.0.1 }
        set {
            var newPadding = self.padding
            newPadding.0.1 = newValue!
            self._pythonObject.pad = PSGPadding(fromPadding: newPadding).pythonObject
        }
    }
    
    public var paddingBottom: Int? {
        get { return self.padding.1.1 }
        set {
            var newPadding = self.padding
            newPadding.1.1 = newValue!
            self._pythonObject.pad = PSGPadding(fromPadding: newPadding).pythonObject
        }
    }
    
    public var paddingLeft: Int? {
        get { return self.padding.0.0 }
        set {
            var newPadding = self.padding
            newPadding.0.0 = newValue!
            self._pythonObject.pad = PSGPadding(fromPadding: newPadding).pythonObject
        }
    }
    
    public var key: String? {
        get { return String(self._pythonObject.key) }
    }
    
    public var visible: Bool {
        get { return Bool(self._pythonObject.visible)! }
        set { self._pythonObject.visible = PythonObject(newValue) }
    }
    
    public init(buttonText: String,
                toolTip: String? = nil,
                disabled: Bool = false,
                imageFilename: String? = nil,
                imageSize: PSGSize = PSGSize(nil, nil),
                borderWidth: Int? = nil,
                size: PSGSize = PSGSize(nil, nil),
                autoSize: Bool? = nil,
                focus: Bool = false,
                paddingTop: Int? = nil,
                paddingRight: Int? = nil,
                paddingBottom: Int? = nil,
                paddingLeft: Int? = nil,
                key: String? = nil,
                visible: Bool = true
    ) {
        self._pythonObject = sg.Button(button_text: buttonText,
                                       tooltip: toolTip,
                                       disabled: disabled,
                                       image_filename: imageFilename,
                                       image_size: imageSize,
                                       border_width: borderWidth,
                                       size: size,
                                       auto_size_button: autoSize,
                                       focus: focus,
                                       pad: PSGPadding(top: paddingTop, right: paddingRight, bottom: paddingBottom, left: paddingLeft).pythonObject,
                                       key: key,
                                       visible: visible
        )
    }
}
