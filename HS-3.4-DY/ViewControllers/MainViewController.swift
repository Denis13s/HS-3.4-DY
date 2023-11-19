//
//  MainViewController.swift
//  HW-3.2-DY
//
//  Created by Denis Yarets on 11/11/2023.
//

import UIKit

final class MainViewController: UICollectionViewController {
    
//    let dataService = DataService.shared
    let networkManager = NetworkManager.shared
    
    private var fruits: [Fruit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dataService.delegate = self
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let fruitAddVC = navVC.viewControllers.first as? FruitAddViewController {
                fruitAddVC.delegate = self
            }
        }
    }
    
    @IBAction func buttonPlusPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showFruitAddVC", sender: nil)
    }
    
}

// MARK: UICollectionViewDataSource
extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataService.fruits.count
        fruits.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFruit", for: indexPath) as? MainItemViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 15
        cell.label.text = fruits[indexPath.item].description
        
        return cell
    }
}

extension MainViewController: FruitAddViewControllerDelegate {
    func postFruit(title: String, family: String, genus: String) {
        let fruit = Fruit (
            name: title,
            id: Int.random(in: 0...100),
            family: family,
            order: "order",
            genus: genus,
            nutritions: Nutrition(
                calories: Utilities.randomDouble(),
                fat: Utilities.randomDouble(),
                sugar: Utilities.randomDouble(),
                carbohydrates: Utilities.randomDouble(),
                protein: Utilities.randomDouble()
            ))
        networkManager.postFruit(fruit) { [unowned self] fruit in
            self.fruits.append(fruit)
            self.collectionView.insertItems(at: [IndexPath(item: (fruits.count - 1), section: 0)])
        }
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
    
}

//// MARK: DataServiceDelegate
//extension MainViewController: DataServiceDelegate {
//    func didGetData() {
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
//}

private extension MainViewController {
    
    func fetchData() {
        guard let url = URL(string: Links.main.url) else { return }
        
//        networkManager.fetchData(type: [Fruit].self, url: url) { result in
//            switch result {
//            case .success(let fruits):
//                self.fruits = fruits
//                self.collectionView.reloadData()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        networkManager.fetchDataAFArray(type: Fruit.self, url: url) { fruits in
            let smallerAmount = 3
            if smallerAmount < fruits.count {
                for index in 0..<smallerAmount {
                    self.fruits . append(fruits[index])
                }
            } else {
                self.fruits = fruits
            }
            self.collectionView.reloadData()
        }
        
    }
    
}
