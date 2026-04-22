"
I am the internal, immutable building block used by `CTPersistentArray`.

I store a value alongside `leftChild` and `rightChild` pointers to maintain the fully balanced binary tree structure. 

To guarantee persistence, I am never mutated in-place. Instead, my `copyAndUpdateAt:withValue:range:` method utilizes path-copying to instantiate a new version of myself, securely sharing untouched child branches with previous historical versions. This ensures strict O(log N) memory overhead per update.
"
Class {
	#name : 'CTPersistentArrayNode',
	#superclass : 'Object',
	#instVars : [
		'value',
		'leftChild',
		'rightChild'
	],
	#category : 'Containers-PersistentArray',
	#package : 'Containers-PersistentArray'
}
