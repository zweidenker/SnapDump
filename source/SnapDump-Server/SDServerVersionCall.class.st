Class {
	#name : #SDServerVersionCall,
	#superclass : #SDOpenAPICall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDServerVersionCall class >> path [
	^ '/version'
]

{ #category : #public }
SDServerVersionCall >> get [	
	response := ZnResponse ok: (
		ZnEntity 
			with: SDServer version
			type: ZnMimeType applicationJson setCharSetUTF8)
]
