Class {
	#name : #SDSnapProjectListCall,
	#superclass : #SnapDumpCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapProjectListCall class >> pattern [
	^ #( 'snaps' '*' )
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
