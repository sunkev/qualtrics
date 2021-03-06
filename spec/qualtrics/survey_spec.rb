require 'spec_helper'

describe Qualtrics::Survey, :vcr => true  do

  it 'has a survey id' do
    survey_id = 'SV_id'
    survey = Qualtrics::Survey.new({
      id: survey_id
    })
    expect(survey.id).to eq(survey_id)
  end

  it 'has a survey name' do
    survey_name = 'Best survey for Kevin'
    survey = Qualtrics::Survey.new({
      survey_name: survey_name
    })
    expect(survey.survey_name).to eq(survey_name)
  end

  it 'has a survey status' do
    survey_status = 'Active'
    survey = Qualtrics::Survey.new({
      survey_status: survey_status
    })
    expect(survey.survey_status).to eq(survey_status)
  end

  it 'has a survey owner id and creator id' do
    survey_owner_id = 'something'
    creator_id = 'something else'

    survey = Qualtrics::Survey.new({
      survey_owner_id: survey_owner_id,
      creator_id: creator_id
    })

    expect(survey.survey_owner_id).to eq(survey_owner_id)
    expect(survey.creator_id).to eq(creator_id)
  end

  it 'has a number of responses' do
    responses = 10
    survey = Qualtrics::Survey.new({
      responses: responses
    })
    expect(survey.responses).to eq(responses)
  end

  it 'has various date attributes' do
    survey_start_date = '0000-00-00 00:00:00'
    survey_expiration_date = '2014-10-02 18:03:12'
    survey_creation_date = '2014-10-02 18:03:13'
    last_modified = '2014-10-02 18:03:14'
    last_activated = '2014-10-02 18:03:15'

    survey = Qualtrics::Survey.new({
      survey_start_date: survey_start_date,
      survey_expiration_date: survey_expiration_date,
      survey_creation_date: survey_creation_date,
      last_modified: last_modified,
      last_activated: last_activated
    })

    expect(survey.survey_start_date).to eq(survey_start_date)
    expect(survey.survey_expiration_date).to eq(survey_expiration_date)
    expect(survey.survey_creation_date).to eq(survey_creation_date)
    expect(survey.last_modified).to eq(last_modified)
    expect(survey.last_activated).to eq(last_activated)
  end

  it 'has a user first and last name' do
    user_first_name = 'I am'
    user_last_name = 'Batman'
    survey = Qualtrics::Survey.new({
      user_first_name: user_first_name,
      user_last_name: user_last_name
    })
    expect(survey.user_first_name).to eq(user_first_name)
    expect(survey.user_last_name).to eq(user_last_name)
  end

  ##TODO get qualtrics transaction to rollback survey creation

  context 'creating to qualtrics' do

    let(:survey_import) do
      survey_import = Qualtrics::SurveyImport.new({
        survey_name: 'Complex survey',
        survey_data_location: 'spec/fixtures/sample_survey.xml'
      })
    end

    let(:survey) { survey_import.survey }

    it 'destroys a survey that returns true when successful' do
      survey_import.save

      expect(survey.destroy).to be true
    end

    it 'populates the survey_id when successful' do
      survey_import.save

      expect(survey.id).to_not be_nil
      survey.destroy
    end

    it 'retrieves an array of all surveys' do
      survey_import.save

      expect(Qualtrics::Survey.all.map{|p| p.id}).to include(survey.id)
      survey.destroy
    end

    it 'can be activated or deactivated' do
      survey_import.save

      expect(survey.activate).to be true
      expect(survey.deactivate).to be true
      survey.destroy
    end
  end

end
