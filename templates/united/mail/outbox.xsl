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
        <xsl:text>Отправленные</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="dataset">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li>
                    <a href="/mail" data-toggle="tab" data-target="#inbox">Входящие</a>
                </li>
                <li class="active">
                    <a href="/mail/outbox" data-toggle="tab" data-target="#outbox">Отправленные</a>
                </li>
            </ul>
            
        </div>
        <div class="span9">
            
        <div class="tab-content">
            
            <div class="tab-pane fade" id="inbox"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade in active" id="outbox">
            
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- Outbox -->
            
                <legend>
                    Отправленные
                </legend>
                
                <xsl:apply-templates select="." mode="inbox" />
            
            </div>
            
            <div class="tab-pane fade" id="msg"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
                       
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/mail.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    
    
    <xsl:template mode="inbox" match="dataset">
        
        <table class="table">
            <thead>
                <tr>
                    <th>Адресат</th>
                    <th>Тема</th>
                    <th>Дата отправки</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="Message" />
                <xsl:if test="not(string(.))">
                    <xsl:text><![CDATA[]]></xsl:text>
                </xsl:if>
            </tbody>
        </table>        
        
    </xsl:template>
    
    <xsl:template match="Message">
        <tr>
            <td>
                <a href="/people/{author_login}">
                    <xsl:value-of select="author_name" />
                </a>
            </td>
            <td>
                <a href="/mail/msg{@id}" data-toggle="tab" data-target="#msg">
                    <xsl:apply-templates select="." mode="subject" />
                </a>
            </td>
            <td>            
                <xsl:apply-templates select="pub_date" />
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="Message[@unread = '1']">
        <tr>
            <td>
                <strong>
                    <a href="/people/{author_login}">
                        <xsl:value-of select="author_name" />
                    </a>
                </strong>
            </td>
            <td>
                <strong>
                    <a href="/mail/msg{@id}" data-toggle="tab" data-target="#msg">
                        <xsl:apply-templates select="." mode="subject" />
                    </a>
                </strong>
            </td>
            <td>            
                <xsl:apply-templates select="pub_date" />
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message[not(subject)]">
        <xsl:text>(без темы)</xsl:text>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message">
        <xsl:value-of select="subject" />
    </xsl:template>

    
</xsl:stylesheet>
