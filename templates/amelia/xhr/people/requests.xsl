<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />
    
    <!-- Person information  -->
       
    <xsl:template match="Person">
        
        <xsl:apply-templates select="." mode="friends-list" />
        
    </xsl:template>
    
    <xsl:template match="Person[@is_respond = 1]">
        <div class="span9">
            <xsl:apply-templates select="meta" />
        </div>
    </xsl:template>
             
    <!-- 
        Friends templates
    -->
    
   
    <xsl:template mode="friends-list" match="Person[not(friends)]">
        <hr />
        <div class="alert">
            <xsl:text>Вам заявок не поступало</xsl:text>
        </div>
    </xsl:template>
    
    <!-- Block mode -->
    
    <xsl:template mode="friends-list" match="Person[@mode = 'block']">
        <xsl:apply-templates select="friends" mode="block" />
    </xsl:template>
    
    <!-- Normal mode -->
    
    <xsl:template mode="friends-list" match="Person">
        <xsl:apply-templates select="friends" />
    </xsl:template>
    
    <xsl:template match="friends">
        <xsl:apply-templates select="Person" mode="friend" />
    </xsl:template>
    
    <xsl:template match="friends" mode="block">
        <hr/>
        <h3>
            <a href="/people/friends/requests">Заявки</a>
        </h3>
        <p><xsl:text><![CDATA[]]></xsl:text></p>
        
        <ul class="thumbnails">
            <xsl:apply-templates select="Person" mode="thumb" />
        </ul>
    </xsl:template>
          
    <!-- 
        Friend templates starts here 
    -->

    <xsl:template mode="friend" match="Person">
        <hr />
        <div class="row">
            <div class="span1">
                <a href="/people/{login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-50" />
                </a>
            </div>
            <div class="span3">
                <p>
                    <a href="/people/{login}">
                        <xsl:apply-templates select="." mode="full-name" />
                    </a>
                </p>
                    <form style="display:inline;" action="/people/friends/requests" method="POST">
                        <input type="hidden" name="id" value="{@id}" />
                        <input type="hidden" name="approved" value="0" />
                        <button class="btn btn" type="submit">Отклонить</button>
                    </form>
                    <form style="display:inline;" action="/people/friends/requests" method="POST">
                        <input type="hidden" name="id" value="{@id}" />
                        <input type="hidden" name="approved" value="1" />
                        <button class="btn btn-info" type="submit">Добавить</button>
                    </form>
            </div>
            <div class="span5">
                <xsl:apply-templates select="info" />
            </div>
        </div>
    </xsl:template>
    
    <!-- Request message -->

    <xsl:template match="info">
        <p><small>Прикреплённое сообщение</small></p>
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>

</xsl:stylesheet>