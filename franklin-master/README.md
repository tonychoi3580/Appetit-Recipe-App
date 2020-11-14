Franklin Final Project

App Idea: IOS App that allows users to maintain a catalogue of the ingredients in their fridge. Using that database of ingredients, we are also able to recommend recipes. The user will be able to add ingredients to their fridge by scanning the barcode or adding it manually. 

Feature 1: User profile
Username and password log in (should be hashed)
Maintain basic user info such as preference for maximum calories per meal 

Feature 2: Virtual Fridge
Maintain the list of ingredients that the user has and how much of it 
Add ingredients through barcode scanning or manual input
Take out ingredients manually 

Feature 3: Recipe Recommendation 
Use an external API to get a list of recipes that the user could make with the ingredients in their virtual fridge 
Sort based on User Profile’s preferences 

VIDEO LINK: 
https://duke.zoom.us/rec/share/x8BXcIGzyT9IG9bV9GOOVqwxD6imX6a8hHUX-vAMzUff7bjzJNZLXv9aW6iayAiC 

CONTRIBUTION: 
Frank Hu: I worked on wireframing the initial design of the application. I also worked on laying out the initial storyboard. Then proceeded to handle the frontend and connecting the frontend with the backend for the fridge, adding, and saved pages. I also implemented the layout used for the collectionviews. 

Jair Espino: Made the app logo and edited the launcher screen. Created the login capabilities which included a collection view displaying a user guide for individuals when launching the app. Ensured the user's inputs were valid and connected the frontend to the backend. Enabled the app to remember if the user is login or not if they decide to sign out or terminate the app. Created the layout for the recipes displayed once the API is called and made a focus launcher to display the ingredient and health labels for each item selected. Made the side menu pop up with the proper linkage to an accounts page and sign out capabilities. Linked the accounts page to the backend to allow users to change their profile as they wish.

Mark Kang: I outlined the features we will be working on for our app idea. I split up the different roles by the different features we needed to develop. I wrote up directions on how to work with git and gitlab merge requests. I was also in charge of designing the backend and the architecture of the app. I designed the database schema to fit all of the data that we will be working with. I wrote all the code to communicate with the database. I wrote all the abstraction layers as “controllers” which are the internal API that the frontend developers would use to communicate with the backend. I also wrote unit tests that would test all the controllers so that the frontend developers could check that the database was functioning correctly. I also wrote code to use a public API in order to fetch recipes given an input of ingredients. I helped the frontend developers with the backend implementation. 

Tommy Hessel: Transitioned from backend assignment to frontend work. Helped in
storyboarding the layout of the application. Worked in a local project to avoid storyboard merge conflicts and sent changes to Frank and Ulises to be implemented in the frontend. Programatically designed and tested the profile view controller. Programmatically added to and tested the focus recipe view controller. Fixed minor bugs throughout the application and reformatted several constraints. Regrettably did not contribute as much to the completion of the project as desired, but was able to find meaningful contributions.     

Yoo Bin Shin: Programmed and designed barcode scanner from AVFoundation and wrote code to fetch UPC information on scanned items from third-party API then pass data to adding view controller to handle backend. Assisted in connecting frontend to backend throughout the app. Created the initial focus recipe view controller and contributed in setting up constraints and bugs. 

Tony Choi: I worked initially on finding the right recipe API and finding out the input/output so that it fits our app. I then collected image pngs for our ingredient database and uploaded them to assets.
