#!/usr/bin/python3.6

"""
Created on Thu Apr 25 19:53:00 2024

@author: alexmitchell
"""
import threading
import itertools
#----------------------------------------------------------------------------
#gloab variables 
master_dict = {}

# get dictionary for building and their time between from an input file 
def building_time(input_file):
    building_time_dict = {} 
    file = open(input_file, 'r') 
    # reading tfile
    text_input = file.read() 
    # get list of all the words
    input_list = text_input.lower().split('\n')
    #for each list item, split into key value pairs
    try:
        for li in input_list:
            key,value = li.split(' : ')
            value = value.split()
            #store key value pairs in building dict
            building_time_dict[key] = value
    except:
        pass

    return building_time_dict

# get a list of keys for any dict
def key_list(dictionary): #building_time_dict, master_dict
    return list(dictionary.keys())

#-----------------------------------------------------------------------------
def building_and_times():
    #get times between buildings for input 2
    building_time_dict = building_time('input2.txt')
    
    #get 
    building_key_list = key_list(building_time_dict)
    
    #get the starting/ending building
    first_building = building_key_list[0]
    
    #get remaining buildings 
    remaining_building_list = list()
    for n in range(1,len(building_key_list)):
        remaining_building_list.append(building_key_list[n])
    
    # get all combos of those keys 
    unique_combos = list()
    
    for uc in itertools.permutations(remaining_building_list):
        #create empty list for a unique combo
        uc_list = list()
        #add the starting building to the list
        uc_list.append(first_building)
        #for each list item in the unique combos for remaining builds, add to the unique combo list
        for li in list(uc):
            uc_list.append(li)
        #add ending building to the list
        uc_list.append(first_building)
        #add the sinlge comnbo to the list of all the unique combos 
        unique_combos.append(uc_list)
        
    
    #protect the global varaible 
    my_lock.acquire() 
    #for each list in the list of unique combos...
    for li in unique_combos:
        # set total time variable to 0
        total_time = 0
        # for a sinle list item in a list of building combos ...
        for i in range(0,len(li)):
            #if the next item in the list exists...
            if len(li) > i+1:
                # get the building key of the current building
                building_key = li[i]
                # get the next building 
                next_buiding = li[i+1]
                # find the position of the next building from the building key list
                position = building_key_list.index(next_buiding)
                #get the dict record for the current building 
                building_times =  building_time_dict[building_key]
                #using the building position, get the time beween the current building and the next building in the list
                time_between = int(building_times[position])
                #add up the total time between buildings for each combo list 
                total_time += time_between
        #using the time as the key, update the master dictionary with the time and the order of the buildings 
        master_dict[total_time] = li 
    #release lock 
    my_lock.release()

# do all the treading stuff 
myThreads = list()
myThreads.append(threading.Thread(target=building_and_times, args=()))

my_lock = threading.Lock()
for currentThread in myThreads:
    currentThread.start()

for currentThread in myThreads:
    currentThread.join()

#get the final output 
master_key_list = key_list(master_dict)
best_time = min(master_key_list)
best_order = ' '.join(master_dict[best_time])

with open("output2.txt", "w") as text_file:
    text_file.write(f'{best_order} {best_time}')
