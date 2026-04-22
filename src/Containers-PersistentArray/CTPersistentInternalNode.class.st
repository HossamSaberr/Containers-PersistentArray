"
I am a branch in the persistent array tree.
I hold references to a left and right child. When an update is requested, I clone myself and delegate the update to the appropriate child, maintaining the O(log N) structural sharing.
"
Class {
	#name : 'CTPersistentInternalNode',
	#superclass : 'CTPersistentAbstractNode',
	#instVars : [
		'leftChild',
		'rightChild'
	],
	#category : 'Containers-PersistentArray',
	#package : 'Containers-PersistentArray'
}

{ #category : 'accessing' }
CTPersistentInternalNode >> leftChild: aNode [
	leftChild := aNode
]

{ #category : 'accessing' }
CTPersistentInternalNode >> rightChild: aNode [
	rightChild := aNode
]
