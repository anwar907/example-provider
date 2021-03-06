/*
 * Copyright (c) 2020 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// 1
import 'package:flutter/foundation.dart';
import 'package:moolax/business_logic/models/currency.dart';
import 'package:moolax/business_logic/models/rate.dart';
import 'package:moolax/business_logic/utils/iso_data.dart';
import 'package:moolax/services/currency/currency_service.dart';
import 'package:moolax/services/service_locator.dart';

import '../models/currency.dart';
import '../models/rate.dart';
import '../utils/iso_data.dart';

// 2
class ChooseFavoritesViewModel extends ChangeNotifier {
  // 3
  final CurrencyService? _currencyService = serviceLocator<CurrencyService>();

  List<FavoritePresentation> _choices = [];
  List<Currency> _favorites = [];

  // 4
  List<FavoritePresentation> get choices => _choices;

  void loadData() async {
    // ...
    final rates = await _currencyService!.getAllExchangeRates();
    _favorites = await _currencyService!.getFavoriteCurrencies();
    _prepareChoicePresentation(rates);
    // 5
    notifyListeners();
  }

  void _prepareChoicePresentation(List<Rate> rates) {
    List<FavoritePresentation> list = [];
    for (Rate rate in rates) {
      String? code = rate.quoteCurrency;
      bool isFavorite = _getFavoritesStatus(code!);
      list.add(FavoritePresentation(
          flag: IsoData.flagOf(code),
          alphabeticCode: code,
          longName: IsoData.longNameOf(code),
          isFavorite: isFavorite));
    }
    _choices = list;
  }

  bool _getFavoritesStatus(String code) {
    for (Currency currency in _favorites) {
      if (code == currency.isoCode) return true;
    }
    return false;
  }

  void toggleFavoriteStatus(int choiceIndex) {
    // ...
    final isFavorite = _choices[choiceIndex].isFavorite;
    final code = _choices[choiceIndex].alphabeticCode;
    _choices[choiceIndex].isFavorite = isFavorite;
    if (isFavorite) {
      _addToFavorites(code);
    } else {
      _removeDromFavorite(code);
    }
    // 5
    notifyListeners();
  }

  void _addToFavorites(String? alphabeticCode) {
    _favorites.add(Currency(alphabeticCode));
    _currencyService!.saveFavoriteCurrencies(_favorites);
  }

  void _removeDromFavorite(String? alphabeticCode) {
    for (final currency in _favorites) {
      if (currency.isoCode == alphabeticCode) {
        _favorites.remove(currency);
        break;
      }
    }
    _currencyService!.saveFavoriteCurrencies(_favorites);
  }
}

class FavoritePresentation {
  final String? flag;
  final String? alphabeticCode;
  final String? longName;
  bool isFavorite;

  FavoritePresentation({
    this.flag,
    this.alphabeticCode,
    this.longName,
    required this.isFavorite,
  });
}
