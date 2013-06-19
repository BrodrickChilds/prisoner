from Population import *
import numpy
import matplotlib.pyplot as plt

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
        if int(z['stage_id']) != 4:
            if z['user_id'] not in user_plays:
                user_plays[z['user_id']] = [z['user_strat'],float(z['updated_at'])]
            else:
                if user_plays[z['user_id']][1]<float(z['updated_at']):
                    pass
                else:
                    user_plays[z['user_id']] = [z['user_strat'],float(z['updated_at'])]
    for p in user_plays:
        if user_plays[p][0] == 't':
            user_betrays +=1
        else:
##            print "adding"
            user_cooperates+=1
    return float(user_betrays)/(user_betrays + user_cooperates)


def opp_start_effects(games):
    opp_plays = {}
    user_betrays = 0
    user_cooperates = 0
    for z in games:
        if int(z['stage_id']) != 4:
            if z['opp_id'] not in opp_plays:
                opp_plays[z['opp_id']] = [z['opp_strat'],float(z['created_at'])]
            else:
                if opp_plays[z['opp_id']][1]<float(z['created_at']):
                    pass
                else:
                    opp_plays[z['opp_id']] = [z['opp_strat'],float(z['created_at'])]
    for p in opp_plays:
##        print p
        if opp_plays[p][0] == 't':
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
            elif int(z['opp_history']) >= thresh:
                if z['user_history'] == 't':
                    b_count += 1
                else:
                    c_count += 1
    print b_count, c_count
    return float(b_count)/(b_count + c_count)

def opp_gender(games, users):
    b_count = 0
    c_count = 0
    for z in games:
        if z['complete'] == "t" and users[z['user_id']].gender == 'male':
            if z['user_strat'] == 't':
                b_count += 1
            else:
                c_count += 1
    return float(b_count)/(b_count + c_count)

def good_pairs(games, thresh):
    pairs = {}
    for z in games:
        if z['complete'] == "t":
            if (z['opp_id'], z['user_id']) not in pairs and (z['user_id'], z['opp_id']) not in pairs:
                pairs[(z['opp_id'], z['user_id'])] = 1
            elif (z['opp_id'], z['user_id']) in pairs:
                pairs[(z['opp_id'], z['user_id'])] += 1
            elif (z['user_id'], z['opp_id']) in pairs:
                pairs[(z['user_id'], z['opp_id'])] += 1
    for p in pairs:
        if pairs[p] >= thresh:
            pass
        
        
        
                
