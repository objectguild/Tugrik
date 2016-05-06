queries
insertOperation: dict query: query result: result
  | obj hasOid theOid |
  hasOid := false.
  obj := dict
    at: '_id'
    ifPresent: [ :oid | 
      hasOid := true.
      theOid := oid.
      (query bind: 'oid' to: oid value) qeuryResult
        detect: [ :each | true ]
        ifNone: [ self error: 'Object with id: ' , oid printString , ' not found' ] ].
  obj
    ifNil: [ 
      obj := hasOid
        ifTrue: [ 
          TugrikObject
            basicNew;
            _id: theOid;
            yourself ]
        ifFalse: [ TugrikObject new ].
      dict
        keysAndValuesDo: [ :key :value | 
          key ~= '_id'
            ifTrue: [ 
              | indexSpec |
              (self validateClassForIndexCreation: value class)
                ifTrue: [ 
                  TugrikObject
                    compile:
                      key , ' ^self dynamicInstVarAt: #' , key printString
                    classified: '*generated'.
                  indexSpec := RcEqualityIndexSpecification
                    path: '#' , key
                    lastElementClass: value class.
                  indexSpec createIndexOn: collection ].
              obj
                dynamicInstVarAt: key asSymbol put: value;
                yourself ] ].
      collection add: obj ]