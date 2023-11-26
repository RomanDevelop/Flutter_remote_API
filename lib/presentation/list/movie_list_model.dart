import 'package:flutter_application_2/data/repository/movies_repository.dart';
import 'package:flutter_application_2/domain/model/movie.dart';
import 'package:logger/logger.dart';

class MoviesListModel {
  final Logger log;
  final MoviesRepository moviesRepo;

  MoviesListModel({required this.log, required this.moviesRepo});

  Future<List<Movie>> fetchPage(int page) async {
    try {
      return await moviesRepo.getUpcomingMovies(limit: 10, page: page);
    } catch (e) {
      log.e('Error when fetching page $page', error: e);
      rethrow;
    }
  }
}
