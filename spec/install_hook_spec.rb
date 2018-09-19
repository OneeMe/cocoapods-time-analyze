require 'fakefs/safe'

RSpec::Matchers.define :a_approximate_hash_of do |x|
  match do |actual|
    actual.all? { |k, v| (x[k] - v).abs < 0.05 }
  end
end

describe 'InstallHook' do
  let(:target_steps) { %w[prepare resolve_dependencies download_dependencies validate_targets generate_pods_project integrate_user_project perform_post_install_actions] }
  let(:installer) { Pod::Installer.new(nil, nil) }
  let(:installation_options) { double('installation_options') }
  let(:expected_detail) { target_steps.each_with_object({}) { |step, hash| hash[step.to_sym] = 0.1 } }
  let(:expected_total_time) { target_steps.count * 0.1 }
  let!(:summary_file_content) { File.read(File.expand_path('fixtures/pod-install-summary.yml', __dir__)) }
  
  before do
    allow(TimeAnalyzeConfig::PodInstall).to receive(:target_steps).and_return(target_steps)
    allow(TimeAnalyzeConfig::PodInstall).to receive(:after_all)
    allow(installer).to receive(:installation_options).and_return(installation_options)
    allow(installation_options).to receive(:integrate_targets?).and_return(true)
    allow_any_instance_of(Date).to receive(:to_s).and_return('2018-09-18')

    target_steps.each do |step|
      allow(installer).to receive("origin_#{step}") { sleep(0.1) }
    end

    FakeFS.activate!

    installer.install!
  end

  it 'call the origin step method' do
    target_steps.each do |step|
      expect(installer).to have_received("origin_#{step}".to_sym)
    end
  end

  it 'call the after_all hook in config file' do
    expect(TimeAnalyzeConfig::PodInstall).to have_received(:after_all).with(
      be_within(0.05).of(expected_total_time),
      a_approximate_hash_of(expected_detail)
    )
  end

  context 'when enable_local_summary is true' do
    it 'save summary file to root dir' do
      expect(File.read(File.join('/', PodTimeAnalyze::POD_INSTALL_SUMMARY_FILE_NAME))).to eql(summary_file_content)
    end
  end

  after do
    FakeFS.deactivate!
  end
end
