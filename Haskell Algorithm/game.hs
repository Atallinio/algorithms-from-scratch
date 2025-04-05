-- [Required imports] ---------------------------------------------------------
-- Do not change this, you can ignore it, it's for the test harness.
-- DO NOT USE EXCEPTIONS or `error` IN YOUR CODE!
import qualified Control.Exception as Excep
-- Bring in the file IO functions.
import System.IO                            
import System.Directory

-- [Optional imports] ---------------------------------------------------------
-- If you wish, you may import other modules immediately below this comment.
-- The problems are designed so you don't need to do so.



-- [Given types] --------------------------------------------------------------
-- The types in this section are defined for you.  DO NOT CHANGE THEM.
-- The deriving Show and Eq types are purely for debugging and the test harness
-- so do not change them either - note, those automatically derived functions
-- may not behave the way the problem specifies.

-- |A representation of 2D coordinates as a pair of ints.
-- Used to represent a position in a 2D grid.
-- First value is x coordinate (ie, what column it is in)
-- second value is y (ie, what row it is in).
type Coord = (Int, Int)

-- |The four compass direction.  North is up, west is left.
data Dir = North | South | East | West
    deriving (Eq, Show)

-- |Is a given door open or close?
data DoorState = Open | Closed
    deriving (Eq, Show)

-- |What different kinds of elements make up the game map?
data Terrain = Floor
             | Wall
             | Water
             | Door DoorState
    deriving (Eq, Show)

-- |A game map is a 2D grid of terrain elements.  
-- The outer list represents rows, each innner list represents elements in that row.
-- All inner lists should be the same length.
-- Coordinates start at (0,0) at the start of the first list.
data GameMap = GameMap [[Terrain]]
    deriving (Eq, Show)

-- |Different types of item that exist.
data Slot = Helm | Weapon | Armour | Boots
    deriving (Eq, Show)

-- |An item has a name, type, and a number for use as a slot-dependent stat.
-- Two items are the same if they share exactly the same name.
data Item = Item String Slot Int
    deriving (Eq, Show)

-- |A player has a name, current position, current health value, and a
-- list of currently equipped items.
data Player = Player String Coord Int [Item]
    deriving (Eq, Show)


-- [Questions] ----------------------------------------------------------------
-- You should implement the functions as specified below.
-- Skeletons of each function have been provided with the correct types, and
-- an implementation that uses `error` to immediately crash.  You should delete 
-- the `error` call and correctly implement the function.
-- You may define additional functions or types as you desire to help you
-- complete each question.
-- DO NOT CHANGE THE TYPES OF THE FUNCTIONS.



-- Q 1) Write the two functions below to return the width and height of a game map.
-- 2 marks.
getHeight :: GameMap -> Int
getHeight (GameMap [[]]) = 0            -- If gameMap is empty
getHeight (GameMap g) = length g

getWidth :: GameMap -> Int
getWidth (GameMap []) = 0               -- If gameMap is empty 
getWidth (GameMap g) = length (head g) 


-- Q 2) Write the function below to return whether a coordinate is inside a map or not.
-- 2 marks.
isInBounds :: GameMap -> Coord -> Bool
isInBounds g (x,y) 
    | y < h && y >= 0 && x < w && x >= 0 = True             -- Check that the x & y coordinates are within 0 and the width and height respectively
    | otherwise = False

    where 
        h = getHeight g
        w = getWidth g


-- Q 3) Write the function below to take a coordinate and generate a new one 1 step in the
-- given direction.  This function should ignore the bounds of the map and calculate the
-- coordinate regardless.
-- 1 mark.
offsetCoord :: Coord -> Dir -> Coord
offsetCoord (x, y) d = case d of
    North -> (x,y-1)
    South -> (x,y+1)
    East -> (x+1,y)
    West -> (x-1,y)


-- Q 4) Write the function below to return the terrain at a specific location in a map
-- only if the coordinates are in bounds.
-- 3 marks.
getTile :: GameMap -> Coord -> Maybe Terrain
getTile (GameMap g) (x,y) = if isInBounds (GameMap g) (x,y) == True then            -- Check first if coordinate is inbounds
                    Just (g !! y !! x)                                              -- find the terrain at that specific location
                else Nothing                                                        -- Else return Nothing

-- Q 5) Write the function below to return True if the terrain at the given location is
-- passable.  Passable terrain are floors and open doors.  Nothing out of bounds is passable.
-- 2 marks.
isPassable :: GameMap -> Coord -> Bool
isPassable (GameMap g) (x,y)
    | isInBounds (GameMap g) (x,y) == False = False                                 -- Check first if the coordinate is in bounds
    | getTile (GameMap g) (x,y) == Just (Floor) = True                              -- Check for Floor
    | getTile (GameMap g) (x,y) == Just (Door Open) = True                          -- Check for open door
    | otherwise = False

-- Q 6) Write the function below which takes a gamemap, coordinate, and a direction, and
-- returns a new coordinate which is the result of that move with an Either type.
-- If the move was possible then the result should be (Right) with the new coord.
-- If the move was not possible then the result should be (Left) with the current coord.
-- 3 marks.
move :: GameMap -> Coord -> Dir -> Either Coord Coord
move (GameMap g) (x,y) d = if isInBounds (GameMap g) (x,y) == True then                 -- Check if the coordinate is in bounds
                                if isPassable (GameMap g) (new_x,new_y) == True then    -- Check if the new coordinate is passable
                                    Right (new_x, new_y)
                                else Left (x,y)
                            else Left (x,y)
                            where
                            (new_x,new_y) = offsetCoord (x,y) d                          -- Find new coordinate using offsetMethod



-- Q 7) Write the function below to create a new player with the given name but otherwise
-- default values of 100 health, no items, and a position of (1,1).
-- 1 mark.
newPlayer :: String -> Player
newPlayer n = Player n (1,1) 100 []             -- Create new player


-- Q 8) Write the function below to create a "status line" string describing the current
-- state of the player.
-- The line should be formatted as follows, with commas and spacing as seen in the examples:
-- the line starts with "Hero" then the player name, then their HP followed by "HP",
-- then "wielding " followed by either the weapon name or "(nothing)", then "wearing", followed
-- by the helm, armour, and boots names or "(no helm)", "(no armour)", "(no boots)".  The boots
-- are the last element of the list so should have "and" before and a full stop after.
-- See these two examples for the expected formatting, spacing, and punctuation:
-- (Player "Ray" (12,63) 94 [(Item "T-Shirt of Defiance" Armour 12), (Item "dagger" Weapon 8), (Item "leather boots" Boots 4), (Item "mining cap" Helm 6)])
--    should return
-- "Hero Ray, 94 HP, wielding dagger, wearing mining cap, T-Shirt of Defiance, and leather boots."
-- (Player "Jim" (1,1) 12 [])
--    should return
-- "Hero Jim, 12 HP, wielding (nothing), wearing (no helm), (no armour), and (no boots)."
-- 5 marks.

slotInItems :: Slot -> [Item] -> Bool
slotInItems slot items = any (\(Item _ s _) -> s == slot) items             -- Return True if any of the items have a slot "s" equal to the slot

showItem :: Slot -> [Item] -> String
showItem slot items = if (slotInItems slot items) == False then            
                        case slot of
                            Weapon -> "(nothing)"
                            Helm -> "(no helm)"
                            Armour -> "(no armour)"
                            Boots -> "(no boots)"
                        else 
                            head [itemName | (Item itemName s _) <- items, s == slot]   
                            -- If the slot is in the items then return Item name where the slot "s" equals slot

-- Here I will do a large statement where I call the show Item function to get the right string to show depending on the item
playerStatus :: Player -> String
playerStatus (Player name coord health items) = "Hero " ++ name ++ ", " ++ show health ++ " HP, wielding " ++ showItem Weapon items ++ ", wearing " ++ showItem Helm items ++ ", " ++ showItem Armour items ++ ", and " ++ showItem Boots items ++ "."


-- Q 9) A player can only hold 1 item of each type at a time.  Write the function below to
-- pick up the given item.  If there is already an item of that type then the new item
-- should replace that.  Return the new state of the player.
-- 3 marks.
pickupItem :: Player -> Item -> Player
pickupItem (Player name coord health items) (Item iName slot stat) = if slotInItems slot items == False then    -- Check if the player has the item
                                                    (Player name coord health ((Item iName slot stat):items))
                                                    else
                                                        (Player name coord health 
                                                        ((Item iName slot stat):(filter (\(Item _ s _) -> s /= slot) items)))   -- Remove old item using filter and add new item


-- Q 10) Write the function below to replace the terrain at the given coordinate of a game map 
-- with a new one, returning the new game map.  If the coordinates are invalid then return the
-- map unchanged.
-- 5 marks.
--This helper function searches the rows using foldr to find the right x coordinate and switch the terrain with the new one
searchRows :: [Terrain] -> Int -> Terrain -> [Terrain]
searchRows ts x t = foldr (\terrian acc -> if (length acc) == (length ts) - x - 1 then t:acc else terrian:acc) [] ts

-- Here I will do a double foldr to loop over the rows and columns respectively and change only the terrain required
updateMap :: GameMap -> Coord -> Terrain -> GameMap
updateMap (GameMap g) (x,y) t = GameMap $
    foldr (\row acc -> if (length acc) == ((getHeight (GameMap g)) - y - 1) then (searchRows row x t):acc else row:acc) [] g
    -- This foldr checks if we have reached the right coordinate --> if so --> search the row --> otherwise --> add row to accumelator


-- Q 11) Write the function below to open/close a door that is next to the given coordinate in the
-- specified direction.  Return the new state of the game map.  If there is no door or the coordinate
-- is invalid, the game map is returned unchanged.
-- 5 marks.
-- This helper functions checks if the tile is a door open or door close
isThereDoor :: GameMap -> Coord -> Bool
isThereDoor g c = if getTile g c == Just (Door Open) ||
                    getTile g c == Just (Door Closed) then True
                    else False

tryOpenDoor :: GameMap -> Coord -> Dir -> GameMap
tryOpenDoor g c dir = if isInBounds g c == False || isInBounds g newCoord == False ||   -- Inbounds check first
                            isThereDoor g newCoord == False then                        -- Return the gamemap unchanged if there is no door
                            g
                        else
                            if isPassable g newCoord == True then updateMap g newCoord (Door Closed)    -- use isPassable fn to see if door is open
                                else updateMap g newCoord (Door Open)
                        where
                            newCoord = (offsetCoord c dir) 

-- Q 12) Write the two functions below to visually display the GameMap as grid of characters
-- in a single String.  Each line should be terminated by a newline in the string.
-- Floor tiles should appear as '.', walls are '#', water as '~', open doors as '-', and
-- closed doors as '+'.
-- Note that after you implement renderMap, you can "pretty print" your maps with
-- `putStrLn (renderMap testMap1)` which might help you in debugging other functions.
-- 3 marks.
-- This helper function takes a terrain and returns its corresponding character 
renderTerrain :: Terrain -> Char
renderTerrain t = case t of
    Floor -> '.'
    Wall -> '#'
    Water -> '~'
    (Door Open) -> '-'
    (Door Closed) -> '+'

-- Here we use 2 foldl to loop over the gameMap, swapping everry terrain with its corresponding string
renderMap :: GameMap -> String
renderMap (GameMap g) =  foldl (\acc row -> acc ++ (foldl (\a r -> a ++ [renderTerrain r]) "" row) ++ "\n") "" g


-- Q 13) Write the function below which when given a filename, loads and parses the contents
-- of it as a game map, returning the map or Nothing if the contents of the file are invalid
-- or the file does not exist.
-- The contents of the file should be a a series of lines of all the same length, containing the
-- same characters with the same meaning as the characters used to render the terrain.  Each
-- line is ended with a newline character.
-- 5 marks.

-- Change the char in the map to it proper terrain
getTerrain :: Char -> (Maybe Terrain)
getTerrain c
    | c == '.' = Just Floor
    | c == '#' = Just Wall
    | c == '~' = Just Water
    | c == '-' = Just (Door Open)
    | c == '+' = Just (Door Closed)
    | otherwise = Nothing

-- Parse each row of the map, separating it into terrain elements.
getRow :: String -> [Maybe Terrain]
getRow row = map getTerrain row

-- Check if a map has non terrain objects making it a broken map
checkMap :: [Maybe Terrain] -> Bool
checkMap m = length (filter (\x -> x == Nothing) m) == 0

-- turn map from maybe terrain -> terrain
removeJusts :: [Maybe Terrain] -> [Terrain]
removeJusts row = [x | Just x <- row]

loadMap :: String -> IO (Maybe GameMap)
loadMap filename = do
        exist <- doesFileExist filename             -- Check if the file exists
        if not exist 
            then pure Nothing 
            else do 
                content <- readFile filename        -- Read the content of the file
                let linesOfMap = lines content      -- Get the rows
                let rowLength = length (head linesOfMap)                -- get the length of one row
                let finalMap = map getRow linesOfMap                    -- Apply the get row method to each row to get final map with justs

                -- if any of the rows are not equal or there exists non terrains then return nothing
                if any (\row -> length row /= rowLength || not (checkMap row)) finalMap 
                    then return Nothing
                    else return (Just (GameMap (map removeJusts finalMap)))         -- Remove justs and turn map into the Maybe GameMap type
                        
-- Q 14) Navigating long distances through empty areas can be annoying when having to move each step
-- manually.  Write the function below which will take a starting location and a destination location
-- and calculate a path between the two.  The path must involve only passable tiles.  Open doors can be
-- passed but closed doors can't - don't include opening any doors to check for routes. 
-- The exact algorithm is not specified but should be reasonably direct rather than needlessly wandering
-- around, must find a route if one exists, and must finish within a reasonable time (<5 seconds for a
-- 50x50 map).
-- The return value should be a list of coordinates which represent each step in the path - include the
-- destination but not the starting point.
-- If no route is possible or the destination is the start point, return the empty list.
-- 5 marks.

-- Calculate the Manhattan Distance and use it to get the actual distace from the start node 
manhattanDistance :: Coord -> Coord -> Int
manhattanDistance (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)

-- Calculate distance equation sqrt((x1-x2)^2 + (y1-y2)^2)
heuristicEstimate :: Coord -> Coord -> Int
heuristicEstimate (x1,y1) (x2,y2) =  round (sqrt (fromIntegral ((x1-x2)^2+(y1-y2)^2))) 

-- Estimated Cost of a node = Cost from the start node using Manhattan Distance + Manhattan Distance
estimatedCost :: Coord -> Coord -> Coord -> (Coord,Int) 
estimatedCost startNode endNode currentNode = (currentNode,
    manhattanDistance startNode currentNode + heuristicEstimate currentNode endNode)

--Get All Passable neighbour nodes to an input node
getNeighbourNodes :: GameMap -> Coord -> Coord -> Coord -> [(Coord,Int)]
getNeighbourNodes g startNode (currX, currY) endNode = map (estimatedCost startNode endNode) (filter (isPassable g) 
    [(x,y) | x <- [(currX-1)..(currX+1)], y <- [(currY-1)..(currY+1)], (x /= currX && y == currY) || (x == currX && y /= currY)])

--Get the Lowest Cost Node
getCheapestNode :: [(Coord, Int)] -> (Coord, Int)
getCheapestNode [x] = x  -- If there's only one element, return it
getCheapestNode (x:xs) = compareNodes x (getCheapestNode xs)

-- Helper function to compare two nodes and return the one with the lower cost
compareNodes :: (Coord, Int) -> (Coord, Int) -> (Coord, Int)
compareNodes a b = if snd a <= snd b then a else b

-- Helper function to reconstruct path from the final list
reconstructPath :: Coord -> [Coord] -> [Coord]
reconstructPath currentNode list2 = foldl (\acc row -> if manhattanDistance row (head acc) == 1 then row:acc else acc)
                                [currentNode] list2

aStar :: GameMap -> (Coord, Int) -> Coord -> [(Coord, Int)] -> [(Coord, Int)] -> (Coord, Int) -> [Coord]
aStar g startNode endNode list1 list2 currentNode
    | null list1 = []  -- If no path exists, return empty list
    | fst currentNode == endNode = reconstructPath (fst currentNode) (map fst list2)  -- Return path if goal is reached
    | notElem (fst currentNode) (map fst list2) =  -- Check if node has already been visited
    -- Recursively call the aStar method
        aStar g startNode endNode
            (getNeighbourNodes g (fst startNode) (fst currentNode) endNode ++ filter (\x -> fst x /= fst currentNode) list1) 
            -- Add the neighboring nodes to the open list,
            -- while filtering out the current node from the old open list
            (currentNode:list2)
            (getCheapestNode list1)
            -- Pick the next node to explore (the one with the lowest cost)

    -- If the current node is already visited, move to the next cheapest node
    | otherwise = aStar g startNode endNode (filter (\x -> fst x /= fst currentNode) list1) 
    list2 (getCheapestNode (filter (\x -> fst x /= fst currentNode) list1))

-- I Implemented the A* algorithm to calculate the path between destination and origin
calculateRoute :: GameMap -> Coord -> Coord -> [Coord]
calculateRoute g origin dest = aStar g (origin,0)  dest [(origin, 0)] [] (origin,0) 


-- Q 15) Not an actual question, this "question" is worth 5 marks and will be based
-- on the use of good Haskell coding style in your solutions.  This includes things like
-- appropriately sized functions; re-use of existing functions and types instead of reimplementing them;
-- idiomatic use of functional programming techniques like recusion, higher-order functions,
-- and pattern matching; identifier naming; and code layout.
-- 5 marks for good Haskell coding style.

-- Total 50 marks available.
-- Questions end here.

-- [Testing framework] --------------------------------------------------------
-- DO NOT CHANGE OR ADD ANYTHING BELOW THIS LINE.
-- This section contains some test values and a small testing framework that
-- you can use to partially test the correctness of your function implementation.
-- This is not an exhaustive range of tests for every function and may omit
-- important cases.
-- This deliberately does not use a standard Haskell testing framework to avoid
-- bringing in external modules or language extensions - don't do it this way
-- yourself in the future (look at something like HSpec instead)!

-- |A generic small map with a room and two doors.
-- Features all terrain types.
testMap1 :: GameMap
testMap1 = GameMap [ [f,f,f,w,w],
                     [f,r,f,f,w],
                     [f,w,w,x,w],
                     [f,o,f,f,w],
                     [f,w,w,w,w],
                     [f,f,f,f,f]
                   ]
                   where f = Floor
                         w = Wall
                         x = Door Closed
                         o = Door Open
                         r = Water

-- |A small empty map.
testMap2 :: GameMap
testMap2 = GameMap [ [f,f,f],
                     [f,f,f],
                     [f,f,f]
                   ]
                   where f = Floor

-- |A small map surrounded by walls which should prevent
-- a player trying to walk out of bounds.  A tasteful
-- water feature is present in the middle of the room!
testMap3 :: GameMap
testMap3 = GameMap [ [w,w,w,w,w],
                     [w,f,f,f,w],
                     [w,f,r,f,w],
                     [w,f,f,f,w],
                     [w,w,w,w,w]
                   ]
                   where f = Floor
                         w = Wall
                         r = Water
                

-- |Utility function to generate ok or fail tag based on result.
yn :: Bool -> String
yn True = "[✓ OK]"
yn False = "[❌ FAIL]"

-- |Run some tests for getHeight (Q1).
test_getHeight :: IO ()
test_getHeight = 
    do f testMap1 6
       f testMap2 3
       f testMap3 5
              where
                  f :: GameMap -> Int -> IO ()
                  f g r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " getHeight " ++ (show g)
                        rhs = " == " ++ (show val)
                        val = getHeight g
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for getHeight (Q1).
test_getWidth :: IO ()
test_getWidth = 
    do f testMap1 5
       f testMap2 3
       f testMap3 5
              where
                  f :: GameMap -> Int -> IO ()
                  f g r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " getWidth " ++ (show g)
                        rhs = " == " ++ (show val)
                        val = getWidth g
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"                        

-- |Run some tests for isInbounds (Q2).
test_isInBounds :: IO ()
test_isInBounds = do f testMap1 (0,0) True
                     f testMap1 (0,(-1)) False
                     f testMap1 ((-1),0) False
                     f testMap1 ((-1),(-1)) False
                     f testMap1 (2,3) True
                     f testMap1 (2,5) True
                     f testMap1 (2,6) False
                     f testMap1 (5,5) False
                     f testMap1 (4,5) True
              where
                  f :: GameMap -> Coord -> Bool -> IO ()
                  f g c r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " isInBounds " ++ (show c)
                        rhs = " == " ++ (show val)
                        val = isInBounds g c
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for offsetCoord (Q3).
test_offsetCoord :: IO ()
test_offsetCoord = 
    do f (5,8) North (5,7)
       f (5,8) South (5,9)
       f (5,8) West (4,8)
       f (5,8) East (6,8)
       f (0,0) North (0, (-1))
       f (0,0) South (0,1)
       f (0,0) West ((-1),0)
       f (0,0) East (1,0)
              where
                  f :: Coord -> Dir -> Coord -> IO ()
                  f c d r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " offsetCoord " ++ (show c) ++ " " ++ (show d)
                        rhs = " == " ++ (show val)
                        val = offsetCoord c d
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"   

-- |Run some tests for getTile (Q4).
test_getTile:: IO ()
test_getTile = 
    do f testMap1 (0,0) (Just Floor)
       f testMap1 ((-1), 0) Nothing
       f testMap1 (6, 0) Nothing
       f testMap1 (3,0) (Just Wall)
       f testMap1 (1,1) (Just Water)
       f testMap1 (1,3) (Just (Door Open))
       f testMap1 (3,2) (Just (Door Closed))
              where
                  f :: GameMap -> Coord -> Maybe Terrain -> IO ()
                  f g c r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " getTile " ++ (show g) ++ " " ++ (show c)
                        rhs = " == " ++ (show val)
                        val = getTile g c
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"  

-- |Run some tests for isPassable (Q5).
test_isPassable :: IO ()
test_isPassable = 
    do f testMap1 (0,0) True
       f testMap1 ((-1), 0) False
       f testMap1 (6, 0) False
       f testMap1 (3,0) False
       f testMap1 (1,1) False
       f testMap1 (1,3) True
       f testMap1 (3,2) False
              where
                  f :: GameMap -> Coord -> Bool -> IO ()
                  f g c r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " isPaassable " ++ (show g) ++ " " ++ (show c)
                        rhs = " == " ++ (show val)
                        val = isPassable g c
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"  

-- |Run some tests for move (Q6).
test_move :: IO ()
test_move = 
    do f testMap1 (2,0) West (Right (1,0))
       f testMap1 (2,0) North (Left (2,0))   -- out of bounds
       f testMap1 (2,0) South (Right (2,1))
       f testMap1 (2,0) East (Left (2,0))    -- wall
       f testMap1 (3,1) West (Right (2,1))
       f testMap1 (3,1) North (Left (3,1))   -- wall
       f testMap1 (3,1) East (Left (3,1))    -- wall
       f testMap1 (3,1) South (Left (3,1))   -- closed door
       f testMap1 (0,1) East (Left (0,1))    -- water
              where
                  f :: GameMap -> Coord -> Dir -> Either Coord Coord -> IO ()
                  f g c d r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " move " ++ (show c)
                        rhs = " == " ++ (show val)
                        val = move g c d
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for newPlayer (Q7).
test_newPlayer :: IO ()
test_newPlayer = 
    do f "Paul" (Player "Paul" (1,1) 100 [])
       f "Bob" (Player "Bob" (1,1) 100 [])
              where
                  f :: String -> Player -> IO ()
                  f n r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " newPlayer " ++ (show n)
                        rhs = " == " ++ (show val)
                        val = newPlayer n
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"  

-- |Run some tests for playerStatus (Q8).
test_playerStatus :: IO ()
test_playerStatus = 
    do f (Player "Bob" (1,1) 100 [(Item "a camera" Weapon 2), (Item "a Hawaiian shirt" Armour 5), (Item "sandals" Boots 1), (Item "baseball cap" Helm 2)]) "Hero Bob, 100 HP, wielding a camera, wearing baseball cap, a Hawaiian shirt, and sandals."
       f (Player "Bob" (1,1) 52 [(Item "a camera" Weapon 2), (Item "a Hawaiian shirt" Armour 5), (Item "sandals" Boots 1), (Item "baseball cap" Helm 2)]) "Hero Bob, 52 HP, wielding a camera, wearing baseball cap, a Hawaiian shirt, and sandals."
       f (Player "Jim" (1,1) 12 []) "Hero Jim, 12 HP, wielding (nothing), wearing (no helm), (no armour), and (no boots)."
       f (Player "Ray" (12,63) 94 [(Item "T-Shirt of Defiance" Armour 12), (Item "dagger" Weapon 8), (Item "leather boots" Boots 4), (Item "mining cap" Helm 6)]) "Hero Ray, 94 HP, wielding dagger, wearing mining cap, T-Shirt of Defiance, and leather boots."
              where
                  f :: Player -> String -> IO ()
                  f p r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " playerStatus " ++ (show p)
                        rhs = " == " ++ (show val)
                        val = playerStatus p
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for pickupItem (Q9).
test_pickupItem :: IO ()
test_pickupItem = 
    do f (Player "Sally" (1,1) 74 []) (Item "Sword" Weapon 15) (Player "Sally" (1,1) 74 [Item "Sword" Weapon 15])   -- straight pickup.
       f (Player "Sally" (1,1) 74 [(Item "Axe" Weapon 10)]) (Item "Sword" Weapon 15) (Player "Sally" (1,1) 74 [Item "Sword" Weapon 15])  -- replace
       f (Player "Sally" (1,1) 74 [(Item "leather cap" Helm 5), (Item "dragon scale" Armour 50)]) (Item "rain boots" Boots 10) (Player "Sally" (1,1) 74 [(Item "rain boots" Boots 10), (Item "leather cap" Helm 5), (Item "dragon scale" Armour 50)]) -- straight pickup and maintain other gear.
              where
                  f :: Player -> Item -> Player -> IO ()
                  f p it r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " pickupItem " ++ (show it)
                        rhs = " == " ++ (show val)
                        val = pickupItem p it
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"


test_rmap :: GameMap
test_rmap = GameMap [ [f,f,f,w,w],
                      [f,r,f,f,w],
                      [f,w,w,x,w],
                      [f,o,r,f,w],
                      [f,w,w,w,w],
                      [f,f,f,f,f]
                   ]
                   where f = Floor
                         w = Wall
                         x = Door Closed
                         o = Door Open
                         r = Water

-- |Run some tests for updateMap (Q10).  Only 1 test here to avoid huge
-- lengthy output in the test log.
test_updateMap :: IO ()
test_updateMap = 
    do f testMap1 (2,3) Water test_rmap
              where
                  f :: GameMap -> Coord -> Terrain -> GameMap -> IO ()
                  f g c t r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " updateMap " ++ (show g) ++ " " ++ (show c) ++ " " ++ (show t)
                        rhs = " == " ++ (show val)
                        val = updateMap g c t
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"


test_openmap :: GameMap
test_openmap = GameMap [ [f,f,f,w,w],
                         [f,r,f,f,w],
                         [f,w,w,o,w],
                         [f,o,f,f,w],
                         [f,w,w,w,w],
                         [f,f,f,f,f]
                      ]
                   where f = Floor
                         w = Wall
                         x = Door Closed
                         o = Door Open
                         r = Water

-- |Run some tests for tryOpenDoor (Q11).
test_tryOpenDoor :: IO ()
test_tryOpenDoor = 
    do f testMap1 (3,1) North testMap1
       f testMap1 (3,1) West testMap1
       f testMap1 (3,1) East testMap1
       f testMap1 (3,1) South test_openmap
              where
                  f :: GameMap -> Coord -> Dir -> GameMap -> IO ()
                  f g c d r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " tryOpenDoor " ++ (show g) ++ " " ++ (show c) ++ " " ++ (show d)
                        rhs = " == " ++ (show val)
                        val = tryOpenDoor g c d
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for renderTerrain (Q12).
test_renderTerrain :: IO ()
test_renderTerrain = 
    do f Floor '.'
       f Wall '#'
       f Water '~'
       f (Door Open) '-'
       f (Door Closed) '+'
              where
                  f :: Terrain -> Char -> IO ()
                  f c r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " renderTerrain " ++ (show c)
                        rhs = " == " ++ (show val)
                        val = renderTerrain c
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for renderMap (Q12).
test_renderMap :: IO ()
test_renderMap = 
    do f testMap1 "...##\n.~..#\n.##+#\n.-..#\n.####\n.....\n"
       f testMap2 "...\n...\n...\n"
       f testMap3 "#####\n#...#\n#.~.#\n#...#\n#####\n"
              where
                  f :: GameMap -> String -> IO ()
                  f g r = Excep.catch (putStrLn $ (yn (val == r)) ++ lhs ++ rhs) handler
                    where
                        lhs = " renderMap " ++ (show g)
                        rhs = " == " ++ (show val)
                        val = renderMap g
                        handler :: Excep.ErrorCall -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"

-- |Run some tests for loadMap (Q13).
test_loadMap :: IO ()
test_loadMap = 
    do f "map1.txt" (Just testMap1)
       f "map2.txt" (Just testMap2)
       f "map3.txt" (Just testMap3)
       f "no_such_file_i_hope_nothing_clashes.txt" Nothing
       f "map4broken.txt" Nothing   -- contains invalid char
              where
                  f :: String -> Maybe GameMap -> IO ()
                  f fn r = Excep.catch (do val <- loadMap fn
                                           if val == r
                                           then putStrLn $ (yn True) ++ lhs ++ ": Returns expected value."
                                           else putStrLn $ (yn False) ++ lhs ++ ": Returned value not equal to expected value, check manually."
                           ) handler
                    where
                        lhs = " loadMap " ++ (show fn)
                        handler :: Excep.SomeException -> IO ()
                        handler ex = putStrLn $ (yn False) ++ lhs ++ " ** Exception occured **"
                                        


-- No test for Q14 as there as no exact answer is specified.

-- No test for Q15 as that is a non-function based question.

-- |Run this to run all tests at once.
testAll :: IO()
testAll = sequence_ [test_getHeight, test_getWidth,
                     test_isInBounds,
                     test_offsetCoord,
                     test_getTile,
                     test_isPassable,
                     test_move,
                     test_newPlayer,
                     test_playerStatus,
                     test_pickupItem,
                     test_updateMap,
                     test_tryOpenDoor,
                     test_renderTerrain,
                     test_renderMap,
                     test_loadMap
                     ]
