# XPList

Cross(X) Platform List in SwiftUI

## What is this

I ran into an issue with the regular SwiftUI.List when I was making my own collection. It basically doesn't work as far as I can tell. When using a type class that conforms to RandomAccessCollection as a datasource for List causes the app to crash whenever rows are removed from the data. Take a look at this [GIST](https://gist.github.com/jeffreybergier/0a366e173a871c1a8f3828824dbf7a54) to see a simple app that replicates the issue on macOS and iOS.

I was investigating using LazyVStack and ForEach (which does work in the GIST above) as a way to make my own "crappy" list. And then I realized that List in SwiftUI is not great to use when the code is cross platform as the macOS and iOS have such different concepts about selecting and opening data in a list. So I decided to go ahead and make XPList. It solves the crashing issue of using real list and it also solves the interaction issues by abstracting the interaction models.
