// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:


// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//



private extension Data {
    #if !SKIP
    init(reading input: InputStream) {
        self.init()
        input.open()
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        
        input.close()
    }
    #endif
}

#if !SKIP // disabled for to reduce test count and avoid io.grpc.StatusRuntimeException: RESOURCE_EXHAUSTED: gRPC message exceeds maximum size

class TestStream : XCTestCase {
    func test_InputStreamWithData(){
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let message: NSString = "Hello, playground"
        let messageData: Data = message.data(using: String.Encoding.utf8.rawValue)!
        let dataStream: InputStream = InputStream(data: messageData)
        XCTAssertEqual(.notOpen, dataStream.streamStatus)
        dataStream.open()
        XCTAssertEqual(.open, dataStream.streamStatus)
        var buffer = [UInt8](repeating: 0, count: 20)
        if dataStream.hasBytesAvailable {
            let result: Int = dataStream.read(&buffer, maxLength: buffer.count)
            dataStream.close()
            XCTAssertEqual(.closed, dataStream.streamStatus)
            if(result > 0) {
                let output = NSString(bytes: &buffer, length: buffer.firstIndex(of: 0) ?? buffer.count, encoding: String.Encoding.utf8.rawValue)
                XCTAssertEqual(message, output!)
            }
        }
        #endif // !SKIP
    }
    
    func test_InputStreamWithUrl() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let message: NSString = "Hello, playground"
        let messageData: Data  = message.data(using: String.Encoding.utf8.rawValue)!
        guard let testFile = createTestFile("testFile_in.txt", _contents: messageData) else {
            XCTFail("Unable to create temp file")
            return
        }

        //Initialiser with url
        let url = URL(fileURLWithPath: testFile)
        let urlStream: InputStream = InputStream(url: url)!
        XCTAssertEqual(.notOpen, urlStream.streamStatus)
        urlStream.open()
        XCTAssertEqual(.open, urlStream.streamStatus)
        var buffer = [UInt8](repeating: 0, count: 20)
        if urlStream.hasBytesAvailable {
            let result :Int = urlStream.read(&buffer, maxLength: buffer.count)
            urlStream.close()
            XCTAssertEqual(.closed, urlStream.streamStatus)
            XCTAssertEqual(messageData.count, result)
            if(result > 0) {
                let output = NSString(bytes: &buffer, length: buffer.firstIndex(of: 0) ?? buffer.count, encoding: String.Encoding.utf8.rawValue)
                XCTAssertEqual(message, output!)
            }
        }
        removeTestFile(testFile)
        #endif // !SKIP
    }
    
    func test_InputStreamWithFile() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let message: NSString = "Hello, playground"
        let messageData: Data  = message.data(using: String.Encoding.utf8.rawValue)!
        guard let testFile = createTestFile("testFile_in.txt", _contents: messageData) else {
            XCTFail("Unable to create temp file")
            return
        }

        //Initialiser with file
        let fileStream: InputStream = InputStream(fileAtPath: testFile)!
        XCTAssertEqual(.notOpen, fileStream.streamStatus)
        fileStream.open()
        XCTAssertEqual(.open, fileStream.streamStatus)
        var buffer = [UInt8](repeating: 0, count: 20)
        if fileStream.hasBytesAvailable {
            let result: Int = fileStream.read(&buffer, maxLength: buffer.count)
            fileStream.close()
            XCTAssertEqual(.closed, fileStream.streamStatus)
            XCTAssertEqual(messageData.count, result)
            if(result > 0) {
                let output = NSString(bytes: &buffer, length: buffer.firstIndex(of: 0) ?? buffer.count, encoding: String.Encoding.utf8.rawValue)
                XCTAssertEqual(message, output!)
            }
        }
        removeTestFile(testFile)
        #endif // !SKIP
    }
    
    func test_InputStreamHasBytesAvailable() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let message: NSString = "Hello, playground"
        let messageData: Data  = message.data(using: String.Encoding.utf8.rawValue)!
        let stream: InputStream = InputStream(data: messageData)
        var buffer = [UInt8](repeating: 0, count: 20)
        stream.open()
        XCTAssertTrue(stream.hasBytesAvailable)
        _ = stream.read(&buffer, maxLength: buffer.count)
        XCTAssertFalse(stream.hasBytesAvailable)
        #endif // !SKIP
    }
    
    func test_InputStreamInvalidPath() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let fileStream: InputStream = InputStream(fileAtPath: NSTemporaryDirectory() + "file.txt")!
        XCTAssertEqual(.notOpen, fileStream.streamStatus)
        fileStream.open()
        XCTAssertEqual(.error, fileStream.streamStatus)
        #endif // !SKIP
    }

#if NS_FOUNDATION_ALLOWS_TESTABLE_IMPORT        // Stream.seek(to:) is an internal API method
    func test_InputStreamSeekToPosition() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras congue laoreet facilisis. Sed porta tristique orci. Fusce ut nisl dignissim, tempor tortor id, molestie neque. Nam non tincidunt mi. Integer ac diam quis leo aliquam congue et non magna. In porta mauris suscipit erat pulvinar, sed fringilla quam ornare. Nulla vulputate et ligula vitae sollicitudin. Nulla vel vehicula risus. Quisque eu urna ullamcorper, tincidunt ante vitae, aliquet sem. Suspendisse nec turpis placerat, porttitor ex vel, tristique orci. Maecenas pretium, augue non elementum imperdiet, diam ex vestibulum tortor, non ultrices ante enim iaculis ex. Fusce ut nisl dignissim, tempor tortor id, molestie neque. Nam non tincidunt mi. Integer ac diam quis leo aliquam congue et non magna. In porta mauris suscipit erat pulvinar, sed fringilla quam ornare. Nulla vulputate et ligula vitae sollicitudin. Nulla vel vehicula risus. Quisque eu urna ullamcorper, tincidunt ante vitae, aliquet sem. Suspendisse nec turpis placerat, porttitor ex vel, tristique orci. Maecenas pretium, augue non elementum imperdiet, diam ex vestibulum tortor, non ultrices ante enim iaculis ex.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras congue laoreet facilisis. Sed porta tristique orci. Fusce ut nisl dignissim, tempor tortor id, molestie neque. Nam non tincidunt mi. Integer ac diam quis leo aliquam congue et non magna. In porta mauris suscipit erat pulvinar, sed fringilla quam ornare. Nulla vulputate et ligula vitae sollicitudin. Nulla vel vehicula risus. Quisque eu urna ullamcorper, tincidunt ante vitae, aliquet sem. Suspendisse nec turpis placerat, porttitor ex vel."
        XCTAssert(str.count > 1024) // str.count must be bigger than buffersize inside InputStream.seek func.
        
        func testSubdata(_ pos: UInt64) throws -> Data? {
            guard let data = str.data(using: .utf8) else {
                XCTFail()
                return nil
            }
            
            let stream = InputStream(data: data)
            stream.open()
            
            try stream.seek(to: pos)
            let streamData = Data(reading: stream)
            
            let subdata = data[Int(pos)..<data.count]
            XCTAssertEqual(streamData, subdata)
            
            return subdata
        }
        
        var sum = 0
        for i in 0...str.count {
            do {
                sum += try testSubdata(UInt64(i))!.count
            } catch _ {
                XCTFail()
            }
        }
        
        XCTAssertEqual(((1 + str.count) * str.count)/2, sum) // Test on sum of arithmetic sequence :)
        XCTAssertEqual(try testSubdata(UInt64(str.count))!.count, 0) // It shouldbe end
        
        do {
            _ = try testSubdata(UInt64(str.count + 1)) // out of boundaries
            XCTFail()
        } catch let error as InputStream._Error {
            XCTAssertEqual(error, .cantSeekInputStream)
        } catch {
            XCTFail()
        }
        #endif // !SKIP
    }
#endif
    
    func test_outputStreamCreationToFile() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        guard let filePath = createTestFile("TestFileOut.txt", _contents: Data(capacity: 256)) else {
            XCTFail("Unable to create temp file");
            return
        }

        let outputStream = OutputStream(toFileAtPath: filePath, append: true)
        XCTAssertEqual(.notOpen, outputStream!.streamStatus)
        let myString = "Hello world!"
        let encodedData = [UInt8](myString.utf8)
        outputStream?.open()
        XCTAssertEqual(.open, outputStream!.streamStatus)
        let result: Int? = outputStream?.write(encodedData, maxLength: encodedData.count)
        outputStream?.close()
        XCTAssertEqual(myString.count, result)
        XCTAssertEqual(.closed, outputStream!.streamStatus)
        removeTestFile(filePath)
        #endif // !SKIP
    }
    
    func  test_outputStreamCreationToBuffer() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var buffer = Array<UInt8>(repeating: 0, count: 12)
        let myString = "Hello world!"
        let encodedData = [UInt8](myString.utf8)
        let outputStream = OutputStream(toBuffer: &buffer, capacity: buffer.count)
        XCTAssertEqual(.notOpen, outputStream.streamStatus)
        outputStream.open()
        XCTAssertEqual(.open, outputStream.streamStatus)
        let result: Int? = outputStream.write(encodedData, maxLength: encodedData.count)
        outputStream.close()
        XCTAssertEqual(.closed, outputStream.streamStatus)
        XCTAssertEqual(myString.count, result)
        XCTAssertEqual(NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue), NSString(string: myString))
        #endif // !SKIP
    }
    
    func test_outputStreamCreationWithUrl() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        guard let filePath = createTestFile("TestFileOut.txt", _contents: Data(capacity: 256)) else {
            XCTFail("Unable to create temp file");
            return
        }

        let outputStream = OutputStream(url: URL(fileURLWithPath: filePath), append: true)
        XCTAssertEqual(.notOpen, outputStream!.streamStatus)
        let myString = "Hello world!"
        let encodedData = [UInt8](myString.utf8)
        outputStream!.open()
        XCTAssertEqual(.open, outputStream!.streamStatus)
        let result: Int? = outputStream?.write(encodedData, maxLength: encodedData.count)
        outputStream?.close()
        XCTAssertEqual(myString.count, result)
        XCTAssertEqual(.closed, outputStream!.streamStatus)
        removeTestFile(filePath)
        #endif // !SKIP
    }
    
    func test_outputStreamCreationToMemory(){
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var buffer = Array<UInt8>(repeating: 0, count: 12)
        let myString = "Hello world!"
        let encodedData = [UInt8](myString.utf8)
        let outputStream = OutputStream.toMemory()
        XCTAssertEqual(.notOpen, outputStream.streamStatus)
        outputStream.open()
        XCTAssertEqual(.open, outputStream.streamStatus)
        let result: Int? = outputStream.write(encodedData, maxLength: encodedData.count)
        XCTAssertEqual(myString.count, result)
        //verify the data written
        let dataWritten  = outputStream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey)
        if let nsdataWritten = dataWritten as? NSData {
            nsdataWritten.getBytes(&buffer, length: result!)
            XCTAssertEqual(NSString(bytes: buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue), NSString(string: myString))
            outputStream.close()
        } else {
            XCTFail("Unable to get data from memory.")
        }
        #endif // !SKIP
    }

    func test_outputStreamHasSpaceAvailable() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var buffer = Array<UInt8>(repeating: 0, count: 12)
        let myString = "Welcome To Hello world  !"
        let encodedData = [UInt8](myString.utf8)
        let outputStream = OutputStream(toBuffer: &buffer, capacity: buffer.count)
        outputStream.open()
        XCTAssertTrue(outputStream.hasSpaceAvailable)
        _ = outputStream.write(encodedData, maxLength: encodedData.count)
        XCTAssertFalse(outputStream.hasSpaceAvailable)
        #endif // !SKIP
    }
    
    func test_ouputStreamWithInvalidPath(){
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let outputStream = OutputStream(toFileAtPath: "http:///home/sdsfsdfd", append: true)
        XCTAssertEqual(.notOpen, outputStream!.streamStatus)
        outputStream?.open()
        XCTAssertEqual(.error, outputStream!.streamStatus)
        #endif // !SKIP
    }
    
    
    private func createTestFile(_ path: String, _contents: Data) -> String? {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let tempDir = NSTemporaryDirectory() + "TestFoundation_Playground_" + NSUUID().uuidString + "/"
        do {
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: false, attributes: nil)
            if FileManager.default.createFile(atPath: tempDir + "/" + path, contents: _contents,
                                                attributes: nil) {
                return tempDir + path
            } else {
                return nil
            }
        } catch {
            return nil
        }
        #endif // !SKIP
    }
    
    private func removeTestFile(_ location: String) {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        try? FileManager.default.removeItem(atPath: location)
        #endif // !SKIP
    }
}


#endif
