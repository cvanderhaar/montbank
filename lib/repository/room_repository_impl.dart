import 'dart:async';

import 'package:montbank/api/montbank_api.dart';
import 'package:montbank/models/room.dart';
import 'package:montbank/repository/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  MontbankApi _api;

  Map<int, Room> _cache = new Map();

  bool isDirty = true;

  RoomRepositoryImpl(this._api, this._cache);

  @override
  Future<Map<int, Room>> findAll() {
    if (!isDirty && _cache.isNotEmpty) {
      return new Future.value(_cache);
    }
    return _api.getRooms().then((rooms) {
      isDirty = false;
      _cache = rooms;
      return rooms;
    });
  }

  @override
  Future<Room> find(int id) {
    if (!isDirty && _cache.containsKey(id)) {
      return new Future.value(_cache[id]);
    }
    return findAll().then((rooms) {
      _cache = rooms;
      rooms[id];
    }).then((room) {
      isDirty = false;
      return room;
    });
  }
}
