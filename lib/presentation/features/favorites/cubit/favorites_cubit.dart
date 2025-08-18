import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../../../core/hive/hive_setup.dart';
import '../../../../data/models/product.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  Box<Product> get _box => Hive.box<Product>(productsBoxKey);
  // Store favorite ids per-user in meta box
  Box get _meta => Hive.box(metaBoxKey);

  String _userKey(String uid) => 'favorite_ids_$uid';

  Future<void> load(String uid) async {
    final ids = List<int>.from(_meta.get(_userKey(uid)) ?? const <int>[]);
    emit(state.copyWith(ids: ids));
  }

  Future<void> toggle(String uid, Product p) async {
  final ids = <int>{...state.ids};
    if (ids.contains(p.id)) {
      ids.remove(p.id);
    } else {
      ids.add(p.id);
    }
    await _meta.put(_userKey(uid), ids.toList());
    emit(state.copyWith(ids: ids.toList()));
  }

  bool isFav(Product p) => state.ids.contains(p.id);

  List<Product> currentProducts() {
    final all = _box.values.toList(growable: false);
    return all.where((p) => state.ids.contains(p.id)).toList();
  }
}
