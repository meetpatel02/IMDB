class Movie {
  final String? title;
  final String? overview;
  final String? imagePath;
  var vote_average;
  var vote_count;
  var release_date;
  var original_language;

  Movie(
      {this.title,
      this.overview,
      this.imagePath,
      this.vote_average,
      this.vote_count,
      this.release_date,
        this.original_language,
      });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
      imagePath: json['poster_path'],
      vote_average: json['vote_average'],
      vote_count: json['vote_count'],
      release_date: json['release_date'],
      original_language: json['original_language'],
    );
  }

  String getPosterUrl() {
    return 'https://image.tmdb.org/t/p/w200$imagePath';
  }
}
