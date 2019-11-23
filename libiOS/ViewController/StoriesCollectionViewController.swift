

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

private let reuseIdentifier = "Cell"

class StoryCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var storyNameLabel: UILabel!
    // function that updates the views
    func updateViews(from story: Story){
        storyNameLabel.text = story.name
        if let url = URL(string: story.imageUrl){
            print(url)
            pictureImageView.af_setImage(withURL: url)
        }
    }
}

class StoriesCollectionViewController: UICollectionViewController {
    
    var stories: [Story] = []
    var currentBook = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return stories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoryCell
    
        // Configure the cell
        cell.updateViews(from: stories[indexPath.row])
        return cell
    }
    

    func updateData(){
        Alamofire.AF.request(libiOSApi.storiesListUrl).validate().responseJSON(completionHandler: {
            response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                print(json)
                self.stories = Story.buildAll(from: json["data"].arrayValue)
                self.collectionView!.reloadData()
            case .failure(let error):
                print("Response Error: \(error.localizedDescription)")
            }
        })
    }

}
