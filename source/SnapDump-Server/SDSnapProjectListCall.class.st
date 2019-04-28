Class {
	#name : #SDSnapProjectListCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapProjectListCall class >> pattern [
	^ #( 'projects' '*' )
]

{ #category : #public }
SDSnapProjectListCall >> filterBlock [
	^ [ :each | each project = request uri segments second ]
]

{ #category : #public }
SDSnapProjectListCall >> get [
	Transcript show: 'configurations: ', (NeoJSONWriter toStringPretty: self configurations asString); cr.
	self jsonResponse: (self configurations select: self filterBlock). 
	
]
