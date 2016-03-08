This is a Demo App that demonstrates MapKit, Deriving a location on a Map, and displaying photos around that point in a UICollectionView.

When you open this app you will be taken to the world map.  Click any region (idealy New York, New York) and a pin will drop there.  Zoom in and out to get a more specific region.  You may move the slider to change the search radius around the point you touched.  After the pin drops, the app will segue to a UICollectionView which will show you the images.

In the UICollectionView you will see Images in the area as well as the username and the distance from the point selected in the previous screen.  In the top of this screen you will see some basic information about where you have set the location pin.  If it is not on land the location will indicate an Unknown Area.

[Reflections]
  A hard coded Access Token is used.  This Access Token might expired at any time which is that event the app will no longer be able to to download images.

More information about acquiring an access token can be found here:  https://www.instagram.com/developer/authentication/

A new Access token can be generated at: http://instagram.pixelunion.net

The PNInstagramPhotoManager class caches the photos of the downloaded images in order to prevent redundant downloads.

[Limited Photos]
If you are experiencing limited Photos it may be because the client "pixelunion" is offering a client ID in SandBox Mode.  This is a mode that allows developers to test their api using something more small scale.  I have gotten plenty of photos from the New York, Los Angeles, and Paris regions.  Other regions may not offer very many photos.
