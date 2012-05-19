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
        <xsl:text>Добавление друга</xsl:text>
    </xsl:template>
    
    <!-- Add friend body  -->
       
    <xsl:template match="Person">
        <div class="span5 offset3">
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- password -->
            
            <form method="POST" action="/people/add/{@id}">
                <fieldset>
                <legend>Добавление друга</legend>
                    
                    <div class="row">
                        <div class="span1">
                            <a href="/people/{login}" class="thumbnail">
                                <xsl:apply-templates select="." mode="profile-picture-50" />
                            </a>
                        </div>

                        <div class="span4">
                            <textarea name="message" class="input-xlarge" id="message" rows="3" placeholder="Сообщение">
                                <xsl:text><![CDATA[]]></xsl:text>
                            </textarea>
                            <input type="hidden" value="{login}" name="login" />
                        </div>
                    </div>
                                                                              
                    <div class="form-actions" style="text-align:right;">
                        <a class="btn" href="/people/{login}">Отмена</a>
                        <button class="btn btn-inverse" type="submit">Добавить</button>
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
