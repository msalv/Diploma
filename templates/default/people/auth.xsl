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
                <link href="/media/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
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
                        
                        <div class="span2">
                            <xsl:text>&#160;</xsl:text>
                        </div>
                        
                        <div class="span8">
                        
                        <xsl:apply-templates select="message" />
                        
                        <form class="form-horizontal" method="POST" action="/">
                            <fieldset>
                                <legend>Вход</legend>
                                
                                <div class="control-group">
                                    <label class="control-label" for="login">Логин</label>
                                    <div class="controls">
                                        <input type="text" class="input-xlarge" id="login" name="login" />
                                    </div>
                                </div>
                                
                                <div class="control-group">
                                    <label class="control-label" for="password">Пароль</label>
                                    <div class="controls">
                                        <input type="password" class="input-xlarge" id="password" name="password" />
                                    </div>
                                </div>
                                
                                <div class="form-actions">
                                    <button class="btn btn-large btn-inverse" type="submit">Войти</button>
                                    <!--<button class="btn btn-large">Вспомнить пароль</button>-->
                                </div>
                                
                            </fieldset>
                        </form>
                        
                        </div>
                        
                    </div>
                </div>
                
                <script src="/media/js/jquery.min.js"><xsl:comment/></script>
                <script src="/media/bootstrap/js/bootstrap.min.js"><xsl:comment/></script>
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
