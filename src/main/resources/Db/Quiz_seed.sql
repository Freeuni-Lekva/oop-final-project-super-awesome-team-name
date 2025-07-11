USE QuizWebsite;

## the Structure of this is as follows: Quiz followed by its questions

## Quiz 1 (Actors)
INSERT INTO quizzes(id,name,description,num_questions,random_order,one_page,immediate_correction,practice_mode,creator_username)
VALUES(1,'Actor Quiz','Can you name all the Actors?',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageurl, order_matters)
VALUES(1,1,'Name this Actor','Picture-Response',NULL,'Leonardo Dicaprio','https://th.bing.com/th/id/OIP.pwzTVSCYJB1kxwTz9-u0WgHaFj?r=0&rs=1&pid=ImgDetMain&cb=idpwebp2&o=7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(2,1,'Name this Actor','Picture-Response',NULL,'Tom Hanks','https://th.bing.com/th/id/OIP.Ww-CTR8XwfY1rhuv8lhPLQHaE7?w=220&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(3,1,'Name this Actor','Picture-Response',NULL,'Margot Robbie','https://cdn.britannica.com/32/201632-050-66971649/actress-Margot-Robbie-Australian-2018.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(4,1,'Name this Actor','Picture-Response',NULL,'Daniel Radcliffe','https://cdn.britannica.com/43/237443-050-C81087AD/Daniel-Radcliffe-2022-London-England.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(5,1,'Name this Actor','Picture-Response',NULL,'Keanu Reeves','https://cdn.britannica.com/11/215011-050-3127A07E/American-actor-Keanu-Reeves-2014.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(6,1,'Name this Actor','Picture-Response',NULL,'Ryan Reynolds','https://cdn.britannica.com/85/205685-050-24677990/Ryan-Reynolds-2011.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(7,1,'Name this Actor','Picture-Response',NULL,'Ryan Gosling','https://cdn.britannica.com/93/215393-050-E428CADE/Canadian-actor-musician-Ryan-Gosling-2016.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(8,1,'Name this Actor','Picture-Response',NULL,'Robert De Niro','https://cdn.britannica.com/00/213300-050-ADF31CD9/American-actor-Robert-De-Niro-2019.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(9,1,'Name this Actor','Picture-Response',NULL,'Scarlett Johansson','https://cdn.britannica.com/59/182359-050-C6F38CA3/Scarlett-Johansson-Natasha-Romanoff-Avengers-Age-of.jpg?w=300',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(10,1,'Name this Actor','Picture-Response',NULL,'Jennifer Aniston','https://cdn.britannica.com/46/242146-050-B3385913/Jennifer-Aniston-Golden-Globes-2020.jpg?w=300',NULL);


## Quiz 2 (Marvel)
INSERT INTO quizzes(id,name,description,num_questions,random_order,one_page,immediate_correction,practice_mode,creator_username)
VALUES(2,'Marvel Quiz','If you are a TRUE marvel fan this will be easy',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(11,2,'Who played Spider-man in "The Amazing Spider-man" movies?','Multiple Choice','Tom Holland,Tobey Maguire,Dave Bautista,Andrew Garfield','Andrew Garfield',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(12,2,'Who cut Thanos'' head off?','Question-Response',NULL,'Thor',NULL,NULL);

INSERT INTO questions (id, quiz_id, question_text, question_type,possible_answers ,correct_answer, imageURL, order_matters )
VALUES(13, 2, 'Who is the leader of the Avengers?', 'Question-Response', NULL,'Captain America',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(14,2,'Tony Stark is also known as _ _.','Fill in the Blank',NULL,'Iron Man',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(15,2,'What is the name of Thor’s hammer?','Multiple Choice','Mjolnir,Stormbreaker,Gungnir,Dave','Mjolnir',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(16,2,'Identify this Marvel character from the image below','Picture-Response',NULL,'Spider-Man','https://th.bing.com/th/id/OIP.8YZK3A06HkAm8DatkDSQwQHaHa?w=212&h=204&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(17,2,'Name all original members of the Guardians of the Galaxy','Multi-Answer',NULL,'Star-Lord,Gamora,Drax,Rocket,Groot',NULL,0);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(18,2,'Which of the following characters were in Avengers: Endgame?','Multiple Choice with Multiple Answers','Deadpool,Wolverine,Ant-Man,Captain America','Ant-Man,Captain America',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(19,2,'Match each Marvel hero to their real name','Matching','Iron Man=T''Challa;Spider-Man=Tony Stark;Black Panther=Peter Parker','Iron Man=Tony Stark;Spider-Man=Peter Parker;Black Panther=T''Challa',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(20,2,'The super-soldier serum was used to enhance _ _ into Captain America.','Fill in the Blank',NULL,'Steve Rogers',NULL,NULL);



## Quiz 3 (football)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(3,'Football Quiz','Fan of Football? try this!',10,1,1,0,0,'Admin');

INSERT INTO questions (id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(21,3 ,'Who won the FIFA World Cup in 2018?', 'Question-Response', NULL,'France',NULL,NULL);

INSERT INTO questions (id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(22,3 ,'The legendary footballer Lionel _ has won multiple Ballon d''Or awards.', 'Fill in the Blank',NULL ,'Messi',NULL,NULL);

INSERT INTO questions (id,quiz_id, question_text, question_type, possible_answers, correct_answer)
VALUES(23,3,'Which country has won the most FIFA World Cups?','Multiple Choice','Brazil,Germany,Italy,Argentina','Brazil');

INSERT INTO questions (id,quiz_id, question_text, question_type, imageURL, correct_answer)
VALUES(24,3,'Identify the player in the image.','Picture-Response','https://th.bing.com/th/id/OIP.eupohIiFL08KNRcol8X6vwHaDt?w=329&h=174&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3','Cristiano Ronaldo');

INSERT INTO questions (id,quiz_id, question_text, question_type, correct_answer, order_matters)
VALUES(25,3,'Name three countries that have hosted the FIFA World Cup latest.','Multi-Answer','Qatar,Russia,Brazil',false);

INSERT INTO questions (id,quiz_id, question_text, question_type, possible_answers, correct_answer)
VALUES(26,3,'Which of the following players have played for Real Madrid? (Select all that apply)','Multiple Choice with Multiple Answers',
       'Kylian Mbappe,Cristiano Ronaldo,Luka Modric,Ronaldinho','Kylian Mbappe,Cristiano Ronaldo,Luka Modric');

INSERT INTO questions (id,quiz_id, question_text, question_type, correct_answer)
VALUES(27,3,'Match the footballers to their national teams.','Matching','Lionel Messi=Argentina;Harry Kane=England;Neymar=Brazil;Luka Modric=Croatia');

INSERT INTO questions (id,quiz_id, question_text, question_type, correct_answer)
VALUES(28,3,'The football club Manchester United plays its home games at _ _.','Fill in the Blank','Old Trafford');

INSERT INTO questions (id,quiz_id, question_text, question_type, correct_answer)
VALUES(29,3,'Who is the all-time top scorer in the UEFA Champions League?','Question-Response','Cristiano Ronaldo');

INSERT INTO questions (id,quiz_id, question_text, question_type, possible_answers, correct_answer)
VALUES(30,3,'Which team won the UEFA Champions League in 2023?','Multiple Choice','Manchester City,Real Madrid,Bayern Munich,PSG','Manchester City');




## Quiz 4 (Music)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(4,'Music Quiz','Like listening to Music? Try  out this Quiz!',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(31,4,'Who was in paris?','Question-Response',NULL,'Niggas',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(32,4,'Who is known as the "Queen of Pop"?','Multiple Choice','Britney Spears,Madonna,Beyoncé,Lady Gaga','Madonna',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(33,4,'The Beatles'' iconic album is called Sgt. Pepper''s Lonely _ Club Band.','Fill in the Blank',NULL,'Hearts',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(34,4,'Which of the following artists have headlined the Super Bowl halftime show?','Multiple Choice with Multiple Answers','Rihanna,Bruno Mars,Billie Eilish,Katy Perry','Rihanna,Bruno Mars,Katy Perry',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(35,4,'Name this singer','Picture-Response',NULL,'Taylor Swift','https://th.bing.com/th/id/OIP.Ha68ba6j0TIZoW_kATrZPQHaD4?w=339&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(36,4,'Match the artist to their genre','Matching','Kendrick Lamar=Pop;Metallica=Electronic;Taylor Swift=Heavy Metal;Daft Punk=Hip Hop','Kendrick Lamar=Hip Hop;Metallica=Heavy Metal;Taylor Swift=Pop;Daft Punk=Electronic',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(37,4,'Name all members of the band Queen','Multi-Answer',NULL,'Freddie Mercury,Brian May,Roger Taylor,John Deacon',NULL,0);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(38,4,'What instrument does Yo-Yo Ma play?','Question-Response',NULL,'Cello',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(39,4,'Which of these artists performed at Coachella 2024?','Multiple Choice with Multiple Answers','Lana Del Rey,Ice Spice,Travis Scott,Dua Lipa','Lana Del Rey,Ice Spice,Travis Scott',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(40,4,'Match each artist to their 2023–2025 hit','Matching','Olivia Rodrigo=Lunch;Ice Spice=Deli;SZA=Vampire;Billie Eilish=Kill Bill','Olivia Rodrigo=Vampire;Ice Spice=Deli;SZA=Kill Bill;Billie Eilish=Lunch',NULL,NULL);



## Quiz 5 (Films)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(5,'Films Quiz','Like watching Films? see if you can get them all correct',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(41,5,'In The Film "Hangover" Tiger belongs to the Actor _','Fill in the Blank',NULL,'Mike Tyson',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(42,5,'Which movie is NOT directed by Quentin Tarantino?','Multiple Choice','Pulp Fiction,Django Unchained,Kill Bill,Fight Club','Fight Club',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(43,5,'What movie is this character from?','Picture-Response',NULL,'Joker','https://th.bing.com/th/id/OIP.NZ0gXccY-Aq4UODLsr1TKQHaEK?w=333&h=187&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(44,5,'Which movie features the quote "I''m the king of the world!"?','Multiple Choice','Titanic,Gladiator,The Wolf of Wall Street,Braveheart','Titanic',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(45,5,'The main character in The Matrix is known as _','Fill in the Blank',NULL,'Neo',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(46,5,'What movie won the Best Picture Oscar in 2023?','Question-Response',NULL,'Everything Everywhere All at Once',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(47,5,'Which of these are Pixar films?','Multiple Choice with Multiple Answers','The Lion King,Shrek,Toy Story,Madagascar','Toy Story',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(48,5,'Which actor played Batman in The Dark Knight trilogy?','Question-Response',NULL,'Christian Bale',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(49,5,'In Forrest Gump, life is like a box of _','Fill in the Blank',NULL,'chocolates',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(50,5,'Match the actor with their iconic role','Matching','Leonardo DiCaprio=Terminator;Tom Hanks=John Wick;Keanu Reeves=Jack Dawson;Arnold Schwarzenegger=Forrest Gump','Leonardo DiCaprio=Jack Dawson;Tom Hanks=Forrest Gump;Keanu Reeves=John Wick;Arnold Schwarzenegger=Terminator',NULL,NULL);



## Quiz 6 (Video Games)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(6,'Video game Quiz','Quiz for True gamers',15,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(51,6,'From Which game Franchise is "Handsome Jack" ?','Multiple Choice',
       'Far Cry,Deus Ex,Borderlands','Borderlands',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(52,6,'Hideo Kojima is know for','Multiple Choice with Multiple Answers',
       'Borderlands,Undertale,Metal Gear,Silent Hill','Metal Gear,Silent Hill',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(53,6,'Name this Villain','Picture-Response',NULL,'Pagan Min','https://th.bing.com/th/id/OIP.p7cdNVv52aE3xwr62oEhnQHaEK?w=331&h=187&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

Insert Into questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(54,6,'Who is the main protagonist in the game series “God of War”?','Question-Response',NULL,'Kratos',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
    VALUE(55,6,'Name all the playable Characters in GTA 5','Multi-Answer',NULL,'Trevor Philips,Michael De Santa,Franklin Clinton',NULL,0);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(56,6,'Would you _ ...','Fill in the Blank',NULL,'Kindly',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(57,6,'Who was the DJ that first performed in fortnite','Question-Response',NULL,'Marshmello',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(58,6,'Which of these are MOBA games?','Multiple Choice with Multiple Answers','CS:GO,Dota 2,League of Legends,Overwatch','Dota 2,League of Legends',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(59,6,'To officially beat game "Minecraft" you have to defeat','Multiple Choice','Wither,Ender Dragon,Jack Black,Warden','Ender Dragon',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(60,6,'Wolfenstein:The New _','Fill in the Blank',NULL,'Order',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(61,6,'Match the game to its developer','Matching','Halo=CD Projekt red;God of War=Blizzard;The Witcher 3=343 Games;Overwatch=Santa Monica Studio','Halo=343 Games;God of War=Santa Monica Studio;The Witcher 3=CD Prokect Red;Overwatch=Blizzard',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(62,6,'Guess the Game by the Logo','Picture-Response',NULL,'Half-Life','https://th.bing.com/th/id/OIP.Jiqm0OJcMXdXpwpc3JkUGgHaEK?w=160&h=104&c=7&bgcl=69def8&r=0&o=6&cb=iavawebpc1&dpr=1.3&pid=13.1',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(63,6,'"Fromsoftware" is know for their hardcore games, out of these games which are not developed by them?','Multiple Choice with Multiple Answers','Dark Souls,Bloodborne,Elden Ring,Nioh','Bloodborne,Nioh',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(64,6,'The main antagonist in the Portal series is a rogue AI named _','Fill in the Blank',NULL,'GLaDOS',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(65,6,'Match the Protagonists to the Games','Matching','Lara Croft=Uncharted;Nathan Drake=Halo;Arthur Morgan=Tomb Raider;Master Chief=Red Dead Redemption 2','Lara Croft=Tomb Raider;Nathan Drake=Uncharted;Arthur Morgan=Red Dead Redemption;Master Chief=Halo',NULL,NULL);


## Quiz 7 (The Matching Quiz)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(7,'The Matching Quiz','can you match all the pairs correctly?',5,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(66,7,'Match the Game to Their Developer','Matching','The Legend of Zelda=CD Projekt Red;Fortnite=Obsidian Entertainment;Cyberpunk=Epic Games;Fallout: New Vegas=Nintendo','The Legend of Zelda=Nintendo;Fortnite=Epic Games;Cyberpunk=CD Projekt Red;Fallout: New Vegas=Obsidian Entertainment',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(67,7,'Match each artist to one of their famous songs','Matching','Taylor Swift=God''s Plan;The Weekend=Shake It Off;Ed Sheeran=Blinding Lights;Billie Eilish=Bad Guy;Drake=Shape of You','Taylor Swift=Shake It Off;The Weeknd=Blinding Lights;Ed Sheeran=Shape of You;Billie Eilish=Bad Guy;Drake=God''s Plan',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(68,7,'Match the Movie to Its Director','Matching','Inception=James Cameron;Pulp Fiction=Martin Scorsese;Titanic=Quentin Tarantino;Parasite=Bong Joon-ho;The Irishman=Christopher Nolan','Inception=Christopher Nolan;Pulp Fiction=Quentin Tarantino;Titanic=James Cameron;Parasite=Bong Joon-ho;The Irishman=Martin Scorsese',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(69,7,'Match the App to Its Main Function','Matching','Spotify=Team Communication;TikTok=Productivity;Slack=Music Streaming;Notion=Photo Sharing;Instagram=Short Videos
','Spotify=Music Streaming;TikTok=Short Videos;Slack=Team Communication;Notion=Productivity;Instagram=Photo Sharing',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(70,7,'Match the Gaming Console to Its Manufacturer','Matching','PlayStation 5=Microsoft;Xbox Series X=Nintendo;Nintendo Switch=Atari;Steam Deck=Sony;Atari VCS=Valve
','PlayStation 5=Sony;Xbox Series X=Microsoft;Nintendo Switch=Nintendo;Steam Deck=Valve;Atari VCS=Atari',NULL,NULL);



## Quiz 8 (Esports Quiz)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(8,'Esports Quiz','Like competitive gaming? give this Esports Quiz a go!', 15,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(71,8,'Who was the first Person in the League of Legends Hall of Fame?','Question-Response',NULL,'Faker',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(72,8,'Who is this?(Write only ign)','Picture-Response',NULL,'Caps','https://th.bing.com/th/id/OIP.XzaO6oXo7xfZEcK3jqU8qQHaHe?w=146&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(73,8,'During Valorant Champions tour final 2022, Who played against "LOUD"','Multiple Choice','Leviatan,DRX,Fnatic,OpTic Gaming','OpTic Gaming',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(74,8,'Who won Austin major 2025 ','Question-Response',NULL,'Vitality',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES (75,8,'Match the organizations to the Regions','Matching','G2=North America;MIBR=Europe;TSM=Brazil;Paper Rex=China;BLG=Pacific','G2=Europe;MIBR=Brazil;TSM=North America;Paper Rex=Pacific;BLG=China',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES (76,8,'Which Country won Overwatch World Cup 2016','Multiple Choice','Singapore,Russia,Sweden,South Korea','South Korea',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES (77,8,'Name 4 Popular battle Royale games','Multi-Answer',NULL,'Fortnite,PUBG,Call of duty:Warzone,Apex Legends',NULL,0);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(78,8,'Who was Selected as MVP player in Valorant Masters Toronto Final','Multiple Choice','leaf,zekken,something,f0rsaken','f0rsaken',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(79,8,'Name the Organization','Picture-Response',NULL,'Ninjas in Pyjamas','https://th.bing.com/th/id/OIP.rNrhCOHHa-ZoP1CYBaXylwHaHa?w=169&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUEs(80,8,'Select European organizations','Multiple Choice with Multiple Answers','Sentinels,G2,Fnatic,Team Liquid','G2,Fnatic,Team Liquid',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(81,8,'Which titles are real-time strategy (RTS) games with Esports scenes?','Multiple Choice with Multiple Answers','StarCraft II,Age of Empires IV,Valorant,Mortal Kombat','StarCraft II,Age of Empires IV',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(82,8,'Which team won the international 2021 in Dota 2?','Question-Response',NULL,'Team Spirit',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(83,8,'Which Team won League Worlds 2023?','Multiple Choice','Gen.G,JDG,G2,T1','T1',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(84,8,'Match the player to the game','Matching','Faker=CS:GO;S1mple=Valorant;Tenz=Apex Legends;iiTzTimmy=League of Legends','Faker=League of Legends;S1mple=CS:GO;Tenz=Valorant;iiTzTimmy=Apex Legends',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(85,8,'Which of these Football Clubs have Valorant Teams?','Multiple Choice with Multiple Answers','FC Barcelona,Manchester United,Wolverhampton Wanderers,Eintracht Frankfurt','FC Barcelona,Wolverhampton Wanderers,Eintracht Frankfurt',NULL,NULL);


## Quiz 9 (Anime Quiz)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(9,'Anime Quiz','Immerse yourself in the World of Anime, try this Quiz out!',15,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(86,9,'Name the Original "Big 3" Anime','Multi-Answer',NULL,'One Piece,Naruto,Bleach',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(87,9,'Who is the creator of Attack on Titan?','Question-Response',NULL,'Hajime Isayama',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(88,9,'Match the anime to its protagonist','Matching','Naruto=Ichigo Kurosaki;Death Note=Naruto Uzumaki;Bleach=Yuji Itado;One Piece=Light Yagami;Jujutsu Kaisen=Monkey D. Luffy','Naruto=Naruto Uzumaki;Death Note=Light Yagami;Bleach=Ichigo Kurosaki;One Piece=Monkey D. Luffy;Jujutsu Kaisen=Yuji Itado',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(89,9,'Tokyo Ghoul is set in a world where humans coexist with flesh-eating creatures called _.','Fill in the Blank',NULL,'Ghouls',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(90,9,'Name the Elric brothers in Fullmetal Alchemist','Multi-Answer',NULL,'Edward, Alphonse',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(91,9,'The anime Your Name was directed by Makoto _.','Fill in the Blank',NULL,'Shinkai',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(92,9,'What anime features a school where students train to be heroes?','Multiple Choice','One Punch Man,My Hero Academia,Haikyuu!!,Blue Exorcist','My Hero Academia',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(93,9,'Which of these are anime movies?','Multiple Choice with Multiple Answers','Your Name,Chainsaw Man,I want to eat you pancreas,Violet Evergarden','Your Name,I want to eat you pancreas',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(94,9,'Which of the following are Studio Ghibli films?','Multiple Choice with Multiple Answers','Spirited Away,My Neighbor Totoro,Akira,Howl’s Moving Castle','Spirited Away,My Neighbor Totoro,Howl’s Moving Castle',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(95,9,'Name the Anime','Picture-Response',NULL,'Assassination Classroom','https://th.bing.com/th/id/OIP.Jq_nTOGhZqOVpiaH8zmL1QHaEK?w=333&h=187&c=7&r=0&o=5&dpr=1.3&pid=1.7',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(96,9,'Name the Main Character of this Anime','Picture-Response',NULL,'Natsuki Subaru','https://th.bing.com/th/id/ODL.fc8c53c53e4d0e60481c6d80bd20d221?w=143&h=201&c=10&rs=1&o=6&cb=iavawebpc1&dpr=1.3&pid=AlgoBlockDebug',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(97,9,'Who is the Flame Hashira in Demon Slayer?','Question-Response',NULL,'Kyojuro Rengoku',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(98,9,'In anime "Sound! Euphonium" what instrument does the main Character play?','Question-Response',NULL,'Euphonium',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(99,9,'Name the former 4 Yonkos','Multi-Answer',NULL,'Shanks,Kaido,Big Mom,Blackbeard',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(100,9,'Which anime centers on volleyball?','Multiple Choice','Kuroko no Basket,Free!,Haikyuu!!,Slam Dunk','Haikyuu!!',NULL,NULL);




## Quiz 10 (World History Quiz)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(10,'World History Quiz','Like World History? Try to Complete this Quiz with all points',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(101,10,'The Berlin Wall fell in the year _','Fill in the Blank',NULL,'1989',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(102,10,'Who was the first President of the United States?','Question-Response',NULL,'George Washington',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(103,10,'Which empire was ruled by Genghis Khan?','Multiple Choice','Roman Empire,Mongol Empire,Ottoman Empire,Byzantine Empire','Mongol Empire',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(104,10,'Identify the historical figure in this image','Picture-Response',NULL,'Napoleon Bonaparte','https://th.bing.com/th/id/OIP.SD_9v01uDwergtnd-xASqwHaEK?w=303&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(105,10,'Match each historical event to the correct year','Matching','Fall of Constantinople=1215;French Revolution begins=1914;Start of World War I=1453;Signing of the Magna Carta=1789','Fall of Constantinople=1453;French Revolution begins=1789;Start of World War I=1914;Signing of the Magna Carta=1215',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(106,10,'The Renaissance began in _ during the 14th century','Fill in the Blank',NULL,'Italy',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(107,10,'Which civilization built Machu Picchu?','Multiple Choice','Maya,Inca,Aztec,Olmec','Inca',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(108,10,'Which of the following were Axis Powers during World War II?','Multiple Choice with Multiple Answers','France,Germany,Japan,China','Germany,Japan',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(109,10,'Who was the leader of the Soviet Union during the Cuban Missile Crisis?','Question-Response',NULL,'Nikita Khrushchev',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(110,10,'What event is considered the start of the French Revolution?','Multiple Choice','Battle of Waterloo,Storming of the Bastille,Execution of Louis XVI,Reign of Terror','Storming of the Bastille',NULL,NULL);




## Quiz 11 (Geography Quiz)
INSERT INTO quizzes(id, name, description, num_questions, random_order, one_page, immediate_correction, practice_mode, creator_username)
VALUES(11,'World Geography Quiz','Like Geography',10,1,1,0,0,'Admin');

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(111,11,'What is the capital city of Australia?','Question-Response',NULL,'Canberra',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(112,11,'What is the longest river in the world?','Question-Response',NULL,'Nile',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(113,11,'The _ Desert is the largest hot desert in the world.','Fill in the Blank',NULL,'Sahara',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(114,11,'Which country has the most natural lakes?','Multiple Choice','Canada,Russia,Brazil,United States','Canada',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(115,11,'Which of the following are Scandinavian countries?','Multiple Choice with Multiple Answers','Sweden,Finland,Denmark,Germany','Sweden,Finland,Denmark',NULL,NULL);

INSERT INTO  questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(116,11,'Match the capital to the country','Matching','Tokyo=Australia;Cairo=Canada;Canberra=Egypt;Ottawa=Japan','Tokyo=Japan;Cairo=Egypt;Canberra=Australia;Ottawa=Canada',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(117,11,'What is the smallest country in the world by land area?','Multiple Choice','Monaco,San Marino,Liechtenstein,Vatican City','Vatican City',NULL,NULL);

INSERT INTO questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(118,11,'Name the 5 biggest Countries by Area from biggest to smallest','Multi-Answer',NULL,'Russia,Canada,United States,China,Brazil',NULL,1);

INSERT INTO  questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(119,11,'Guess the Country','Picture-Response',NULL,'Japan','https://img.freepik.com/premium-photo/picturesque-scene-mount-fuji-with-cherry-blossoms-foreground_1145402-6776.jpg',NULL);

INSERT INTO  questions(id, quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters)
VALUES(120,11,'Guess the Country','Picture-Response',NULL,'Netherlands','https://th.bing.com/th/id/OIP.qYjv67oxdJvLHLXadhenJAHaFu?w=219&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',NULL);


INSERT INTO quiz_attempts (user_name, quiz_id, score, total_questions, time_taken, is_practice_mode) VALUES
                                                                                                         ('user1', 1, 8, 10, 300, FALSE),
                                                                                                         ('user2', 1, 7, 10, 450, FALSE),
                                                                                                         ('user3', 1, 9, 10, 250, FALSE),
                                                                                                         ('user1', 2, 6, 10, 400, FALSE),
                                                                                                         ('user2', 2, 8, 10, 350, FALSE),
                                                                                                         ('user1', 3, 5, 10, 500, FALSE);