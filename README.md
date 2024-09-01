# RMGuideTCA

<img width="500" alt="RMGuide Logo" src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/dfc5cde1-524c-4815-82ae-bf34000cfae4">

## Table of Content
* [General Info](#general-info)
* [Technologies](#technologies-and-solutions)
* [Status](#status)
* [Requirements](#requirements)
* [Screenshots](#screenshots)
* [Preview Video](#preview-video)


## General info
Rick and Morthy guide app!  
It utilises open [Rick and Morty API](https://rickandmortyapi.com/documentation/#introduction) to display information about characters and episodes from the TV series.

## Technologies and solutions
* Swift (SwiftUI)
* Xcode 15.4
* [TCA architecture](https://github.com/pointfreeco/swift-composable-architecture)
* Async/Await for concurrency
* [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) for marking favorite characters from TCA's default implementation for AppStorage
* [NSCache](https://developer.apple.com/documentation/foundation/nscache) for caching loaded episodes info from TCA's default implementation for Cache
* TCA's default dependency injection DI implementation
* Pop-up error handling
* Custom (UIKit) sheet modal
* Native pull to refresh to get latest data from API
* Possibility to filter displayed characters by search text and/or favorites only
* Possibility to display characters in a grid or in a list
* Support for both light and dark mode


## Status
In Progress


## Requirements
Apple iPhone with iOS 16+ installed


## Screenshots

### Start

<p float="left">
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/240b44ae-1007-454f-a839-168f1b1aeaad" width="30%" />
</p>


### CharactersList

<p float="left">
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/7a0f3e4a-d4c2-4caf-a237-4a8543d1cc9f" width="30%" />
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/4638d0f0-94ff-4ecf-b230-6361ebf057d9" width="30%" />
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/9e01efe8-de80-44a5-ae12-2c567c4720c1" width="30%" />
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/71c2d629-accf-4454-bb8f-8570a658f046" width="30%" />
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/d30402d5-5402-45ed-bfe0-b393c048e78d" width="30%" />
</p>


### CharacterDetails

<p float="left">
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/88c336a6-7bce-4a0f-8e2d-551317e0ba5d" width="30%" />
</p>


### EpisodeDetails

<p float="left">
  <img src="https://github.com/ljaniszewski00/RMGuide/assets/78795431/98716680-0496-49fd-bea5-64685bed45e3" width="30%" />
</p>

   
## Preview Video 

https://github.com/ljaniszewski00/RMGuide/assets/78795431/27c1e860-1b3c-4a81-b5c8-bd8f46714581

