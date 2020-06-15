require 'test_helper'

class ReportPdfsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get report_pdfs_index_url
    assert_response :success
  end

end
