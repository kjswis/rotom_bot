namespace :cleanup do
  namespace :carousels do

  end
  desc 'This cleans up carousels that are more than 24 hours old'
  task :recent do
  end

  desc 'Cleanup carousels since the dawn of time'
  task :all do
    carousels = Carousel.all

    carousels.each do |c|
    end
  end
end
