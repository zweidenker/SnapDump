Class {
	#name : #SDVersionListCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionListCall class >> pattern [
	^ #( 'projects' '*' 'versions' )
]

{ #category : #accessing }
SDVersionListCall >> filterBlock [
	^ [ :each | 
		each project = request uri segments second  and: [ 
			each version = request uri segments third ] ]
]

{ #category : #accessing }
SDVersionListCall >> get [
	self jsonResponse: (self store projectNamed: request uri pathSegments second) versions 
	
]
