Class {
	#name : #SDProjectListCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDProjectListCall class >> pattern [
	^ #( 'projects' )
]

{ #category : #public }
SDProjectListCall >> get [
	self jsonResponse: self store projects. 
	
]
