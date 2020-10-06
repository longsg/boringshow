import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:shamand/bloc/preference_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceBloc {
  final _currentPrefen =
      BehaviorSubject<PreferenceState>.seeded(PreferenceState(showWebView: true));
  final _showWebViewPref = StreamController<bool>();

  Stream<PreferenceState> get currentPref => _currentPrefen.stream;

  Sink<bool> get showWebViewPref => _showWebViewPref.sink;

//constructor cant not async
  PreferenceBloc() {
    _loadSharePrefence();
    _currentPrefen.stream.listen((bool) {
      _saveNewWebView(PreferenceState(showWebView: bool ?? true));
    });
  }

  void close() {
    _showWebViewPref.close();
    _currentPrefen.close();
  }

  Future<void> _loadSharePrefence() async {
    final sharePref = await SharedPreferences.getInstance();
    final showWebView = sharePref.getBool('showWebView') ?? true;
    _currentPrefen.add(PreferenceState(showWebView: showWebView));
  }

  Future<void> _saveNewWebView(PreferenceState preferenceState) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setBool('showWebVew', preferenceState.showWebView);
    _currentPrefen.add(preferenceState);
  }
}

class PreferenError extends Error {
  final String error;

  PreferenError({this.error});
}
