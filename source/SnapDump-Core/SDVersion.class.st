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
SDVersion >> project [
	^ project
]

{ #category : #accessing }
SDVersion >> project: anObject [
	project := anObject
]

{ #category : #'as yet unclassified' }
SDVersion >> signatures [
	^ self store signaturesOfVersion: self
]

{ #category : #'as yet unclassified' }
SDVersion >> snapshots [
	^ self store signaturesOfVersion: self
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
