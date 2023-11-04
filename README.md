# recipetopia

## Setup 
1. Download Project locally
2. Open project using Xcode
3. Add your SpoonacularAPI key to Targets -> Recipetopia -> Info key: SpoonAPIKey
4. Change the Bundle ID to your liking
5. run the project

## Discussion:

Given the scope of the challenge and the 4-hour time limit, it was important not to over-architect, but at the same time, have a project you could build on.

The first layer I built was the networking and model layer. After inspecting the responses from the Spoonacular API in Postman, a little upfront domain modeling was in order. I established a protocol for the service. Using an enum with computed properties as a router helps compose the URLRequest. It is a bit verbose for just two endpoints, but it will scale well in the short term if needed.

I added sample JSON responses from the Spoonacular API into the Preview Content folder. The JSON files can be used for sample preview data or when unit testing. The `PreviewDataWrapper` is a helper to decode the JSON and pass it to any preview. The nice thing about the Preview Content folder is that it is NOT included in release builds, so it does not increase the build size.

Using MVVM and Dependency Injection, I built the UI layer. The Pages folder houses the “Parent” views, while the Views folder houses what I would call “Child” / reusable components. Search and filtering, by a few diet types, is implemented. Nutritional info is shown in the recipe detail view.

For persistence of recipes, I chose to save them on disk in JSON format. It's simple and effective. Taking advantage of the scenePhases, I can save/load the recipes at the appropriate times. Saved recipes are available offline.

Unit tests for the `RecipesViewModel` using a mock recipe service were added. Due to time constraints, I was unable to add more, but the majority of the non-UI is unit testable.


<img src="https://github.com/dominiquemiller/recipetopia/assets/14062553/02f98325-51cf-44e4-9b6e-239c4a953faa" width="150" height="300">
<img src="https://github.com/dominiquemiller/recipetopia/assets/14062553/aeb166e5-3137-475e-aa6a-b9dae2c0f38f" width="150" height="300">
<img src="https://github.com/dominiquemiller/recipetopia/assets/14062553/f5da56f0-c61d-4cf6-94de-e3224d77ffdf" width="150" height="300">
<img src="https://github.com/dominiquemiller/recipetopia/assets/14062553/05ac48ee-163c-421c-a5df-90b8b46feebf" width="150" height="300">


