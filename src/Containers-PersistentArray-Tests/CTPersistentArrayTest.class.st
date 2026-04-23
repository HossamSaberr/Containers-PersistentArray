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
CTPersistentArrayTest >> testAsArray [
	| data |
	data := #(1 2 3).
	array buildFrom: data.
	
	"Create Version 1"
	array at: 2 put: 99.
	
	"Verify Version 0 converted correctly"
	self assert: (array asArrayVersion: 0) equals: #(1 2 3).
	
	"Verify default convert the latest version"
	self assert: array asArray equals: #(1 99 3).
]

{ #category : 'tests' }
CTPersistentArrayTest >> testAt [
	| data |
	data := #(10 20 30).
	array buildFrom: data.
	
	"Update the array to create Version 1"
	array at: 2 put: 999.
	
	"Verify default 'at:' reads from Version 1"
	self assert: (array at: 2) equals: 999.
	self assert: array first equals: 10.
	self assert: array last equals: 30.
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
CTPersistentArrayTest >> testCopy [
	| data copyArray |
	data := #(10 20 30).
	array buildFrom: data.
	
	copyArray := array copy.
	
	"Verify the copy is the exact same instance in memory"
	self assert: copyArray identicalTo: array.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testDo [
	| data collected |
	data := #(1 2 3 4).
	array buildFrom: data.
	
	"Update to create Version 1"
	array at: 3 put: 99.
	
	"should read Version 1"
	collected := Array streamContents: [ :stream | 
		array do: [ :each | stream nextPut: each ] ].
	self assert: collected equals: #(1 2 99 4).
	
	"should read Version 0"
	collected := Array streamContents: [ :stream | 
		array do: [ :each | stream nextPut: each ] version: 0 ].
	self assert: collected equals: #(1 2 3 4).
]

{ #category : 'tests' }
CTPersistentArrayTest >> testEquality [
	| array2 |
	array buildFrom: #(10 20 30).
	
	array2 := CTPersistentArray new.
	array2 buildFrom: #(10 20 30).
	
	"check they represent the same data"
	self assert: array equals: array2.
	
	"check they are NOT the same in memory"
	self deny: array identicalTo: array2.
	
	"change one and check they are no longer equal"
	array at: 1 put: 99.
	self deny: array equals: array2.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testHash [
	| array2 |
	array buildFrom: #(10 20 30).
	
	array2 := CTPersistentArray new.
	array2 buildFrom: #(10 20 30).
	
	"check hashes are equal for equal objects"
	self assert: array hash equals: array2 hash.
	
	"check hashes are different after an update"
	array at: 1 put: 99.
	self deny: array hash equals: array2 hash.
]

{ #category : 'tests' }
CTPersistentArrayTest >> testOutOfBounds [
	| data |
	data := #(10 20 30).
	array buildFrom: data.
	
	"reading out of bounds"
	self should: [ array at: 4 ] raise: SubscriptOutOfBounds.
	self should: [ array at: 0 ] raise: SubscriptOutOfBounds.
	
	"writing out of bounds"
	self should: [ array at: 5 put: 99 ] raise: SubscriptOutOfBounds.
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
