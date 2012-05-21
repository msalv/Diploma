<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : default.xsl
    Created on : March 17, 2012, 10:21 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
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
                    <xsl:apply-templates mode="title" select="." />
                </title>
                <link href="/media/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
                <link href="/media/bootstrap/css/bootstrap.subnav.css" rel="stylesheet" />
                <link href="/media/styles.css" rel="stylesheet" />
                <xsl:comment>Le HTML5 shim, for IE6-8 support of HTML5 elements</xsl:comment>
                <xsl:comment><![CDATA[[if lt IE 9]><script src="/media/js/html5.js"></script><![endif]]]></xsl:comment>
            </head>
            <body>
                <div class="navbar navbar-fixed-top">
                    <div class="navbar-inner">
                    <div class="container">
                        <a class="brand" href="/">Diploma</a>
                            <ul class="nav">
                                <li><a href="/feed">Лента</a></li>
                                <li><a href="/people">Люди</a></li>
                                <li><a href="/groups">Группы</a></li>
                                <li><a href="/mail">Сообщения</a> <span id="msg-num"><xsl:text><![CDATA[]]></xsl:text></span></li>
                            </ul>
                            <ul class="nav pull-right">
                                <li class="dropdown" id="user-menu">
                                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                        <xsl:value-of select="$name" />
                                        <xsl:text> </xsl:text>
                                        <b class="caret">
                                            <xsl:comment/>
                                        </b>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li><a href="/people/{$username}">Моя страница</a></li>
                                        <li><a href="/people/{$username}/friends">Друзья</a></li>
                                        <li><a href="/settings/">Настройки</a></li>
                                        <li class="divider"><xsl:comment/></li>
                                        <li><a href="/logout/{substring($PHPSESSID, 0, 7)}">Выйти</a></li>
                                    </ul>
                                </li>
                            </ul>
                    </div>
                    </div>
                </div>
                                
                <div class="container">
                    <div class="row">
                        <xsl:apply-templates />
                    </div>
                                       
                    <!-- modal -->
                    
                    <div class="modal hide fade" id="common-modal">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </div>
                    
                </div>
                
                <script src="/media/js/jquery.min.js">
                    <xsl:text><![CDATA[]]></xsl:text>
                </script>
                <script src="/media/bootstrap/js/bootstrap.min.js">
                    <xsl:text><![CDATA[]]></xsl:text>
                </script>
                
                <xsl:apply-templates mode="scripts" select="." />
                
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
