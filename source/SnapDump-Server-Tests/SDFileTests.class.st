Class {
	#name : #SDFileTests,
	#superclass : #SDServerTests,
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
SDFileTests >> testSimpleRead [
	| snapshot |
	snapshot := self createSimpleSnapshot.
	self assert: rootPath hasFiles.
	snapshot := SDFileSnapshot fromFile: ((rootPath / snapshot id), #fuel) store: snapDump store.
	self assert: snapshot project name equals: 'TestProject'.
	self assert: snapshot version string equals: '0.1'

]

{ #category : #tests }
SDFileTests >> testSimpleWrite [
	| snapshot |
	snapshot := self createSimpleSnapshot.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / snapshot id), #fuel) exists.

]

{ #category : #running }
SDFileTests >> zeroDivide [
	^ [ 1 / 0 ]
	on: Exception 
	do: [ :ex | snapDump storeException: ex ].
]
