import csv
from collections import Counter



game_heading = ['id','user_id','opp_id','user_strat','opp_strat','complete','seen_bit',
            'created_at','updated_at','stage_id','user_time_left','opp_time_left',
            'user_hist','opp_hist','fb_friend','same_parity','mutual_friends']

user_heading=['id', 'provider','name','oauth_token','oath_exp','created_at',
              'updated_at','score','last_stage','gender','politics','religion',
              'has_info','education','birthdate','completion_time','time_spent',
              'last_reminder']


##Read all games
reader = csv.reader(open("trial2.csv"))
numlines = len(list(reader))
print "number of games: ",numlines
reader = csv.reader(open("trial2.csv"))
head=reader.next()
print head
indices = head
numcolumns = len(indices)
reader = csv.reader(open("trial2.csv"))   ##Reset reader again
rows = []
for i in xrange(numlines):  ##Construct list of lists
    row = reader.next()
    rows.append([row[j] for j in range(len(indices))])

game_objs = []
for row in rows[1:]:
    obj = {}
    for i in xrange(len(indices)):
        obj[indices[i]] = row[i]
    game_objs.append(obj)

columns = [[row[i] for row in rows] for i in xrange(numcolumns)]
counters = [Counter(column[1:]) for column in columns]

##Read user table
reader = csv.reader(open("users.csv"))
numlines = len(list(reader))
print "number of users: ",numlines
reader = csv.reader(open("users.csv"))
head=reader.next()
print head
indices = head
numcolumns = len(indices)
reader = csv.reader(open("users.csv"))   ##Reset reader again
rows = []
for i in xrange(numlines):  ##Construct list of lists
    row = reader.next()
    rows.append([row[j] for j in range(len(indices))])

user_objs = []
for row in rows[1:]:
    obj = {}
    for i in xrange(len(indices)):
        obj[indices[i]] = row[i]
    user_objs.append(obj)


