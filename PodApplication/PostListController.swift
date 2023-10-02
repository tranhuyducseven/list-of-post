//
//  ViewController.swift
//  PodApplication
//
//  Created by rosen on 26/09/2023.
//

import UIKit
import Alamofire

class PostListController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            var contentConfiguration = cell.defaultContentConfiguration()
                contentConfiguration.text = itemIdentifier
                contentConfiguration.textProperties.color = .black
                cell.contentConfiguration = contentConfiguration
        }        
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, title: String) in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: title)
            return cell
        }
        
        fetchDataFromAPI()
        
        
        collectionView.dataSource = dataSource
    }
    
    
    
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    
    private func fetchDataFromAPI() {
        let url = "https://stock-api.f247.com/news?cate=&hot=false&offset=0&limit=30&with_content=true"
        
        AF.request(url).validate().responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                // Extract titles and update your data source
                //                let titles = posts.map { $0.title }
                //                self.updateDataSource(with: titles)
                let titlesWithUUID = posts.map { post -> String in
                    let uuid = UUID().uuidString
                    return "\(post.title) - \(uuid)"
                }
                self.updateDataSource(with: titlesWithUUID)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    
    private func updateDataSource(with titles: [String]) {
        var snapshot = Snapshot() // Assuming you have a Snapshot defined in your code
        
        // Append a section to the snapshot (you can use 0 for a single section)
        snapshot.appendSections([0])
        
        // Append items (posts) to the section
        snapshot.appendItems(titles, toSection: 0)
        
        // Apply the snapshot to your dataSource
        dataSource.apply(snapshot)
        
        // Reload the collection view to reflect the changes
        collectionView.reloadData()
    }
}

