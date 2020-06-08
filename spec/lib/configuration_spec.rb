require 'configuration'
describe '#CommentLine' do
  let(:subject) { Configuration::CommentLine}
  it 'will return a hash for a ruby comment' do
    expect(subject.call("# This is a valid comment")).to eq({})
  end
  it 'will return nil for an invalid comment' do
    expect(subject.call("This is an invalud comment")).to eq(nil)
  end
end

describe '#NumberLine' do
  let(:subject) { Configuration::NumberLine}
  it 'will return a formatted hash when valid' do
    expect(subject.call("valid_key=55331")).to eq({"valid_key"=>55331})
  end
  it 'will return nil for an invalid line' do
    expect(subject.call("123")).to eq(nil)
  end
end

describe '#BooleanLine' do
  let(:subject) { Configuration::BooleanLine}
  it 'will return a formatted hash when valid' do
    expect(subject.call("valid_key=true")).to eq({"valid_key"=>true})
  end
  it 'will return nil for an invalid line' do
    expect(subject.call("TRUE")).to eq(nil)
  end
end

describe '#StringLine' do
  let(:subject) { Configuration::BooleanLine}
  it 'will return nil for an invalid line' do
    expect(subject.call("TRUE")).to eq(nil)
  end
end

def normalized_results
  {"host"=>"test.com",
   "server_id"=>55331,
   "server_load_alarm"=>2.5,
   "user"=>"user",
   "verbose"=>true,
   "test_mode"=>true,
   "debug_mode"=>false,
   "log_file_path"=>"/tmp/logfile.log",
   "send_notifications"=>true}
end
