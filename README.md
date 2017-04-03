# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **13** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Added a third tab for **Upcoming** movies.
- [x] Animate overview/title section on Detailed view
- [x] Add rating and release date to movies list and detail view

## Video Walkthrough

Here's an overall walkthru:

<img src='http://imgur.com/a/ndgK1' title='Flicks Walkthrough' width='' alt='Flicks Walkthrough' />

Here's a demo with no network, then with wifi turned back on.

<img src='http://imgur.com/ZrJHeoA.gif' title='Flicks Walkthrough' width='' alt='Flicks Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

It was really tricky navigating around the closure/block syntax, especially in the network request methods because of the nestness of the code. I also ran into a bug where the search results are inaccurate of the actual detail view once you tap on a movie, it took a while to figure that I was passing the wrong data in the prepare for segue method.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.