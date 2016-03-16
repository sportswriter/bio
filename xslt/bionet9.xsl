<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--  Some term labels begin with a combination of dashes and spaces.  Removes leading dashes & spaces.  -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="term/@name">
        <xsl:analyze-string select="." regex="^([-\s]+)">
            <xsl:non-matching-substring>
                <xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        
    </xsl:template>
    
</xsl:stylesheet>