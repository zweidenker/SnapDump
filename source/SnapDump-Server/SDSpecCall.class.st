Class {
	#name : #SDSpecCall,
	#superclass : #SDOpenAPICall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSpecCall class >> path [
	^ '/spec'
]

{ #category : #public }
SDSpecCall >> get [
	response := ZnResponse ok: (
		ZnEntity 
			with: SnapDumpAPI new specString
			type: ZnMimeType applicationJson setCharSetUTF8)
]
