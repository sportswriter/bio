<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs html"
    version="2.0">
    
    <!-- Transforms html to xml.    -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Vocabs for importing   -->
    <!--<xsl:variable name="vocabDoc" select="document('../inputs/source%20files%20-%20xml/reproductiveCondiitionVocabularies.xml')"/>-->
    
    <xsl:template match="/">
        <doc>
            <xsl:apply-templates select="//html:table[@class='dataModelSectionTable']"/>  
        </doc>
    </xsl:template>
    
    <xsl:template match="html:table[@class='dataModelSectionTable']">
        <section>
            <xsl:attribute name="name" select="preceding::html:p[@class='modelSectionHeading'][1]"></xsl:attribute>
            <xsl:apply-templates select="preceding::html:p[1][@class='dataModelSectionIntroText']"></xsl:apply-templates>
            
            <!-- Process each row containing information about a term/field           -->
            <xsl:apply-templates select="descendant::html:tr[html:td/html:p[@class='fieldName']]"></xsl:apply-templates>
        </section>
    </xsl:template>
    
    <xsl:template match="//html:p[@class='dataModelSectionIntroText']">
        <intro><xsl:value-of select="normalize-space(.)"/></intro>
    </xsl:template>
    
    <xsl:template match="html:tr[html:td/html:p[@class='fieldName']]">
        
        
        <xsl:variable name="name">
            <xsl:apply-templates select="./html:td/html:p[@class='fieldName']"></xsl:apply-templates>
        </xsl:variable>
        <term name="{$name}">
            <xsl:apply-templates select="./html:td/html:p[@class='fieldExample']"></xsl:apply-templates>
            <xsl:apply-templates select="./html:td/html:p[@class='fieldDefinition']"></xsl:apply-templates>
            
            <!-- If there's an embedded vocabulary (in a table) associated with a term/field            -->
            <xsl:apply-templates select="descendant::html:table[@class='vocabTable']"/>  
            
            <xsl:if test="exists(./html:td/html:p[@class='vocabTerm'])">
                <!--   The vocab name will share the same name as the term name with which it is associated             -->
                <vocab name="{$name}">
                    <!-- If there's an embedded vocabulary (that isn't in a table) associated with a term/field           -->
                    <xsl:apply-templates select="./html:td/html:p[@class='vocabTerm']" mode="test"></xsl:apply-templates>
                </vocab>
            </xsl:if>
            
            <!--   If this term is reproductiveCondition, import the two associated vocabularies         -->
            <!--<xsl:if test="normalize-space($name) eq 'reproductiveCondition'">
                
                <!-\-   Import the vocabularies     -\->
                <xsl:copy-of select="$vocabDoc/doc/*"></xsl:copy-of>
            </xsl:if>-->
        </term>
    </xsl:template>
    
    <xsl:template match="//html:p[@class='fieldName']">
        <name><xsl:value-of select="normalize-space(.)"/></name>
    </xsl:template>
    
    <xsl:template match="//html:p[@class='fieldDefinition']">
        <definition><xsl:value-of select="normalize-space(.)"/></definition>
    </xsl:template>
    
    <xsl:template match="//html:p[@class='fieldExample']">
        <example><xsl:value-of select="normalize-space(.)"/></example>
    </xsl:template>
    
    <xsl:template match="//html:table[@class='vocabTable']">
        <xsl:variable name="name">
            <xsl:value-of select="normalize-space(ancestor::html:tr/html:td/html:p[@class='fieldName'])"/>
        </xsl:variable>
        
        <vocab name="{$name}">
            <xsl:apply-templates select="html:tr[html:td/html:p[@class='vocabTerm']]" mode="embedded"></xsl:apply-templates>
        </vocab>
    </xsl:template>
    
    <xsl:template match="//html:tr[html:td/html:p[@class='vocabTerm']]" mode="embedded">
        <xsl:variable name="name">
            <xsl:apply-templates select="./html:td/html:p[@class='vocabTerm']"></xsl:apply-templates>
        </xsl:variable>
        <term name="{normalize-space($name)}">
            <xsl:apply-templates select="./html:td/html:p[@class='vocabTermDefinition']"></xsl:apply-templates>
        </term>
    </xsl:template>
    
    <xsl:template match="html:td/html:p[@class='vocabTermDefinition']">
        <definition><xsl:value-of select="normalize-space(.)"/></definition>
    </xsl:template>
    
    <xsl:template match="//html:td/html:p[@class='vocabTerm']" mode="test">
        <term name="{normalize-space(.)}"></term>
    </xsl:template>
    
    
</xsl:stylesheet>