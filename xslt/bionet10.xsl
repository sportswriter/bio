<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--  Split some terms into labels and definitions - part one.  Couldn't work out how to add the definition element here
            so created an attribute and turned it into a definition element in the following xslt. 
            Kept getting error - can't add attribute nodes to an element using <xsl:attribute> after you've added any child nodes-->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    
    
    <xsl:template match="term/@name[ancestor::term/@name[contains(., 'geogExtent')][1]]
        | term/@name[ancestor::term/@name[contains(., 'vulnerability')][1]]
        | term/@name[ancestor::term/@name[contains(., 'consequence')][1]]
        | term/@name[ancestor::term/@name[contains(., 'PNFFilter')][1]]
        ">
        
        <!--   Copy  ancestor      -->
        <xsl:copy></xsl:copy>
        
        <xsl:analyze-string select="." regex="^([a-zA-Z]+)([\s:\\=]+)([\sa-zA-Z;0-9:()=,]+)">
            <xsl:matching-substring>
                
               <!-- Can't add an element here               -->
               <!-- <definition><xsl:value-of select="regex-group(3)"/></definition>-->
                
                <xsl:attribute name="name"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
                <xsl:attribute name="definition"><xsl:value-of select="regex-group(3)"/></xsl:attribute>
                
            </xsl:matching-substring>
        </xsl:analyze-string>
        
    </xsl:template>
    
    
</xsl:stylesheet>