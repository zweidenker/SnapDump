Class {
	#name : #SDFileTests2,
	#superclass : #SDTests,
	#category : #'SnapDump-Tests'
}

{ #category : #running }
SDFileTests2 >> setUp [ 
	super setUp.
	"SnapDump current stub store willReturn: store."
]

{ #category : #running }
SDFileTests2 >> store [ 
	^ SDFilesystemStore new path: rootPath
]

{ #category : #tests }
SDFileTests2 >> testSimpleWrite [
	| snapshot |
	snapshot := self zeroDivide.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / snapshot id), #fuel) exists.

]

{ #category : #running }
SDFileTests2 >> zeroDivide [
	^ [ 1 / 0 ]
	on: Exception 
	do: [ :ex | snapDump handleException: ex ].
]
