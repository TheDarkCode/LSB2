//
//  Utils.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class Utils {
    
    private let endSymbols: String = "&^//]!21s3;"
    private var binaryEndSymbols: [String] = []
    
    
    func resize(image: UIImage) -> UIImage {
        
        var width = image.size.width
        var height = image.size.height
        if width > 400 || height > 400 {
            switch width > height {
            case true:
                let scale = 400 / width
                width = 400
                height = height * scale
            default:
                let scale = 400 / height
                height = 400
                width = width * scale
            }
        }
        
        let newWidth = CGFloat(width)
        let newHeight = CGFloat(height)
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    func pixelData(image: UIImage) -> [UInt8]? {
        let size = image.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = image.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
    
    
    func toDecimals(string: String) -> [String]? {
        var result: [String] = []
        for char in string.characters {
            guard let asciiValue = char.asciiValue else {return nil}
            var dec = String(asciiValue, radix: 2)
            for _ in dec.characters.count..<8 {
                dec.insert("0", at: dec.startIndex)
            }
            result.append(dec)
        }
        return result
    }
    
    
    
    func toImage(data: [UInt8], width: Int, height: Int) -> UIImage? {
        var pixels: [PixelData] = []
        var i: Int = 0
        
        while (i < data.count) {
            let tmpData = PixelData(a: data[i+3], r: data[i], g: data[i+1], b: data[i+2])
            i += 4
            
            pixels.append(tmpData)
            
        }
        
        let pixelDataSize = MemoryLayout<PixelData>.size
        assert(pixelDataSize == 4)
        
        assert(pixels.count == Int(width * height))
        
        let data: Data = pixels.withUnsafeBufferPointer {
            return Data(buffer: $0)
        }
        
        let cfdata = NSData(data: data) as CFData
        let provider: CGDataProvider! = CGDataProvider(data: cfdata)
        if provider == nil {
            print("CGDataProvider is not supposed to be nil")
            return nil
        }
        let cgimage: CGImage! = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * pixelDataSize,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        if cgimage == nil {
            print("CGImage is not supposed to be nil")
            return nil
        }
        return UIImage(cgImage: cgimage)
        
    }
    
    
    func encrypt(imageToEncrypt: UIImage, message: String, completion: @escaping (UIImage?) -> (Void)) {
        
        DispatchQueue.global().async {
            let image = self.resize(image: imageToEncrypt)

            var text = message
            text += self.endSymbols
        
            guard var RGBArray = self.pixelData(image: image) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let binaryMessage = self.toDecimals(string: text) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            var counter: Int = 0
            
            for letter in binaryMessage {
                for char in letter.characters {
                    
                    let num = RGBArray[counter]
                    let characterBit = char
                    guard let bitValue = UInt8(String(characterBit)) else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    let resultNum = (num & 0b11111110) | bitValue
                    RGBArray[counter] = resultNum
                    counter += 4
                }
            }
            let resultImg = self.toImage(data: RGBArray, width: Int(image.size.width), height: Int(image.size.height))
            DispatchQueue.main.async {
                completion(resultImg)
            }
        }
    }
    
    
    func decrypt(image: UIImage, completion: @escaping (String) -> (Void)) {
        DispatchQueue.global().async {
            self.binaryEndSymbols = self.toDecimals(string: self.endSymbols)!
            guard let RGBArray = self.pixelData(image: image) else {
                DispatchQueue.main.async {
                    completion(Constants.decryptingErrorMessage)
                }
                return
            }
            var isEnd: Bool = false
            var textFound = true
            var i = 0
            var bits = 0
            var binLetter: String = ""
            var letters: [String] = []
            var result: String = ""
            
            while !isEnd {
                
                bits += 1
                if i >= RGBArray.count {
                    textFound = false
                    break
                }
                binLetter += String(String((RGBArray[i]), radix: 2).characters.last!)
                
                if bits % 8 == 0 {
                    letters.append(binLetter)
                    binLetter = ""
                }
                
                i += 4
                
                if letters.count >= self.binaryEndSymbols.count {
                    let startIndex = letters.count - self.binaryEndSymbols.count
                    let newArrayFromLetters = Array(letters[startIndex...letters.count-1])
                    if newArrayFromLetters == self.binaryEndSymbols {
                        isEnd = true
                        letters = Array(letters[0...letters.count-(1 + self.binaryEndSymbols.count)])
                    }
                }
            }
            
            for str in letters {
                let asciiNum = Int(str, radix: 2)
                let letter = String(UnicodeScalar(asciiNum!)!)
                result += letter
            }
            
            if !textFound {result = Constants.noTextFoundMessage}

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

}
