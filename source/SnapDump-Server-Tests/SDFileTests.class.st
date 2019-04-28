Class {
	#name : #SDFileTests,
	#superclass : #SDTests,
	#category : #'SnapDump-Server-Tests'
}

{ #category : #running }
SDFileTests >> setUp [ 
	super setUp.
	"SnapDump current stub store willReturn: store."
]

{ #category : #running }
SDFileTests >> store [ 
	^ self filesystemStore
]

{ #category : #tests }
SDFileTests >> testSimpleWrite [
	| snapshot |
	snapshot := self zeroDivide.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / snapshot id), #fuel) exists.

]

{ #category : #running }
SDFileTests >> zeroDivide [
	^ [ 1 / 0 ]
	on: Exception 
	do: [ :ex | snapDump handleException: ex ].
]
