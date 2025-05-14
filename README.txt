Solitaire Project
Ronan Tsoi

Programming Patterns: My code uses the flyeight pattern for handling cards and their data when they're loaded by the game. The card and stack classes also utilize states to handle player input for dragging/dropping cards.

I received feedback on this project from:
Tyler
- Held color values in global constants for readability
- Fixed style inconsistencies with spacing
- Divided up the CardClass:isCardOver conditional into multiple functions
Cal
- Style inconsistencies with spacing in main.lua
- Also wrote feedback about the isCardOver conditional
- Added more comments throughout the code
Leo
- Helper functions in StackClass:checkForMouseOver()
- Global enum variable for stackType instead of an integer
- Added comments that better explain what certain variables mean

Postmortem
The key pains of my Solitaire project definitely occurred in the very early stages when I was still figuring out how Lua/LOVE2D worked. It was definitely overwhelming at first since it felt like there were so many different types of stacks and logic that I would need in order to create a fully functional solitaire, but after I designed the fundamental structure of my object classes I found the rest of the project to be very scalable with the new features I needed to add. I'm quite proud of the logic I made with moving cards between Lua tables associated with the different stacks, it certainly also has made me warm up to the data structure as a concept since it ended up being so intuitive to work with.
Because of the flexibility I had built into the framework earlier on in the project it ended up being shockingly easy to implement later features such as moving card stacks--I only really had to adjust 3-4 lines of code for the card stacks to be moved around and rendered properly. Overall I think my refactoring efforts were worth it, I'd like to think it makes my code much more readable now.

Assets
Card backs: https://www.carstickers.com/products/stickers/card-suits-playing-cards-dice-stickers/marketplace/playing-cards-back-design-in-blue-sticker/
Card faces: https://opengameart.org/content/playing-cards-vector-png
Recycle deck pile icon: https://www.iconfinder.com/icons/5344379/arrow_looping_refresh_restart_icon
Suit pips: https://en.wikipedia.org/wiki/Playing_card
