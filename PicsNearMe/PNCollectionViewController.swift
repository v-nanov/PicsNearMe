//
//  PNCollectionViewController.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

class PNCollectionViewController: UICollectionViewController {
	
	let instagramManager = PNInstagramPhotoManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		instagramManager.getPhotosInArea({ photoObjs in
			self.collectionView!.reloadData()
		})
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(typeAsString(PNPicCellView), forIndexPath: indexPath) as! PNPicCellView
		
		let currentPhoto = instagramManager.recentPhotos[indexPath.row]
		
		cell.imageView.image = UIImage(data: NSData(contentsOfURL: currentPhoto.photoURL)!) // Temp verify it works then make it load async
		cell.username = currentPhoto.username
		cell.distance = instagramManager.currentLocation.distanceTo(currentPhoto.location)
		
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return instagramManager.recentPhotos.count
	}
}
