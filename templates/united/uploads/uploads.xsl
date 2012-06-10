<?xml version="1.0" encoding="UTF-8"?>

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
                <title>Документы</title>
                <link href="/media/templates/united/css/bootstrap.min.css" rel="stylesheet" />
                <xsl:comment>Le HTML5 shim, for IE6-8 support of HTML5 elements</xsl:comment>
                <xsl:comment><![CDATA[[if lt IE 9]><script src="/media/js/html5.js"></script><![endif]]]></xsl:comment>
            </head>
            <body>
                               
                <div class="container-fluid">
                    <div class="row-fluid">
                        
                        <form enctype="multipart/form-data" action="/uploads" method="POST" class="well form-inline">
                            <!--<input name="file-input" id="file-input" class="input-large"/>
                            <button class="btn" type="button" id="file-btn">Обзор...</button>-->
                            <input type="file" name="doc" id="doc" />
                            <button class="btn btn-info" type="submit">Загрузить</button>
                        </form>
                        
                        <xsl:apply-templates select="dataset" />
                    </div>                   
                </div>
                
                <script src="/media/js/jquery.min.js">
                    <xsl:text><![CDATA[]]></xsl:text>
                </script>
                <script>
                    (function($, window, document, undefined) {
                        
                    <!--var fakeClick = function(e) {
                            $('input#doc').click();
                            e.preventDefault();
                        } 
                    
                        $('input#file-input').on('click', fakeClick);
                        $('button#file-btn').on('click', fakeClick);
                        
                        $('input[type=file]').on('change', function() {
                            
                            var val = $(this).val();
                            
                            if (typeof val === "string") {
                                $("input#file-input").val( val );
                            }
                        });
                    -->
                        
                        $('tbody tr').on('click', function(e) {
                                                           
                            var $link = $('a', this),
                                name = $link.text(),
                                url = $link.attr('href');
                                                            
                            window.parent.jQuery('textarea#content').val(function(i,old){
                                                            
                                return old + '\n\n[' + name + '](' + url + ')';
                            
                            });
                            
                            $(this).remove();
                            
                            e.preventDefault();
                        });
                        
                    })(jQuery, window, document);
                </script>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- Docs template -->
    
    <xsl:template match="dataset">
        <table class="table">
            <thead>
                <tr>
                    <th>Название</th>
                    <th>Дата загрузки</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="Doc" />
                <xsl:if test="not(string(.))">
                    <xsl:text><![CDATA[]]></xsl:text>
                </xsl:if>
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template match="Doc">
        <tr id="doc-{@id}">
            <td>
                <i class="icon-file">
                    <xsl:text><![CDATA[]]></xsl:text>
                </i>
                <xsl:text> </xsl:text>
                <a href="{url}" target="_blank">
                    <xsl:value-of select="name"/>
                </a>
            </td>
            <td>
                <xsl:value-of select="upload_date"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
