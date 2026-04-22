Class {
	#name : 'CTPersistentArrayTest',
	#superclass : 'TestCase',
	#instVars : [
		'array'
	],
	#category : 'Containers-PersistentArray-Tests',
	#package : 'Containers-PersistentArray-Tests'
}

{ #category : 'running' }
CTPersistentArrayTest >> setUp [
	super setUp.
	array := CTPersistentArray new.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testBuildFrom [
	| data |
	data := #(10 20 30 40 50).
	array buildFrom: data.
	
	self assert: array size equals: 5.
	self assert: array latestVersion equals: 0.
]
