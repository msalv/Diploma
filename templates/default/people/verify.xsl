<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : auth.xsl
    Created on : March 17, 2012, 10:21 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8" />
                <title>
                    <xsl:text>Вход</xsl:text>
                </title>
                <link href="/media/templates/default/css/bootstrap.min.css" rel="stylesheet" />
                <style><![CDATA[body { padding-top: 60px; }]]></style>
                <xsl:comment>Le HTML5 shim, for IE6-8 support of HTML5 elements</xsl:comment>
                <xsl:comment><![CDATA[[if lt IE 9]><script src="/media/js/html5.js"></script><![endif]]]></xsl:comment>
            </head>
            <body>
                <div class="navbar navbar-fixed-top">
                    <div class="navbar-inner">
                    <div class="container">
                        <a class="brand" href="/">Diploma</a>
                    </div>
                    </div>
                </div>
                
                <div class="container">
                    <div class="row">
       
                        <div class="span8 offset2">
                                               
                        <legend>Проверка</legend>
                        
                        <div class="alert alert-info">Через <b>несколько минут</b> вы получите код подтверждения</div>
                        
                        <xsl:apply-templates select="message" />
                        
                        <form class="form-inline well" method="POST" action="/">
                            <input type="text" class="input-large" id="code" name="code" placeholder="Код" />    
                            <button class="btn" type="submit">ОК</button>
                            <!--<button class="btn btn-large">Выслать другой код</button>-->                            
                        </form>
                        
                        </div>
                        
                    </div>
                </div>
                
                <script src="/media/js/jquery.min.js"><xsl:comment/></script>
                <script src="/media/templates/default/js/bootstrap.min.js"><xsl:comment/></script>
            </body>
        </html>
    </xsl:template>

    <!-- messages -->

    <xsl:template match="message">
        <div class="alert alert-{@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>

</xsl:stylesheet>
