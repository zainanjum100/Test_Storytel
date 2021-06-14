//
//  BookCell.swift
//  Test_Storytel
//
//  Created by ZainUlAbideen on 12/06/2021.
//

import UIKit
import SDWebImage
class BookCell: UITableViewCell {
    //cell identifier for registeration
    static let cellIdentifier = "BookCell"
    //update views based on viewmodel
    func configure(viewModel: BooksListViewModel) {
        //updating cell labels with text from viewmodel
        bookNameLabel.text = viewModel.bookTitle
        bookAuthorLabel.text = viewModel.authorName
        bookNarratorLabel.text = viewModel.narratorName
        //loading image with sdwebimage using progssive funstion and loading
        bookCoverImageView.sd_setImage(with: viewModel.coverUrl, placeholderImage: nil, options: [.progressiveLoad])
        bookCoverImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    // MARK: Views Closures
    //cover image
    let bookCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    //book title
    let bookNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    //book author
    let bookAuthorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    //book narrator
    let bookNarratorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    //setup views and constraints
    func layoutViews() {
        //creating stack views and labels
        let bookCoverHorizontalStackView = UIStackView()
        bookCoverHorizontalStackView.distribution = .fill
        bookCoverHorizontalStackView.axis = .horizontal
        bookCoverHorizontalStackView.spacing = 10

        addSubview(bookCoverHorizontalStackView)

        let bookTitleVerticalStackView = UIStackView()
        bookTitleVerticalStackView.distribution = .fill
        bookTitleVerticalStackView.axis = .vertical
        bookTitleVerticalStackView.spacing = 10

        addSubview(bookTitleVerticalStackView)
        
        
        bookCoverHorizontalStackView.addArrangedSubview(bookCoverImageView)
        bookCoverHorizontalStackView.addArrangedSubview(bookTitleVerticalStackView)

        bookTitleVerticalStackView.addArrangedSubview(bookNameLabel)
        bookTitleVerticalStackView.addArrangedSubview(bookAuthorLabel)
        bookTitleVerticalStackView.addArrangedSubview(bookNarratorLabel)

        //bookCoverHorizontalStackView constriants with an extension
        bookCoverHorizontalStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        //setting up book cover constrains
        NSLayoutConstraint.activate([
            bookCoverImageView.widthAnchor.constraint(equalToConstant: 80),
            bookCoverImageView.heightAnchor.constraint(equalToConstant: 80),
            ])
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setup views on init
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

