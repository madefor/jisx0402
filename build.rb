require 'json'
require 'open-uri'
require 'tmpdir'
require 'fileutils'
require 'spreadsheet'
require 'nkf'

CODE_FILE_URL = "http://www.soumu.go.jp/main_content/000442937.xls"
API_DIR = "api/v1/"

def conv_katakana(str)
  NKF::nkf("--katakana -w", str)
end

def load_xls
  cities = []
  designated_cities = []

  Dir.mktmpdir do |dir|
    xls_file = File.join(dir, "code.xls")
    open(CODE_FILE_URL) do |f|
      open(xls_file, "wb") do |f2|
        content = f.read
        f2.write(content)
      end
    end
    xls = Spreadsheet.open(xls_file)
    sheet0 = xls.worksheet(0)
    sheet1 = xls.worksheet(1)
    sheet0.each{|row| cities << [row[0].to_i, row[1], row[2], conv_katakana(row[3].to_s), conv_katakana(row[4].to_s)] }
    sheet1.each{|row| designated_cities << [row[0].to_i, row[1], conv_katakana(row[2])] }
  end

  [cities, designated_cities]
end

def make_pref_table(cities)
  prefs = Hash.new
  cities.each do |row|
    code_with_checksum = row[0].to_i
    code = code_with_checksum / 10
    if code % 1000 == 0 && code != 0
      prefs[make_pref_dir(code / 1000)] = [row[1], row[3]]
    end
  end
  prefs
end

def merge_pref(designated_cities, prefs)
  rows = designated_cities.map do |row|
    code = sprintf("%06d", row[0])
    pref_name, pref_kana = prefs[code[0,2]]
    [row[0], pref_name, row[1], pref_kana, row[2]]
  end
  rows
end

def merge_data(cities, designated_cities)
  city_data = {}
  prefs = make_pref_table(cities)
  d_cities = merge_pref(designated_cities, prefs)
  (cities + d_cities).sort{|a, b| a[0] <=> b[0]}.each do |row|
    code_str = sprintf("%06d", row[0])
    next if code_str[0,5] == "00000"
    next if code_str[2,3] == "000"
    city_data[code_str] = {
      "prefecture"=>row[1],
      "city"=>row[2],
      "prefecture_kana"=>row[3],
      "city_kana"=>row[4],
    }
  end
  city_data
end

def write_json(city_data, api_dir = API_DIR)
  bulk_prepare = Hash.new{|h,k| h[k] = Hash.new}
  (1..47).each do |pref_code|
    pref_path = File.join(api_dir, make_pref_dir(pref_code))
    FileUtils.mkdir_p(pref_path)
  end
  File.open(File.join(api_dir, "all.json"), "wb") do |f|
    f.write JSON.dump(city_data)
  end
  city_data.each do |code, data|
    code35 = code[2,3]
    code36 = code[2,4]
    code05 = code[0,5]
    pref_code = code[0,2].to_i
    data_ext = data.dup
    data_ext["code"] = code
    data_ext["code5"] = code05
    pref_dir = make_pref_dir(pref_code)
    File.open(File.join(api_dir, pref_dir, code35 + ".json"), "wb") do |f|
      f.write JSON.dump(data_ext)
    end
    File.open(File.join(api_dir, pref_dir, code36 + ".json"), "wb") do |f|
      f.write JSON.dump(data_ext)
    end
    bulk_prepare[pref_dir][code] = data
    bulk_prepare[pref_dir][code05] = data
  end
  # create bulk json
  (1..47).each do |pref_code|
    pref_dir = make_pref_dir(pref_code)
    File.open(File.join(api_dir, pref_dir + ".json"), "wb") do |f|
      f.write JSON.dump(bulk_prepare[pref_dir])
    end
  end

end

def make_pref_dir(pref_code)
  sprintf("%02d", pref_code)
end

def main
  cities, ordinance_designated_cities = load_xls
  city_data = merge_data(cities, ordinance_designated_cities)
  write_json(city_data)
end

if __FILE__ == $0
  main
end
