<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : default.xsl
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
                    <xsl:apply-templates mode="title" />
                </title>
                <link href="/media/bootstrap/css/bootstrap.css" rel="stylesheet" />
                <link href="/media/bootstrap/css/bootstrap.subnav.css" rel="stylesheet" />
                <style><![CDATA[body { padding-top: 60px; }]]></style>
                <xsl:comment>Le HTML5 shim, for IE6-8 support of HTML5 elements</xsl:comment>
                <xsl:comment><![CDATA[[if lt IE 9]><script src="/media/js/html5.js"></script><![endif]]]></xsl:comment>
            </head>
            <body>
                <div class="navbar navbar-fixed-top">
                    <div class="navbar-inner">
                    <div class="container">
                        <a class="brand" href="/">Diploma</a>
                            <ul class="nav">
                                <li><a href="#">Лента</a></li>
                                <li><a href="/people">Люди</a></li>
                                <li><a href="#">Группы</a></li>
                                <li><a href="#">События</a></li>
                            </ul>
                    </div>
                    </div>
                </div>
                
                <div class="container">
                    <div class="row">
                        <xsl:apply-templates />
                    </div>
                </div>
                
                <script src="/media/js/jquery.min.js"><xsl:comment/></script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
