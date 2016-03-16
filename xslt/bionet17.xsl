<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <!--  Output the bionet schema as skos rdf  -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="schemaBaseURI" select="'https://vocabs.ands.org.au/Bionet/schema'"/>
    <xsl:variable name="vocabBaseURI" select="'https://vocabs.ands.org.au/Bionet/vocab/'"/>
    <xsl:variable name="skosConceptSchemeURI" select="'http://www.w3.org/2004/02/skos/core#ConceptScheme'"/>
    <xsl:variable name="skosConceptURI" select="'http://www.w3.org/2004/02/skos/core#Concept'"/>
    <xsl:variable name="creator" select="'Bionet (NSW Office of Environment and Heritage)'"/>
    <xsl:variable name="contributor" select="$creator"/>
    <xsl:variable name="publisher" select="$creator"/>
    <xsl:variable name="subject" select="'species'"/>
    <xsl:variable name="language" select="'en'"/>
    <!--<xsl:variable name="titlePrefix"><xsl:value-of select="'Bionet'"/></xsl:variable>-->
    <xsl:variable name="title">Bionet Species Sighting Standard (RB test v3)</xsl:variable>
    <xsl:variable name="description">For more information about the Bionet Species Sighting Standard, see https://data.bionet.nsw.gov.au/resources/bionet/BioNet-species-sighting-web-service-data-standard.pdf</xsl:variable>
    
   <xsl:template match="/">
       <xsl:apply-templates select="doc"/>
   </xsl:template>
    
    <!--  Concept scheme  -->
    <xsl:template match="doc">
        <rdf:RDF>
            <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
            <rdf:Description rdf:about="{$schemaBaseURI}">
                <rdf:type rdf:resource="{$skosConceptSchemeURI}"/>
                <rdfs:label xml:lang="{$language}"><xsl:value-of select="$title"/></rdfs:label>
                <dcterms:title xml:lang="{$language}"><xsl:value-of select="$title"/></dcterms:title>
                <dcterms:description xml:lang="{$language}"><xsl:value-of select="$description"/></dcterms:description>
                <dcterms:subject xml:lang="{$language}"><xsl:value-of select="$subject"/></dcterms:subject>
                <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
                <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
                <dcterms:publisher><xsl:value-of select="$creator"/></dcterms:publisher>
                <xsl:apply-templates select="section" mode="topConcept"/>
            </rdf:Description>
            <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
            
            <!--  Describe top concepts         -->
            <xsl:apply-templates select="section" mode="conceptDescription"/>
            <!--  Describe narrower concepts of the top concepts that don't have child vocabularies       -->
            <xsl:apply-templates select="section/term[exists(@parentSectionName)]" mode="conceptDescription"/>
            <!--  Describe narrower concepts of the top concepts that do have child vocabularies       -->
            <xsl:apply-templates select="section/term[exists(@childVocabName)]" mode="conceptDescription"/>
            <!--  Describe narrower concepts of the narrower concepts of the top concepts (that don't have child vocabularies)          -->
            <xsl:apply-templates select="section/term/term[not(exists(@childVocabName))]"/>
            <!--  Describe narrower concepts of the narrower concepts of the top concepts (that do have child vocabularies)          -->
            <xsl:apply-templates select="section/term/term[exists(@childVocabName)]"/>
        </rdf:RDF>
    </xsl:template>
   
    <!--  Top concept URIs -->
    <xsl:template match="section" mode="topConcept">
       <skos:hasTopConcept rdf:resource="{concat($schemaBaseURI,'/',@id)}"/>
   </xsl:template>
    
    <!--  Top concept descriptions  -->
    <xsl:template match="section" mode="conceptDescription">
        <rdf:Description rdf:about="{concat($schemaBaseURI,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            
            <skos:topConceptOf rdf:resource="{concat($schemaBaseURI,'/',ancestor::vocab[1]/@name)}"/>
            
            <xsl:apply-templates select="intro"/>
            <xsl:apply-templates select="term" mode="narrower"></xsl:apply-templates>
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!--  NT concepts of top concepts that don't have child vocabularies -->
    <xsl:template match="section/term[exists(@parentSectionName)]" mode="conceptDescription">
        <rdf:Description rdf:about="{concat($schemaBaseURI,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            
            <skos:broader rdf:resource="{concat($schemaBaseURI,'/',@parentSectionID)}"/>
            
            <xsl:apply-templates select="intro"/>
            <xsl:apply-templates select="term" mode="narrower"></xsl:apply-templates>
            <xsl:apply-templates select="definition"/>
            <xsl:apply-templates select="example"/>
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- Describe narrower concepts of the top concepts that do have child vocabularies   -->
    <xsl:template match="section/term[exists(@childVocabName)]" mode="conceptDescription">
        <rdf:Description rdf:about="{concat($schemaBaseURI,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            
            <skos:broader rdf:resource="{concat($schemaBaseURI,'/',ancestor::section[1]/@id)}"/>
            
            <xsl:apply-templates select="definition"/>
            <xsl:apply-templates select="example"/>
            
            <!-- To get the narrower links, read in from the related child vocab file-->
            <xsl:variable name="file"><xsl:value-of select="concat('../output/separate/',@childVocabName,'.rdf')"/></xsl:variable>
            <xsl:variable name="childVocab" select=" if (doc-available($file)) then document($file) else ()"/>
            <xsl:for-each select="$childVocab/rdf:RDF/rdf:Description/skos:hasTopConcept/@rdf:resource">
                <skos:narrowMatch rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    
    <!--  Narrower concepts of the narrower concepts of the top concepts (that don't have child vocabularies)   -->
    <xsl:template match="section/term/term[not(exists(@childVocabID))]">
        <rdf:Description rdf:about="{concat($schemaBaseURI,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            <skos:broader rdf:resource="{concat($schemaBaseURI,'/',ancestor::term[1]/@id)}"/>
            <xsl:apply-templates select="definition"/>
            <xsl:apply-templates select="example"/>
            <!--<xsl:apply-templates select="term" mode="narrower"></xsl:apply-templates>-->
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!--  Narrower concepts of the narrower concepts of the top concepts (that have child vocabularies)   -->
    <xsl:template match="section/term/term[exists(@childVocabID)]">
        <rdf:Description rdf:about="{concat($schemaBaseURI,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            
            <skos:broader rdf:resource="{concat($schemaBaseURI,'/',ancestor::term[1]/@id)}"/>
            
            <xsl:apply-templates select="definition"/>
            <xsl:apply-templates select="example"/>
            
            <!-- To get the narrower links, read in from the related child vocab file-->
            <xsl:variable name="file"><xsl:value-of select="concat('../output/separate/',@childVocabName,'.rdf')"/></xsl:variable>
            <xsl:variable name="childVocab" select=" if (doc-available($file)) then document($file) else ()"/>
            <xsl:for-each select="$childVocab/rdf:RDF/rdf:Description/skos:hasTopConcept/@rdf:resource">
                <skos:narrowMatch rdf:resource="{.}"/>
            </xsl:for-each>
            
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <xsl:template match="definition">
        <skos:definition xml:lang="{$language}"><xsl:value-of select="."/></skos:definition>
    </xsl:template>
    
    <xsl:template match="example">
        <skos:example xml:lang="{$language}"><xsl:value-of select="."/></skos:example>
    </xsl:template>
    
    <xsl:template match="intro">
        <dcterms:description xml:lang="{$language}"><xsl:value-of select="."/></dcterms:description>
    </xsl:template>
    
    <xsl:template match="term" mode="narrower">
        <skos:narrower rdf:resource="{concat($schemaBaseURI,'/',@id)}"/>
    </xsl:template>
    
</xsl:stylesheet>