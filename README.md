# McGreaham_Recipes

### Summary: Include screen shots or a video of your app highlighting its features
![HomeView](https://github.com/user-attachments/assets/8f9ae6b0-c764-45c9-9972-71de07df6c1f)
![SearchResults](https://github.com/user-attachments/assets/0012b97a-37d2-431e-91c0-55057ae2afd6)
![EmptyView](https://github.com/user-attachments/assets/95083dc3-8da0-4529-b1d1-ffb6f8b939f7)
https://github.com/user-attachments/assets/0e018f94-9e84-48e5-a5bd-43cbc402d7e5

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused first on a data model and network calls that I could work against. After that, I then built the single row component then populated the main list.  After it was all working, I started refining the UI and considering additional features I wanted to add, like the search and full-recipe web view. I started with the data because that would inform what I could show in the UI. I built the smaller components (like the row) before the list because the list depended on the smaller parts being done first. Once it was all functional I could start taking holistic passes across how everything worked in its entirety to make sure things like caching and scrolling felt good.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent about six hours coding and refining, then an additional two hours looking at different approaches for unit testing Task{} blocks. I went across the app in a few iterations, so my time was spread fairly evenly across the app until the end, where I spent extra time experimenting with the UI. 

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I honestly don't think I made any trade-offs with how I implemented this project. The closest I can think of would be my observable model structure with regards to unit testing, but that is discussed more in the following question.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I think my unit tests suffered a bit due to the undecided nature of unit testing on Tasks. The way I structured my project had the observable models using tasks in functions, which meant the function itself wasn't marked as async. From the reading I did, there isn't a clearly decided-upon superior way to test these functions, so I tried several different versions before settling on what I have now. 

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I added exterior linking to the full recipes for those that had the URL, and indicated it with the link symbol on the bottom right of each row. Given the size of the project, I chose to put all unit tests in the same file for ease of reading.
