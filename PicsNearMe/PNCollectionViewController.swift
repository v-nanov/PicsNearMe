//
//  PNCollectionViewController.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

class PNCollectionViewController: UICollectionViewController {
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var barButton: UIBarButtonItem!
	let instagramManager = PNInstagramPhotoManager.sharedInstance
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		activityIndicator.startAnimating()
		instagramManager.getPhotosInArea({ photoObjs in
			self.activityIndicator.stopAnimating()
			self.collectionView!.reloadData()
			self.barButton.title = "\(photoObjs.count)"
		})
		
		let geo = CLGeocoder()
		let latlong = instagramManager.currentLocation
		let loc = CLLocation(latitude: latlong.latitude, longitude: latlong.longitude)
		geo.reverseGeocodeLocation(loc) { (pms: [CLPlacemark]?, e: NSError?) -> Void in
			if let pm = pms?.first,
				city = pm.locality
			{
				self.title = "\(city)"
			} else {
				self.title = "Unknown Area"
			}
		}
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(typeAsString(PNPicCellView), forIndexPath: indexPath) as! PNPicCellView
		cell.clear()
		
		let currentPhoto = instagramManager.recentPhotos[indexPath.item]
		cell.uuid = NSUUID().UUIDString
		
		let imageSetBlock = { (url: NSURL, uuid: String) in
			cell.activityIndicator.startAnimating()
			dispatch_async(self.instagramManager.downloadManager.downloaderDispatchQueue, { () -> Void in
				do {
					let img = try self.instagramManager.downloadManager.getImageFromURL(url)
					
					let visibleCells = collectionView.visibleCells().filter({
						return ($0 as! PNPicCellView).uuid == uuid
					})
					
					if let cell = visibleCells.first as? PNPicCellView {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							cell.imageView.image = img
							cell.activityIndicator.stopAnimating()
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
