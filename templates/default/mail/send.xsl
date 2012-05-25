<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl date">
    
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
        <xsl:text>Отправить сообщение</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Person">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li><a href="/mail" data-toggle="tab" data-target="#inbox">Входящие</a></li>
                <li><a href="/mail/outbox" data-toggle="tab" data-target="#outbox">Отправленные</a></li>
            </ul>
            
        </div>
        <div class="span9">
            
        <div class="tab-content">
            
            <div class="tab-pane fade" id="inbox"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade" id="outbox"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade in active" id="msg">
            
            <legend>Отправить сообщение</legend>
            
            <!-- Messages -->
            
            <div id="meta">
                <xsl:apply-templates select="meta" />
                <xsl:text><![CDATA[]]></xsl:text>
            </div>
            
            <form method="POST" action="/mail/to/{@id}" id="reply">
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
                    
                    <div class="form-actions span6" style="text-align:right;">
                        <button class="btn btn-inverse" type="submit">Отправить</button>
                    </div>
                    
                </fieldset>
            </form>
            
            </div>
        </div>
                       
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/mail.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    
</xsl:stylesheet>
