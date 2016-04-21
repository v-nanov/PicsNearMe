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

	var section0Title = ""
	
	var instagramManager = PNInstagramPhotoManager.sharedInstance
	var downloadManager = PNDownloaderManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.collectionView!.backgroundColor = UIColor(patternImage: PNImages.travel.image)
	}
	
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
			self.section0Title = ""
			var arrLocName = [String]()
			if let pm = pms?.first {
				if let name = pm.name {
					arrLocName.append("\(name)")
				}
				if let city = pm.locality {
					arrLocName.append("\(city)")
				}
				if let country = pm.country {
					arrLocName.append("\(country)")
				}
				
				if arrLocName.isEmpty {
					self.section0Title = "Unknown Area"
				} else {
					self.section0Title = arrLocName.joinWithSeparator(", ")
				}
			}
		}
	}
	
	// MARK: - UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let currentPhoto = instagramManager.recentPhotos[indexPath.item]
		if currentPhoto.visible {
			// flag or cancel
			let alert = UIAlertController(title: "Flag Content?", message: "Do you want to flag content?  If this photo is flagged it will be hidden by default", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Flag it", style: UIAlertActionStyle.Destructive, handler: { _ in
				self.instagramManager.recentPhotos[indexPath.item].visible = false
				collectionView.reloadItemsAtIndexPaths([indexPath])
				// TODO: Submit flag request async
				let record = CKRecord.initWithFlaggedPic(withRecordID: currentPhoto.id)
				record.instagramID = currentPhoto.id
				CKContainer.defaultContainer().publicCloudDatabase.saveRecord(record as! CKRecord, completionHandler: { (record: CKRecord?, err: NSError?) in
					guard err == nil else {
						print(err)
						return
					}
				})
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		} else {
			// temporarily unflag
			let alert = UIAlertController(title: "Reveal Content?", message: "Do you want to temporarily reveal flagged content?", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Reveal it", style: UIAlertActionStyle.Destructive, handler: { _ in
				self.instagramManager.recentPhotos[indexPath.item].visible = true
				collectionView.reloadItemsAtIndexPaths([indexPath])
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(typeAsString(PNPicCellView), forIndexPath: indexPath) as! PNPicCellView
		cell.clear()
		
		let currentPhoto = instagramManager.recentPhotos[indexPath.item]
		cell.uuid = NSUUID().UUIDString
		cell.imageView.hidden = currentPhoto.visible == false
		cell.flag.text = currentPhoto.visible == false ? "⭕️" : "❌"
		let imageSetBlock = { (url: NSURL, uuid: String) in
			cell.activityIndicator.startAnimating()
			dispatch_async(self.downloadManager.downloaderDispatchQueue, { () -> Void in
				do {
					let img = try self.downloadManager.getImageFromURL(url)
					
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
			cell.imageView.image = try self.downloadManager.getImageFromCache(currentPhoto.photoURL)
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
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		var view = UICollectionReusableView()
		switch kind {
		case UICollectionElementKindSectionHeader:
			let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: typeAsString(PNCollectionViewHeader), forIndexPath: indexPath) as! PNCollectionViewHeader
			header.sectionTitle.text = self.section0Title
			view = header
		default:()
		}
		return view
	}
	
	func collectionView( collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout,  sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
	{
		if (indexPath.row % 3) == 0 {
			return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width)
		} else {
			return CGSizeMake( (collectionView.bounds.size.width/2) - 5, (collectionView.bounds.size.width/2) - 5)
		}
	}
}
