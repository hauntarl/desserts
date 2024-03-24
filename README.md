# Desserts

Take Home Exercise from **[Fetch](https://fetch.com/)**: A native iOS app that allows users to browse desserts using the [themealdb.com](https://themealdb.com/api.php) API.

<img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertsAppIcon.png">

> Developed by: [Sameer Mungole](https://www.linkedin.com/in/sameer-mungole/)
> 
> Using **XCode Version 15.3 (15E204a)**
> 
> Minimum deployment: **iOS 17.4**
> 
> Tested on **iPhone 15** (Physical device), and **iPhone 15 Pro** (Simulator).

## Previews

> <img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertsView.gif" width="150"> <img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertDetailView.gif" width="150">
> <img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertsError.gif" width="150"> <img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertDetailError.gif" width="150">

## Features

### Architecture and Design

- Utilized the [Model-view-viewmodel (MVVM)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) architecture for separation of concern.
- Followed the [Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development) paradigm to ensure robustness in the app.

### Models

- Implemented a custom decoding strategy to perform corrupt data, and null safety checks while parsing.
- Applied various transformations on the API response objects and converted them into meaningful Swift objects.
- Performed rigorous unit testing to ensure the data models gracefully handle null, and corrupt data while parsing.

### Networking

- Wrote a generic `NetworkManager` to fetch data from the [themealdb.com](https://themealdb.com/api.php) API.
- Utilized Protocol-based mocking technique to write unit tests for the `NetworkManager`.

### ViewModels

- Filtered responses that do not have meaningful values for necessary attributes such as `id, name, thumbnail`.
- Designed a generic `ViewState` enum with associated values to keep track of the current state of the API request/response. i.e. `.loading, .success, .failure`.
- Created test cases utilizing `MockNetworkManager` to cover all the edge cases for the API response.

> **NOTE:** `WelcomeView` doesn't serve any other purpose than displaying a welcome message to the user.

### Views

- `WelcomeView`
    - Used adaptive layout techniques to generate a fluid animating message at app launch.
- `DessertsView`
    - Provided a way for users to search through the dessert recipes.
    - Added pull to refresh functionality.
- `DessertsDetailView`
    - Placed segmented `PickerView` at the bottom for users to jump through different sections in the recipe.
    - Added a `Read more` button to the instruction steps for improved user experience.
    - Provided an article link for the recipe that opens via `WebView` integration.
    - Provided a YouTube link for the recipe that opens in the device's browser.
 
> **NOTE:** `WelcomeView` doesn't serve any other purpose than displaying a welcome message to the user.
 
### Components

- Created `ImageCache` component, which utilizes `NSCache` to perform in-memory image caching for the application.
- Created a custom `NetworkImage`, an alternative to `AsyncImage`, which utilizes the `ImageCache` component to cache and render images.
- Created a custom `ErrorView` component, displayed to the user if the `NetworkManager` throws an error or when the data is invalid.
 
### Animations

- Ensured that every transition throughout the app is smooth for optimal user experience.

> **NOTE:** I've purposefully kept longer animations so that the transitions occur gradually for the app review.

## Asset Catalogue

- [AppIcon, DessertsWelcomeBackground](https://www.pexels.com/photo/close-up-photo-of-dessert-on-top-of-the-jar-2638026/): Photo by *Anna Tukhfatullina* Food Photographer/Stylist.
- [DessertsBackground](https://www.pexels.com/photo/close-up-photo-of-stacked-chocolate-brownies-2373520/): Photo by *Jhon Marquez*.
- [DessertsUnavailable, RecipeUnavailable](https://undraw.co/illustrations): Illustrations from *Undraw.co* with [license](https://undraw.co/license) for free commercial use.

