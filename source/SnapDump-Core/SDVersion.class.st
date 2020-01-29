Class {
	#name : #SDVersion,
	#superclass : #Object,
	#instVars : [
		'string',
		'project'
	],
	#category : #'SnapDump-Core-Model'
}

{ #category : #accessing }
SDVersion class >> defaultVersionString [

	^ 'unknown'
]

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
	| own other versionPart1 versionPart2 |
	own := $. split: string.
	other := $. split: aVersion string.
	
	1 to: (own size max: other size) do: [ :index | 
		versionPart1 := (own at: index ifAbsent: [0]).
		versionPart2 := (other at: index ifAbsent: [0]).
		 versionPart1 = versionPart2 ifFalse: [ 
			^ versionPart1 asNumber < versionPart2 asNumber ] ].
	^ false
]

{ #category : #comparing }
SDVersion >> = aVersion [
	^ string = aVersion string
]

{ #category : #'accessing - exceptions' }
SDVersion >> exceptions [
	^ self store exceptionsOfVersion: self
]

{ #category : #'accessing - exceptions' }
SDVersion >> exceptionsAt: aString [ 
	^ self 
		exceptionsAt: aString 
		ifAbsent: [ NotFound signal: 'no exception ', aString asString, ' found' ]
		
]

{ #category : #'accessing - exceptions' }
SDVersion >> exceptionsAt: aString ifAbsent: aBlock [
	^ self exceptions 
		detect: [ :each | each string = aString ]
		ifNone: aBlock
		
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

{ #category : #accessing }
SDVersion >> projectName [ 

	^ project name
]

{ #category : #removing }
SDVersion >> remove [

	self store removeVersion: self
]

{ #category : #accessing }
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
