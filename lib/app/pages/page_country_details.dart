import 'package:desafio_covid/app/shared/models/country.dart';
import 'package:desafio_covid/app/shared/widgets/button_return.dart';
import 'package:desafio_covid/app/shared/widgets/center_country_details.dart';
import 'package:desafio_covid/app/shared/widgets/text_labeled_value.dart';
import 'package:desafio_covid/app/shared/widgets/text_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CountryDetailsPage extends StatelessWidget {
  const CountryDetailsPage({Key key}) : super(key: key);

  Future<Country> _httpGet(String countryName) async {
    var response = await Dio().get(
        'https://disease.sh/v3/covid-19/countries/${countryName.toLowerCase()}?strict=true');

    if (response == null) return null;
    var jsonContent = response.data;
    return Country.fromJson(jsonContent);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: transformar em final e remover placeholder
    String countryName = ModalRoute.of(context).settings.arguments;

    if (countryName == null) {
      countryName = 'Brazil';
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBFBFD),
          elevation: 0.0,
          leadingWidth: 36.0,
          automaticallyImplyLeading: false,
          leading: Navigator.canPop(context) ? ReturnButton() : null,
          title: Text(
            countryName,
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xFF1E2243),
            ),
          ),
        ),
        body: FutureBuilder<Country>(
          future: _httpGet(countryName),
          builder: (_, snapshot) {
            return snapshot.hasData
                ? CountryDetails(
                    country: snapshot.data,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1E2243)),
                    ),
                  );
          },
        ));
  }
}
