Class {
	#name : #SDVersionsCall,
	#superclass : #SnapDumpCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionsCall class >> pattern [
	^ #( 'snaps' '*' '*' )
]

{ #category : #accessing }
SDVersionsCall >> filterBlock [
	^ [ :each | 
		each project = request uri segments second  and: [ 
			each version = request uri segments third ] ]
]

{ #category : #accessing }
SDVersionsCall >> get [
	
	self jsonResponse: (self configurations select: self filterBlock). 
	
]
