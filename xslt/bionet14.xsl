<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    
    <!--  Output the 21 component vocabularies  -->
    <xsl:template match="/">
        <vocabs>
            <xsl:apply-templates select="//term[exists(vocab)]"></xsl:apply-templates>
        </vocabs>
    </xsl:template>
    
    <xsl:template match="//term[exists(vocab)]">
        <xsl:copy-of select="vocab"></xsl:copy-of>
    </xsl:template>
    
</xsl:stylesheet>