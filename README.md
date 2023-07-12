# Suchey-Brooks Method for Pubic Age Determination
This is an RDFBones ontology extension implementing the Suchey-Brooks method for estimating age at death from the degree of pubic symphysis deterioration (Brooks & Suchey 1990).

Proposed prefix for this ontology: sb

The ontology extension requires the [RDFBones core ontology](https://github.com/RDFBones/RDFBones-O) to work. It implements the elements defined by Brooks & Suchey (1990) and provides general concepts supporting implementation in more concrete research contexts. These need to provide the following exact information:

  * Target material in specimen, specified by some 'anatomical region of interest' (rdfbones:AnatomicalRegionOfInterest)
  * Conclusion about the estimated age at death for a skeletal specimen (subclass of 'pubic age determination conclusion', sb:PubicAgeDeterminationConclusion).

The ontology was produced building on [version 0.1](https://github.com/RDFBones/ExtensionTemplate/releases/tag/v0.1) of the [RDFBones Extension Template](https://github.com/RDFBones/ExtensionTemplate). The code for building the ontology resides on branch [robot](https://github.com/RDFBones/SucheyBrooksPubicAge/tree/robot). It requires the [ROBOT tool for ontology manipulation](http://robot.obolibrary.org/). Run the script [Script-Build_OntologyExtension-Robot.sh](https://github.com/RDFBones/SucheyBrooksPubicAge/blob/robot/Script-Build_OntologyExtension-Robot.sh) with appropriate options to obtain an OWL file as output (run `./Script-Build_OntologyExtension-Robot.sh -h` for instructions).

## Contributing
Issues concerning this repository are organised through the [RDFBones-O issue tracker](https://github.com/RDFBones/RDFBones-O/issues). Please use the ['SucheyBrooksPubicAge' label](https://github.com/RDFBones/RDFBones-O/labels/SucheyBrooksPubicAge) there.

## References
* Brooks, S., & Suchey, J. M. (1990). Skeletal age determination based on the os pubis: a comparison of the Acsádi- Nemeskéri and Suchey-Brooks methods. Human Evolution 5(3), 227-238 . doi:10.1007/BF02437238
