namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    50.times do |n|
      User.all(:limit => 6).each do |user|
        googleid = "id#{n+1}"
	googleref = "ref#{n+1}"
        name = "Name#{n+1}"
        place = {:googleid => googleid,
		 :googleref => googleref,
		 :name => name}
        user.cards.create!(:comment => Faker::Lorem.sentence(5), 
			   :place_attributes => place)
      end
    end
  end
end

