# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :place do |place|
  place.googleid	"id100"
  place.googleref	"ref100"
  place.name		"Place100"
end

Factory.define :card do |card|
  card.comment "Foo bar"
  card.association :user
  card.association :place
end
