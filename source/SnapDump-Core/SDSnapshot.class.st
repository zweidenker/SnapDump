Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'className',
		'selector',
		'exceptionClass',
		'id'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'as yet unclassified' }
SDSnapshot class >> exception: anException [
	^ self new exception: anException
]

{ #category : #accessing }
SDSnapshot >> className [
	^ className
]

{ #category : #accessing }
SDSnapshot >> className: aString [ 
	className := aString
]

{ #category : #accessing }
SDSnapshot >> exceptionClass [
	^ exceptionClass
]

{ #category : #accessing }
SDSnapshot >> exceptionClass: aString [ 
	exceptionClass := aString
]

{ #category : #accessing }
SDSnapshot >> id [ 
	^ id 
]

{ #category : #accessing }
SDSnapshot >> id: anObject [
	id := anObject
]

{ #category : #accessing }
SDSnapshot >> idString [
	^ String streamContents: [ :stream |
		stream 
			<< className << selector << exceptionClass ]
]

{ #category : #'as yet unclassified' }
SDSnapshot >> preparePutRequest: request [
	request headers
		at: 'SnapDump-className' put: className;
		at: 'SnapDump-selector' put: selector;
		at: 'SnapDump-exceptionClass' put: exceptionClass

]

{ #category : #accessing }
SDSnapshot >> selector [
	^ selector
]

{ #category : #accessing }
SDSnapshot >> selector: aString [ 
	selector := aString
]

{ #category : #writing }
SDSnapshot >> writeMetaOn: stream [
	(NeoJSONWriter on: stream) 
		prettyPrint: true;
		nextPut: ({ 
			#className -> className .
			#selector -> selector.
			#exceptionClass -> exceptionClass } asDictionary)
]
