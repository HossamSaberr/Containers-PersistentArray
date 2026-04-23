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
CTPersistentArrayTest >> testAtVersion [
	| data |
	data := #(10 20 30 40 50).
	array buildFrom: data.
	
	self assert: (array at: 1 version: 0) equals: 10.
	self assert: (array at: 3 version: 0) equals: 30.
	self assert: (array at: 5 version: 0) equals: 50.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testBuildFrom [
	| data |
	data := #(10 20 30 40 50).
	array buildFrom: data.
	
	self assert: array size equals: 5.
	self assert: array latestVersion equals: 0.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testPathCopyingUpdate [
	| data |
	data := #(10 20 30 40 50).
	array buildFrom: data.
	
	"Update index 3 from 30 to 999"
	array at: 3 put: 999.
	
	"Verify Version 1 has the new value and correct latest version"
	self assert: array latestVersion equals: 1.
	self assert: (array at: 3 version: 1) equals: 999.
	
	"Verify Version 0 is completely untouched"
	self assert: (array at: 3 version: 0) equals: 30.
	
	"Verify other elements in Version 1 share the old structure"
	self assert: (array at: 4 version: 1) equals: 40.
]
