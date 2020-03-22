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
	self deny: rootPath hasFiles.
	self assert: rootPath hasDirectories.
	self assert: snapshot projectName equals: 'TestProject'.
	self assert: snapshot versionString equals: '0.1'

]

{ #category : #tests }
SDFileTests >> testSimpleWrite [
	| snapshot root |
	snapshot := self createSimpleSnapshot.
	self deny: rootPath hasFiles.
	self assert: rootPath hasDirectories.
	root := self dummySnapshotRootPath / snapshot exceptionId.
	self assert: (root / snapshot snapshotId , #snap) exists
]
