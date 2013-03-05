<?xml version="1.0" encoding="UTF-8"?>

<!--
  template.xsl

  Version: $Revision: 3705 $
 
  Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
 
  Copyright (c) 2002-2005, Hewlett-Packard Company and Massachusetts
  Institute of Technology.  All rights reserved.
 
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:
 
  - Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 
  - Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 
  - Neither the name of the Hewlett-Packard Company nor the name of the
  Massachusetts Institute of Technology nor the names of their
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  DAMAGE.
-->

<!--
    TODO: Describe this XSL file    
    Author: Alexey Maslov
    
-->    

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:output indent="yes"/>
    
    <!-- Copied from ../dri2html/structural.xsl to override for customizations -->
    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>
            <!-- Add stylsheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            
            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            
            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>
            
            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script type="text/javascript">
                                //Clear default text of emty text areas on focus
                                function tFocus(element)
                                {
                                        if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                                }
                                //Clear default text of emty text areas on submit
                                function tSubmit(form)
                                {
                                        var defaultedElements = document.getElementsByTagName("textarea");
                                        for (var i=0; i != defaultedElements.length; i++){
                                                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                                                        defaultedElements[i].value='';}}
                                }
                                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                                function disableEnterKey(e)
                                {
                                     var key;
                                
                                     if(window.event)
                                          key = window.event.keyCode;     //Internet Explorer
                                     else
                                          key = e.which;     //Firefox and Netscape
                                
                                     if(key == 13)  //if "Enter" pressed, then disable!
                                          return false;
                                     else
                                          return true;
                                }
            </script>
            
            <!-- Add theme javascipt  -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>&#160;</script>
            </xsl:for-each>
            
            <!-- add "shared" javascript from static, path is relative to webapp root-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>&#160;</script>
            </xsl:for-each>
            
            
            <!-- Add a google analytics script if the key is present -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
                <script type="text/javascript">
                                        <xsl:text>var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");</xsl:text>
                                        <xsl:text>document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));</xsl:text>
                                </script>
                
                <script type="text/javascript">
                                        <xsl:text>try {</xsl:text>
                                                <xsl:text>var pageTracker = _gat._getTracker("</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>");</xsl:text>
                                                <xsl:text>pageTracker._trackPageview();</xsl:text>
                                        <xsl:text>} catch(err) {}</xsl:text>
                                </script>
            </xsl:if>
            
            
            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />
            <title>
                <xsl:choose>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>
            
            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                    disable-output-escaping="yes"/>
            </xsl:if>
            
            <!-- Add favicon -->
            <link rel="shortcut icon" href="/xmlui/themes/Lobo/images/unm.ico" type="image/x-icon" />
        </head>
    </xsl:template>
    
    <!-- Copied from ../dri2html/structural.xsl to override for customizations -->
    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">
        <div id="unm_header">
            <div class="header_content">
                <div id="skipnav"><a accesskey="2" href="#content" tabindex="1">Skip to Main Content</a> <span class="hide">|</span> <a accesskey="1" href="http://www.unm.edu">UNM Homepage</a> <span class="hide">|</span> <a accesskey="0" href="http://www.unm.edu/accessibility.html">Accessibility Statement</a></div>
                <div class="unm_header_title"><a href="http://www.unm.edu" title="The University of New Mexico">The University of New Mexico</a></div>
                <div id="unm_header_links">
                    <ul title="global UNM navigation">
                        <li><a href="http://www.unm.edu/depart.html" title="UNM A to Z">UNM A-Z</a></li>
                        <li><a href="http://studentinfo.unm.edu" title="StudentInfo">StudentInfo</a></li>
                        <li><a href="http://fastinfo.unm.edu" title="FastInfo">FastInfo</a></li>
                        <li><a href="https://my.unm.edu" title="myUNM">myUNM</a></li>
                        <li><a href="http://directory.unm.edu" title="Directory">Directory</a></li>
                    </ul>
                    <form action="http://google.unm.edu/search" id="unm_search_form" method="get">
                        <fieldset><input name="site" type="hidden" value="UNM" /> <input name="client" type="hidden" value="UNM" /> <input name="proxystylesheet" type="hidden" value="UNM" /> <input name="output" type="hidden" value="xml_no_dtd" /> <input accesskey="4" alt="input search query here" class="search_query" id="unm_search_form_q" maxlength="255" name="q" title="input search query here" type="text" /> <input accesskey="s" alt="search now" class="search_button" id="unm_search_for_submit" name="submit" src="http://webcore.unm.edu/v1/images/search.gif" type="image" value="search" /></fieldset>
                    </form>
                </div>
            </div>
        </div>

        <div>
            <a href="/"><img src="/themes/Lobo/images/LoboVault.gif" alt="LoboVault Home" height="75" id="lobovaultbanner" border="0" /></a>
        </div>

        <!-- Horizontal navigation menu -->
        <div id="hornav">&#160;
<!--
          <ul class="bannernav">
            <li><a href="http://escholar.unm.edu/ejournals.html">eJournals</a></li>
            <li><a href="http://escholar.unm.edu/openaccess.html">Open Access</a></li>
            <li><a href="https://repository.unm.edu/dspace/">LoboVault</a></li>
            <li><a href="http://elibrary.unm.edu/">Libraries</a></li>
            <li  class="lastlink"><a href="http://www.unm.edu/research/">Research</a></li>
          </ul>
-->
        </div>

        <div id="ds-header">
            <h1 class="pagetitle">
                <xsl:choose>
                        <!-- protectiotion against an empty page title -->
                        <xsl:when test="not(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'])">
                                <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/>
                        </xsl:otherwise>
                </xsl:choose>

            </h1>
            <h2 class="static-pagetitle"><i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text></h2>


            <ul id="ds-trail">
                <xsl:choose>
                        <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 0">
                                <li class="ds-trail-link first-link"> - </li>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                        </xsl:otherwise>
                </xsl:choose>
            </ul>

<!--  REMOVED because the elements are provided elsewhere on page
            <xsl:choose>
                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                    <div id="ds-user-box">
                        <p>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='url']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.profile</i18n:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='logoutURL']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                            </a>
                        </p>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div id="ds-user-box">
                        <p>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='loginURL']"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                            </a>
                        </p>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
-->
        </div>
    </xsl:template>    

    <!-- Copied from structural.xsl to override h[eader]1 element size from exceeding 200% -->
    <!-- The font-sizing variable is the result of a linear function applied to the character count of the heading text -->
    <xsl:template match="dri:div/dri:head" priority="3">
        <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <!-- with the help of the font-sizing variable, the font-size of our header text is made continuously variable based on the character count -->
        <xsl:variable name="font-sizing" select="365 - $head_count * 80 - string-length(current())"></xsl:variable>
        <xsl:element name="h{$head_count}">
            <!-- if Community or Collection home page, assign width to allow browse box space -->
            <xsl:variable name="wid">
                <xsl:choose>
                    <xsl:when test="../@n='community-home' or ../@n='collection-home'">
                        <xsl:text> width: 680px;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> width: 100%;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- in case the chosen size is less than 120%, don't let it go below. Shrinking stops at 120% -->
            <xsl:choose>
                <xsl:when test="$font-sizing &lt; 120">
                    <xsl:attribute name="style">font-size: 120%;<xsl:value-of select="$wid"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$font-sizing &gt; 200">
                    <xsl:attribute name="style">font-size: 200%;<xsl:value-of select="$wid"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style">font-size: <xsl:value-of select="$font-sizing"/>%;<xsl:value-of select="$wid"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-div-head</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="dri:body">
        <div id="ds-body">
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div id="ds-system-wide-alert">
                    <p>
                        <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                    </p>
                </div>
            </xsl:if>
            <xsl:if test="/dri:document/dri:body/dri:div[@n='item-view']">
                <xsl:variable name="HandleURLvar" select="concat('http://hdl.handle.net/',substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='object']/node(),':'))"/>
                <div id="identifier-citation">
                    <p>
                        <xsl:text>Please use this identifier to cite or link to this item:  </xsl:text>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$HandleURLvar"/></xsl:attribute>
                            <xsl:value-of select="$HandleURLvar"/>
                        </a>
                    </p>
                </div>
            </xsl:if>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <!-- Home Page Recent Submission: Read RSS, pull values and display -->
    <xsl:template match="/dri:document/dri:body/dri:div[@n='comunity-browser']">
        <!-- add search box code above Community list. -->
        <h1 style="font-size: 200%; width: 100%;" class="ds-div-head">Search LoboVault</h1>
        <form xmlns="http://di.tamu.edu/DRI/1.0/" id="front-page-search" class="ds-interactive-div primary" action="/search" method="get" onsubmit="javascript:tSubmit(this);">
            <p class="ds-paragraph">Enter some text in the box below to search LoboVault.</p>
            <p xmlns="http://di.tamu.edu/DRI/1.0/" class="ds-paragraph">
                <input id="aspect_artifactbrowser_FrontPageSearch_field_query" class="ds-text-field" name="query" type="text" value="" />
                <input id="aspect_artifactbrowser_FrontPageSearch_field_submit" class="ds-button-field" name="submit" type="submit" value="Go" />
            </p>
        </form>
        <!-- apply rest of template -->
        <xsl:apply-templates />
        <!-- Check for and name value of the second feed element for RSS location -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed'][2]">
            <xsl:variable name="RSSMapURL" select="concat('cocoon:/',/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed'][2])"/>
            <h1 class="ds-list-head">
                <i18n:text>xmlui.ArtifactBrowser.CommunityViewer.head_recent_submissions</i18n:text>
            </h1>
            <ul class="ds-artifact-list">
                <!-- Open document, navigate to item and loop -->
                <xsl:for-each select="document($RSSMapURL)/rss/channel/item">
                    <li class="ds-artifact-item odd">
                        <div class="artifact-description">
                            <div class="artifact-title">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="(link)"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="title"/>
                                </a>
                            </div>
                            <div class="artifact-info">
                                <xsl:value-of select="description"/>
                                <!-- Trim RSS pubDate value  -->
                                <xsl:variable name="dateformated"
                                    select="substring(normalize-space(pubDate),1,16)"/>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="$dateformated"/>
                                <xsl:text>)</xsl:text>
                            </div>
                        </div>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>    
    
    <!-- Footer copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            <p style="text-align:left; width: 97%;">University Libraries<br />MSC05 3020<br />1 University of New Mexico<br />Albuquerque NM 87131<br />505.277.9100</p>
            <div id="ds-footer-links">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>http://www.unm.edu/accessibility.html</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Accessibility</xsl:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>http://www.unm.edu/legal.html</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Legal</xsl:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/contact</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/feedback</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                </a>
            </div>
        </div>
    </xsl:template>
    
    <!-- Generate the info about the item from the metadata section -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <table class="ds-includeSet-table">
            <xsl:choose>
                <xsl:when test="dim:field[@mdschema='data'] and not(dim:field[@qualifier='streamurl'])">
                    <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="itemSummaryView-DIM-fields">
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </table>
    </xsl:template>
    
    <xsl:template name="itemSummaryView-DIM-fields">
        <xsl:param name="clause" select="'1'"/>
        <xsl:param name="phase" select="'even'"/>
        <xsl:variable name="otherPhase">
            <xsl:choose>
                <xsl:when test="$phase = 'even'">
                    <xsl:text>odd</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>even</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            
            <!-- Title row -->
            <xsl:when test="$clause = 1">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>: </span></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                                <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                    <xsl:value-of select="./node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                        <xsl:text>; </xsl:text><br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                                <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Author(s) row -->
            <xsl:when test="$clause = 2 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor'] or dim:field[@element='description'][@qualifier='advisor'] or dim:field[@element='description'][@qualifier='committee-member'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                    <span>
                                        <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                        </xsl:if>
                                        <xsl:copy-of select="node()"/>
                                    </span>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='creator']">
                                <xsl:for-each select="dim:field[@element='creator']">
                                    <xsl:copy-of select="node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='contributor']">
                                <xsl:for-each select="dim:field[@element='contributor']">
                                    <xsl:copy-of select="node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Thesis Advisor row -->
            <xsl:when test="$clause = 3 and (dim:field[@element='description' and @qualifier='advisor'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-thesis-advisor</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='advisor']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='advisor']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Thesis Committee Member row -->
            <xsl:when test="$clause = 4 and (dim:field[@element='description' and @qualifier='committee-member'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-thesis-committee-member</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='committee-member']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='committee-member']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Thesis Department row -->
            <xsl:when test="$clause = 5 and (dim:field[@element='description' and @qualifier='department'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-thesis-department</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='department']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='department']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Subject (non-LC) row -->
            <xsl:when test="$clause = 6 and (dim:field[@element='subject' and not(@qualifier='lcsh')])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='subject' and not(@qualifier='lcsh')]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier='lcsh')]) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Subject (LC) row -->
            <xsl:when test="$clause = 7 and (dim:field[@element='subject' and @qualifier='lcsh'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject-lcsh</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='subject' and @qualifier='lcsh']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='lcsh']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Thesis Degree Level row -->
            <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='level'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-thesis-level</i18n:text>:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='description' and @qualifier='level']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- description.acqdata row -->
            <xsl:when test="$clause = 9 and (dim:field[@element='description' and @qualifier='acqdata'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-acqdata</i18n:text>:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='description' and @qualifier='acqdata']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.cavetype row -->
            <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='cavetype'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-cavetype</i18n:text>:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='cavetype']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.imageid row -->
            <xsl:when test="$clause = 11 and (dim:field[@element='identifier' and @qualifier='imageid'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-imageid</i18n:text>:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='imageid']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- relation.relatedimages row -->
            <xsl:when test="$clause = 12 and (dim:field[@element='relation' and @qualifier='relatedimages'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-relatedimages</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation' and @qualifier='relatedimages']">
                            <xsl:copy-of select="substring-before(./node(), ':  ')"/><xsl:text>:  </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:copy-of select="substring-after(./node(),':  ')"/>
                                </xsl:attribute>
                                <xsl:copy-of select="substring-after(./node(),':  ')"/>
                            </a><br />
                            <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='relatedimages']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- description.sampletype row -->
            <xsl:when test="$clause = 13 and (dim:field[@element='description' and @qualifier='sampletype'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-sampletype</i18n:text>:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='description' and @qualifier='sampletype']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Abstract row -->
            <xsl:when test="$clause = 14 and (dim:field[@element='description' and @qualifier='abstract'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
                    <td>
                        <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                        <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                                <hr class="metadata-seperator"/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Date row -->
            <xsl:when test="$clause = 15 and (dim:field[@element='date'])">
                <tr class="ds-table-row {$phase}">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='date' and @qualifier='submitted']">
                            <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date-submitted</i18n:text>:</span></td>
                            <td>
                                <xsl:copy-of select="dim:field[@element='date' and @qualifier='submitted']/node()"/>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
                            <td>
                                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                                    <xsl:copy-of select="substring(./node(),1,10)"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                                        <br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </td>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Publisher row -->
            <xsl:when test="$clause = 16 and (dim:field[@element='publisher'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='publisher']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.citation row -->
            <xsl:when test="$clause = 17 and (dim:field[@element='identifier' and @qualifier='citation'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-citation</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='citation']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- relation.ispartofseries row -->
            <xsl:when test="$clause = 18 and (dim:field[@element='relation' and @qualifier='ispartofseries'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartofseries</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartofseries']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Description row -->
            <xsl:when test="$clause = 19 and (dim:field[@element='description' and not(@qualifier)])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
                    <td>
                        <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                        <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                                <hr class="metadata-seperator"/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.uri row -->
            <xsl:when test="$clause = 20 and (dim:field[@element='identifier' and @qualifier='uri'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:copy-of select="./node()"/>
                                </xsl:attribute>
                                <xsl:copy-of select="./node()"/>
                            </a>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.url row -->
            <xsl:when test="$clause = 21 and (dim:field[@element='identifier' and @qualifier='url'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-url</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='url']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:copy-of select="./node()"/>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:copy-of select="./node()"/>
                            </a>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='url']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.govdoc row -->
            <xsl:when test="$clause = 22 and (dim:field[@element='identifier' and @qualifier='govdoc'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-govdoc</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='govdoc']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='govdoc']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.isbn row -->
            <xsl:when test="$clause = 23 and (dim:field[@element='identifier' and @qualifier='isbn'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-isbn</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='isbn']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='isbn']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.issn row -->
            <xsl:when test="$clause = 24 and (dim:field[@element='identifier' and @qualifier='issn'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-issn</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='issn']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='issn']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- identifier.ismn row -->
            <xsl:when test="$clause = 25 and (dim:field[@element='identifier' and @qualifier='ismn'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ismn</i18n:text>:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier' and @qualifier='ismn']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='ismn']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Embargoed item available date row -->
            <xsl:when test="$clause = 26 and (dim:field[@element='embargo' and @qualifier='lift'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Item Available:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='embargo' and @qualifier='lift']">
                            <xsl:copy-of select="./node()"/>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Embedded video row -->
            <xsl:when test="$clause = 27 and (dim:field[@element='identifier'][@qualifier='streamurl'])">
                <tr class="ds-table-row {$phase}">
                    <td>
                        <xsl:attribute name="colspan">2</xsl:attribute>
                        <object>
                            <xsl:attribute name="width">580</xsl:attribute>
                            <xsl:attribute name="height">395</xsl:attribute>
                            <param>
                                <xsl:attribute name="name">movie</xsl:attribute>
                                <xsl:attribute name="value">http://fpdownload.adobe.com/strobe/FlashMediaPlayback_101.swf</xsl:attribute>
                            </param>
                            <param>
                                <xsl:attribute name="name">flashvars</xsl:attribute>
                                <xsl:attribute name="value">
                                    <xsl:text>src=</xsl:text>
                                    <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='streamurl']/node()"/>
                                    <xsl:text>&amp;poster=</xsl:text>
                                    <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='streamposter']/node()"/>
                                </xsl:attribute>
                            </param>
                            <param>
                                <xsl:attribute name="name">allowFullScreen</xsl:attribute>
                                <xsl:attribute name="value">true</xsl:attribute>
                            </param>
                            <param>
                                <xsl:attribute name="name">allowscriptaccess</xsl:attribute>
                                <xsl:attribute name="value">always</xsl:attribute>
                            </param>
                            <embed>
                                <xsl:attribute name="src">http://fpdownload.adobe.com/strobe/FlashMediaPlayback_101.swf</xsl:attribute>
                                <xsl:attribute name="type">application/x-shockwave-flash</xsl:attribute>
                                <xsl:attribute name="allowscriptaccess">always</xsl:attribute>
                                <xsl:attribute name="allowfullscreen">true</xsl:attribute>
                                <xsl:attribute name="width">580</xsl:attribute>
                                <xsl:attribute name="height">395</xsl:attribute>
                                <xsl:attribute name="flashvars">
                                    <xsl:text>src=</xsl:text>
                                    <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='streamurl']/node()"/>
                                    <xsl:text>&amp;poster=</xsl:text>
                                    <xsl:copy-of select="dim:field[@element='identifier' and @qualifier='streamposter']/node()"/>
                                </xsl:attribute>
                            </embed>
                        </object>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- recurse without changing phase if we didn't output anything -->
            <xsl:otherwise>
                <!-- IMPORTANT: This test should be updated if clauses are added! -->
                <xsl:if test="$clause &lt; 28">
                    <xsl:call-template name="itemSummaryView-DIM-fields">
                        <xsl:with-param name="clause" select="($clause + 1)"/>
                        <xsl:with-param name="phase" select="$phase"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    
    <!-- Duplicate to allow items with 'data' schema to display differently in simple item view -->
    <xsl:template name="itemSummaryView-DIM-fields-DATA-mdschema">
        <xsl:param name="clause" select="'1'"/>
        <xsl:param name="phase" select="'even'"/>
        <xsl:variable name="otherPhase">
            <xsl:choose>
                <xsl:when test="$phase = 'even'">
                    <xsl:text>odd</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>even</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            
            <!-- Project Name row -->
            <xsl:when test="$clause = 1">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Name: </span></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 0">
                                <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                    <xsl:value-of select="./node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                        <xsl:text>; </xsl:text><br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Principal Investigator row -->
            <xsl:when test="$clause = 2 and (dim:field[@element='contributor'][@qualifier='author'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                    <span>
                                        <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                        </xsl:if>
                                        <xsl:copy-of select="node()"/>
                                    </span>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Contributors row -->
            <xsl:when test="$clause = 3 and (dim:field[@element='project'][@qualifier='contributor'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Contributors:</span></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="count(dim:field[@element='project'][@qualifier='contributor']) &gt; 0">
                                <xsl:for-each select="dim:field[@element='project'][@qualifier='contributor']">
                                    <xsl:value-of select="./node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='contributor']) != 0">
                                        <xsl:text>; </xsl:text><br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Description row -->
            <xsl:when test="$clause = 4 and (dim:field[@element='project'][@qualifier='description'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Description:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='description']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='description']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Summary row -->
            <xsl:when test="$clause = 5 and (dim:field[@element='project'][@qualifier='descriptionabstract'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Summary:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='descriptionabstract']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='descriptionabstract']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Spatial Coverage row -->
            <xsl:when test="$clause = 6 and (dim:field[@element='project'][@qualifier='coveragespatial'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Spatial Coverage:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='coveragespatial']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='coveragespatial']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Temporal Coverage row -->
            <xsl:when test="$clause = 7 and (dim:field[@element='project'][@qualifier='coveragetemporal'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Temporal Coverage:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='coveragetemporal']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='coveragetemporal']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Subjects of Inquiry row -->
            <xsl:when test="$clause = 8 and (dim:field[@element='subject'][not(@qualifier)])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Subjects of Inquiry:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='subject'][not(@qualifier)]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='subject'][not(@qualifier)]) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Start Date row -->
            <xsl:when test="$clause = 9 and (dim:field[@element='project'][@qualifier='startdate'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Start Date:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='project'][@qualifier='startdate']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project End Date row -->
            <xsl:when test="$clause = 10 and (dim:field[@element='project'][@qualifier='enddate'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project End Date:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='project'][@qualifier='enddate']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Status row -->
            <xsl:when test="$clause = 11 and (dim:field[@element='project'][@qualifier='status'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Status:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='project'][@qualifier='status']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Type row -->
            <xsl:when test="$clause = 12 and (dim:field[@element='project'][@qualifier='type'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Type:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='type']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='type']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Data Types row -->
            <xsl:when test="$clause = 13 and (dim:field[@element='type'][not(@qualifier)])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Data Types:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='type'][not(@qualifier)]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='type'][not(@qualifier)]) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Data Format row -->
            <xsl:when test="$clause = 14 and (dim:field[@element='format'][not(@qualifier)])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Data Format:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='format'][not(@qualifier)]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='format'][not(@qualifier)]) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Data Access Requirements row -->
            <xsl:when test="$clause = 15 and (dim:field[@element='relation'][@qualifier='requires'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Data Access Requirements:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='requires']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifier='requires']) != 0">
                                <br />
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Submitted Date row -->
            <xsl:when test="$clause = 16 and (dim:field[@element='project'][@qualifier='datesubmitted'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Submitted Date:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='project'][@qualifier='datesubmitted']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Available Date row -->
            <xsl:when test="$clause = 17 and (dim:field[@element='date'][@qualifier='issued'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Available Date:</span></td>
                    <td>
                        <xsl:copy-of select="dim:field[@element='date'][@qualifier='issued']/node()"/>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Parent row -->
            <xsl:when test="$clause = 18 and (dim:field[@element='relation'][@qualifier='ispartof'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Parent:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='ispartof']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifier='ispartof']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Parts row -->
            <xsl:when test="$clause = 19 and (dim:field[@element='relation'][@qualifier='haspart'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Parts:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='haspart']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifier='haspart']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Related Projects row -->
            <xsl:when test="$clause = 20 and (dim:field[@element='relation'][@qualifier='projects'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Related Projects:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='projects']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifier='projects']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Related Publications row -->
            <xsl:when test="$clause = 21 and (dim:field[@element='relation'][@qualifier='publications'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Related Publications:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='publications']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='relation'][@qualifier='publications']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Archive Link row -->
            <xsl:when test="$clause = 22 and (dim:field[@element='identifier'][@qualifier='url'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Archive Link:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='identifier'][@qualifier='url']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:copy-of select="./node()"/>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:copy-of select="./node()"/>
                            </a>
                            <xsl:if test="count(following-sibling::dim:field[@element='identifier'][@qualifier='url']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Access Rights row -->
            <xsl:when test="$clause = 23 and (dim:field[@element='project'][@qualifier='rights'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Access Rights:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='rights']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='rights']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Project Identifier row -->
            <xsl:when test="$clause = 24 and (dim:field[@element='project'][@qualifier='id'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Project Identifier:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='id']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='id']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Funding Source row -->
            <xsl:when test="$clause = 25 and (dim:field[@element='project'][@qualifier='source'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Funding Source:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='source']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='source']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- Notes row -->
            <xsl:when test="$clause = 26 and (dim:field[@element='project'][@qualifier='notes'])">
                <tr class="ds-table-row {$phase}">
                    <td><span class="bold">Notes:</span></td>
                    <td>
                        <xsl:for-each select="dim:field[@element='project'][@qualifier='notes']">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='project'][@qualifier='notes']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
                <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                    <xsl:with-param name="clause" select="($clause + 1)"/>
                    <xsl:with-param name="phase" select="$otherPhase"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- recurse without changing phase if we didn't output anything -->
            <xsl:otherwise>
                <!-- IMPORTANT: This test should be updated if clauses are added! -->
                <xsl:if test="$clause &lt; 27">
                    <xsl:call-template name="itemSummaryView-DIM-fields-DATA-mdschema">
                        <xsl:with-param name="clause" select="($clause + 1)"/>
                        <xsl:with-param name="phase" select="$phase"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Copied from dri2xhtml/DIM-Handler.xsl to add ingest date in front of recent submissions -->
    <!-- Generate the info about the item from the metadata section -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM"> 
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
		   <div class="artifact-title">
                <span class="recent-date-accessioned">
                    <xsl:text>[</xsl:text><xsl:value-of select="substring(dim:field[@element='date' and @qualifier='accessioned']/node(),1,10)"/><xsl:text>]</xsl:text>
                </span>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$itemWithdrawn">
                                <xsl:value-of select="ancestor::mets:METS/@OBJEDIT" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ancestor::mets:METS/@OBJID" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@mdschema='dc' and @element='title'] and (string-length(dim:field[@element='title']) &gt; 0)">
                            <xsl:value-of select="dim:field[@mdschema='dc' and @element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
               <!-- Generate COinS with empty content per spec but force Cocoon to not create a minified tag  -->
               <span class="Z3988">
                   <xsl:attribute name="title">
                       <xsl:call-template name="renderCOinS"/>
                   </xsl:attribute>
                   &#xFEFF; <!-- non-breaking space to force separating the end tag -->
               </span>
           </div>
            <div class="artifact-info">
                <span class="author">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
	                <span class="publisher-date">
	                    <xsl:text>(</xsl:text>
	                    <xsl:if test="dim:field[@element='publisher']">
	                        <span class="publisher">
	                            <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
	                        </span>
	                        <xsl:text>, </xsl:text>
	                    </xsl:if>
	                    <span class="date">
	                        <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
	                    </span>
	                    <xsl:text>)</xsl:text>
	                </span>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- Copied from ../dri2xhtml/structural.xsl to add local navigation to options section -->
    <!--
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying
        the templates inside it.
        
        In fact, the only bit of real work this template does is add the search box, which has to be
        handled specially in that it is not actually included in the options div, and is instead built
        from metadata available under pageMeta.
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
    <xsl:template match="dri:options">
        <div id="ds-options" class="ds-option-set-head">
            <h3 id="UL-browse" class="ds-option-set-head">UNM Libraries</h3>
            <div id="UL-browse-option" class="ds-option-set">
                <ul class="ds-options-list">
                    <li><a href="http://elibrary.unm.edu">University Libraries</a></li>
                    <li><a href="http://lawlibrary.unm.edu/">Law Library</a></li>
                    <li><a href="http://hsc.unm.edu/library/">Health Sciences Library</a></li>
                </ul>
            </div>
            <h3 id="ds-search-option-head" class="ds-option-set-head"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></h3>
            <div id="ds-search-option" class="ds-option-set">
                <!-- The form, complete with a text box and a button, all built from attributes referenced
                    from under pageMeta. -->
                <form id="ds-search-form" method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    </xsl:attribute>
                    <fieldset>
                        <input class="ds-text-field " type="text">
                            <xsl:attribute name="name">
                                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                            </xsl:attribute>
                        </input>
                        <input class="ds-button-field " name="submit" type="submit" i18n:attr="value" value="xmlui.general.go" >
                            <xsl:attribute name="onclick">
                                <xsl:text>
                                    var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                    if (radio != undefined &amp;&amp; radio.checked)
                                    {
                                    var form = document.getElementById(&quot;ds-search-form&quot;);
                                    form.action=
                                </xsl:text>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                                <xsl:text>/handle/&quot; + radio.value + &quot;/search&quot; ; </xsl:text>
                                <xsl:text>
                                    }
                                </xsl:text>
                            </xsl:attribute>
                        </input>
                        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
                            <label>
                                <input id="ds-search-form-scope-all" type="radio" name="scope" value="" checked="checked"/>
                                <i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
                            </label>
                            <br/>
                            <label>
                                <input id="ds-search-form-scope-container" type="radio" name="scope">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container'],':')"/>
                                    </xsl:attribute>
                                </input>
                                <xsl:choose>
                                    <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='containerType']/text() = 'type:community'">
                                        <i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text>
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                            </label>
                        </xsl:if>
                    </fieldset>
                </form>
                <!-- The "Advanced search" link, to be perched underneath the search box -->
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                </a>
            </div>
            
            <!-- Once the search box is built, the other parts of the options are added -->
            <xsl:apply-templates />
        </div>
    </xsl:template>

    
</xsl:stylesheet>
