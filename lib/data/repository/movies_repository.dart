import 'package:flutter_application_2/data/database/dao/movies_dao.dart';
import 'package:flutter_application_2/data/database/database_mapper.dart';
import 'package:flutter_application_2/data/network/client/api_client.dart';
import 'package:flutter_application_2/data/network/network_mapper.dart';
import 'package:flutter_application_2/domain/model/movie.dart';

class MoviesRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final MoviesDao moviesDao;
  final DatabaseMapper databaseMapper;

  MoviesRepository({
    required this.apiClient,
    required this.networkMapper,
    required this.moviesDao,
    required this.databaseMapper,
  });

  Future<List<Movie>> getUpcomingMovies({
    required int limit,
    required int page,
  }) async {
    // Try to load the movies from the database
    final dbEntities =
        await moviesDao.selectAll(limit: limit, offset: (page * limit) - limit);

    if (dbEntities.isNotEmpty) {
      return databaseMapper.toMovies(dbEntities);
    }

    // Fetch movies from remote API
    final upcomingMovies =
        await apiClient.getUpcomingMovies(page: page, limit: limit);
    final movies = networkMapper.toMovies(upcomingMovies.results);

    // Save movies to database
    moviesDao.insertAll(databaseMapper.toMovieDbEntities(movies));

    return movies;
  }
}
