class Array
  def mean
    return if empty?
    result_sum = inject { |sum, n| sum + n }.to_f
    result_sum / size
  end
end
