# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
    User.destroy_all
    Goal.destroy_all
    Comment.destroy_all
    
    john = User.create!(name:'John',password:'123456') 
    jim = User.create!(name:'Jim',password:'123456')
    tom = User.create!(name:'Tom',password:'123456')
    mary = User.create!(name:'Mary',password:'123456')
    emma = User.create!(name:'Emma',password:'123456')

    Comment.create!(body:"Hello Tom",commenter_id:emma.id,commentable_type:'User',commentable_id:tom.id)
    Comment.create!(body:"Hello",commenter_id:tom.id,commentable_type:'User',commentable_id:tom.id)
    Comment.create!(body:"Keep it up,you can do it",commenter_id:tom.id,commentable_type:'User',commentable_id:emma.id)
    Comment.create!(body:"Thanks",commenter_id:emma.id,commentable_type:'User',commentable_id:emma.id)
    Comment.create!(body:"John is such a bookworm",commenter_id:jim.id,commentable_type:'User',commentable_id:john.id)
    Comment.create!(body:"I want to read the Harry Potter books too at some point",commenter_id:mary.id,commentable_type:'User',commentable_id:john.id)
    Comment.create!(body:"Jim hasn\'t posted a goal in while",commenter_id:tom.id,commentable_type:'User',commentable_id:jim.id)
    Comment.create!(body:"How many books can you manage to read in a week",commenter_id:john.id,commentable_type:'User',commentable_id:mary.id)
    Comment.create!(body:"Maybe 2.3 might be pushing it",commenter_id:mary.id,commentable_type:'User',commentable_id:mary.id)
    Comment.create!(body:"He is probably busy doing other stuff",commenter_id:emma.id,commentable_type:'User',commentable_id:jim.id)
    Comment.create!(body:"I see you are into sports",commenter_id:mary.id,commentable_type:'User',commentable_id:emma.id)
    Comment.create!(body:"Do you have any sci-fi book suggestions",commenter_id:emma.id,commentable_type:'User',commentable_id:john.id)

    goal =Goal.create!(title:"Read Harry Potter and the philosopher\'s stone",user_id:john.id)
    goal =Goal.create!(title:"Read Harry Potter and the chamber of secrets",private:true,description:"Nobody needs to know",user_id: john.id)


    goal =Goal.create!(title:"Bench press 225",user_id:tom.id)

    goal =Goal.create!(title:"Read Pride and Prejudice",user_id:mary.id)
    goal =Goal.create!(title:"Read The Shadow over Innsmouth",user_id:mary.id)
    Comment.create!(body:"What a horrifying reading",commenter_id:john.id,commentable_type:'Goal',commentable_id:goal.id)

    

    goal = Goal.create!(title:"Find a job in the US",private:true,user_id:jim.id)
    goal =Goal.create!(title:"Go sightseeing in Italy",private:true,user_id:jim.id)

    goal = Goal.create!(title:"Prepare for the football tournament in winter",description: "Circle-Around-The-Cone Drill. ...,Fast Feet Drill. ... ,High-To-Low Drill. ...  ,Speed Ladder Change-Of-Direction Drill. ...  ,Single-Leg Hops. ...  ,Single-Leg Swiss Ball Squats. ...  ,Single-Leg Band Jumps.",completed: true,user_id:emma.id)
    Comment.create!(body:"How did your team do in the tournament",commenter_id:tom.id,commentable_type:'Goal',commentable_id:goal.id)
    Comment.create!(body:"Not great but we did our best...",commenter_id:emma.id,commentable_type:'Goal',commentable_id:goal.id)
    goal = Goal.create!(title:"Become better at shooting in basketball",private: true,user_id:emma.id)
end