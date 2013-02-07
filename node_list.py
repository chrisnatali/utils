class ListNode(object):

    def __init__(self, value):
        self.value = value
        self.nxt = None
        

class LinkedList(object):

    def __init__(self):
        self.head = None
        self.tail = None

    def is_empty(self):
        return self.head == None

    def append(self, value):
        newNode = ListNode(value)
        if self.is_empty():
            self.head = newNode
            self.tail = newNode
        else:
            self.tail.nxt = newNode
            self.tail = newNode

    def cat(self, other):
        if self.is_empty():
            self.head = other.head
            self.tail = other.tail
        else:
            self.tail.nxt = other.head
            self.tail = other.tail

    def __iter__(self):
        node = self.head
        while node:
            yield node.value
            node = node.nxt
          
    def __len__(self):
        return sum(1 for _ in self)


