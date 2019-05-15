Class {
	#name : #SDClient,
	#superclass : #SnapDump,
	#category : #'SnapDump-Client'
}

{ #category : #accessing }
SDClient class >> type [
	^ #client
]

{ #category : #accessing }
SDClient >> defaultStoreClass [
	^ SDHTTPStore 
]

{ #category : #accessing }
SDClient >> projectNamed: aString [ 
	^ self store projectNamed: aString
]

{ #category : #accessing }
SDClient >> projectNamed: aString ifAbsent: aBlock [
	^ self store projectNamed: aString ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
SDClient >> projects [
	^ store projects
]

{ #category : #searching }
SDClient >> snapshotWithId: aString [ 
	^ self store snapshotWithId: aString 
]
