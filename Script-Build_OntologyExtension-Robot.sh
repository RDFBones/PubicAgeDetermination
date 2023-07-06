#! /bin/bash


## VARIABLES
## =========

cleanup=0
update=0
build=0


## USAGE FUNCTION
## ==============

function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temporary files"
    echo "    -u          initialise/update submodules"
    echo "    -h -?       print this help"

    exit

}

while getopts "bcuh?" opt; do
    case "$opt" in
	c)
	    cleanup=1
	    ;;
	u)
	    update=1
	    ;;
	b)
	    build=1
	    ;;
	?)
	    usage
	    ;;
	h)
	    usage
	    ;;
    esac
done

if [ -z "$1" ]; then
    usage
fi


## SUBMODULES
## ==========

## Check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ]; then
    update=1
    echo "Initialising git submodules"
fi

## Initialise and update git submodules

if [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi


## BUILD ONTOLOGY EXTENSION
## ========================

if [ $build -eq 1 ]; then


    ## DEPENDENCIES
    ## ------------

    ## Build core ontology

    cd dependencies/RDFBones-O/robot/

    ./Script-Build_RDFBones-Robot.sh

    cd ../../../


    ## TEMPLATES
    ## ---------


    ## Create category labels

    robot template --template template-category_labels.tsv \
	  --prefixes prefixes.json \
	  --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --output results/template_CategoryLabels.owl

    robot merge --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --input results/template_CategoryLabels.owl \
	  --output results/merged.owl


    ## Create value specifications

    robot template --template template-value_specifications.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ValueSpecifications.owl

    robot merge --input results/merged.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/merged.owl


    ## Create data items

    robot template --template template-data_items.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataItems.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataItems.owl \
	  --output results/merged.owl
    

    ## Create data sets

    robot template --template template-data_sets.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataSets.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataSets.owl \
	  --output results/merged.owl

    
    ## Create assays

    robot template --template template-assays.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Assays.owl

    robot merge --input results/merged.owl \
	  --input results/template_Assays.owl \
	  --output results/merged.owl


    ## Create data transformations

    robot template --template template-data_transformations.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataTransformations.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataTransformations.owl \
	  --output results/merged.owl


    ## Create Conclusion Processes

    robot template --template template-conclusion_processes.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ConclusionProcesses.owl

    robot merge --input results/merged.owl \
	  --input results/template_ConclusionProcesses.owl \
	  --output results/merged.owl


    ## Create Study Design Execution Processes

    robot template --template template-study_design_executions.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesignExecutions.owl

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesignExecutions.owl \
	  --output results/merged.owl


    ## Create Protocols

    robot template --template template-protocols.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Protocols.owl

    robot merge --input results/merged.owl \
	  --input results/template_Protocols.owl \
	  --output results/merged.owl


    ## Create Study Designs

    robot template --template template-study_designs.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesigns.owl

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesigns.owl \
	  --output results/merged.owl


    ## Create Planning Processes

    robot template --template template-planning.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Planning.owl

    robot merge --input results/merged.owl \
	  --input results/template_Planning.owl \
	  --output results/merged.owl


    ## Create Investigation Processes

    robot template --template template-investigations.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Investigations.owl

    robot merge --input results/merged.owl \
	  --input results/template_Investigations.owl \
	  --output results/merged.owl


    ## CONSISTENCY TEST
    ## ----------------

    robot reason --reasoner ELK \
	  --input results/merged.owl \
	  -D results/debug.owl

    
    ## CLEANUP TEMPORARY FILES
    ## -----------------------

    if [ $cleanup -eq 1 ]; then
	cd results
	find . -not -regex "./merged.owl" -delete
	cd ..
    fi

    
    ## ANNOTATE OUTPUT
    ## ---------------

    robot annotate --input results/merged.owl \
	  --remove-annotations \
	  --ontology-iri "http://w3id.org/rdfbones/ext/sb/latest/sb.owl" \
	  --version-iri "http://w3id.org/rdfbones/ext/sb/v0-1/sb.owl" \
	  --annotation dc:contributor "Stefan Schlager" \
	  --annotation dc:creator "Felix Engel" \
	  --annotation dc:date 2023-07-06 \
	  --language-annotation dc:description "This RDFBones ontology extension implements the Suchey-Brooks method for estimating age at death from the degree of pubic symphysis deterioration in skeletal specimen as outlined by Brooks & Suchey (1990)." en \
	  --annotation dc:source "Brooks, S., & Suchey, J. M. (1990). Skeletal age determination based on the os pubis: a comparison of the Acsádi- Nemeskéri and Suchey-Brooks methods. Human Evolution 5(3), 227-238 . doi:10.1007/BF02437238" \
	  --language-annotation dc:title "Suchey-Brooks Method for Pubic Age Determination" en \
	  --annotation owl:versionInfo "0.1" \
	  --language-annotation rdfs:comment "This RDFBones ontology extension only works in conjunction with the RDFBones core ontology." en \
	  --language-annotation rdfs:label "Suchey-Brooks Method for Pubic Age Determination" en \
	  --output results/sb.owl

    
    ## CLEANUP TEMPORARY FILES
    ## -----------------------

    if [ $cleanup -eq 1 ]; then
	rm results/merged.owl
    fi

fi


## CLEANUP
## =======


## CLEANUP TEMPORARY FILES IN DEPENDENCIES
## ---------------------------------------

FILE=dependencies/RDFBones-O/robot/results/
if [ -f "$FILE" ]; then
    rm -r dependencies/RDFBones-O/robot/results/
fi
