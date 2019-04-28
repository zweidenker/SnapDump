Class {
	#name : #SDStore,
	#superclass : #Object,
	#instVars : [
		'nameStrategy'
	],
	#category : #'SnapDump-Server-Store'
}

{ #category : #lookup }
SDStore class >> withName: aString [
	^ self subclasses detect: [ :each | each storeName = aString ]
]

{ #category : #'as yet unclassified' }
SDStore >> createDebugContextFrom: exception [
	^ exception signalerContext 
]

{ #category : #'instance creation' }
SDStore >> descriptionFor: exception [
	| method |
	method := exception signalerContext sender method.
	^ SDSnapshot new
		className: method classBinding key asString;
		selector: (method selector asString copyWithout: $:);
		exceptionClass: (exception class name)
]

{ #category : #'as yet unclassified' }
SDStore >> descriptionString: snap [
	^ String streamContents: [:stream |
			stream 
				<< snap className
				<< '-'
				<< snap selector
				<< '-'
				<< snap exceptionClass ]
]

{ #category : #testing }
SDStore >> hasSnapshotNamed: aString [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	(self hasSnapshotNamed: snapshot)
		ifFalse: [ self store: snapshot ]
]
