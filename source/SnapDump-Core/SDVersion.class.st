Class {
	#name : #SDVersion,
	#superclass : #Object,
	#instVars : [
		'string',
		'project'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDVersion class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(string) ]
]

{ #category : #accessing }
SDVersion class >> string: aString [
	^ self new string: aString
]

{ #category : #comparing }
SDVersion >> <  aVersion [
	| own other |
	own := $. split: string.
	other := $. split: aVersion string.
	self assert: own size = other size.
	own withIndexDo: [ :part :index | 
		 part = (other at: index) ifFalse: [ 
			^ part asNumber < (other at: index) asNumber ] ].
	^ false
]

{ #category : #comparing }
SDVersion >> = aVersion [
	^ string = aVersion string
]

{ #category : #comparing }
SDVersion >> hash [
	^ string hash
]

{ #category : #printing }
SDVersion >> printOn: aStream [
	aStream << string
]

{ #category : #accessing }
SDVersion >> project [
	^ project
]

{ #category : #accessing }
SDVersion >> project: anObject [
	project := anObject
]

{ #category : #removing }
SDVersion >> remove [
	self snapshots 
		do: [ :snapshot | self store removeSnapshot: snapshot ].
	self store removeVersion: self
]

{ #category : #'as yet unclassified' }
SDVersion >> snapshots [
	^ self store snapshotsWithVersion: self
]

{ #category : #'as yet unclassified' }
SDVersion >> store [
	^ project store
]

{ #category : #accessing }
SDVersion >> string [
	^ string
]

{ #category : #accessing }
SDVersion >> string: anObject [
	string := anObject
]
