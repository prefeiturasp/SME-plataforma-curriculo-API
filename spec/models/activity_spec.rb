require 'rails_helper'

RSpec.describe Activity, type: :model do
  include_examples 'image_concern'

  let(:subject) { build :activity }

  describe 'Associations' do
    it 'belongs to main activity_sequence' do
      should belong_to(:activity_sequence)
    end

    it 'has and belongs to many curricular components' do
      should have_and_belong_to_many(:curricular_components)
    end

    it 'has and belongs to many learning objectives' do
      should have_and_belong_to_many(:learning_objectives)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a sequence' do
        subject.sequence = nil

        expect(subject).to_not be_valid
      end

      it 'without a title' do
        subject.title = nil

        expect(subject).to_not be_valid
      end

      it 'if the title already exists' do
        subject.save
        new_object = build :activity, title: subject.title

        expect(new_object).to_not be_valid
      end

      it 'without a activity sequence' do
        subject.activity_sequence = nil

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'methods' do
    context 'sequences' do
      it 'next return valid' do
        subject.save

        expect(subject.next_sequence).to eq(subject.sequence + 1)
      end

      it 'last return valid' do
        activity_sequence = create :activity_sequence
        create_list(:activity, 3, activity_sequence: activity_sequence)
        second_activity = Activity.where(sequence: 2).last

        expect(second_activity.last_sequence).to eq(second_activity.sequence - 1)
      end

      it 'last sequence return nil if sequence <= 1' do
        subject.sequence = 1
        subject.save

        expect(subject.last_sequence).to eq(nil)
      end
    end

    context 'next activity' do
      it 'return nil if not exists' do
        subject.save

        expect(subject.next_activity).to be_nil
      end

      context 'return valid next activity' do
        it 'if status is published' do
          activity_sequence = create :activity_sequence
            create_list(:activity, 2, activity_sequence: activity_sequence, status: :published)
          activities = Activity.all

          expect(activities.first.next_activity).to eq(activities.last)
        end

        it 'skip draft status' do
          activity_sequence = create :activity_sequence
          activity_1 = create :activity, activity_sequence: activity_sequence, status: :published, sequence: 1
          activity_2 = create :activity, activity_sequence: activity_sequence, status: :draft, sequence: 2
          activity_3 = create :activity, activity_sequence: activity_sequence, status: :published, sequence: 3

          expect(activity_1.next_activity).to_not eq(activity_2)
          expect(activity_1.next_activity).to eq(activity_3)
        end
      end
    end

    context 'last activity' do
      it 'return nil if not exists' do
        activity_sequence = create :activity_sequence
        activity_test = create :activity, activity_sequence: activity_sequence
        activity_test.reload

        expect(activity_test.last_activity).to be_nil
      end

      context 'return valid last activity' do
        it 'if all status is published' do
        activity_sequence = create :activity_sequence
          create_list(:activity, 2, activity_sequence: activity_sequence, status: :published)
        activities = Activity.all

        expect(activities.last.last_activity).to eq(activities.first)
      end

        it 'skip draft activity' do
          activity_sequence = create :activity_sequence
          activity_1 = create :activity, activity_sequence: activity_sequence, status: :published, sequence: 1
          activity_2 = create :activity, activity_sequence: activity_sequence, status: :draft, sequence: 2
          activity_3 = create :activity, activity_sequence: activity_sequence, status: :published, sequence: 3

          expect(activity_3.last_activity).to eq(activity_1)
        end
      end
    end
  end
  it_behaves_like 'image_concern'
end
