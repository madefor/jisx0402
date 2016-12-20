# JIS X 0402 API

[![Build Status](https://travis-ci.org/madefor/jisx0402.svg?branch=master)](https://travis-ci.org/madefor/jisx0402)

JSON API for JIS X 0402, Identification code for cities, towns and villages (市区町村コード).

## Usage

This APIs is just static JSON files, so you can get them with URL below:

* All city data: https://madefor.github.io/jisx0402/api/v1/all.json
* All city data in a prefecture (prefecture code: NN): https://madefor.github.io/jisx0402/api/v1/NN.json
    * sample: https://madefor.github.io/jisx0402/api/v1/01.json
* A city data (city code with check digit: NNMMMM): https://madefor.github.io/jisx0402/api/v1/NN/MMMM.json
    * sample: https://madefor.github.io/jisx0402/api/v1/01/1002.json
* A city data (city code without check digit: NNMMM): https://madefor.github.io/jisx0402/api/v1/NN/MMM.json
    * sample: https://madefor.github.io/jisx0402/api/v1/01/100.json

## API v1 details

### List all cities of all prefectures

```
GET /api/v1/all.json
```

#### Response

Response pairs of city code and information about its name. A city code is consisted with 2 digits of city code, 3 digits of city code and a check digit, in order.

```
$ curl http://madefor.github.io/jisx0402/api/v1/all.json

{
    "102016": {
        "prefecture": "群馬県",
        "city": "前橋市",
        "prefecture_kana": "グンマケン",
        "city_kana": "マエバシシ"
    },
    "102024": {
        "prefecture": "群馬県",
        "city": "高崎市",
        "prefecture_kana": "グンマケン",
        "city_kana": "タカサキシ"
    },
    ...
}
```

|key|value description|
|:--|:--|
|*prefecture*| Kanji name of prefecture the city belongs to|
|*city*|Kanji name of the city|
|*prefecture_kana*|Kana name of prefecture the city belongs to|
|*city_kana*|Kana name of the city|

### List all cities of a prefecture

```
GET /api/v1/:pref_code.json
```

#### Response

Response combined result of 2 types of city information, which key has a check digit and that has no check digits. Values are information about name of the cities.

```
$ curl http://madefor.github.io/jisx0402/api/v1/01.json

{
    "011002": {
        "prefecture": "北海道",
        "city": "札幌市",
        "prefecture_kana": "ホッカイドウ",
        "city_kana": "サッポロシ"
    },
    "01100": {
        "prefecture": "北海道",
        "city": "札幌市",
        "prefecture_kana": "ホッカイドウ",
        "city_kana": "サッポロシ"
    },
    "011011": {
        "prefecture": "北海道",
        "city": "札幌市中央区",
        "prefecture_kana": "ホッカイドウ",
        "city_kana": "サッポロシチュウオウク"
    },
    "01101": {
        "prefecture": "北海道",
        "city": "札幌市中央区",
        "prefecture_kana": "ホッカイドウ",
        "city_kana": "サッポロシチュウオウク"
    },
    ...
}
```

|key|value description|
|:--|:--|
|*prefecture*| Kanji name of prefecture the city belongs to|
|*city*|Kanji name of the city|
|*prefecture_kana*|Kana name of prefecture the city belongs to|
|*city_kana*|Kana name of the city|

### Get a city with check digit

```
GET /api/v1/:pref_code/:city_code.json
```

#### response

Response is information about name of the city.

```
$ curl http://madefor.github.io/jisx0402/api/v1/01/100.json

{
    "prefecture": "北海道",
    "city": "札幌市",
    "prefecture_kana": "ホッカイドウ",
    "city_kana": "サッポロシ",
    "code": "011002",
    "code5": "01100"
}
```

|key|value description|
|:--|:--|
|*prefecture*| Kanji name of prefecture the city belongs to|
|*city*|Kanji name of the city|
|*prefecture_kana*|Kana name of prefecture the city belongs to|
|*city_kana*|Kana name of the city|
|*code*|The city code with a check digit|
|*code5*|The city code without check digits (totally 5 digits)|

### Get a city without check digit

Get information of a city by keys without check digit.

```
GET /api/v1/:pref_code/:city_code.json
```

#### response

Response is information about name of the city.

```
$ curl http://madefor.github.io/jisx0402/api/v1/01/1002.json

{
    "prefecture": "北海道",
    "city": "札幌市",
    "prefecture_kana": "ホッカイドウ",
    "city_kana": "サッポロシ",
    "code": "011002",
    "code5": "01100"
}
```

|key|value description|
|:--|:--|
|*prefecture*| Kanji name of prefecture the city belongs to|
|*city*|Kanji name of the city|
|*prefecture_kana*|Kana name of prefecture the city belongs to|
|*city_kana*|Kana name of the city|
|*code*|The city code with a check digit|
|*code5*|The city code without check digits (totally 5 digits)|

## How to Build JSON files

This JSON files are built from an Excel file in Ministry of Internal Affairs and Communications (総務省).

Requiments: Ruby (>= 2.0)

```
$ bundle install
$ bundle exec rake
```

## License

* [CC0 1.0 Universal](LICENSE)

## Reference

* JIS X 0402:2003 To−Do−Fu−Ken (Prefecture) Identification Code (市区町村コード) http://kikakurui.com/x0/X0401-1973-01.html
* 都道府県コード及び市区町村コード (総務省 電子自治体) http://www.soumu.go.jp/denshijiti/code.html
* https://ja.wikipedia.org/wiki/%E5%85%A8%E5%9B%BD%E5%9C%B0%E6%96%B9%E5%85%AC%E5%85%B1%E5%9B%A3%E4%BD%93%E3%82%B3%E3%83%BC%E3%83%89
