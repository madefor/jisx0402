# JIS X 0402 API

JSON API for JIS X 0402, Identification code for cities, towns and villages (市区町村コード).

## Usage

This APIs is just static JSON files, so you can get them with URL below:

* All city data: http://madefor.github.io/jisx0402/api/v1/all.json
* A city data (city code with check digit: NNMMMM): http://madefor.github.io/jisx0402/api/v1/NN/MMMM.json
    * sample: http://madefor.github.io/jisx0402/api/v1/01/1002.json
* A city data (city code without check digit: NNMMM): http://madefor.github.io/jisx0402/api/v1/NN/MMM.json
    * sample: http://madefor.github.io/jisx0402/api/v1/01/100.json

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
