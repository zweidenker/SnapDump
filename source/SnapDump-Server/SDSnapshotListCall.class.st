Class {
	#name : #SDSnapshotListCall,
	#superclass : #SDCall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotListCall class >> pattern [
	^ #( 'projects' '*' 'versions' '*' 'snapshots' )
]

{ #category : #accessing }
SDSnapshotListCall >> get [
	self jsonResponse: ((self store projectWithName: request uri pathSegments second) versionWithString: request uri pathSegments fourth) signatures
	
]
