part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  final List<int> ids;
  const FavoritesState({this.ids = const []});

  FavoritesState copyWith({List<int>? ids}) => FavoritesState(ids: ids ?? this.ids);

  @override
  List<Object?> get props => [ids];
}
