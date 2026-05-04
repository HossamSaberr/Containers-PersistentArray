"
I am a custom benchmarking tool designed to measure block execution time and garbage collection (GC) activity precisely.

Standard time profilers can suffer from the observer effect, where adding profiling code changes the execution itself, and they rely on sampling at specific yield points rather than ground truth. 

To avoid this, I wrap a target block of code and use fast primitives (like `Time primMillisecondClock`) to capture highly accurate start and end times. 
I simultaneously track VM parameters to capture both full GC time (large generation cleanup) and incremental/scavenge GC time (small generation cleanup). 

Upon completion, I return a `PersistentArrayBenchmarkerResult` containing the gathered metrics.
"
Class {
	#name : 'PersistentArrayBenchmarker',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'Containers-PersistentArray-Benchmarks',
	#package : 'Containers-PersistentArray-Benchmarks'
}

{ #category : 'as yet unclassified' }
PersistentArrayBenchmarker >> benchmark [

	| executionTime fullGCTime incrementalGCTime |
	fullGCTime := Smalltalk vm totalFullGCTime.
	incrementalGCTime := Smalltalk vm totalIncrementalGCTime.
	executionTime := Time millisecondClockValue.

	block value.

	executionTime := Time millisecondClockValue - executionTime.
	fullGCTime := Smalltalk vm totalFullGCTime - fullGCTime.
	incrementalGCTime := Smalltalk vm totalIncrementalGCTime - incrementalGCTime.

	^ PersistentArrayBenchmarkerResult new
		  executionTime: executionTime;
		  fullGCTime: fullGCTime;
		  incrementalGCTime: incrementalGCTime;
		  yourself
]

{ #category : 'as yet unclassified' }
PersistentArrayBenchmarker >> blockToExcute: aBlock [

	block := aBlock
]
