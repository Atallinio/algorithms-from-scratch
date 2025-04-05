class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class LinkedList():
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
        Add a new node to the list
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

    def getLength(self):
        """
        Get the length of the linked list
        """

        length = 0
        current = self.head

        # Traverse the list from the head until the end
        while current is not None:
            current = current.next
            length += 1

        return length

    def display(self):
        """
        Display the linked list
        """

        current = self.head
        while current:
            print(current.val, end=" -> ")
            current = current.next

        print("None")


def partition(arr, start, end):
    """
    Partition the array using Lomuto's scheme.
    
    Args:
        arr (LinkedList): The linked list to be partitioned.
        start (int): The starting index of the subarray.
        end (int): The ending index of the subarray.
    
    Returns:
        int: The index of the pivot after partitioning.
    """

    # Choose the last element as the pivot
    pivot = arr.getValue(end) 

    # Initialize the boundary index
    i = start - 1 

    for j in range(start, end):
        if arr.getValue(j) <= pivot:
            # Move the boundary
            i += 1
            
            val_1 = arr.getValue(j)
            val_2 = arr.getValue(i)

            # Swap the elements
            arr.setValue(i, val_1)
            arr.setValue(j, val_2)
   
    
    val_1 = arr.getValue(end)
    val_2 = arr.getValue(i + 1)

    # Place the pivot in its correct position
    arr.setValue(i + 1, val_1)
    arr.setValue(end, val_2)

    return i + 1  # Return the pivot index


def quicksort(arr, start, end):
    """
    Sort the array using Quicksort with Lomuto's partitioning.
    
    Args:
        arr (LinkedList): The array to be sorted.
        start (int): The starting index of the subarray.
        end (int): The ending index of the subarray.
    """
    if start < end:
        # Partition the array and get the pivot index
        pivot_index = partition(arr, start, end)

        # Recursively sort the left and right subarrays
        quicksort(arr, start, pivot_index - 1)
        quicksort(arr, pivot_index + 1, end)

# Initialize array
arr = LinkedList()

# Use the from list function to create a linked list from a python list
arr.fromList([1,2,5,3,2,7,8,5,4,6,3,8,66,4,234,54,3])

# Display the linked list
arr.display()

# Sort the list using quicksort
quicksort(arr, 0, arr.getLength()-1) 
arr.display()
