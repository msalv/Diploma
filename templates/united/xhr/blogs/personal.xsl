<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
       
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

    <!-- Wall information  -->
    
    <xsl:template match="/">
        <xsl:apply-templates select="Blog" />
    </xsl:template>
       
    <xsl:template match="Blog">
                      
        <xsl:apply-templates select="." mode="posts" />
            
    </xsl:template>
          
    <!-- 
        Wall template
    -->
    
    <xsl:template mode="posts" match="Blog[not(posts)]">
        <div class="alert alert-info">
            <xsl:apply-templates select="." mode="posts-info" />
        </div>
    </xsl:template>
    
    <xsl:template mode="posts-info" match="Blog[@locked = 0]">
        Здесь ещё никто ничего не написал
    </xsl:template>
    
    <xsl:template mode="posts-info" match="Blog[@locked = 1]">
        <b>Внимание!</b>
        <xsl:text> </xsl:text>
        <xsl:text>На этой стене разрешили писать только друзьям</xsl:text>
    </xsl:template>
    
    <xsl:template mode="posts" match="Blog">
        <xsl:apply-templates select="posts" />
    </xsl:template>
    
    <xsl:template match="posts">
        <xsl:apply-templates select="Post" />
    </xsl:template>
    
    <xsl:template match="Post">
        <div class="row">
            <div class="span1">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates mode="profile-picture" select="." />
                </a>
            </div>
            <div class="span8">
                <p>
                    <a href="/people/{author_login}">
                        <xsl:value-of select="author_name" />
                    </a>
                </p>
                <!--<p>-->
                    <xsl:value-of select="content" disable-output-escaping="yes" />
                <!--</p>-->
                <p>
                    <small>
                        <xsl:apply-templates select="pub_date" />
                        <xsl:text> | </xsl:text>
                            <a href="/people/{/Blog/owners/Person/login}/wall/post/{@id}">
                                <xsl:apply-templates select="." mode="comments" />
                            </a>
                    </small>
                </p>
            </div>
        </div>
        
        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>
    
    <!-- Post date -->
    
    <xsl:template match="pub_date">
        <xsl:value-of select="number(@day)" />
        <xsl:text> </xsl:text>
        
        <xsl:apply-templates select="document('../../calendar.xml')/months/item">
            <xsl:with-param name="month" select="number(@month)"/>
        </xsl:apply-templates>
        
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
        <xsl:text> г. </xsl:text>
        <xsl:value-of select="@hour" />
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@minute" />
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:param name="month" />
        <xsl:if test="position() = $month">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
    
    <!-- Comments link -->
    
    <xsl:template mode="comments" match="Post[@comm_num mod 10 = 1 and @comm_num mod 100 != 11]">
        <xsl:value-of select="@comm_num" />
        <xsl:text> комментарий</xsl:text>
    </xsl:template>
    
    <xsl:template mode="comments" match="Post[@comm_num mod 10 &gt;= 2 and @comm_num mod 10 &lt;= 4 and (@comm_num mod 100 &lt; 10 or @comm_num mod 100 &gt;= 20)]">
        <xsl:value-of select="@comm_num" />
        <xsl:text> комментария</xsl:text>
    </xsl:template>

    <xsl:template mode="comments" match="Post[@comm_num = 0]">
        <xsl:text>Комментировать</xsl:text>
    </xsl:template>

    <xsl:template mode="comments" match="Post">
        <xsl:value-of select="@comm_num" />
        <xsl:text> комментариев</xsl:text>
    </xsl:template>
    
    <!-- 
        Profile picture templates 
    -->
    
    <!-- Profile picture is not set -->
    
    <xsl:template mode="profile-picture" match="Post[not(author_pic)]">
        <xsl:apply-templates select="." mode="gender-picture" />
    </xsl:template>
    
    <!-- Female default picture -->
    
    <xsl:template mode="gender-picture" match="Post[@author_gender='0']">
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture" match="Post">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture" match="Post">
        <img src="/media/thumbs/{author_pic}/{@author_id}.jpg" class="profile-small" />
    </xsl:template>
    
</xsl:stylesheet>
