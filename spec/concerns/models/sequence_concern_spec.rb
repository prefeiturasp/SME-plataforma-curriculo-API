RSpec.shared_examples_for 'sequence_concern_spec' do
  describe 'update sequences' do
    context 'on create' do
      it 'replace sequence value and modify current sequence' do
        subject = create(described_class.to_s.underscore.to_sym, sequence: 1)
        new_subject = create(described_class.to_s.underscore.to_sym, sequence: 1)

        subject.reload
        new_subject.reload

        expect(subject.sequence).to be > new_subject.sequence
        expect(subject.sequence).to eq(new_subject.sequence + 1)
      end

      it 'sets as the first of the sequence if no objects exist' do
        new_subject = create(described_class.to_s.underscore.to_sym, sequence: 2)
        new_subject.reload

        expect(new_subject.reload.sequence).to eq(1)
      end
    end

    context 'on update' do
      it 'not swap value if sequence not change' do
        subject = create(described_class.to_s.underscore.to_sym, sequence: 1)
        new_subject = create(described_class.to_s.underscore.to_sym, sequence: 2)

        subject.reload
        new_subject.reload

        new_subject.sequence = 2
        new_subject.save

        expect(new_subject.reload.sequence).to eq(2)
      end
    end

    context 'on destroy' do
      it 'reorders the sequence of objects' do
        create_list(described_class.to_s.underscore.to_sym, 3)
        subject = create(described_class.to_s.underscore.to_sym, sequence: described_class.last.sequence + 1)

        subject.reload
        subject.sequence = 1
        subject.save

        expect(subject.reload.sequence).to eq(1)
        expect(described_class.order(:sequence).last.sequence).to eq(4)
      end
    end

    context 'validate sequence' do
      it 'is valid' do
        create_list(described_class.to_s.underscore.to_sym, 3)
        subject = create(described_class.to_s.underscore.to_sym, sequence: described_class.last.sequence + 1)

        expect(subject.send(:valid_sequence?)).to be true
      end

      it 'invalid' do
        # never is invalid
        create_list(described_class.to_s.underscore.to_sym, 3)

        expect(described_class.last.send(:valid_sequence?)).to be true
      end
    end
  end
end
