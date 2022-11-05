#!/usr/bin/python3
## SCRIPT TO POPULATE THE DATABASE WITH RANDOMLY GENERATED USERS ##

import os
import requests
import json
from random import randrange

endpoint = "http://3.250.3.51:8080/"

names =["Liam",
"Noah",
"Oliver",
"Elijah",
"James",
"William",
"Benjamin",
"Lucas",
"Henry",
"Theodore",
"Jack",
"Levi",
"Alexander",
"Jackson",
"Mateo",
"Daniel",
"Michael",
"Mason",
"Sebastian",
"Ethan",
"Logan",
"Owen",
"Samuel",
"Jacob",
"Asher",
"Aiden",
"John",
"Joseph",
"Wyatt",
"David",
"Leo",
"Luke",
"Julian",
"Hudson",
"Grayson",
"Matthew",
"Ezra",
"Gabriel",
"Carter",
"Isaac",
"Jayden",
"Luca",
"Anthony",
"Dylan",
"Lincoln",
"Thomas",
"Maverick",
"Elias",
"Josiah",
"Charles",
"Caleb",
"Christopher",
"Ezekiel",
"Miles",
"Jaxon",
"Isaiah",
"Andrew",
"Joshua",
"Nathan",
"Nolan",
"Adrian",
"Cameron",
"Santiago",
"Eli",
"Aaron",
"Ryan",
"Angel",
"Cooper",
"Waylon",
"Easton",
"Kai",
"Christian",
"Landon",
"Colton",
"Roman",
"Axel",
"Brooks",
"Jonathan",
"Robert",
"Jameson",
"Ian",
"Everett",
"Greyson",
"Wesley",
"Jeremiah",
"Hunter",
"Leonardo",
"Jordan",
"Jose",
"Bennett",
"Silas",
"Nicholas",
"Parker",
"Beau",
"Weston",
"Austin",
"Connor",
"Carson",
"Dominic",
"Xavier",
"Jaxson",
"Jace",
"Emmett",
"Adam",
"Declan",
"Rowan",
"Micah",
"Kayden",
"Gael",
"River",
"Ryder",
"Kingston",
"Damian",
"Sawyer",
"Luka",
"Evan",
"Vincent",
"Legend",
"Myles",
"Harrison",
"August",
"Bryson",
"Amir",
"Giovanni",
"Chase",
"Diego",
"Milo",
"Jasper",
"Walker",
"Jason",
"Brayden",
"Cole",
"Nathaniel",
"George",
"Lorenzo",
"Zion",
"Luis",
"Archer",
"Enzo",
"Jonah",
"Thiago",
"Theo",
"Ayden",
"Zachary",
"Calvin",
"Braxton",
"Ashton",
"Rhett",
"Atlas",
"Jude",
"Bentley",
"Carlos",
"Ryker",
"Adriel",
"Arthur",
"Ace",
"Tyler",
"Jayce",
"Max",
"Elliot",
"Graham",
"Kaiden",
"Maxwell",
"Juan",
"Dean",
"Matteo",
"Malachi",
"Ivan",
"Elliott",
"Jesus",
"Emiliano",
"Messiah",
"Gavin",
"Maddox",
"Camden",
"Hayden",
"Leon",
"Antonio",
"Justin",
"Tucker",
"Brandon",
"Kevin",
"Judah",
"Finn",
"King",
"Brody",
"Xander",
"Nicolas",
"Charlie",
"Arlo",
"Emmanuel",
"Barrett",
"Felix",
"Alex",
"Miguel",
"Abel",
"Alan",
"Beckett",
"Amari",
"Karter",
"Timothy",
"Abraham",
"Jesse",
"Zayden",
"Blake",
"Alejandro",
"Dawson",
"Tristan",
"Victor",
"Avery",
"Joel",
"Grant",
"Eric",
"Patrick",
"Peter",
"Richard",
"Edward",
"Andres",
"Emilio",
"Colt",
"Knox",
"Beckham",
"Adonis",
"Kyrie",
"Matias",
"Oscar",
"Lukas",
"Marcus",
"Hayes",
"Caden",
"Remington",
"Griffin",
"Nash",
"Israel",
"Steven",
"Holden",
"Rafael",
"Zane",
"Jeremy",
"Kash",
"Preston",
"Kyler",
"Jax",
"Jett",
"Kaleb",
"Riley",
"Simon",
"Phoenix",
"Javier",
"Bryce",
"Louis",
"Mark",
"Cash",
"Lennox",
"Paxton",
"Malakai",
"Paul",
"Kenneth",
"Nico",
"Kaden",
"Lane",
"Kairo",
"Maximus",
"Omar",
"Finley",
"Atticus",
"Crew",
"Brantley",
"Colin",
"Dallas",
"Walter",
"Brady",
"Callum",
"Ronan",
"Hendrix",
"Jorge",
"Tobias",
"Clayton",
"Emerson",
"Damien",
"Zayn",
"Malcolm",
"Kayson",
"Bodhi",
"Bryan",
"Aidan",
"Cohen",
"Brian",
"Cayden",
"Andre",
"Niko"]

separators = ['', '.', '_']

hobbies = [    
"American football",
"Airsoft",
"Archery",
"Archery tag",
"Australian football",
"Axe throwing",
"Badminton",
"Baton twirling",
"Baseball",
"Basketball",
"Beach volleyball",
"Bicycling",
"Billiards",
"Bobsledding",
"Bodybuilding",
"Bowling",
"Boxing",
"Bull riding",
"Cheer-leading",
"Chess tournaments",
"Cooking competitions",
"Color guard",
"Cricket",
"Curling",
"Cycling",
"Chess Boxing",
"Croquet",
"Dancing",
"Darts",
"Debate",
"Disc Golf",
"Dodge-ball",
"Dog Sports",
"Du-athlon",
"Falconry",
"Fantasy Sports (Football, Baseball, Basketball, etc)",
"Fencing",
"Field hockey",
"Figure skating",
"Fish tournaments",
"Flag football",
"Floor-ball",
"Golfing",
"Gymnastics",
"Hacky Sack",
"Handball",
"Horseback riding (Equestrianism)",
"Hot Air Ballooning",
"Hunting",
"Ice hockey",
"Ice fishing",
"Ice sailing",
"Inline skating",
"Javlin throwing",
"Judo",
"Jujitsu",
"Kickboxing",
"Knife throwing",
"Lacrosse",
"Laser tag",
"Lasso throwing",
"Long-boarding",
"Long jumping",
"Luge",
"Marksmanship",
"Mountain biking",
"Paintball",
"Pinochle",
"Racquetball",
"Roller Derby",
"Roller Skating",
"Rugby",
"Sailing",
"Shuffleboard",
"Skateboarding",
"Skeet Shooting",
"Skiing",
"Slingshots",
"Snowboarding",
"Soccer / Association Football",
"Speed skating",
"Squash",
"Surfing",
"Swimming",
"Table tennis (ping pong)",
"Table football",
"Taekwondo",
"Tennis",
"Triathalon",
"Ultimate Disc",
"Unicycling",
"Volleyball",
"Weight lifting",
"Wrestling",
"Yo yo-ing"
]

descriptions = ["A strong positive mental attitude will create more miracles than any wonder drug",
"I feel there should have been some recognition of the Spice Girls at this year's 25th anniversary. We flew the flag for Britain around the globe in the 1990s and we achieved a hell of a lot.",
"We had a relationship that lasted 44 years. Herbert and I lived together 10 years before we were married. He always gave me a little heart for whatever anniversary. ",
"The concept of two people living together for 25 years without a serious dispute suggests a lack of spirit only to be admired in sheep.",
"One science only will one genius fit so vast is art, so narrow human wit.",
"Art is the only way to run away without leaving home.",
"The greatest glory in living lies not in never falling, but in rising every time we fall. -Nelson Mandela",
"The way to get started is to quit talking and begin doing. -Walt Disney",
"Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma – which is living with the results of other people's thinking. -Steve Jobs",
"If life were predictable it would cease to be life, and be without flavor. -Eleanor Roosevelt",
"If you look at what you have in life, you'll always have more. If you look at what you don't have in life, you'll never have enough. -Oprah Winfrey",
"If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success. -James Cameron",
"Life is what happens when you're busy making other plans. -John Lennon",
"Spread love everywhere you go. Let no one ever come to you without leaving happier. -Mother Teresa",
"When you reach the end of your rope, tie a knot in it and hang on. -Franklin D. Roosevelt",
"Always remember that you are absolutely unique. Just like everyone else. -Margaret Mead",
"Don't judge each day by the harvest you reap but by the seeds that you plant. -Robert Louis Stevenson",
"The future belongs to those who believe in the beauty of their dreams. -Eleanor Roosevelt",
"Tell me and I forget. Teach me and I remember. Involve me and I learn. -Benjamin Franklin",
"The best and most beautiful things in the world cannot be seen or even touched — they must be felt with the heart. -Helen Keller",
"It is during our darkest moments that we must focus to see the light. -Aristotle",
"Whoever is happy will make others happy too. -Anne Frank",
"Do not go where the path may lead, go instead where there is no path and leave a trail. -Ralph Waldo Emerson",
"You will face many defeats in life, but never let yourself be defeated. -Maya Angelou",
"The greatest glory in living lies not in never falling, but in rising every time we fall. -Nelson Mandela",
"In the end, it's not the years in your life that count. It's the life in your years. -Abraham Lincoln",
"Never let the fear of striking out keep you from playing the game. -Babe Ruth",
"Life is either a daring adventure or nothing at all. -Helen Keller",
"Many of life's failures are people who did not realize how close they were to success when they gave up. -Thomas A. Edison",
"You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose. -Dr. Seuss",
"Success is not final; failure is not fatal: It is the courage to continue that counts. -Winston S. Churchill",
"Success usually comes to those who are too busy to be looking for it. -Henry David Thoreau",
"The way to get started is to quit talking and begin doing. -Walt Disney",
"If you really look closely, most overnight successes took a long time. -Steve Jobs",
"The secret of success is to do the common thing uncommonly well. -John D. Rockefeller Jr.",
"I find that the harder I work, the more luck I seem to have. -Thomas Jefferson",
"The real test is not whether you avoid this failure, because you won't. It's whether you let it harden or shame you into inaction, or whether you learn from it; whether you choose to persevere. -Barack Obama",
"You miss 100% of the shots you don't take. -Wayne Gretzky",
"Whether you think you can or you think you can't, you're right. -Henry Ford",
"I have learned over the years that when one's mind is made up, this diminishes fear. -Rosa Parks",
"I alone cannot change the world, but I can cast a stone across the water to create many ripples. -Mother Teresa",
"Nothing is impossible, the word itself says, ‘I'm possible!' -Audrey Hepburn",
"The question isn't who is going to let me; it's who is going to stop me. -Ayn Rand",
"The only person you are destined to become is the person you decide to be. -Ralph Waldo Emerson"
]

for i in range(100):
    os.system('clear')
    print(i+1)

    # REGISTER
    name1 = names[randrange(len(names))]
    separator = separators[randrange(len(separators))]
    name2 = names[randrange(len(names))]
    number = str(randrange(0, 99))
    email = name1.lower() + separator + name2.lower() + number + "@mail.com"

    payload = json.dumps({
    "mail": email,
    "password": "xxx"
    })
    headers = {
    'Content-Type': 'application/json'
    }
    response = requests.request("POST", endpoint + "register", headers=headers, data=payload)   

    headers = {
    'Content-Type': 'application/json',
    "Authorization":response.text
    }

    # IDENTITY
    day = str(randrange(1,29)).zfill(2)
    month = str(randrange(1,13)).zfill(2)
    year = str(randrange(1950, 2010))
    desc = descriptions[randrange(len(descriptions))]

    payload = json.dumps({
    "firstName": name1,    
    "description": desc,
    "dateOfBirth": year+'-'+month+'-'+day
    })
    requests.request("PUT", endpoint + "identity", headers=headers, data=payload)

    # HOBBIES
    list = []
    for j in range(randrange(len(hobbies))):
        hobby = hobbies[randrange(len(hobbies))]
        if hobby not in list:
            list.append(hobby)

    payload = json.dumps({
        'hobbies': list
    })
    requests.request("PUT", endpoint + "hobbies", headers=headers, data=payload)

    # STEPS
    payload = json.dumps({
    "identity": True,
    "gettingStarted": True
    })
    requests.request("PUT", endpoint + "steps", headers=headers, data=payload)

    # LOCATION
    posx = (randrange(-90, 90) * 10000 + randrange(10000)) / 10000
    posy = (randrange(-180, 180) * 10000 + randrange(10000)) / 10000

    payload = json.dumps({
    "posX": posx,
    'posY': posy
    })
    requests.request("PUT", endpoint + "location", headers=headers, data=payload)