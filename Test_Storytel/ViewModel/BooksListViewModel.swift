//
//  BooksListViewModel.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 12/06/2021.
//

import Foundation
import Alamofire
class BooksListViewModel: NSObject {
    
    
    // MARK: Variables
    var booksList: BooksList?
    var items = [Item]()
    var bookTitle: String?
    var authorName: String?
    var narratorName: String?
    var coverUrl: URL?
    var errorMessage: String?
    
    var queryTitle: String?{
        // setting query title
        return "Query: " + (booksList?.query ?? "")
    }
    // MARK: Configure ViewModel to get Item data
    func configure(index: Int){
        //safe unwrap bookslist
        guard let book = booksList else { return }
        self.bookTitle = book.items[index].title
        self.authorName = "by " + book.items[index].authors.map{$0.name}.joined(separator: ",")
        self.narratorName = "with " + book.items[index].narrators.map{$0.name}.joined(separator: ",")
        self.coverUrl = book.items[index].cover.url
    }
    // MARK: Fetch BooksList from backend
    func fetchBookList(completion: @escaping (Bool) -> Void) {
        //endpoint to fetch data
        var endpoint = "search?query=harry"
        //checking if there is next page token availavle or not
        if let nextPage = self.booksList?.nextPageToken{
            //appending endpoint with the next page token
            endpoint += "&page=\(nextPage)"
        }
        //calling request function from ApiService
        ApiService.instance.requestApi(BooksList.self, method: .get, url: endpoint) { result in
            switch result{
            case .success(let bookList):
                //pagination check data will bookslist will be assigned if nil
                if self.booksList == nil{
                    self.booksList = bookList
                }else{
                    //bookslist is not nil meaning there is already data available just need to append new items
                    self.booksList?.query = bookList.query
                    self.booksList?.nextPageToken = bookList.nextPageToken
                    self.booksList?.items.append(contentsOf: bookList.items)
                }
                //request result is success so sending success in completion
                completion(true)
            case .failure(let error):
                if let error = error as? ServiceError{
                    
                    print(error)
                    self.errorMessage = error.errorDescription
                    completion(false)
                    //something must be wrong with the request
                }
            }
        }
    }

}


