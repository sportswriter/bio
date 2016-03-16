<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    
    <!-- imports two additional vocabularies concerning reproductiveCondition    -->
    
    <!-- Vocabs for importing   -->
<!--    <xsl:variable name="vocabFlora" select="document('../inputs/source%20files%20-%20xml/reproductiveCondiitionFlora.xml')"/>-->
    <!--<xsl:variable name="vocabFauna" select="document('../inputs/source%20files%20-%20xml/reproductiveCondiitionFauna.xml')"/>-->
    
    
    <xsl:variable name="vocabFlora" select=" if (doc-available('../inputs/source%20files%20-%20xml/reproductiveCondiitionFlora.xml')) 
        then document('../inputs/source%20files%20-%20xml/reproductiveCondiitionFlora.xml') else ()"/>
    <xsl:variable name="vocabFauna" select=" if (doc-available('../inputs/source%20files%20-%20xml/reproductiveCondiitionFauna.xml')) 
        then document('../inputs/source%20files%20-%20xml/reproductiveCondiitionFauna.xml') else ()"/>
    
   
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="term[@name='reproductiveConditionFlora']">
        <term name='reproductiveConditionFlora'>
            <xsl:copy-of select="$vocabFlora/doc/*"></xsl:copy-of> 
        </term>
    </xsl:template>
    
    <xsl:template match="term[@name='reproductiveConditionFauna']">
        <term name='reproductiveConditionFauna'>
            <xsl:copy-of select="$vocabFauna/doc/*"></xsl:copy-of> 
        </term>
    </xsl:template>
    
    
    
    
    
    
</xsl:stylesheet>