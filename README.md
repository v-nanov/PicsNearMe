This is a Demo App that demonstrates MapKit, Deriving a location on a Map, and displaying photos around that point in a UICollectionView.

When you open this app you will see a login screen to Instagram.  You can use your Instagram account or if you do not have one, you may use the one below.

Username: picsnearmedummyacct
Password: DummyAcct

The act of logging in will give the app the correct access_token which will allow the app to access the photos your account is allowed to see.

After a succesful login in ideal networking conditions you will be taken to the world map.  Click any region and a pin will drop there.  Zoom in and out to get a more specific region.  You may move the slider to change the search radius around the point you touched.  After the pin drops, the app will segue to a UICollectionView which will show you the images.

In the UICollectionView you will see Images in the area as well as the username and the distance from the point selected in the previous screen.  In the top of this screen you will see some basic information about where you have set the location pin.  If it is not on land the location will indicate an Unknown Area.

[Reflections]
  Instagram's API is quite restrictive. 

Although the simplest way to start is to get any random access_token that works with Instagram, the number of available photos is restricted.  Unlike other API like Giphy which will give you a images with a basic query, Instagram's API requires an ACCESS_TOKEN which can only be received after a successful login.  A hard coded value for the ACCESS_TOKEN could be a short term fix but would be no good in the long term since the Instagram API states that the ACCESS_TOKEN can expire at any time.  Thus it was neccessary to put in some extra work to add a login screen in order to get a fresh ACCESS_TOKEN.
  
More information about acquiring an access token can be found here:  https://www.instagram.com/developer/authentication/

The steps they provide are high level and I found success in gaining the access token by using a proxy: http://instagram.pixelunion.net

The PNInstagramPhotoManager class caches the photos of the downloaded images in order to prevent redundant downloads.

[Troubleshooting]
If you are using a simulator, your login might be blocked.  This is because by default the simulator desables http requests.  To fix this, turn it on in iOS Settings> Developer> Allow HTTP services
Then terminate the app and relaunch it.

[Limited Photos]
If you are experiencing limited Photos it may be because the client "pixelunion" is offering a client ID in SandBox Mode.  This is a mode that allows developer to test their api using something more small scale.  I have gotten plenty of photos from the New York, Los Angeles, and Paris regions
