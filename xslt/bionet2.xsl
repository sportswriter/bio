<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    
    <!--  Removes empty paragraph and span elements    -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <!--  Unicode Character 'MASCULINE ORDINAL INDICATOR' (U+00BA), &#186;  -->
    <xsl:template match="html:span[not(*) and not (matches(., '&#186;' )) 
        and not (matches(., '([a-zA-Z0-9-])' ))   ] ">
    </xsl:template>
    
    <xsl:template match="html:p[not(*) and not (matches(., '&#186;' )) 
        and not (matches(., '([a-zA-Z0-9-])' ))    ] ">
    </xsl:template>
    
</xsl:stylesheet>