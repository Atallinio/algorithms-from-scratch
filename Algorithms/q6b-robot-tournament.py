class Solution(object):
    def lastRobotHP(self, hp):
        """
        hp type: List[int]
        return type: int
        """

        # Base case
        if len(hp) == 0 or len(hp) == 1:
            return hp

        # Get the largest value in the array
        maximum = max(hp)
        hp.remove(maximum)

        # Get the second largest value in the array
        second_maximum = max(hp)
        hp.remove(second_maximum)

        # Calculate the difference between the two hp's 
        difference = maximum - second_maximum
        if difference > 0:
            hp.append(difference)
        
        self.lastRobotHP(hp)

        return 0 if len(hp) == 0 else hp[0]

hp = [54,1,23,66,178,51,60,32,15,90,5]
sol = Solution()

solution = sol.lastRobotHP(hp)
print(solution)
