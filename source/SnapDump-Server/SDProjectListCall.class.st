Class {
	#name : #SDProjectListCall,
	#superclass : #SDOpenAPICall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDProjectListCall class >> path [
	^ '/projects'
]

{ #category : #public }
SDProjectListCall >> get [
	self jsonResponse: self store projects. 
	
]
