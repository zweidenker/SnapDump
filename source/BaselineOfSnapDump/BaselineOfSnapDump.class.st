Class {
	#name : #BaselineOfSnapDump,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapDump
}

{ #category : #baselines }
BaselineOfSnapDump >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec package: #'SnapDump-Core'.
		spec package: #'SnapDump-Rest' with: [ spec requires: #('SnapDump-Core' 'ZincHTTPComponents' ) ].
		spec package: #'SnapDump-Client'.
		spec baseline: 'ZincHTTPComponents' with: [ 
				spec 
					loads: #('REST');
					repository: 'github://zweidenker/zinc/repository'].
		spec 
			group: 'default' with: #(#'SnapDump-Core' );
			group: 'server' with: #( #'SnapDump-Rest' );
			group: 'client' with: #( #'SnapDump-Client' );
			group: 'core' with: #(#'SnapDump-Core' );
			group: 'all' with: #( #'SnapDump-Core'  #'SnapDump-Rest' #'SnapDump-Client' )].

]
