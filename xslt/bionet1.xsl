<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xd html"
    version="2.0">
    
    
    <!--  Removes some extraneous sections and class statements from the source document.  Removes some empty elements and cleans up a couple of 
            class statements associated with vocabularies.  -->
    
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="html:head"></xsl:template>
    <xsl:template match="html:img"></xsl:template>
    <xsl:template match="html:a"><xsl:value-of select="."/></xsl:template>
    <xsl:template match="@width | @valign | @align |@rowspan | @colspan | @name | @shape | @lang | @xml:lang | 
        @border | @cellpadding | @cellspacing | @href | @nowrap | @id "></xsl:template>
    <xsl:template match="@class[not (contains(.,'dataModelSectionTable')) and not (contains(.,'dataModelSectionIntroText'))
        and not (contains(.,'fieldDefinition')) and not (contains(.,'fieldExample'))
        and not (contains(.,'fieldName')) and not (contains(.,'fieldRow'))
        and not (contains(.,'modelSectionHeading')) and not (contains(.,'modelSectionTable'))
        and not (contains(.,'vocabTable')) and not (contains(.,'vocabTerm'))
        and not (contains(.,'vocabTermDefinition'))
        ]">
        
    </xsl:template>
    
    <!--not(*) means: not having a child element; not(text()[normalize-space()]) means: not having a text-node with non - white-space-only text.-->
    <xsl:template match="*[not(*) and not(text()[normalize-space()])]"/>
    
    <xsl:template match="html:table/@class[contains(.,'dataModelSectionTable')]">
        <xsl:attribute name="class"><xsl:value-of select="'dataModelSectionTable'"/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="html:table/@class[contains(.,'vocabTable')]">
        <xsl:attribute name="class"><xsl:value-of select="'vocabTable'"/></xsl:attribute>
    </xsl:template>
    
    
    
</xsl:stylesheet>