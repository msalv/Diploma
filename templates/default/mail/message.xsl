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
        <xsl:text>Сообщение</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Message">
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
            
            <!-- Messages -->
            
            <div id="meta">
                <xsl:apply-templates select="meta" />
                <xsl:text><![CDATA[]]></xsl:text>
            </div>
          
            <!-- Message -->
            
                <legend>
                    <xsl:apply-templates select="." mode="subject" />
                </legend>
                
                <xsl:apply-templates select="." mode="show" />
                
                <!-- Reply form -->
                
                <hr />
                
                <form method="POST" class="well" id="reply">
                    <xsl:attribute name="action">
                        <xsl:text>/mail/to/</xsl:text>
                        <xsl:apply-templates select="." mode="reply-to" />
                    </xsl:attribute>
                    <input type="text" class="input-xlarge" name="subject" id="subject" placeholder="Тема письма">
                        <xsl:attribute name="value">
                            <xsl:text>Re: </xsl:text>
                            <xsl:apply-templates select="." mode="subject" />
                        </xsl:attribute>
                    </input>
                    <textarea placeholder="Напишите ответ..." style="width:98%;" rows="3" name="content" id="content">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </textarea>
                    <button class="btn btn-info" type="submit">Отправить</button>
                    <a class="btn" type="submit" href="/uploads" id="attach">Прикрепить</a>
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
    
    
    <xsl:template mode="show" match="Message">
        
        <div class="row">
            <div class="span1">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-50"/>
                </a>
            </div>
            <div class="span8">
                <xsl:value-of select="content" disable-output-escaping="yes" />
        
                <p>
                    <small>
                        <xsl:apply-templates select="pub_date" />
                    </small>
                </p>
            </div>
        </div>
        
    </xsl:template>
    
    <xsl:template mode="reply-to" match="Message">
        <xsl:if test="@author_id = $id">
            <xsl:value-of select="@recipient_id"/>
        </xsl:if>
        <xsl:if test="@recipient_id = $id">
            <xsl:value-of select="@author_id"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message[not(subject)]">
        <xsl:text>(без темы)</xsl:text>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message">
        <xsl:value-of select="subject" />
    </xsl:template>

    
</xsl:stylesheet>
