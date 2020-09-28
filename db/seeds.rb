User.create(first_name: "Brian", last_name: "Feldman", username: "bf", password: "1")
User.create(first_name: "Arthur", last_name: "Wilton", username: "aw", password: "2")

List.create(user_id: 1, name: "Cool Movies")

Movie.create(title: "Mission: Impossible", cast: "Tom Cruise, Jon Voight, Emmanuelle Béart, Henry Czerny", plot: "An American agent, under false suspicion of disloyalty, must discover and expose the real spy without the help of his organization.", year: 1996, metascore: 59, imdb_id: "tt0117060")
Movie.create(title: "Michael Clayton", cast: "Tom Wilkinson, George Clooney, Sydney Pollack, Tilda Swinton", plot: "A law firm brings in its \"fixer\" to remedy the situation after a lawyer has a breakdown while representing a chemical company that he knows is guilty in a multibillion-dollar class action suit.", year: 2007, metascore: 82, imdb_id: "tt0465538")

ListsMovies.create(list_id: 1, movie_id: 1)
ListsMovies.create(list_id: 1, movie_id: 2)