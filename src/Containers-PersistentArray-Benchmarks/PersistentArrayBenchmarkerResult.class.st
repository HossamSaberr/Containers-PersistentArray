"
I represent the output metrics of a `PersistentArrayBenchmarker` run.

All raw recorded times (`executionTime`, `fullGCTime`, `incrementalGCTime`) are stored in milliseconds. 

I provide a `#relativeGCTime` helper method to calculate the percentage of total execution time that the Virtual Machine spent strictly on garbage collection. 

Interpreting Results:
A high relative GC time (e.g., 30% to 70%) indicates heavy object allocation and a potential memory bottleneck. 
For persistent data structures, this highlights the exact overhead cost of path-copying. 
If memory issues are identified here, a dedicated memory profiler should be used subsequently to pinpoint the exact node allocations.
"
Class {
	#name : 'PersistentArrayBenchmarkerResult',
	#superclass : 'Object',
	#instVars : [
		'executionTime',
		'fullGCTime',
		'incrementalGCTime'
	],
	#category : 'Containers-PersistentArray-Benchmarks',
	#package : 'Containers-PersistentArray-Benchmarks'
}

{ #category : 'accessing' }
PersistentArrayBenchmarkerResult >> executionTime [
    ^ executionTime
]

{ #category : 'as yet unclassified' }
PersistentArrayBenchmarkerResult >> executionTime: anInteger [

	executionTime := anInteger
]

{ #category : 'accessing' }
PersistentArrayBenchmarkerResult >> fullGCTime [
    ^ fullGCTime
]

{ #category : 'as yet unclassified' }
PersistentArrayBenchmarkerResult >> fullGCTime: anInteger [

	fullGCTime := anInteger
]

{ #category : 'accessing' }
PersistentArrayBenchmarkerResult >> incrementalGCTime [
    ^ incrementalGCTime
]

{ #category : 'as yet unclassified' }
PersistentArrayBenchmarkerResult >> incrementalGCTime: anInteger [

	incrementalGCTime := anInteger
]

{ #category : 'accessing' }
PersistentArrayBenchmarkerResult >> relativeGCTime [
    "Prevent ZeroDivide if the code executes in under 1 millisecond"
    executionTime = 0 ifTrue: [ ^ '0.00 %' ].
    
    ^ ((fullGCTime + incrementalGCTime / executionTime * 100) asFloat
           printShowingDecimalPlaces: 2) , ' %'
]
