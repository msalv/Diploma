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
                <h3>Удаление друга</h3>
            </div>
            <div class="modal-body">
                
            <div id="modal-messages">
                <xsl:text><![CDATA[]]></xsl:text>
            </div>
                
            <form method="POST" action="/people/remove/{@id}">
                <fieldset>
                    
                    <div class="row">
                        <div class="span1">
                            <a href="/people/{login}" class="thumbnail">
                                <xsl:apply-templates select="." mode="profile-picture-50" />
                            </a>
                        </div>

                        <div class="span5">
                            <h3>Внимание!</h3>
                            <p>Удаляя пользователя из друзей вы лишаете себя и его доступа к данным доступным только для друзей.</p>
                            <input type="hidden" value="{login}" name="login" />
                        </div>
                    </div>
                    
                </fieldset>
            </form>
                
            </div>
            <div class="modal-footer">
                <a class="btn" href="#" data-dismiss="modal">Отмена</a>
                <a class="btn btn-danger" href="#" id="submit">Удалить</a>
            </div>
            
    </xsl:template>
    
    <!-- messages on resond -->
    
    <xsl:template match="Person[@is_respond = '1']">

        <xsl:apply-templates select="meta" />
            
    </xsl:template>
    
    <!-- scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    


</xsl:stylesheet>
