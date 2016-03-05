//
//  PNCollectionViewController.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

class PNCollectionViewController: UICollectionViewController {
	
	let instagramManager = PNInstagramPhotoManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		instagramManager.getPhotosInArea({ photoObjs in
			self.collectionView!.reloadData()
		})
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(typeAsString(PNPicCellView), forIndexPath: indexPath) as! PNPicCellView
		cell.clear()
		
		let currentPhoto = instagramManager.recentPhotos[indexPath.item]
		cell.uuid = NSUUID().UUIDString
		
		let imageSetBlock = { (url: NSURL, uuid: String) in
			dispatch_async(self.instagramManager.downloadManager.downloaderDispatchQueue, { () -> Void in
				do {
					let img = try self.instagramManager.downloadManager.getImageFromURL(url)
					
					let visibleCells = collectionView.visibleCells().filter({
						return ($0 as! PNPicCellView).uuid == uuid
					})
					
					if let cell = visibleCells.first as? PNPicCellView {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							cell.imageView.image = img
							cell.setNeedsLayout()
						})
					}
				} catch _ {
				
				}
			})
		}
		
		do {
			cell.imageView.image = try self.instagramManager.downloadManager.getImageFromCache(currentPhoto.photoURL)
		} catch _ {
			imageSetBlock(currentPhoto.photoURL, cell.uuid)
		}
		
		cell.username = currentPhoto.username
		cell.distance = instagramManager.currentLocation.distanceTo(currentPhoto.location)
		
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return instagramManager.recentPhotos.count
	}
}
