# recipetopia

## Setup 
1. Download Project locally
2. Open project using Xcode
3. Add your SpoonacularAPI key to Targets -> Recipetopia -> Info key: SpoonAPIKey
4. Change the Bundle ID to your liking
5. run the project

## Discussion:

Given the scope of the challenge and the given time limit, its important to not over-architech, but at the same time have a project you could build on. Its all about trade offs and comprimises, much like a professional project.  

I used MVVM and Dependency Injection for speration of concerns and to allow for unit testing. For persitance of recipes saved by the user, I chose to save on disk in the JSON format. Its simple and effective. Taking advantage
of the scenePhases I can save / load the saved recipes at the appropriate times. 

For networking I first established a protocol for the service, then a enum as router to help compose the URLRequest. It is a bit verbose for just two endpoints, but it will scale well in the short term if needed.

I also added JSON files in the Preview Content folder for easy access when needed in previews or when unit testing.  Nice thing about the Preview Content folder is that it is NOT included in release builds.
