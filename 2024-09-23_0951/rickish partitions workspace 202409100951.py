
## the main number
a = 12


board_history = []
partition_paths = []
for b in range(2, a): ## for each number less than the number
    while 2 * b < a:
        b = b * 2
    board = [b, a - b] ## create the board
    active_position = 0 ## initial active position
    inactive_position = 1 ## initial inactive position
    bin_continue = 1
    turn_history = []
    if b in board_history:
        bin_continue = 0
    while bin_continue == 1: ## continue until there is a reason not to
        board_history.append(board[active_position]) ## add to board history
        turn_history.append(board[active_position]) ## add to board history
        #print(board_history)
        active_position_value = board[active_position] ## save the value
        inactive_position_value = board[inactive_position] ## save the value
        if board[active_position] % 2 == 0: 
            board[active_position] = active_position_value/2
            board[inactive_position] = inactive_position_value + active_position_value/2
        else:
            board[active_position] = (active_position_value - 1)/2
            board[inactive_position] = inactive_position_value + (active_position_value + 1)/2
            if active_position == 1:
                active_position = 0
                inactive_position = 1
            else:
                active_position = 1
                inactive_position = 0
        if board[active_position] in turn_history:
            bin_continue = 0
        if board[active_position] == a or board[inactive_position] == a or board[active_position] < 2 :
            bin_continue = 0
            turn_history.append(1)
            turn_history.append(a)
            board_history.append(1)
            board_history.append(a)
    partition_paths.append(turn_history)
    #partition_paths.remove([1])
        #print(board[active_position],", ", board[inactive_position])
            #print('here')
        #bin_continue = 0
#thing = list(set(tuple(row) for row in partition_paths))
partition_paths_pre = [x for x in partition_paths if x]
partition_paths_pre = sorted(partition_paths_pre, key=len, reverse = True)


partition_paths = []
for d, b in enumerate(partition_paths_pre):
    keep_this_thing = 1
    if d == 0:
        partition_paths.append(b)
    else:
        #print(b[0])
        for c in range(0, d):
            if b[0] in partition_paths_pre[c]:
                keep_this_thing = keep_this_thing * 0
        if keep_this_thing == 1:
            partition_paths.append(b)

thing = []
for b in partition_paths:
    if b[-1] == a:
        thing.append([1,len(b)])
    else:
        thing.append([0,len(b)])
