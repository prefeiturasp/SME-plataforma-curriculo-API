ActiveAdmin.register ChallengeContentBlock do
  belongs_to :challenge

  permit_params :challenge_id,
                :content_block_id,
                :content

  config.filters = false

  collection_action :set_order, method: :post do
    challenge = Challenge.find_by(id: params[:challenge_id])
    challenge_content_block_ids = params[:challenge_content_block_ids].reject(&:empty?)
    challenge_content_block_ids.each.with_index(1) do |challenge_content_block_id, sequence|
      challenge_content_block = challenge.challenge_content_blocks.find_by(id: challenge_content_block_id)
      next unless challenge_content_block
      challenge_content_block.sequence = sequence
      challenge_content_block.save
    end

    render json: {}
  end

  index do
    selectable_column
    column :content_block
    actions
  end

  show do
    attributes_table do
      row :content_block
    end
  end
end
