# odk-marvel
A demonstration app for ODK Media. It has been implemented with SwiftUI and Combine. The backend server is [Marvel API](https://developer.marvel.com/) .

## Marvel API 
This application is using [Marvel Developer API](https://developer.marvel.com/) to retrieve contents. We are only using one endpoint `/v1/public/characters` for the demonstration.  Here is the [documentation](https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0) of the API.

The app need three environment variables to run correctly. They are `marvel_public_key`, `marvel_private_key`, and `marvel_base_url`. You can fetch them from you Marvel developer portal. 

You can set those three environment variables via Xcode scheme configuration. `marvel_public_key`, `marvel_private_key` are required. `marvel_base_url` is optional. We have default set in the code.

The functions related to the Marvel API are static functions inside the `MarvelAPI` struct. 

## Data Models
The main data model for the Marvel API is `MVCharacter`. It's struct mapping to the API server side objects. It's where we store the characters fetched from the Marvel server. 

Other structs like `MVDataWrapper`, `MVDataContainer`, `MVList`, `MVURI`, `MVURL`, and `MVPath` are used for decoding and storing the informations from the Marvel server. 

In additional to the data models for the Marvel API, There are also two View Models. They are `MarvelCharacterList` and `MarvelCharacterModel`. 

`MarvelCharacterList` is the environment observable object to manage the characters list. It has the responsiblity to call the Marvel API to fetch the characters from server. It also has the responsibility to store and load favorites characters. All the views can access it via the environment object. 

`MarvelCharacterModel` is the observable object to manage the detail of character. It supports to have a separate view model for the Navigation Link Row. But since the information for the row view and detail view are about the same. Only different is the resolution of the images. For simplicity, I am using same object for both row view and detail view. It will load different resolution of image base on the target view. 

## Views 

- First View is the `ContentView` which include the `TabView` for the Characters List view and Favorites View. This is the root view of the application.

- Second view is the `MarvelListView` which includes `MarvelListRowView`. This is the navigation view for the characters list 

- Third view is the `MVFavoriteView` where the favorites characters go. 

- Fourth view is the `MVDetailView` where show the detail of the characters. The image of the character has four randomized animations after the image loaded. 

## Animations 

The animations of the views navigations are using the defaults. 

Added three Geometry Effects for the animations demonstration. They are `DropEffect`, `ExpandEffect`, and `RotateEffect`. And combine those three effect, I created five randomized animations for the detail images of the characters. Those animations are happening after the image of the detail view loaded


## Others

There is a local in-memory cache `MVCache` has been implemented 

The favorites characters will be saved locally and restore on next app launching. 

There are some `UnitTests` has been implemented. Most are for the Marvel API. 


