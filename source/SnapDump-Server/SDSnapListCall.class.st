Class {
	#name : #SDSnapListCall,
	#superclass : #SDBasicCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapListCall class >> pattern [
	^ #( 'snaps' )
]

{ #category : #accessing }
SDSnapListCall >> get [
	
	self jsonResponse: (self configurations collect: #project) asSet. 
	
]
