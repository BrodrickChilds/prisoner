import csv
from collections import Counter 


class Player():

    def __init__(self,uid,name,gender,politics,religion,age):
        self.id=uid
        self.name=name
        self.gender=gender
        self.politics=politics
        self.religion=religion
        self.age=age
        self.friends={} ## stores friend information as this {friend_id: [(user_strat, friend_strat),(user_strat,friend,strat)...]}
        self.games=[]
    
        
    def update_friends(self,game):
        
        """Should get a game obj and updates the friends field based on games accordingly"""
        if game["opp_id"] in self.friends:
           self.friends[game["opp_id"]][game['stage_id']].append((game['user_strat'],game['opp_strat']))
           self.friends[game["opp_id"]]['all'].append((game['user_strat'],game['opp_strat']))

        elif game["user_id"] in self.friends:
           self.friends[game["user_id"]][game['stage_id']].append((game['opp_strat'],game['user_strat']))
           self.friends[game["user_id"]]['all'].append((game['opp_strat'],game['user_strat']))

        elif self.id==game['user_id']:
            self.friends[game["opp_id"]]={}
            for i in range(2,7):
                self.friends[game['opp_id']][str(i)]=[]
            self.friends[game['opp_id']]['all']=[]
            
            self.friends[game["opp_id"]][game['stage_id']].append((game['user_strat'],game['opp_strat']))
            self.friends[game["opp_id"]]['all'].append((game['user_strat'],game['opp_strat']))

        elif self.id==game['opp_id']:
            self.friends[game["user_id"]]={}
            for i in range(2,7):
                self.friends[game['user_id']][str(i)]=[]
            self.friends[game['user_id']]['all']=[]
           
            self.friends[game["user_id"]][game['stage_id']].append((game['opp_strat'],game['user_strat']))
            self.friends[game["user_id"]]['all'].append((game['opp_strat'],game['user_strat']))
    
    def update_games(self,game):
        self.games.append(game)
        self.update_friends(game)


        


    
