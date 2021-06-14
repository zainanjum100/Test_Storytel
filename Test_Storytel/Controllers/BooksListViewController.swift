//
//  ViewController.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 11/06/2021.
//

import UIKit

class BooksListViewController: UIViewController {
    
    // MARK: Constans
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let queryLabel = UILabel()
    let refreshControl = UIRefreshControl()
    // MARK: Variables
    var viewModel = BooksListViewModel()
    var isFetchingData = true
    
    // MARK: initialize TableView
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup tableview
        setupTableView()
        //setup and start loading
        setupActivityIndicator()
        // setup refresh control
        setupRefreshControl()
        //load data from backend
        loadData()
    }
    
    // MARK: Setup TableView
    func setupTableView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        //setting up constraints
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        //register bookcell class
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.cellIdentifier)
        
        
    }
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: viewModel.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default){ [weak self] _ in
            //load data on retry
            self?.loadData()
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: Setup Loading
    private func setupActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.tableView.isHidden = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshBooksList), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc private func refreshBooksList() {
        viewModel.booksList?.nextPageToken = nil
        self.loadData()
    }
    // MARK: Setup FooterView
    private func createLoadingFooterView() -> UIView {
        let footerView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 30))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.center = footerView.center
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return footerView
    }
    private func loadData() {
        //load data from backend
        DispatchQueue.main.async {
            self.viewModel.fetchBookList { success in
                if success{
                    //data loaded successfully update view
                    self.updateViews()
                }else{
                    //show error alert and retry if needed
                    self.showErrorAlert()
                }
            }
        }
    }
    // MARK: Load BooksList
    private func updateViews() {
        DispatchQueue.main.async {
            //stop pagination to load more data
            self.isFetchingData = false
            //set query label title
            self.queryLabel.text = self.viewModel.queryTitle
            //stop the loading and updating the tableview
            self.activityIndicator.stopAnimating()
            //stop refresh control
            self.refreshControl.endRefreshing()
            //updating tableview
            self.tableView.isHidden = false
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
        
    }
    
}
// MARK: TableView DataSources
extension BooksListViewController: UITableViewDataSource {
    //tableview datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.cellIdentifier, for: indexPath) as! BookCell
        //initialize viewModel with correct index path
        self.viewModel.configure(index: indexPath.row)
        //configure cell with the view model
        cell.configure(viewModel: viewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.booksList?.items.count ?? 0
    }
}
// MARK: TableView Delegates
extension BooksListViewController: UITableViewDelegate {
    //tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3))
        //adding queryLabel to headerView
        queryLabel.translatesAutoresizingMaskIntoConstraints = false
        queryLabel.font = .systemFont(ofSize: 32, weight: .regular)
        
        headerView.addSubview(queryLabel)
        //settting up constrains for querylabel
        NSLayoutConstraint.activate([
            queryLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            queryLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        //setting header view background
        headerView.backgroundColor = .systemGray2
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //adapt the header height based on device height
        return view.frame.height / 3
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //pagination conditions
        if scrollView.isEnded() && !self.isFetchingData && viewModel.booksList?.nextPageToken != nil{
            isFetchingData = true
            tableView.tableFooterView = createLoadingFooterView()
            loadData()
            
        }
    }
}

