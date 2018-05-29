RSpec.shared_examples_for 'image_concern' do
  let(:subject) { create(described_class.to_s.underscore.to_sym) }

  describe 'Validations' do
    context 'is valid' do
      subject 'contains image' do
        expect(subject.attached?).to eq(true)
      end
    end

    context 'is not valid' do
      it 'without a image' do
        subject.image.purge

        expect(subject).to_not be_valid
      end

      it 'if it is not the image format' do
        subject.image.purge
        subject.image.attach(
          io: File.open(Rails.root.join('spec', 'factories', 'images', 'format_test.txt')),
          filename: 'format_test.txt',
          content_type: 'text/plain'
        )

        expect(subject).to_not be_valid
      end

      it 'if image size greater than 2MB' do
        subject.image.byte_size = 4.megabytes

        expect(subject).to_not be_valid
      end
    end
  end
end
