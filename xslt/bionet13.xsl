<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- For each vocabulary, add attributes for parent section and parent term - names and IDs
        For each parent term of a vocabulary, add attributes for child vocabulary - names and IDs 
        For each section/term, add a parent section attribute - name and ID.  I don't know whether this will be useful later
    -->
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="vocab/@id">
        <!--  Copy before adding an attribute     -->
        <xsl:copy></xsl:copy>
        <xsl:attribute name="parentSectionName"><xsl:value-of select="ancestor::section[1]/@name"/></xsl:attribute>
        <xsl:attribute name="parentSectionID"><xsl:value-of select="ancestor::section[1]/@id"/></xsl:attribute>
        <xsl:attribute name="parentTermName"><xsl:value-of select="ancestor::term[1]/@name"/></xsl:attribute>
        <xsl:attribute name="parentTermID"><xsl:value-of select="ancestor::term[1]/@id"/></xsl:attribute>
    </xsl:template>
    
    <!--  Terms that have a child vocabulary  -->
    <xsl:template match="term[exists(vocab)]/@id">
        <!--<xsl:message>term name: <xsl:value-of select="../@name"/></xsl:message>
        <xsl:message>vocab name: <xsl:value-of select="../vocab/@name"/></xsl:message>
        <xsl:message>==========</xsl:message>-->
        
        <xsl:copy></xsl:copy>
        
        <xsl:attribute name="childVocabName"><xsl:value-of select="../vocab/@name"/></xsl:attribute>
        <xsl:attribute name="childVocabID"><xsl:value-of select="../vocab/@id"/></xsl:attribute>
        
    </xsl:template>
    
    <!-- Terms that don't have a child vocabulary   -->
    <xsl:template match="section/term[not(exists(vocab))]/@id">
        <xsl:copy></xsl:copy>
        <xsl:attribute name="parentSectionName"><xsl:value-of select="ancestor::section[1]/@name"/></xsl:attribute>
        <xsl:attribute name="parentSectionID"><xsl:value-of select="ancestor::section[1]/@id"/></xsl:attribute>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>