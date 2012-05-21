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
        <xsl:text>Владельцы</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Blog">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li class="active">
                    <a href="/groups/{@id}/admin/owners" data-toggle="tab" data-target="#owners">Руководство</a>
                </li>
                <li><a href="/groups/{@id}/admin/events" data-toggle="tab" data-target="#events">Мероприятия</a></li>
                <li><a href="/groups/{@id}/admin/settings" data-toggle="tab" data-target="#settings">Настройки</a></li>
            </ul>
            
        </div>
        <div class="span9">
            
        <div class="tab-content">
            <div class="tab-pane fade in active" id="owners">
          
            <!-- Messages -->
            <xsl:apply-templates select="meta" />
            
            <legend>
                <a href="/groups/{@id}" class="btn pull-right">
                    <i class="icon-arrow-left"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> к группе</xsl:text>
                </a>
                Руководство
            </legend>
            
            <ul class="nav nav-pills">
                <li class="active">
                    <a href="#remove" data-toggle="pill">Удалить</a>
                </li>
                <li>
                    <a href="#add" data-toggle="pill">Добавить</a>
                </li>
            </ul>
            
            <div class="pill-content">
            
                <div class="pill-pane fade" id="add">
                    <div class="alert alert-info">Вы можете пополнить руководство группы, выбрав нужных подписчиков</div>
                    <form method="POST" action="/groups/{@id}/admin/owners/add" id="add-form">
                        <fieldset>
                            
                            <ul class="thumbnails">
                                <xsl:text><![CDATA[]]></xsl:text>
                            </ul>
                            
                            <a class="btn" id="add-owner" href="/groups/{@id}/subscribers">
                                <i class="icon-search"><xsl:text><![CDATA[]]></xsl:text></i> 
                                Выбрать...
                            </a>
                            <button type="submit" class="btn btn-inverse">
                                <i class="icon-ok icon-white"><xsl:text><![CDATA[]]></xsl:text></i> 
                                Назначить
                            </button>

                        </fieldset>
                    </form>
                </div>
                
                <div class="pill-pane fade in active" id="remove">
                    <form method="POST" action="/groups/{@id}/admin/owners/remove" id="remove-form">
                        <fieldset>
                            <div class="row">
                                <div class="span6">
                                    <ul class="thumbnails" id="markable">
                                        <xsl:apply-templates select="owners" />
                                    </ul>
                                </div>
                                <div class="span3">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="icon-remove icon-white"><xsl:text><![CDATA[]]></xsl:text></i> 
                                        Удалить отмеченных
                                    </button>
                                </div>
                        </div>
                        </fieldset>
                    </form>
                </div>
                
            </div><!-- end pill content -->
            
            </div><!-- end owners -->
            <div class="tab-pane fade" id="events"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade" id="settings"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
                       
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/owners.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        <script src="/media/js/modules/settings.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    
    <xsl:template match="owners">
        <xsl:apply-templates select="Person" mode="thumb" />
    </xsl:template>
    
</xsl:stylesheet>
