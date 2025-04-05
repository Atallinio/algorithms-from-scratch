F = [[1,-2],[2,1],[-2,-1]]

def implication(F):
    """
    Construct the implication graph from the formula F.
    From the 'I' Dictionary we get the next nodes from the current node
    """
    I = dict() 
    for A, B in F:
        if -A not in I:
            I[-A] = []  # ¬A → B
        if -B not in I:
            I[-B] = []  # ¬B → A

    for A, B in F:
        I[-A].append(B)  # ¬A → B
        I[-B].append(A)  # ¬B → A

    return I

I = implication(F)

def get_path(start_node, current_node, I, visited, path, found_contradiction):
    """
    Recursively find all paths starting and ending at start_node (Cycles).  
    """
    if found_contradiction:
        return found_contradiction

    # If we reached the start node then add path to paths
    if start_node == current_node and len(path) != 0:
        path.append(current_node)
        # Check for contradiction in this cycle
        for node in path:
            if -node in path:
                found_contradiction = True
                return found_contradiction

        path.pop()
        return found_contradiction

    if visited[current_node] == True:
        # Node has been already visited
        return found_contradiction
    
    # Tag the node as visited and append it to the path
    visited[current_node] = True
    path.append(current_node)
    
    # Get next node and recursively call the function again
    for next_node in I.get(current_node, []):
        found_contradiction = get_path(start_node, next_node, I, visited, path, found_contradiction)
        if found_contradiction:
            return found_contradiction 

    path.pop()
    visited[current_node] = False
    return found_contradiction

# Find all possible cycles for each starting node
for node in I.keys():
    found_contradiction = get_path(node, node, I, {node : False for node in I.keys()}, [], False)
    if found_contradiction:
        break

print(found_contradiction)
