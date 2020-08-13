import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutter_appwrite/features/settings/data/model/country.dart';
import 'package:flutter_appwrite/features/settings/data/model/currency.dart';
import 'package:flutter_appwrite/features/settings/data/model/prefs.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Country _country;
  Currency _currency;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthState>().loadSettings();
    Prefs prefs = context.read<AuthState>().prefs;
    _country = prefs?.country ?? Country(name: "Nepal", code: "NP");
    _currency = prefs?.currency ??
        Currency(code: "NPR", name: "Nepalese Rupee", symbol: "Rs.");
  }

  @override
  Widget build(BuildContext context) {
    List<Currency> currencies = context.watch<AuthState>().currencies;
    List<Country> countries = context.watch<AuthState>().countries;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (countries != null) ...[
            DropdownSearch<Country>(
              autoFocusSearchBox: true,
              onChanged: (country) {
                setState(() {
                  _country = country;
                });
              },
              compareFn: (a, b) => a.code == b.code,
              showSelectedItem: true,
              showSearchBox: true,
              selectedItem: _country,
              label: "Country",
              mode: Mode.MENU,
              items: countries,
              itemAsString: (country) => country.name,
              onFind: (q) => Future.value(
                List<Country>.from(countries)
                    .where((country) => country.name.contains(q))
                    .toList(),
              ),
            ),
          ],
          if (currencies != null) ...[
            const SizedBox(height: 20.0),
            DropdownSearch<Currency>(
              autoFocusSearchBox: true,
              onChanged: (currency) {
                setState(() {
                  _currency = currency;
                });
              },
              compareFn: (a, b) => a.code == b.code,
              showSelectedItem: true,
              showSearchBox: true,
              selectedItem: _currency,
              label: "currency",
              mode: Mode.MENU,
              items: currencies,
              itemAsString: (currency) => currency.name,
              onFind: (q) => Future.value(
                List<Currency>.from(currencies)
                    .where((currency) => currency.name.contains(q))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 10.0),
          RaisedButton(
            elevation: 0,
            child: _processing ? CircularProgressIndicator() : Text("Save"),
            onPressed: _processing
                ? () {}
                : () async {
                    setState(() {
                      _processing = true;
                    });
                    await context.read<AuthState>().updatePrefs({
                      "country": _country.toMap(),
                      "currency": _currency.toJson(),
                    });
                    setState(() {
                      _processing = false;
                    });
                  },
          )
        ],
      ),
    );
  }
}
