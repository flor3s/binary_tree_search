# NODE CLASS AND SEARCH METHODS #

class Node
  attr_accessor :value, :parent, :left, :right, :tree

  def initialize(value, parent = nil, left = nil, right = nil, tree = nil)
    @value = value
    @parent = parent
    @left = left
    @right = right 
    @tree = tree
  end
  
  def breadth_first_search(value)
    # uses FIFO w/ queue to search the tree until the value is found (returns the node w/ the value) or the queue is 
    # empty (returns nil)
    queue = [self]
    
    until queue.empty? || queue[0].value == value
      left_child = queue[0].left 
      right_child = queue[0].right
      
      queue << left_child if left_child != nil
      queue << right_child if right_child != nil
      queue.shift
    end
    
    queue.empty? ? nil : queue[0]
  end


  def depth_first_search(value) 
    # uses FILO w/ stack to search the tree until the value is found (returns the node w/ the value) or the stack is 
    # empty (returns nil)
    # stores arrays containing 1) a node 2) whether we've checked the node's left child 3) whether we've checked the 
    # node's right child
    stack = [[self, false, false]]
    until stack.empty?
      stack_top = stack.last
      current_node = stack.last[0]
    
      if current_node.value == value 
        return current_node
      elsif stack_top[1] == false
        stack_top[1] = true 
        stack << [current_node.left, false, false] if current_node.left != nil
      elsif stack_top[1] == true && stack_top[2] == false
        stack_top[2] = true
        stack << [current_node.right, false, false] if current_node.right != nil
      elsif stack_top[1] && stack_top[2]
        stack.pop
      end
    end
    
    nil
  end
    
  def dfs_recursive(value, current_node = self)
    # recursively searches the tree in a depth first manner
    return current_node if current_node.value == value
    
    left = dfs_recursive(value, current_node.left) if current_node.left != nil
    right = dfs_recursive(value, current_node.right) if current_node.right != nil
    
    if left != nil
      return left if left.value == value
    elsif right != nil
      return right if right.value == value
    end
    
    nil
  end
end

# LOCAL METHOD #
  
def build_tree(arr)
  tree = Node.new(arr[arr.length / 2])
  arr = arr[0...arr.length/2] + arr[(arr.length/2 + 1)..(arr.length - 1)]
      
  arr.each_with_index do |value, idx|
    node = Node.new(value)
        
    # search through tree for the first available spot, add node to that spot
    placed = false
    parent = tree
        
    until placed == true
    # i decided not to allow nodes with duplicate values because doing so would complicate the breadth and depth 
    # first searches beyond the scope of what it looks like TOP wants. however, if you want to, you can store the
    # number of occurrences in the node with that value in a local variable and then just have the searches continue 
    # until they find the correct @value and @occurrences. thus:
      if parent.value == value
        placed = true
      elsif parent.value > value && parent.left != nil
        parent = parent.left
      elsif parent.value > value
        parent.left = node
        node.parent = parent
        placed = true
      elsif parent.value < value && parent.right != nil
        parent = parent.right
      elsif parent.value < value
        parent.right = node
        node.parent = parent
        placed = true
      end
    end
  end
  
  tree
end