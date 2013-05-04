# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Stage.create(:id => 1, :level => 1, :name => "Dining Hall", :description => "Play some casual games over dinner to learn how other prisoners may play with you.  You won't get any time added or subtracted from your sentence, but you'll get a chance to get a feel for the prison.")
Stage.create(:id => 2, :level => 2, :name => "Kitchen", :description => "You are serving soup to your fellow inmates.  You have the choice to give either the 'good' stuff, or the 'standard.'  Your cellmate is serving bread next to you - and he faces the same choices.  Remember that you will provide him with soup, and he will provide you with bread.  If you both give each other the 'good' stuff, you both stand to benefit and knock off 3 weeks from your sentence.  If you shaft him with the standard (keeping the good stuff for yourself), and he gives you the good stuff, you stand to knock off 5 weeks, while he gains 2 weeks (and vice versa if you give good, and he gives you standard).  Finally, if you both screw each other over with the standard food, nothing changes and no time is added or subtracted from your sentences.")
Stage.create(:id => 3, :level => 3, :name => "Cell", :description => "It is cleaning day - and you need to clean another inmate's toilet, and he yours.  If you both clean, the guards will be satisfied and each of you reduces your sentence by 6 weeks.  If you take advantage of him and shirk while he still cleans your toilet, you knock off 8 weeks while he gains two weeks (and vice versa if you clean and he doesn't).  If both of you shirk, the guards will not be pleased, and neither of your sentences will change.")
Stage.create(:id => 4, :level => 4, :name => "Yard", :description => "It is 5AM. Time to rebuild the wall in the yard.  You and your cellmate are responsible for rebuilding the wall. If either or both of you build, the wall will be completed - and each of you will get 6 weeks off your sentence. However, if only one person builds, while the other slacks, the wall will still get built, but the slacker will have taken advantage, getting 12 weeks off, while the honest worker will have exhausted himself and not receive any time off his sentence. Caution: if neither of you builds, no wall will be formed and each person will gain 12 weeks of jail time.")
Stage.create(:id => 5, :level => 5, :name => "Hospital", :description => "You and your cellmate are on duty.  To try and escape duty, you can try to get sent to the hospital by injuring yourself with a piece of glass.  If you do so, while your cellmate does nothing, you get to reduce your jail time by 20 weeks while your cellmate needs to do extra work - adding on 8 weeks to his sentence (and vice versa if he injures himself while you don't do anything).  If both of you do nothing, you each do half the work and thus get 12 weeks off each for good behavior.  However, if both of you try to pull the 'injure thyself' stunt, you will get caught, and no good will come out of it - your sentences are unchanged.")
Stage.create(:id => 6, :level => 6, :name => "Office", :description => "You and your accomplice are hauled into different interrogation rooms. You have the chance to either implicate your partner or stay silent. If you implicate him, while he stays silent, you will be deemed cooperative and get 16 weeks off your sentence while your partner will have 4 weeks added on.  Likewise, if you stay silent, but he implicates you, you will add 4 weeks. If you both stay silent, both of you will get 12 weeks off since the authorities cannot do much with silence. Finally, if you both implicate the other, neither of your sentences will change.")
