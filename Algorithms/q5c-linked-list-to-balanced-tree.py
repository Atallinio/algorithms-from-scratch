class TreeNode(object):
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class LinkedList:
    def __init__(self):
        # Initially the list is empty
        self.head = None 
    
    def fromList(self, arr):
        """
        Add to curret linked list from list
        Or
        Create new linked list from list
        """
        for value in arr:
            self.addNode(value)

    def addNode(self, value):
        """
        Add a new node to the end of the linked list
        """

        # Create a new node with the value
        new_node = ListNode(value)
        
        # If the list is empty set the head
        if self.head == None:
            self.head = new_node

        else:
            # traverse list until you find next empty node and set to new node
            current = self.head
            while current.next is not None:
                current = current.next

            current.next = new_node 

    def getValue(self, index):
        """
        Get a value in a certain index in the list
        """

        current = self.head
        for _ in range(index):
            # Prevent out of bounds access
            if current is None:
                return None
            current = current.next 

        return current.val

    def setValue(self, index, value):
        """
        Set a value in a certain index in the list
        """

        current = self.head
        for _ in range(index):
            # Prevent out of bounds access
            if current is None:
                return None
            current = current.next 
        
        current.val = value

    def display(self):
        """
        Display the linked list
        """

        current = self.head
        while current:
            print(current.val, end=" -> ")
            current = current.next

        print("None")

class Solution(object):
    def listToBST(self, head):
        """
        head type: Optional[ListNode]
        return type: Optional[TreeNode]
        """

        # Base case: if the list is empty, return None
        if not head:
            return None

        # Get the middle value of the list
        prev_node, middle_node = self.getMiddle(head)
        
        # Set the tree node to the middle value
        node = TreeNode(middle_node.val)  
       
        # if the middle is the head then there is no left node
        if head == middle_node:
            return node
            
        # Recursively call the left and right nodes of the tree
        node.left = self.listToBST(head)
        node.right = self.listToBST(middle_node.next)

        return node 

       
    def getMiddle(self, head):
        # Get the length of the linked list
        length = self.getLength(head)

        if length % 2 == 0:
            middle_index = length // 2

        else:
            middle_index = (length - 1) // 2
        
        # Get the middle node 
        middle_node = self.getNode(head, middle_index)

        # Get the node before the middle node and disconnect from middle node
        prev_node = self.getNode(head, middle_index - 1)
        prev_node.next = None
        
        return prev_node, middle_node

    
    def getLength(self, head):
        """
        Get the length of the linked list
        """

        length = 0
        current = head

        # Traverse the list from the head until the end
        while current is not None:
            current = current.next
            length += 1

        return length

    def getNode(self, head, index):
        """
        Get a value in a certain index in the list
        """

        current = head
        for _ in range(index):
            # Prevent out of bounds access
            if current is None:
                return None
            current = current.next 

        return current

# Create a linked list
ll = LinkedList()
ll.fromList([-10, -3, 4, 2, 65, 23, 0, 5, 9])

# Display the linked list
ll.display()

# Convert the linked list to a BST
solution = Solution()
bst_root = solution.listToBST(ll.head)

# Helper function to print the BST (in-order traversal)
def printBST(node):
    if node:
        printBST(node.left)
        print(node.val, end=" ")
        printBST(node.right)

printBST(bst_root)
