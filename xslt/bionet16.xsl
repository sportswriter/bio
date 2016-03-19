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
    
    <!--  Output 21 skos rdf vocabularies  -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
   <!-- <xsl:variable name="schemaBaseURI" select="'https://vocabs.ands.org.au/Bionet/schema'"/>-->
    <xsl:variable name="vocabBaseURI" select="'http://104.244.76.201/Bionet-ANDS-test/vocab/'"/>
    <xsl:variable name="skosConceptSchemeURI" select="'http://www.w3.org/2004/02/skos/core#ConceptScheme'"/>
    <xsl:variable name="skosConceptURI" select="'http://www.w3.org/2004/02/skos/core#Concept'"/>
    <xsl:variable name="creator" select="'Bionet (NSW Office of Environment and Heritage)'"/>
    <xsl:variable name="contributor" select="$creator"/>
    <xsl:variable name="publisher" select="$creator"/>
    <xsl:variable name="subject" select="'species'"/>
    <xsl:variable name="language" select="'en'"/>
    <!--<xsl:variable name="titlePrefix"><xsl:value-of select="'Bionet'"/></xsl:variable>-->
    <xsl:variable name="titleSuffix"><xsl:value-of select="'(RB test v3)'"/></xsl:variable>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="vocabs"/>
    </xsl:template>
    
    <xsl:template match="vocabs">
        <xsl:apply-templates select="vocab"/>
    </xsl:template>
    
    <xsl:template match="vocab">
        <xsl:result-document href="../output/separate/{concat(@name,'.rdf')}">
            <rdf:RDF>
                <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
                <rdf:Description rdf:about="{concat($vocabBaseURI,@name)}">
                    <rdf:type rdf:resource="{$skosConceptSchemeURI}"/>
                    <rdfs:label xml:lang="{$language}"><xsl:value-of select="concat('Bionet ',@name,' vocabulary ',$titleSuffix)"/></rdfs:label>
                    <dcterms:title xml:lang="{$language}"><xsl:value-of select="concat('Bionet ',@name,' vocabulary ',$titleSuffix)"/></dcterms:title>
                    <dcterms:description xml:lang="{$language}"><xsl:value-of select="concat('The ',@name, ' vocabulary is used by Bionet to populate the ',@parentTermName,' field within the ', @parentSectionName,' section of the Bionet Species Sighting Standard')"/></dcterms:description>
                    <dcterms:description xml:lang="{$language}"><xsl:value-of select="'For more information about the Bionet Species Sighting Standard, see https://data.bionet.nsw.gov.au/resources/bionet/BioNet-species-sighting-web-service-data-standard.pdf'"/></dcterms:description>
                    <dcterms:subject xml:lang="{$language}"><xsl:value-of select="$subject"/></dcterms:subject>
                    <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
                    <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
                    <dcterms:publisher><xsl:value-of select="$creator"/></dcterms:publisher>
                    <xsl:apply-templates select="term" mode="topConcept"/>
                </rdf:Description>
                <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
                <xsl:apply-templates select="term" mode="conceptDescription"/>
            </rdf:RDF>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="term" mode="topConcept">
        <skos:hasTopConcept rdf:resource="{concat($vocabBaseURI,ancestor::vocab[1]/@name,'/',@id)}"/>
    </xsl:template>
    
    <xsl:template match="term" mode="conceptDescription">
        <rdf:Description rdf:about="{concat($vocabBaseURI,ancestor::vocab[1]/@name,'/',@id)}">
            <rdf:type rdf:resource="{$skosConceptURI}"/>
            <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="@name"/></skos:prefLabel>
            <dcterms:creator><xsl:value-of select="$creator"/></dcterms:creator>
            <dcterms:contributor><xsl:value-of select="$creator"/></dcterms:contributor>
            <skos:topConceptOf rdf:resource="{concat($vocabBaseURI,ancestor::vocab[1]/@name)}"/>
            <xsl:apply-templates select="definition"/>
        </rdf:Description>
        <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <xsl:template match="definition">
        <skos:definition xml:lang="{$language}"><xsl:value-of select="."/></skos:definition>
    </xsl:template>
    
</xsl:stylesheet>