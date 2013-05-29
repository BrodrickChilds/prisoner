from reader import *
from Player import *

class Population():
    def __init__(self):
        self.size=0
        self.games=[]
        self.players={}
        
    def add_member(self,player):
        if player.id not in self.players:
            self.players[player.id]=player
            self.size+=1

    def add_game(self,game):
        self.games.append(game)


members=Population()

## make users objects
for user in user_objs:
    new_player=Player(user['id'],user['name'],
                      user['gender'],user['politics'],
                      user['religion'],user['birth_date'])
    members.add_member(new_player)
## contruct the graph
for game in game_objs:
    validation_count=0
    if game['complete']=='t' and game['stage_id']!='1':
        members.add_game(game)
        for member in members.players:
            if member==game['user_id'] or member==game['opp_id']:
                validation_count+=1
                members.players[member].update_games(game)
        if validation_count<2:
            print "something is wrong"

            
