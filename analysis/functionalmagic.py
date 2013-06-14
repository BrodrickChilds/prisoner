from Population import *
import numpy
import matplotlib.pyplot as plt
from operator import itemgetter

def gen_mutual_friends(games):
    mutual_friends = {}
    seen = set()
    for z in games:
        if (z['user_id'],z['opp_id']) in seen:
            pass
        else:
            if z['mutual_friends'] != '':
##                print z['id'], z['mutual_friends'] + 'a'
                mutual_friends[(z['user_id'],z['opp_id'])] = float(z['mutual_friends'])
                mutual_friends[(z['opp_id'],z['user_id'])] = float(z['mutual_friends'])
                seen.add((z['user_id'],z['opp_id']))
                seen.add((z['opp_id'],z['user_id']))
            else:
                pass
    return mutual_friends

def mutual_friend_num(p1,p2,mf):
    pass

#Takes in mf = dictionary of mutual friends from gen_mutual_friends
def mutual_friend_statistics(mf):
    median = numpy.median(mf.values())
    average = numpy.mean(mf.values())
    count = 0
    for z in mf.values():
        if z == 0:
            count+=1
    return len(mf.values())/2, count/2
    


#Takes in t = threshold, players = list of player objects,
#mf = dictionary of mutual friends from gen_mutual_friends
def mutualfriends_coop(t,players, mf):
    betray_above = 0
    coop_above = 0
    betray_below = 0
    coop_below = 0
    for p in players:
        for f in players[p].friends:
            for z in players[p].friends[f]['all']:
                if (p,f) in mf:
                    if z[0] == 't':
                        if mf[(p,f)]>=t:
                            betray_above += 1
                        else:
                            betray_below += 1
                    else:
                        if mf[(p,f)]>=t:
                            coop_above += 1
                        else:
                            coop_below += 1
                else:
                    pass
    return [float(betray_above)/(betray_above+coop_above),
            float(betray_below)/(coop_below + betray_below)]


        
def user_start_effects(games):
    user_plays = {}
    user_betrays = 0
    user_cooperates = 0
    for z in games:
        if z['user_id'] not in user_plays:
            user_plays[z['user_id']] = [z['user_strat'],float(z['created_at'])]
        else:
            if user_plays[z['user_id']][1]<float(z['created_at']):
                pass
            else:
                user_plays[z['user_id']] = [z['user_strat'],float(z['created_at'])]
    for p in user_plays:
        if p[0] == 't':
            user_betrays +=1
        else:
##            print "adding"
            user_cooperates+=1
    return float(user_betrays)/(user_betrays + user_cooperates)


def opp_start_effects(games):
    user_plays = {}
    user_betrays = 0
    user_cooperates = 0
    for z in games:
        if z['user_id'] not in user_plays:
            user_plays[z['user_id']] = [z['user_strat'],float(z['updated_at'])]
        else:
            if user_plays[z['user_id']][1]<float(z['updated_at']):
                pass
            else:
                user_plays[z['user_id']] = [z['user_strat'],float(z['updated_at'])]
    for p in user_plays:
        if p[0] == 't':
            user_betrays +=1
        else:
##            print "adding"
            user_cooperates+=1
    return float(user_betrays)/(user_betrays + user_cooperates)                
                      
#take in a player id, uid
#and a stage number
#only works if # games played > 5
def stage_predict(uid, stage, games):
    b_count = 0
    c_count = 0
    for z in games:
        if int(z['user_id']) == uid:
            if int(z['stage_id']) == stage:
                if z['opp_strat'] == 't':
                    b_count += 1
                else:
                    c_count +=1
        elif int(z['opp_id']) == uid:
            if int(z['stage_id']) == stage:
                if z['user_strat'] == 't':
                    b_count += 1
                else:
                    c_count +=1  
    if b_count + c_count < 5:
        return "Not enough games played"
    else:
        return float(b_count)/(b_count + c_count)

def player_betrays(uid, games):
    b_count = 0
    c_count = 0
    for z in games:
        if int(z['user_id']) == uid:
            if z['opp_strat'] == 't':
                b_count += 1
            else:
                c_count +=1
        elif int(z['opp_id']) == uid:
            if z['user_strat'] == 't':
                b_count += 1
            else:
                c_count +=1        
    if b_count + c_count < 5:
        return "Not enough games played"
    else:
        return float(b_count)/(b_count + c_count)


#thresh is a threshold (0,100)
#calculates prob(betray|history>=thresh)
#Skewed by cheaters + 231
def cond_history(thresh, stage, games):
    b_count = 0
    c_count = 0
    for z in games:
        if z['complete'] == "t" and int(z['stage_id']) == stage and z['same_parity'] == 't':
            if int(z['user_history']) >= thresh:
                if z['opp_strat'] == "t":
                    b_count += 1
                else:
                    c_count +=1
            if int(z['opp_history']) >= thresh:
                if z['user_strat'] == 't':
                    b_count += 1
                else:
                    c_count += 1
    print b_count, c_count
    return float(b_count)/(b_count + c_count)

# returns (stage number, betrayal rate, games played on that stage)
def stage_betrayal(games):
    stage_b = {}
    for i in range(2,7):
        b_count = 0
        c_count = 0
        play_count = 0
        for z in games:
            if z['complete'] == "t" and int(z['stage_id']) == i:
                play_count += 1
                if z['opp_strat'] == "t" and z['user_strat'] == "t":
                    b_count += 2
                elif z['opp_strat'] == "t" or z['user_strat'] == "t":
                    b_count += 1
                    c_count += 1
                else:
                    c_count +=2
        stage_b[i] = (float(b_count)/(b_count + c_count), play_count)
    out = [(k, v, c) for k, (v,c) in stage_b.iteritems()]
    return out

#shows betrayal rates for seen/unseen histories
def info_vs_no_info_stage_betrayal(games):
    stage_b = {}
    no_stage_b = {}
    for i in range(2,7):
        b_count = 0
        c_count = 0
        play_count = 0
        no_b_count = 0
        no_c_count = 0
        no_play_count = 0
        for z in games:
            if z['complete'] == "t" and int(z['stage_id']) == i and z['same_parity'] == 't':
                play_count += 1
                if z['opp_strat'] == "t" and z['user_strat'] == "t":
                    b_count += 2
                elif z['opp_strat'] == "t" or z['user_strat'] == "t":
                    b_count += 1
                    c_count += 1
                else:
                    c_count +=2
            elif z['complete'] == "t" and int(z['stage_id']) == i and z['same_parity'] == 'f':
                no_play_count += 1
                if z['opp_strat'] == "t" and z['user_strat'] == "t":
                    no_b_count += 2
                elif z['opp_strat'] == "t" or z['user_strat'] == "t":
                    no_b_count += 1
                    no_c_count += 1
                else:
                    no_c_count +=2
        stage_b[i] = (float(b_count)/(b_count + c_count), play_count)
        no_stage_b[i] = (float(no_b_count)/(no_b_count + no_c_count), no_play_count)
    with_hist, without_hist = [(k, v, c) for k, (v,c) in stage_b.iteritems()], [(k, v, c) for k, (v,c) in no_stage_b.iteritems()]
    print with_hist, "\n"
    print without_hist
    return 

#returns a dictionary of players, games played
#such that # of games played >= thresh (only completed games)
def good_players(thresh, games):
    player_dict = {}
    for z in games:
        if z['complete'] == "t" and int(z['stage_id'])>1:
            if z['user_id'] in player_dict:
                player_dict[z['user_id']] += 1
            if z['user_id'] not in player_dict:
                player_dict[z['user_id']] = 1
            if z['opp_id'] in player_dict:
                player_dict[z['opp_id']] += 1
            if z['opp_id'] not in player_dict:
                player_dict[z['opp_id']] = 1      
    for k in player_dict.keys():
        if player_dict[k] < thresh:
            del player_dict[k]
    player_list = [(k,v) for k, v in player_dict.iteritems()]
    print "Number of players playing more than " + str(thresh) + " games: " + str(len(player_list))
    return sorted(player_list, key = itemgetter(1), reverse = True)
    

            
            






