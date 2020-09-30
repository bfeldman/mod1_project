# Movie collection app

An app that lets users catalog movies in their collection, or that they want to see, or whatever they want.

#### User Stories:
​
-   Users can see a list of all of their movies
-   Users have the ability to add and delete movies from their lists
-   Users are able to check the metadata of movies
-   Users can also see other users who have the same movie in their collections
-   A user can find the three highest-rated movies in their collection
-   A user can change their list's name
​
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

`ListMovie`
- list_id: integer
- movie_id: integer