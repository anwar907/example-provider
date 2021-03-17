import 'package:moolax/business_logic/models/rate.dart';

import '../../business_logic/models/rate.dart';
import 'web_api.dart';

class FakeWebApi implements WebApi {
  @override
  Future<List<Rate>> fetchExchangeRates() async {
    List<Rate> list = [];
    list.add(Rate(
      baseCurrency: 'USD',
      quoteCurrency: 'EUR',
      exchangeRate: 0.91,
    ));
    list.add(Rate(
      baseCurrency: 'USD',
      quoteCurrency: 'CNY',
      exchangeRate: 7.05,
    ));
    list.add(Rate(
      baseCurrency: 'USD',
      quoteCurrency: 'MNT',
      exchangeRate: 2668.37,
    ));
    list.add(
        Rate(baseCurrency: 'USD', quoteCurrency: 'IDR', exchangeRate: 14400));
    return list;
  }
}
