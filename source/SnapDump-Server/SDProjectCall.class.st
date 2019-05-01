Class {
	#name : #SDProjectCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDProjectCall class >> pattern [
	^ #( 'projects' '*' )
]

{ #category : #public }
SDProjectCall >> get [
	self halt.
	self jsonResponse: self store projects. 
	
]
