<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- Import forms -->
    <xsl:import href="../forms.xsl" />
    <!-- Import common templates -->
    <xsl:import href="../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />

    <!-- Include base template -->
    <xsl:include href="../default.xsl" />
    
    <xsl:template mode="title" match="/">
        <xsl:text>Удаление друга</xsl:text>
    </xsl:template>
    
    <!-- Remove friend body  -->
    
    <xsl:template match="Person[@is_respond = 1]">
        
        <div class="span5 offset3">
            <xsl:apply-templates select="meta" />
        </div>
        
    </xsl:template>
       
    <xsl:template match="Person">
        <div class="span5 offset3">
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- password -->
            
            <form method="POST" action="/people/remove/{@id}">
                <fieldset>
                <legend>Удаление друга</legend>
                    
                    <div class="row">
                        <div class="span1">
                            <a href="/people/{login}" class="thumbnail">
                                <xsl:apply-templates select="." mode="profile-picture-50" />
                            </a>
                        </div>

                        <div class="span4">
                            <h3>Внимание!</h3>
                            <p>Удаляя пользователя из друзей вы лишаете себя и его доступа к данным доступным только для друзей.</p>
                            <input type="hidden" value="{login}" name="login" />
                        </div>
                    </div>
                                                                              
                    <div class="form-actions" style="text-align:right;">
                        <a class="btn" href="/people/{login}">Отмена</a>
                        <button class="btn btn-danger" type="submit">Удалить</button>
                    </div>
                    
                </fieldset>
            </form>
        </div>
    </xsl:template>
    
    <!-- scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    


</xsl:stylesheet>
