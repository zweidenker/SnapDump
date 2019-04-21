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
		spec package: #'ExceptionReport-Core'.
		spec package: #'ExceptionReport-Rest' with: [ spec requires: #('ExceptionReport-Core' 'ZincHTTPComponents' ) ].
		spec package: #'ExceptionReport-Client'.
		spec baseline: 'ZincHTTPComponents' with: [ 
				spec 
					loads: #('REST');
					repository: 'github://zweidenker/zinc/repository'].
		spec 
			group: 'default' with: #(#'ExceptionReport-Core' );
			group: 'server' with: #( #'ExceptionReport-Rest' );
			group: 'client' with: #( #'ExceptionReport-Client' );
			group: 'core' with: #(#'ExceptionReport-Core' );
			group: 'all' with: #( #'ExceptionReport-Core'  #'ExceptionReport-Rest' #'ExceptionReport-Client' )].

]
