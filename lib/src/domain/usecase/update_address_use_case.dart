import 'package:propzy_home/src/domain/repository/app_repository.dart';

class UpdateDistrictUseCase {
  late final AppRepository _repository;

  UpdateDistrictUseCase(this._repository);

  void update(bool force) async {
    if (force) {
      _repository.updateDistrict();
    } else {
      final hasData = await _repository.hasDistrict();
      if (!hasData) {
        _repository.updateDistrict();
      }
    }
  }
}

class UpdateWardUseCase {
  late final AppRepository _repository;

  UpdateWardUseCase(this._repository);

  void update(bool force) async {
    if (force) {
      _repository.updateWard();
    } else {
      final hasData = await _repository.hasWard();
      if (!hasData) {
        _repository.updateWard();
      }
    }
  }
}

class UpdateStreetUseCase {
  late final AppRepository _repository;

  UpdateStreetUseCase(this._repository);

  void update(bool force) async {
    if (force) {
      _repository.updateStreet();
    } else {
      final hasData = await _repository.hasStreet();
      if (!hasData) {
        _repository.updateStreet();
      }
    }
  }
}
