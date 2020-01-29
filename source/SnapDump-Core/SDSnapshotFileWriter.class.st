Class {
	#name : #SDSnapshotFileWriter,
	#superclass : #SDFileFormat,
	#category : #'SnapDump-Core-Base'
}

{ #category : #'instance creation' }
SDSnapshotFileWriter class >> file: aFileReference [
	
	aFileReference parent ensureCreateDirectory.
	^ self on: aFileReference binaryWriteStream 
]

{ #category : #'instance creation' }
SDSnapshotFileWriter class >> on: aStream [

	^ self new initializeStream: aStream 
]

{ #category : #writing }
SDSnapshotFileWriter >> close [
	stream
		flush;
		close.
	
]

{ #category : #writing }
SDSnapshotFileWriter >> write: aByteArray [

	stream 
		nextPutAll: (aByteArray size asByteArrayOfSize: 4);
		nextPutAll: aByteArray
]

{ #category : #writing }
SDSnapshotFileWriter >> writeFuelDump: aSnapshot [

	| byteStream |

	self flag: #TODO.
	"having to write to a bytearray is not performant. We need it to derive the size
	to be written. In a network context the site might be provided from the HTTP Header.
	Need to improve later to be able to stream"
	byteStream := ByteArray new writeStream.
	aSnapshot serializeContextOn: byteStream.
	byteStream flush.
	self write: byteStream contents
	
	
]

{ #category : #writing }
SDSnapshotFileWriter >> writeHeader [
	
	stream 
		nextPutAll: self formatSignature asByteArray;
		nextPut: self formatVersion
]

{ #category : #writing }
SDSnapshotFileWriter >> writeMeta: aSnapshot [

	| metaBytes |
	metaBytes := (NeoJSONWriter toString: aSnapshot) utf8Encoded.
	self write: metaBytes
]

{ #category : #writing }
SDSnapshotFileWriter >> writeRaw: aByteArray [

	stream 
		nextPutAll: aByteArray;
		flush;
		close
]

{ #category : #writing }
SDSnapshotFileWriter >> writeSnapshot: aSnapshot [ 
	
	self 
		writeHeader;
		writeMeta: aSnapshot;
		writeTextualStackTraceFor: aSnapshot;
		writeFuelDump: aSnapshot.
		
	stream
		flush;
		close.
	
]

{ #category : #writing }
SDSnapshotFileWriter >> writeTextualStackTraceFor: aSnapshot [

	self write: (aSnapshot stackTrace) utf8Encoded 
]
