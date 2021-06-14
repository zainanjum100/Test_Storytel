//
//  Test_StorytelTests.swift
//  Test_StorytelTests
//
//  Created by Zain Ul Abideen on 11/06/2021.
//

import XCTest
@testable import Test_Storytel

class Test_StorytelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testBookListViewModel() {
        
        let viewModel = BooksListViewModel()
        let booklist = BooksList(query: "Harry", filter: "", nextPageToken: "10", totalCount: 1500, items: [Item(id: "1", title: "Test Book", authors: [Authors(id: "1", name: "Lukas")], narrators: [Narrators(id: "1", name: "John")], cover: Cover(url: URL(string: "google.com")!, width: 600, height: 600))])
        
        viewModel.booksList = booklist
        
        viewModel.configure(index: 0)
        
        XCTAssertEqual(viewModel.queryTitle, "Query: Harry")
        
        XCTAssertEqual(viewModel.bookTitle, "Test Book")

        XCTAssertEqual(viewModel.authorName, "by Lukas")

        XCTAssertEqual(viewModel.narratorName, "with John")
        
        XCTAssertEqual(viewModel.coverUrl, URL(string: "google.com")!)

    }

}
