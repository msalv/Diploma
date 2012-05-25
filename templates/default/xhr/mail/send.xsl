<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

      
    <!-- Add friend body  -->
       
    <xsl:template match="Person">

            <div class="modal-header">
                <button data-dismiss="modal" class="close">×</button>
                <h3>Отправить сообщение</h3>
            </div>
            <div class="modal-body">
                
            <div id="modal-messages">
                <xsl:text><![CDATA[]]></xsl:text>
            </div>
                
            <form method="POST" action="/mail/to/{@id}">
                <fieldset>
                    
                    <div class="row">
                        <div class="span1">
                            <a href="/mail/to/{@id}" class="thumbnail">
                                <xsl:apply-templates select="." mode="profile-picture-50" />
                            </a>
                        </div>

                        <div class="span5">
                            <input type="text" class="span5" name="subject" id="subject" placeholder="Тема" />
                            <textarea name="content" class="span5" id="content" rows="3" placeholder="Сообщение">
                                <xsl:text><![CDATA[]]></xsl:text>
                            </textarea>
                        </div>
                    </div>
                    
                </fieldset>
            </form>
                
            </div>
            <div class="modal-footer">
                <a class="btn" href="#" data-dismiss="modal">Отмена</a>
                <a class="btn btn-inverse" href="#" id="submit">Отправить</a>
            </div>
            
    </xsl:template>
    
    <!-- messages on resond -->
    
    <xsl:template match="Person[@is_respond = '1']">

        <xsl:apply-templates select="meta" />
            
    </xsl:template>
    
</xsl:stylesheet>
