<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

    <xsl:template match="/">
        <xsl:apply-templates select="dataset"/>
    </xsl:template>
    
    <xsl:template match="dataset">
        <div class="modal-header">
            <button data-dismiss="modal" class="close">×</button>
            <h3>Документы</h3>
        </div>
        <div class="modal-body">
                       
            <iframe src="/uploads" width="500" height="600" frameborder="no">
                <xsl:text><![CDATA[]]></xsl:text>
            </iframe>
        
        </div>
        
        <div class="modal-footer">
            <a class="btn" href="#" data-dismiss="modal">Закрыть</a>
        </div>
    </xsl:template>

</xsl:stylesheet>
