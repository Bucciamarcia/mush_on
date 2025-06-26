import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/repository.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';

class HealthProvider extends ChangeNotifier {
  final BasicLogger logger = BasicLogger();
  final _healthRepo = HealthRepository();
  MainProvider mainProvider;
  bool isLoadingHealthEvents = true;
  bool isLoadingVaccinationEvents = true;
  bool isLoadingHeatCycleEvents = true;
  List<HealthEvent> _healthEvents = [];
  List<HealthEvent> get healthEvents => _healthEvents;
  List<Vaccination> _vaccinations = [];
  List<Vaccination> get vaccinations => _vaccinations;
  List<HeatCycle> _heatCycles = [];
  List<HeatCycle> get heatCycles => _heatCycles;

  StreamSubscription<List<HealthEvent>>? _healthEventsSubscription;
  StreamSubscription<List<Vaccination>>? _vaccinationEventsSubscription;
  StreamSubscription<List<HeatCycle>>? _heatEventsSubscription;

  HealthProvider(this.mainProvider) {
    Future.microtask(() => _initHealthEvents());
    Future.microtask(() => _initVaccinationEvents());
    Future.microtask(() => _initHeatEvents());
  }

  @override
  void dispose() {
    super.dispose();
    _healthEventsSubscription?.cancel();
    _vaccinationEventsSubscription?.cancel();
    _heatEventsSubscription?.cancel();
  }

  void _initHealthEvents() async {
    await _healthEventsSubscription?.cancel();

    _healthEventsSubscription = _healthRepo
        .watchHealthEvents(account: mainProvider.account)
        .listen((events) {
      _healthEvents = events;
      isLoadingHealthEvents = false;
      notifyListeners();
    }, onError: (e, s) {
      logger.error("Failed to fetch health events in init",
          error: e, stackTrace: s);
      isLoadingHealthEvents = false;
      notifyListeners();
    });
  }

  void _initVaccinationEvents() async {
    await _vaccinationEventsSubscription?.cancel();

    _vaccinationEventsSubscription = _healthRepo
        .watchVaccinationEvents(account: mainProvider.account)
        .listen((events) {
      _vaccinations = events;
      isLoadingVaccinationEvents = false;
      notifyListeners();
    }, onError: (e, s) {
      logger.error("Failed to fetch vaccinations in init",
          error: e, stackTrace: s);
      isLoadingVaccinationEvents = false;
      notifyListeners();
    });
  }

  void _initHeatEvents() async {
    await _heatEventsSubscription?.cancel();

    _heatEventsSubscription = _healthRepo
        .watchHeatEvents(account: mainProvider.account)
        .listen((events) {
      _heatCycles = events;
      isLoadingHeatCycleEvents = false;
      notifyListeners();
    }, onError: (e, s) {
      logger.error("Failed to fetch heat cycles in init",
          error: e, stackTrace: s);
      isLoadingHeatCycleEvents = false;
      notifyListeners();
    });
  }
}
