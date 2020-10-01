# Movie collection app

An app that lets users catalog movies in their collection, or that they want to see, or whatever they want.

Created by [Brian Feldman](https://github.com/bfeldman) and [Arthur Wilton](https://github.com/artwilton)

Prerequisites
-------------

In order to use the **poster** and **trailer** features you will need to install **ImageMagick** Version 7 and **FFmpeg** compiled with the libcaca library.

### ImageMagick Installation

```sh
brew instal imagemagick
```

### FFmpeg

```sh
brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-libcaca
```

Installation
-------------

Install required gems via
```sh
bundle install
```

Acknowledgments 
-------------

To get the movie data were are utilizing:

OMDb API - <http://www.omdbapi.com/>

TMDb API - <https://www.themoviedb.org/documentation/api>

"This product uses the TMDb API but is not endorsed or certified by TMDb."
<img width="25%" src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_short-8e7b30f73a4020692ccca9c88bafe5dcb6f8a62a4c6bc55cd9ba82bb2cd95f6c.svg" />


We are also using the following gems:

ttytoolkit - <https://ttytoolkit.org/>

catpix - <https://www.rubydoc.info/github/pazdera/catpix/>

rmagick - <https://github.com/rmagick/rmagick>

launchy - <https://github.com/copiousfreetime/launchy>

***

## User Stories:
-   Users can see a list of all of their movies
-   Users have the ability to add and delete movies from their lists
-   Users are able to check the metadata of movies
-   Users can also see other users who have the same movie in their collections
-   A user can find the three highest-rated movies in their collection
-   A user can change their list's name

## Models, Associations, & Attributes:
​
#### The app has four models: `User`, `List`, `Movie`, and `ListMovie`
​
-   A `User` has one `List`
-   A `List` has many `Movie`s through `ListMovie`
-   A `Movie` belongs to many `List`s
-   A User has many `Movie`s through its `List`
-   A `Movie` belongs to many `User`s
​
***
​
`User`
- username: string
- password: string
- first_name: string
- last_name: string
​

`List`
- user_id: integer
- list_name: string

`Movie`
- title: string
- cast: string
- plot: string
- year: integer
- metascore: integer
- imdb_id: string
- director: string
- poster: string

`ListMovie`
- list_id: integer
- movie_id: integer