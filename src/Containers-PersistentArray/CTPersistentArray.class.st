"
A CTPersistentArray is a fully persistent, indexed data structure modeled as a complete, fully balanced binary tree. 

Unlike a standard array, every update operation (e.g., `at:put:`) does not modify the existing array; instead, it returns a new version of the CTPersistentArray, while efficiently sharing unchanged nodes with the previous versions. This makes it an ideal data structure for maintaining historical state without heavy memory overhead.

The data structure guarantees optimal logarithmic time complexity - O(log N) - for both access and update operations.

# Structure and Invariants

A CTPersistentArray manages an ordered sequence of nodes (`CTPersistentArrayNode`). The structure of this sequence maintains several invariants that guarantee performance:

1. Strict Balance: The underlying tree structure is always a complete binary tree. This means every node has either 0 children (a leaf) or exactly 2 children (internal node). The depth of the tree is strictly bounded by O(log N).
2. Path Copying Persistence: Update operations are non-destructive. Only the path from the root to the target node is copied (O(log N) nodes), while all other branches are shared with the parent version. This ensures updates are memory-efficient.
3. Indexed Access: Elements are accessed and updated via continuous, non-negative integer indices. Indices are resolved by traversing the tree based on the bits of the target index.

# Key Operations

The core public API consists of:

* creation: use `CTPersistentArray class>>#buildFrom:` to instantiate a persistent array from a standard Smalltalk collection.
* accessing: use `at:version:` to retrieve a value from any arbitrary, historical version of the array by its version identifier.
* updating: use `at:put:` to generate a new, updated version of the array. The method does *not* modify the receiver but returns the new root version.

# Complexity Analysis

| Operation | Complexity | Note |
| --- | --- | --- |
| Access | O(log N) | Strictly bounded by tree height. |
| Update | O(log N) | Generates a new version, sharing most data. |
| Creation | O(N) | Optimal construction complexity. |
| Space | O(log N) | Only paths are copied per update. |

# Usage Example

Here is a basic example demonstrating persistence:

```smalltalk
""1. Create the initial version from a collection""
v1 := CTPersistentArray buildFrom: #( 'Apple' 'Banana' 'Cherry' ). 

""2. Access elements (current latest version)""
v1 at: 0 version: v1 latestVersion. ""=> 'Apple'""

""3. Non-destructive update: create version 2""
v2 := v1 at: 0 put: 'Avocado'.

""4. Both versions coexist independently""
v1 at: 0 version: v1 latestVersion. ""=> 'Apple'""
v2 at: 0 version: v2 latestVersion. ""=> 'Avocado'""
```
"
Class {
	#name : 'CTPersistentArray',
	#superclass : 'Object',
	#instVars : [
		'roots',
		'size',
		'array'
	],
	#category : 'Containers-PersistentArray',
	#package : 'Containers-PersistentArray'
}

{ #category : 'instance creation' }
CTPersistentArray >> buildFrom: aCollection [
	| initialArray |
	initialArray := aCollection asArray. 
	
	size := initialArray size.
	roots := OrderedCollection new.
	
	"Start the recursion from index 1 to the end"
	roots add: (self buildTreeFrom: initialArray left: 1 right: size).
]

{ #category : 'private' }
CTPersistentArray >> buildTreeFrom: anArray left: leftIndex right: rightIndex [
	| mid leftNode rightNode parentNode |
	
	leftIndex > rightIndex ifTrue: [ ^ nil ].
	
	"Base case: return a Leaf Node"
	leftIndex = rightIndex ifTrue: [ 
		^ CTPersistentLeafNode new 
			value: (anArray at: leftIndex);
			yourself ].
			
	"Recursive case: split and build an Internal Node"
	mid := (leftIndex + rightIndex) // 2.
	
	leftNode := self buildTreeFrom: anArray left: leftIndex right: mid.
	rightNode := self buildTreeFrom: anArray left: mid + 1 right: rightIndex.
	
	parentNode := CTPersistentInternalNode new.
	parentNode leftChild: leftNode.
	parentNode rightChild: rightNode.
	
	^ parentNode
]

{ #category : 'accessing' }
CTPersistentArray >> latestVersion [
	"Return the index of the last root in our history"
	^ roots size - 1
]

{ #category : 'accessing' }
CTPersistentArray >> size [
	"Return the number of elements in the array"
	^ size
]
