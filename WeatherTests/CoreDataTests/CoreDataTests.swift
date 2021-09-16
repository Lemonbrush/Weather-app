//
//  CoreDataTests.swift
//  WeatherTests
//
//  Created by Alexander Rubtsov on 14.09.2021.
//

import XCTest
import CoreData

class CoreDataTests: XCTestCase {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: K.CoreData.modelName, withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container = NSPersistentContainer(name: K.CoreData.modelName, managedObjectModel: mom)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var sut: WeatherCoreDataManager?
    
    override func setUp() {
        super.setUp()
        let context = persistentContainer.newBackgroundContext()
        sut = WeatherCoreDataManager(managedContext: context)
        
    }
    
    func testDeleteItem() {
        // arrange
        let cityToDelete = SavedCity(name: "CityToDelete",
                                     latitude: 3,
                                     longitude: 3)
        sut?.addNewItem(cityToDelete.name,
                        lat: cityToDelete.latitude,
                        long: cityToDelete.longitude)
        // act
        sut?.deleteItem(at: 0)
        guard let result = sut?.getSavedItems else {
            XCTFail()
            return
        }
        // assert
        XCTAssertEqual(result.count, 0)
    }

    func testAddNewItem() {
        // arrange
        sut?.addNewItem("Moscow", lat: 0, long: 0)
        // act
        let result = sut?.getSavedItems
        print(result ?? "Source undefined")
        // assert
        XCTAssertNotNil(result)
    }
    
    func testGetManagedObjects() {
        // arrange
        for iterator in 0...5 {
            sut?.addNewItem("TestCity",
                            lat: Double(iterator),
                            long: Double(iterator))
        }
        // act
        guard let savedCities = sut?.getSavedItems else {
            XCTFail()
            return
        }
        // assert
        XCTAssertEqual(savedCities.count, 6)
    }
    
    func testDeleteAll() {
        // arrange
        for iterator in 0...10 {
            sut?.addNewItem("TestCity",
                            lat: Double(iterator),
                            long: Double(iterator))
        }
        // act
        sut?.deleteAll()
        guard let result = sut?.getSavedItems else {
            XCTFail()
            return
        }
        // assert
        XCTAssertEqual(result.count, 0)
    }
    
    func testRearrangeItems() {
        // arrange
        sut?.addNewItem("TestCity1", lat: 0, long: 0)
        sut?.addNewItem("TestCity2", lat: 1, long: 1)
        // act
        sut?.rearrangeItems(at: 1, to: 0)
        guard let result = sut?.getSavedItems?.first else {
            XCTFail()
            return
        }
        // assert
        XCTAssertEqual(result.latitude, 1)
    }
}
