Class {
	#name : #SDVersionCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionCall class >> pattern [
	^ #( 'projects' '*' 'versions' '*' )
]

{ #category : #accessing }
SDVersionCall >> filterBlock [
	^ [ :each | 
		each project = request uri segments second  and: [ 
			each version = request uri segments third ] ]
]

{ #category : #accessing }
SDVersionCall >> get [
	self halt.
	self jsonResponse: (self configurations select: self filterBlock). 
	
]
