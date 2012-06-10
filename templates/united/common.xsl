<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : forms.xsl
    Created on : March 20, 2012, 2:28 PM
    Author     : msalv
    Description:
        Holds named templates for common forms elements
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

    <!--
        Full name templates
    -->
    
    <!-- Middle name is not set -->
       
    <xsl:template mode="full-name" match="Person[not(middle_name)]">
        <xsl:value-of select="concat(first_name, ' ', last_name)"/>
    </xsl:template>
    
    <!-- Middle name is set -->
    
    <xsl:template mode="full-name" match="Person">
        <xsl:value-of select="concat(first_name, ' ', middle_name, ' ', last_name)"/>
    </xsl:template>
    
    <!-- 
        Profile picture templates 
    -->
    
    <!-- Profile picture is not set -->
    
    <xsl:template mode="profile-picture" match="Person[not(picture_url)]">
        <xsl:apply-templates select="." mode="gender-picture" />
    </xsl:template>
    
    <!-- Female default picture -->
    
    <xsl:template mode="gender-picture" match="Person[@gender='0']">
        <img src="/media/img/female.png" class="thumbnail" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture" match="Person">
        <img src="/media/img/male.png" class="thumbnail" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture" match="Person">
        <img src="/media/userpics/{picture_url}/{@id}.jpg" class="thumbnail" />
    </xsl:template>
    
    <!-- 
        Templates for small user pic 
    -->
    
    <!-- Profile picture is not set -->
    
    <xsl:template mode="profile-picture-50" match="Person[not(picture_url)]">
        <xsl:apply-templates select="." mode="gender-picture-50" />
    </xsl:template>
    
    <!-- Post -->
    <xsl:template mode="profile-picture-50" match="Post[not(author_pic)]">
        <xsl:apply-templates select="." mode="gender-picture-50" />
    </xsl:template>
    
    <!-- Message -->
    <xsl:template mode="profile-picture-50" match="Message[not(author_pic)]">
        <xsl:apply-templates select="." mode="gender-picture-50" />
    </xsl:template>
    
    <!-- Female default picture -->
    
    <xsl:template mode="gender-picture-50" match="Person[@gender='0']">
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Post -->
    <xsl:template mode="gender-picture-50" match="Post[@author_gender='0']">
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Message -->
    <xsl:template mode="gender-picture-50" match="Message[@author_gender='0']">
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture-50" match="Person">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Post -->
    <xsl:template mode="gender-picture-50" match="Post">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Message -->
    <xsl:template mode="gender-picture-50" match="Message">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture-50" match="Person">
        <img src="/media/thumbs/{picture_url}/{@id}.jpg" class="profile-small" />
    </xsl:template>
    
    <xsl:template mode="profile-picture-50" match="Post">
        <img src="/media/thumbs/{author_pic}/{@author_id}.jpg" class="profile-small" />
    </xsl:template>
    
    <xsl:template mode="profile-picture-50" match="Message">
        <img src="/media/thumbs/{author_pic}/{@author_id}.jpg" class="profile-small" />
    </xsl:template>   
    
    <!-- 
        Templates for mini user pic 
    -->
    
    <!-- Profile picture is not set -->
       
    <!-- Comment -->
    <xsl:template mode="profile-picture-25" match="Comment[not(author_pic)]">
        <xsl:apply-templates select="." mode="gender-picture-25" />
    </xsl:template>
    
    <!-- Female default picture -->
       
    <!-- Post -->
    <xsl:template mode="gender-picture-25" match="Comment[@author_gender='0']">
        <img src="/media/img/female_50.png" class="profile-mini" />
    </xsl:template>
    
    <!-- Male default picture -->
       
    <!-- Post -->
    <xsl:template mode="gender-picture-25" match="Comment">
        <img src="/media/img/male_50.png" class="profile-mini" />
    </xsl:template>
    
    <!-- Profile picture is set -->
        
    <xsl:template mode="profile-picture-25" match="Comment">
        <img src="/media/thumbs/{author_pic}/{@author_id}.jpg" class="profile-mini" />
    </xsl:template>   
    
    <!-- 
        Messages 
    -->
    
    <xsl:template match="meta">
        <xsl:apply-templates select="message" />
    </xsl:template>
    
    <xsl:template match="message">
        <div class="alert alert-{@type}">
            <xsl:apply-templates select="header"/>
            <xsl:value-of select="text()" />
        </div>
    </xsl:template>
    
    <xsl:template match="header">
        <h4 class="alert-heading">
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    
    <!-- 
        Comments link 
    -->
    
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
        Post date 
    -->
    
    <xsl:template match="pub_date">
        <xsl:value-of select="number(@day)" />
        <xsl:text> </xsl:text>
        
        <xsl:apply-templates select="document('calendar.xml')/months/item">
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
    
    <!-- Profile pictures in a block -->
    
    <xsl:template match="Person" mode="thumb">
        <li class="span1">
            <a href="/people/{login}" class="thumbnail" data-id="{@id}">
                <xsl:attribute name="title">
                    <xsl:apply-templates select="." mode="full-name" />
                </xsl:attribute>
                <xsl:apply-templates mode="profile-picture-50" select="." />
            </a>
        </li>
    </xsl:template>
    
    <!-- 
        Scripts
     -->
     
    <xsl:template name="user-sidebar">
        <xsl:param name="login" />
        
        <script>
            // sidebar
            (function($){

                var user = '<xsl:value-of select="$login"/>',
                    $friends_block = $('div#sidebar-friends'),
                    $groups_block = $('div#sidebar-groups');
                    
                $friends_block.load('/people/' + user + '/friends?mode=block', 
                    function() {
                    
                        $('h3 a', $friends_block).on('click', function(e) {
                            $('a[data-target="#friends"]').tab('show');
                            e.preventDefault();
                        });
                        
                    }
                );
                
                $groups_block.load('/people/' + user + '/groups?mode=block', 
                    function() {
                    
                        $('h3 a', $groups_block).on('click', function(e) {
                            $('a[data-target="#groups"]').tab('show');
                            e.preventDefault();
                        });
                        
                    }
                );
                
            <xsl:if test="$login = $username">
            var $requests_block = $('div#sidebar-requests');

                $requests_block.load('/people/friends/requests?mode=block', 
                function() {

                    $('h3 a', $requests_block).on('click', function(e) {
                        $('a[data-target="#requests"]').tab('show');
                        e.preventDefault();
                    });

                }
            );
            </xsl:if>

            })(jQuery);
        </script>
        
    </xsl:template>
    
    <!-- Blog sidebar -->
    
    <xsl:template name="blog-sidebar">
        <xsl:param name="id" />
        
        <script>
            // sidebar
            (function($){

                var id = '<xsl:value-of select="$id"/>',
                    $subs_block = $('div#sidebar-subs'),
                    $events_block = $('div#sidebar-events');
                    
                $subs_block.load('/groups/' + id + '/subscribers?mode=block');
                $events_block.load('/groups/' + id + '/events?mode=block');

            })(jQuery);
        </script>
        
    </xsl:template>

</xsl:stylesheet>