Class {
	#name : #BaselineOfSnapDump,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapDump
}

{ #category : #baselines }
BaselineOfSnapDump >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: #'SnapDump-Core' with: [ spec requires: #('NeoJSON') ].
		spec package: #'SnapDump-Core-Tests' with: [ spec requires: #('SnapDump-Core') ].
		spec package: #'SnapDump-Handler' with: [ spec requires: #('SnapDump-Core') ].
		spec package: #'SnapDump-Client' with: [ spec requires: #('SnapDump-Handler') ].
		spec package: #'SnapDump-Server' with: [ spec requires: #('SnapDump-Core' 'ZincHTTPComponents' 'OpenAPI') ].
		spec package: #'SnapDump-Server-Tests' with: [ spec requires: #('SnapDump-Server' 'Mocketry' ) ].
		spec package: #'SnapDump-UI' with: [ spec requires: #('SnapDump-Client' ) ].

		spec 
			group: 'default' with: #( server 'handler' client ui tests);
			group: 'handler' with: #( #'SnapDump-Handler' );
			group: 'server' with: #( #'SnapDump-Server' 'Cinic');
			group: 'client' with: #( #'SnapDump-Client' );
			group: 'ui' with: #( #'SnapDump-UI' );
			group: 'core' with: #(#'SnapDump-Core' );
			group: 'tests' with: #('SnapDump-Core-Tests' 'SnapDump-Server-Tests').
			
		self zinc: spec.
		self cinic: spec.
		self openApi: spec.
		self neoJson: spec ]

]

{ #category : #baselines }
BaselineOfSnapDump >> cinic: spec [
	spec baseline: 'Cinic' with: [ 
			spec repository: 'github://zweidenker/Cinic:0.3.1'. ]
]

{ #category : #'as yet unclassified' }
BaselineOfSnapDump >> neoJson: spec [
	spec
		baseline: 'NeoJSON' 
		with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ]
]

{ #category : #baselines }
BaselineOfSnapDump >> openApi: spec [
	spec baseline: 'OpenAPI' with: [ 
			spec 
				repository: 'github://zweidenker/OpenAPI:89789192f4e0755c30c248b787fbcb6b86900b09/source';
				loads: #('REST') ]
]

{ #category : #baselines }
BaselineOfSnapDump >> zinc: spec [ 
	spec baseline: 'ZincHTTPComponents' with: [ 
		spec 
			loads: #('REST');
			repository: 'github://svenvc/zinc/repository']
]
