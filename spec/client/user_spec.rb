require 'helper'

describe GoAcoustic::Client::User do
  before do
    @client = GoAcoustic.new({access_token: "abc123",url: 'https://api-campaign-us-1.goacoustic.com'})
  end

  describe ".export_list" do
    it 'returns the job_id' do
      stub_post("/XMLAPI").
          with(:body => "<Envelope><Body><ExportList><LIST_ID>59294</LIST_ID><EXPORT_TYPE>ALL</EXPORT_TYPE><EXPORT_FORMAT>CSV</EXPORT_FORMAT></ExportList></Body></Envelope>").
          to_return(:status => 200, :body => "<Envelope><Body><RESULT><SUCCESS>TRUE</SUCCESS><JOB_ID>499600</JOB_ID><FILE_PATH>file.CSV</FILE_PATH></RESULT></Body></Envelope>", :headers => {'Content-type' => "text/xml", 'Authorization' => 'Bearer abc123'})

      resp = @client.export_list('59294', 'ALL', 'CSV')
      expect(resp.Envelope.Body.RESULT.JOB_ID).to eql "499600"
    end

    it 'returns the job_id when passing options' do
      stub_post("/XMLAPI").
          with(:body => "<Envelope><Body><ExportList><LIST_ID>59294</LIST_ID><EXPORT_TYPE>ALL</EXPORT_TYPE><EXPORT_FORMAT>CSV</EXPORT_FORMAT><ADD_TO_STORED_FILES/><DATE_START>07/25/2011 12:12:11</DATE_START><DATE_END>09/30/2011 14:14:11</DATE_END><EXPORT_COLUMNS><COLUMN>FIRST_NAME</COLUMN><COLUMN>INITIAL</COLUMN><COLUMN>LAST_NAME</COLUMN></EXPORT_COLUMNS></ExportList></Body></Envelope>").
          to_return(:status => 200, :body => "<Envelope><Body><RESULT><SUCCESS>TRUE</SUCCESS><JOB_ID>499600</JOB_ID><FILE_PATH>file.CSV</FILE_PATH></RESULT></Body></Envelope>", :headers => {'Content-type' => "text/xml", 'Authorization' => 'Bearer abc123'})

      resp = @client.export_list('59294', 'ALL', 'CSV', {ADD_TO_STORED_FILES: nil, DATE_START: "07/25/2011 12:12:11", DATE_END: "09/30/2011 14:14:11"}, ["FIRST_NAME","INITIAL","LAST_NAME"])
      expect(resp.Envelope.Body.RESULT.JOB_ID).to eql "499600"
    end
  end

  describe ".export_table" do
    it 'returns the job_id of the relational table' do
      stub_post("/XMLAPI").
        with(:body => "<Envelope><Body><ExportTable><TABLE_NAME>59294</TABLE_NAME><EXPORT_FORMAT>CSV</EXPORT_FORMAT><ADD_TO_STORED_FILES/><DATE_START>07/25/2011 12:12:11</DATE_START><DATE_END>09/30/2011 14:14:11</DATE_END></ExportTable></Body></Envelope>").
        to_return(:status => 200, :body => "<Envelope><Body><RESULT><SUCCESS>TRUE</SUCCESS><JOB_ID>499600</JOB_ID><FILE_PATH>file.CSV</FILE_PATH></RESULT></Body></Envelope>", :headers => {'Content-type' => "text/xml", 'Authorization' => 'Bearer abc123'})

      resp = @client.export_table('59294','CSV',{ADD_TO_STORED_FILES: nil,  DATE_START: "07/25/2011 12:12:11", DATE_END:"09/30/2011 14:14:11"})
      expect(resp.Envelope.Body.RESULT.JOB_ID).to eql "499600"
    end
  end
end
