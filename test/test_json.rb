require 'test/unit'
require './build.rb'

TMP_API_DIR = "tmp_api/"

class TestSample < Test::Unit::TestCase
  class << self
    def startup
    end

    def shutdown
    end
  end

  def setup
  end

  def test_build_json
    cities, ordinance_designated_cities = load_xls
    city_data = merge_data(cities, ordinance_designated_cities)
    write_json(city_data, TMP_API_DIR)

    assert_equal(File.read(File.join(API_DIR,"all.json")),
                 File.read(File.join(TMP_API_DIR,"all.json")))

    ## first item
    assert_equal(File.read(File.join(API_DIR,"01/100.json")),
                 File.read(File.join(TMP_API_DIR,"01/100.json")))
    assert_equal(File.read(File.join(API_DIR,"01/1002.json")),
                 File.read(File.join(TMP_API_DIR,"01/1002.json")))
   ### first summary item
   assert_equal(File.read(File.join(API_DIR, "01.json")),
                File.read(File.join(TMP_API_DIR, "01.json")))

    ## last item
    assert_equal(File.read(File.join(API_DIR,"47/382.json")),
                 File.read(File.join(TMP_API_DIR,"47/382.json")))
    assert_equal(File.read(File.join(API_DIR,"47/3821.json")),
                 File.read(File.join(TMP_API_DIR,"47/3821.json")))
    ### prlast summary item
    assert_equal(File.read(File.join(API_DIR, "47.json")),
                 File.read(File.join(TMP_API_DIR, "47.json")))
  end

  def teardown
    FileUtils.rm_rf(TMP_API_DIR)
  end
end
