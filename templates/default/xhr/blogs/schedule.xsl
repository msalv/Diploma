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
    <xsl:import href="../../forms.xsl" />
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />
    
    <!-- Schedule information  -->
       
    <xsl:template match="Blog">
           
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
            
            <xsl:if test="@type != 3">
                <div class="alert alert-info">
                    <b>Внимание! </b> Расписание буде активировано, только если группа будет студенческой
                </div>
            </xsl:if>
            
            <xsl:if test="string(schedule)">
                <div class="alert">
                    В этой группе уже есть расписание
                </div>
            </xsl:if>
          
            <!-- Settings -->
            
            <form class="form-horizontal" method="POST" action="/groups/{@id}/admin/schedule" enctype="multipart/form-data">
                <fieldset>
                <legend>
                    <a href="/groups/{@id}" class="btn pull-right">
                        <i class="icon-arrow-left"><xsl:text><![CDATA[]]></xsl:text></i>
                        <xsl:text> к группе</xsl:text>
                    </a>
                    Расписание
                </legend>
                                   
                    <div class="control-group">
                        <label for="profile_picture" class="control-label">
                            Файл расписания
                        </label>
                        <div class="controls">
                            <input type="file" class="input-xlarge" id="xml_file" name="xml_file" />
                            <p><small>Максимальный размер — 2 МБ.<br/>Допустимый формат: XML</small></p>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button class="btn btn-inverse" type="submit">Сохранить</button>
                    </div>
                    
                </fieldset>
            </form>
                       
    </xsl:template>
    
</xsl:stylesheet>
