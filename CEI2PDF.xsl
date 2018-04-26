<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xrx="http://www.monasterium.net/NS/xrx" xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:axf="http://www.sxf.de" version="3.0" id="charter2pdf">
    <xsl:preserve-space elements="*"/>
    <xsl:output indent="yes"/>
   
   
    <xsl:key name="names" match="//*" use="local-name(.)"/>
    <xsl:param name="input" select="base-uri(.)"/>



    <!-- function cei:prepare_ext -->
    <xsl:function name="cei:prepare_ext">
        <xsl:param name="input"/>
        <xsl:param name="vorfahren"/>
        <xsl:choose>
            <xsl:when
                test="$vorfahren/@rend[contains(., 'monogrammat') or contains(., 'maiusc') or contains(., 'elongat') or contains(., 'capital') or contains(., 'oncia')]">


                <!--  <xsl:value-of select="$vorfahren/*/name()"/> cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')] -->
                <xsl:analyze-string select="$input" regex="[A-Z]">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:text>&#x200D;</xsl:text>
                        <fo:inline font-style="normal" font-size="75%">
                            <xsl:value-of select="(upper-case(.))"/>
                        </fo:inline>
                        <xsl:text>&#x200D;</xsl:text>

                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="
                        replace(replace($input, '&quot;',
                        '”'), '”(\w)', '“$1')"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- function cei:prepare -->
    <xsl:function name="cei:prepare">
        <xsl:param name="input"/>
        <xsl:value-of select="replace(replace($input, '&quot;', '”'), '”(\w)', '“$1')"/>
    </xsl:function>


    <!-- Leerzeichen aus Elementen rausziehen (löschen und zwischen Elemente schreiben) -->
    <!-- Input Urkunden // XML-Dateien -->
    <!-- Leerzeichen am Ende des Elements rausziehen -->
    <xsl:variable name="intermediate1a"
        select="replace(unparsed-text($input), '([\S]) ((&lt;/[^>]*?>)+)', '$1$2 ')"/>
    <!-- Leerzeichen am Anfang des Elements rausziehen -->
    <xsl:variable name="intermediate1b"
        select="replace($intermediate1a, '(&lt;[^/][^>]*?[^/]>) ([\S])', ' $1$2')"/>
    <xsl:variable name="intermediate2"
        select="replace($intermediate1b, ' (&lt;cei:note.*?&lt;/cei:note>)', '$1 ')"/>
    <xsl:variable name="result"
        select="parse-xml(replace($intermediate2, ' (&lt;cei:handShift.*?/>)', '$1 '))"/>


    <!-- Wurzelknoten -->
    <xsl:template match="/">
        <!-- <xsl:result-document href="result.xml">
            <xsl:copy-of select="$result"/> 
        </xsl:result-document> -->
        <xsl:call-template name="charter">
            <xsl:with-param name="Funktion1"> </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="charter">
        <xsl:param name="Funktion1"/>
        <fo:root>

            <!-- Seitenlayout/Seitenzahlen/Überschrift -->
            <fo:layout-master-set>

                <!-- Urkunden -->
                <fo:simple-page-master master-name="rechts" page-height="240mm" page-width="170mm" margin-top="19.737mm" margin-bottom="19.737mm"
                    margin-left="20mm" margin-right="20mm">
                    <fo:region-body margin-top="10.527mm"/>
                    <fo:region-before extent="10.527mm" region-name="kopf-rechte-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="links" page-height="240mm" page-width="170mm" margin-top="19.737mm" margin-bottom="19.737mm"
                    margin-left="20mm" margin-right="20mm">
                    <fo:region-body margin-top="10.527mm"/>
                    <fo:region-before extent="10.527mm" region-name="kopf-linke-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <!-- Register -->
                <fo:simple-page-master master-name="rechts_2"  page-height="240mm" page-width="170mm" margin-top="19.737mm" margin-bottom="19.737mm"
                    margin-left="20mm" margin-right="20mm">
                    <fo:region-body margin-top="10.527mm" column-count="2" column-gap="7mm"/>
                    <fo:region-before extent="10.527mm" region-name="kopf-rechte-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="links_2"  page-height="240mm" page-width="170mm" margin-top="19.737mm" margin-bottom="19.737mm"
                    margin-left="20mm" margin-right="20mm">
                    <fo:region-body margin-top="10.527mm" column-count="2" column-gap="7mm"/>
                    <fo:region-before extent="10.527mm" region-name="kopf-linke-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <!-- Urkunden -->
                <fo:page-sequence-master master-name="seitenfolgen">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="rechts"
                            odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="links"
                            odd-or-even="even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

                <!-- Register -->
                <fo:page-sequence-master master-name="seitenfolgen_2">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="rechts_2"
                            odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="links_2"
                            odd-or-even="even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>





            </fo:layout-master-set>

            <fo:page-sequence master-reference="seitenfolgen" font-family="Times New Roman" initial-page-number="3">

                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center" font-size="10pt">Documenti</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right" font-size="10pt">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center" font-size="10pt">Documenti</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left" font-size="10pt">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <xsl:document/>
                <fo:static-content flow-name="xsl-footnote-separator">
                    <fo:block text-indent="0mm" space-before="0mm"> </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">

                    <!-- Input Urkunden aus Variable -->

                    <xsl:for-each select="$result//cei:group/cei:text">
                        <xsl:sort select="concat(.//cei:dateRange/@from, .//cei:witnessOrig//cei:archIdentifier//cei:idno)"></xsl:sort>                        

                        <!-- Variable für Fußnotenkörper-->
                        <xsl:variable name="footnote">

                            <!-- Buchstaben -->
                            <fo:block line-height-shift-adjustment="disregard-shifts"
                                line-height="5mm" space-after="5mm">

                                <xsl:for-each
                                    select="
                                        .//cei:tenor//cei:add[@hand and not(@type)] |
                                        .//cei:tenor//cei:add[@type and not(@hand)] |
                                        .//cei:tenor//cei:add[@type and @hand] |
                                        .//cei:tenor//cei:c[@type] |
                                        .//cei:tenor//cei:corr[@type and @sic] |
                                        .//cei:tenor//cei:corr[@type and not(@sic)] |
                                        .//cei:tenor//cei:corr[not(@type) and @sic] |
                                        .//cei:tenor//cei:damage[attribute()] |
                                        .//cei:tenor//cei:del[@type] |
                                        .//cei:tenor//cei:handShift[@hand] |
                                        .//cei:tenor//cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] |
                                        .//cei:tenor//cei:sic[@corr or not(attribute())] |
                                        .//cei:tenor//cei:space |
                                        .//cei:tenor//cei:supplied[@type] |
                                        .//cei:tenor//cei:unclear[@reason]
                                        ">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()" format="a"/>
                                    </fo:inline>
                                    <xsl:text>&#xa0;</xsl:text>

                                    <!-- cei:add[@hand] -->
                                    <xsl:if test="self::cei:add[@hand and not(@type)]">
                                        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and not(@hand)]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and @hand]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:c[@type] -->
                                    <xsl:if test="self::cei:c[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:corr[@type and @sic] -->
                                    <xsl:if test="self::cei:corr[@type and @sic]">
                                        <xsl:choose>
                                            <!-- Attribut @type überprüfen: wenn "su"  -->
                                            <xsl:when test="@type = 'su'">
                                                <!-- Achtung: Matched nur auf einen Text-Knoten -->
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()/following::text()[1], ' ')">
                                                  <xsl:value-of select="text()"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="concat('-', text()[1])"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat(text()[1], '-')"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat('-', text()[1], '-')"
                                                  />
                                                </xsl:if>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. su </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('-', text()[1], '-')"/>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. da </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:text>, </xsl:text>
                                                <xsl:analyze-string select="@type"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>

                                    <!-- cei:corr[@type and not(@sic)] -->
                                    <xsl:if test="self::cei:corr[@type and not(@sic)]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:corr[not(@type) and @sic] -->
                                    <xsl:if test="self::cei:corr[not(@type) and @sic]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="starts-with(@sic, 'A ') or starts-with(@sic, 'B ') or starts-with(@sic, 'B'' ')">
                                                <xsl:value-of select="@sic"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- Achtung: Matched jetzt nur auf einen Text-Knoten -->
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="text()"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="concat('-', text()[1])"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat(text()[1], '-')"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat('-', text()[1], '-')"
                                                  />
                                                </xsl:if>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. da</xsl:text>
                                                  <xsl:text> </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  <xsl:text>&#x200D;</xsl:text>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>

                                    <!-- cei:damage[@agent and not(@extent)] -->
                                    <xsl:if test="self::cei:damage[@agent and not(@extent)]">
                                        <xsl:analyze-string select="@agent" regex="/\w?[^/]*\w?/">
                                            <!-- beides italic? -->
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[not(@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[not(@agent) and @extent]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Lacuna</xsl:text>
                                        </fo:inline>
                                        <xsl:analyze-string select="@extent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[@agent and @extent]">
                                        <xsl:analyze-string select="@agent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@extent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:del[@type] -->
                                    <xsl:if test="self::cei:del[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:handShift[@hand] -->
                                    <xsl:if test="self::cei:handShift[@hand]">
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] -->
                                    <xsl:if
                                        test="self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]">
                                        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@rend" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:sic[@corr] -->
                                    <xsl:if test="self::cei:sic[@corr]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così </xsl:text>
                                        </fo:inline>
                                        <xsl:if
                                            test="ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()]">
                                            <xsl:text>A, </xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()])">
                                            <xsl:value-of
                                                select="concat(ancestor::cei:text//cei:witListPar/cei:witness[1]/@n, ', ')"
                                            />
                                        </xsl:if>
                                        <xsl:analyze-string select="@corr" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:sic[not(attribute())] -->
                                    <xsl:if test="self::cei:sic[not(attribute())]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così </xsl:text>
                                        </fo:inline>
                                        <xsl:if
                                            test="ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()]">
                                            <xsl:text>A.</xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()])">
                                            <xsl:value-of
                                                select="concat(ancestor::cei:text//cei:witListPar/cei:witness[1]/@n, '.')"
                                            />
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- cei:space -->
                                    <xsl:if test="self::cei:space">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Spazio lasciato in bianco </xsl:text>
                                            <xsl:if test="string-length(@extent) != 0">
                                                <xsl:analyze-string select="@extent"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:if>
                                        </fo:inline>
                                        <xsl:text>&#x200D;</xsl:text>
                                    </xsl:if>

                                    <!-- cei:supplied[@type] -->
                                    <xsl:if test="self::cei:supplied[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:unclear[@reason] -->
                                    <xsl:if test="self::cei:unclear[@reason]">
                                        <!-- Achtung: Matched nur auf einen Text-Knoten -->
                                        <xsl:if
                                            test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()/following::text()[1], ' ')">
                                            <xsl:value-of select="text()"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                            <xsl:value-of select="concat('-', text()[1])"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()/following::text()[1], ' '))">
                                            <xsl:value-of select="concat(text()[1], '-')"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                            <xsl:value-of select="concat('-', text()[1], '-')"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@reason" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- Abstand zwischen Fußnoten -->
                                    <xsl:text xml:space="preserve">    </xsl:text>
                                </xsl:for-each>
                            </fo:block>

                            <!-- Zahlen -->
                            <fo:block line-height-shift-adjustment="disregard-shifts"
                                line-height="5mm" space-after="5mm">

                                <xsl:for-each
                                    select="
                                        .//cei:tenor//cei:bibl[ancestor::cei:cit] |
                                        .//cei:tenor//cei:note">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()"/>
                                    </fo:inline>
                                    <xsl:text>&#xa0;</xsl:text>

                                    <!-- cei:bibl[ancestor::cei:cit] -->
                                    <xsl:if test="self::cei:bibl[ancestor::cei:cit]">
                                        <xsl:analyze-string select="." regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200B;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:if
                                            test="not(ends-with(normalize-space(.), '.')) and not(ends-with(normalize-space(.), './'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- cei:note -->
                                    <xsl:if test="self::cei:note">
                                        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
                                        <xsl:if
                                            test="not(ends-with(normalize-space(.), '.')) and not(ends-with(normalize-space(.), './'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- Abstand zwischen Fußnoten -->
                                    <xsl:text xml:space="preserve">    </xsl:text>
                                </xsl:for-each>
                            </fo:block>

                        </xsl:variable>

                        <!-- Ausgabe Urkundennummer -->
                        <fo:block text-align="center" space-before="0mm" space-after="0mm"
                            keep-with-next.within-page="always" font-weight="bold">
                            <xsl:number value="position()" format="1"/>
                        </fo:block>

                        <!-- Ausgabe Urkunde -->
                        <xsl:call-template name="issued"/>
                        <xsl:call-template name="abstract"/>
                        <xsl:call-template name="wittnes"/>
                        <xsl:call-template name="edition"/>
                        <xsl:call-template name="facsimile"/>
                        <xsl:call-template name="regest"/>
                        <xsl:call-template name="physicalDesc"/>
                        <xsl:call-template name="link_editor"/>
                        <fo:block space-after="5mm"/>
                        <xsl:call-template name="tenor"/>

                        <!-- Absatz zwischen Urkunde und Fußnoten -->
                        <fo:block space-after="10mm"/>

                        <!-- Ausgabe Variable Fußnotenkörper -->
                        <fo:block text-indent="0mm" text-align="justify" space-after="20mm">
                            <xsl:copy-of select="$footnote"/>
                        </fo:block>

                    </xsl:for-each>



                </fo:flow>
            </fo:page-sequence>
            
            <!--

            <fo:page-sequence master-reference="seitenfolgen_2" font-family="Times-New-Roman">

                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Nomi di persona</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Nomi di persona</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="register_name"/>

                </fo:flow>
            </fo:page-sequence>

            <fo:page-sequence master-reference="seitenfolgen_2" font-family="Times-New-Roman">

                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Nomi di luogo</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Nomi di luogo</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="register_place"/>

                </fo:flow>
            </fo:page-sequence>

            <fo:page-sequence master-reference="seitenfolgen_2" font-family="Times-New-Roman">

                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Indice analitico</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Indice analitico</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="register_index"/>

                </fo:flow>
            </fo:page-sequence> -->

            <fo:page-sequence master-reference="seitenfolgen_2" font-family="Times-New-Roman">
                
                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center" font-size="10pt">Indice</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right" font-size="10pt">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                
                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center" font-size="10pt">Indice</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left" font-size="10pt">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="Index"/>
                    
                </fo:flow>
            </fo:page-sequence>

        </fo:root>

    </xsl:template>

    <!-- Templates Fußnoten_Körper -->

    <!-- tenplate cei:author fuß_body-->
    <xsl:template match="cei:author" mode="fuß_body">
        <xsl:choose>
            <xsl:when test="cei:persName">
                <!-- Vorname -->
                <xsl:if test="cei:persName/cei:forename">
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
                <!-- Nachname -->
                <xsl:if test="cei:persName/cei:surname">
                    <xsl:text> </xsl:text>
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- Autor steht direkt im cei:author -->
                <xsl:for-each select="text()">
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Template cei:bibl fuß_body -->
    <xsl:template match="cei:bibl" mode="fuß_body">
        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
    </xsl:template>

    <!-- Template cei:expan fuß_body -->
    <xsl:template match="cei:expan" mode="fuß_body">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <!-- Template cei:note fuß_body -->
    <xsl:template match="cei:note" mode="fuß_body">
        <xsl:apply-templates select="* | text()" mode="fuß_body"/>
    </xsl:template>

    <!-- Template text() fuß_body -->
    <xsl:template match="text()" mode="fuß_body">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Template cei:title fuß_body -->
    <xsl:template match="cei:title" mode="fuß_body">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="fuß_body"/>
        </fo:inline>
    </xsl:template>

    <!-- Template cei:quote fuß_body -->
    <xsl:template match="cei:quote" mode="fuß_body">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="fuß_body"/>
        </fo:inline>
    </xsl:template>

    <!-- Templates Metadaten-->

    <!-- Template "issued" (Datum und Ort der Urkunde) -->
    <xsl:template name="issued">
        <xsl:if test=".//cei:issued">
            <fo:block text-align="center" keep-with-next.within-page="always">

                <!-- Datum -->
                <xsl:apply-templates select=".//cei:issued/cei:date | .//cei:issued/cei:dateRange"
                    mode="meta"/>

                <!-- Test auf Vorkommen von Datum und Ort -->
                <xsl:if
                    test=".//cei:issued/cei:date//text() and .//cei:issued/cei:placeName//text() or .//cei:issued/cei:dateRange//text() and .//cei:issued/cei:placeName//text()">
                    <xsl:text>, </xsl:text>
                </xsl:if>

                <!-- Ort -->
                <xsl:apply-templates select=".//cei:issued/cei:placeName" mode="meta"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "abstract" (Zusammenafssung der Urkunde) -->
    <xsl:template name="abstract">
        <xsl:if test=".//cei:abstract">
            <fo:block text-align="justify" text-indent="10mm">
                <xsl:apply-templates select=".//cei:abstract" mode="meta"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "wittness" (Quelle der Urkunde) -->
    <xsl:template name="wittnes">

        <fo:block text-indent="10mm" text-align="justify" margin-top="5mm" font-size="10pt">
            <!-- Fall 1: Die Urkunde ist ein Original -->
            <xsl:if test=".//cei:witnessOrig/cei:traditioForm/text()">
                <!-- Originale -->
                <xsl:apply-templates select=".//cei:witnessOrig/cei:traditioForm/text()" mode="meta"/>
                <xsl:text>, </xsl:text>
                <!-- <cei:arch -->
                <xsl:if test=".//cei:witnessOrig/cei:archIdentifier/cei:arch[1]/text()">
                    <xsl:apply-templates
                        select=".//cei:witnessOrig/cei:archIdentifier/cei:arch[1]/text()"
                        mode="meta"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <!-- <cei:idno> -->
                <xsl:if test=".//cei:witnessOrig/cei:archIdentifier/cei:idno[1]/text()">
                    <xsl:apply-templates
                        select=".//cei:witnessOrig/cei:archIdentifier/cei:idno[1]/text()"
                        mode="meta"/>
                </xsl:if>
                <!-- Sigle A -->
                <xsl:if test=".//cei:witnessOrig/cei:traditioForm/text()">
                    <xsl:text> [A]</xsl:text>
                </xsl:if>
                <!-- Fallunterscheidung Kopien ja/nein -->
                <xsl:choose>
                    <!-- Fall 1b: Es gibt Kopien -->
                    <xsl:when test=".//cei:witListPar/cei:witness[@n]">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <!-- Fall 1: Es gibt keine Kopien -->
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Fall 1b: Die Urkunde ist ein Original und hat Kopien -->
                <!-- Copia -->
                <xsl:if test=".//cei:witListPar/cei:witness[@n]">
                    <!-- for-each -->
                    <xsl:for-each select=".//cei:witListPar/cei:witness[@n]">
                        <xsl:apply-templates select=".//cei:traditioForm/text()" mode="meta"/>
                        <xsl:text>, </xsl:text>
                        <!-- <cei:arch -->
                        <!-- Test fragwürdig !!! -->
                        <xsl:if test="ancestor::cei:text//cei:arch/text()">
                            <xsl:apply-templates select="cei:archIdentifier/cei:arch[1]/text()"
                                mode="meta"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <!-- <cei:idno> -->
                        <!-- Test fragwürdig !!! -->
                        <xsl:if test="ancestor::cei:text//cei:idno/text()">
                            <xsl:apply-templates select="cei:archIdentifier/cei:idno[1]/text()"
                                mode="meta"/>
                        </xsl:if>
                        <!-- Sigle -->
                        <xsl:if test=".[@n]">
                            <xsl:value-of select="concat(' [', @n, ']')"/>
                        </xsl:if>
                        <!-- Datum -->
                        <xsl:if test="cei:archIdentifier/text()[preceding-sibling::cei:idno]">
                            <xsl:value-of select="cei:archIdentifier/text()[last()]"/>
                        </xsl:if>
                        <!-- Fallunterscheidung Position Kopie -->
                        <xsl:choose>
                            <xsl:when test="current()[last()]">. </xsl:when>
                            <xsl:otherwise>; </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
            <!-- Fall 2: Die Urkunde ist eine beglaubigte Kopie -->
            <xsl:if test="not(.//cei:witnessOrig/cei:traditioForm/text())">
                <!-- Copia autentica -->
                <xsl:apply-templates
                    select=".//cei:witListPar/cei:witness[1]//cei:traditioForm/text()" mode="meta"/>
                <xsl:text>, </xsl:text>
                <!-- <cei:arch -->
                <xsl:if test=".//cei:witListPar/cei:witness[1]//cei:arch/text()">
                    <xsl:apply-templates select=".//cei:witListPar/cei:witness[1]//cei:arch/text()"
                        mode="meta"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <!-- <cei:idno> -->
                <xsl:if test=".//cei:witListPar/cei:witness[1]//cei:idno/text()">
                    <xsl:apply-templates select=".//cei:witListPar/cei:witness[1]//cei:idno/text()"
                        mode="meta"/>
                </xsl:if>
                <!-- Sigle B -->
                <xsl:if test=".//cei:witListPar/cei:witness[1][@n]">
                    <xsl:value-of select="concat(' [', .//cei:witListPar/cei:witness[1]/@n, ']')"/>
                </xsl:if>
                <!-- Fallunterscheidung Kopien ja/nein -->
                <xsl:choose>
                    <!-- Fall 2b: Es gibt Kopien -->
                    <xsl:when test=".//cei:witListPar/cei:witness[2]">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <!-- Fall 2b: Es gibt keine Kopien -->
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Fall 2b: Die Urkunde ist eine beglaubigte Kopie und hat Kopien -->
                <!-- Copia -->
                <xsl:if test=".//cei:witListPar/cei:witness[@n][not(position() = 1)]">
                    <!-- for-each -->
                    <xsl:for-each select=".//cei:witListPar/cei:witness[@n][not(position() = 1)]">
                        <xsl:apply-templates select=".//cei:traditioForm/text()" mode="meta"/>
                        <xsl:text>, </xsl:text>
                        <!-- <cei:arch -->
                        <!-- Test fragwürdig !!! -->
                        <xsl:if test="ancestor::cei:text//cei:arch/text()">
                            <xsl:apply-templates select="cei:archIdentifier/cei:arch[1]/text()"
                                mode="meta"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <!-- <cei:idno> -->
                        <!-- Test fragwürdig !!! -->
                        <xsl:if test="ancestor::cei:text//cei:idno/text()">
                            <xsl:apply-templates select="cei:archIdentifier/cei:idno[1]/text()"
                                mode="meta"/>
                        </xsl:if>
                        <!-- Sigle -->
                        <xsl:if test=".[@n]">
                            <xsl:value-of select="concat(' [', @n, ']')"/>
                        </xsl:if>
                        <!-- Datum -->
                        <xsl:if test="cei:archIdentifier/text()[preceding-sibling::cei:idno]">
                            <xsl:value-of select="cei:archIdentifier/text()[last()]"/>
                        </xsl:if>
                        <!-- Fallunterscheidung Position Kopie -->
                        <xsl:choose>
                            <xsl:when test="current()[last()]">. </xsl:when>
                            <xsl:otherwise>; </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
            <!-- cei:rubrum -->
            <xsl:apply-templates select=".//cei:witnessOrig/cei:rubrum" mode="meta"/>
            <!-- cei:nota -->
            <xsl:apply-templates select=".//cei:witnessOrig/cei:nota" mode="meta"/>
        </fo:block>

    </xsl:template>

    <!-- Template "edition" (Edition) -->
    <xsl:template name="edition">
        <!-- Problem, es werden Leerzeichen produziert -->
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Ed. </xsl:text>
                <xsl:choose>
                    <xsl:when
                        test="count(.//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl) > 1">
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl"
                            mode="ed_fac_reg"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl"
                            mode="meta"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "facsimile" -->
    <xsl:template name="facsimile">
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Facs. </xsl:text>
                <xsl:choose>
                    <xsl:when
                        test="count(.//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl) > 1">
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl"
                            mode="ed_fac_reg"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl"
                            mode="meta"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "regest" -->
    <xsl:template name="regest">
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Reg. </xsl:text>
                <xsl:choose>
                    <xsl:when
                        test="count(.//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl) > 1">
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl"
                            mode="ed_fac_reg"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select=".//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl"
                            mode="meta"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </xsl:template>


    <!-- template cei:bibl ed_fac_reg -->
    <!-- Leerzeichen bei mehreren cei:bibl -->
    <xsl:template match="cei:bibl" mode="ed_fac_reg">
        <xsl:apply-templates select="* | text()" mode="meta"/>
        <xsl:text> </xsl:text>
    </xsl:template>



    <!-- Template "physicalDesc" inkl. "misura"-->
    <xsl:template name="physicalDesc">
        <xsl:if test=".//cei:witnessOrig/cei:physicalDesc//text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:apply-templates select=".//cei:witnessOrig/cei:physicalDesc/cei:condition"
                    mode="meta"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select=".//cei:witnessOrig/cei:physicalDesc/cei:material"
                    mode="meta"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select=".//cei:witnessOrig/cei:auth/cei:sealDesc" mode="meta"/>
                <xsl:if test=".//cei:witnessOrig/cei:physicalDesc/cei:dimensions/text()">
                    <xsl:text> Misura </xsl:text>
                    <xsl:apply-templates select=".//cei:witnessOrig/cei:physicalDesc/cei:dimensions"
                        mode="meta"/>
                    <xsl:text>. </xsl:text>
                </xsl:if>
            </fo:block>
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                    <xsl:apply-templates select=".//cei:p[(position() = 1)]" mode="erstes"/>
                    <xsl:apply-templates select=".//cei:p[not(position() = 1)]" mode="nicht_erstes"
                    > </xsl:apply-templates>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "link" -->
    <xsl:template name="link_editor">
        
        <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
            <!-- Titel der digitalen Edition -->
            <xsl:text>I documenti dell'abbazia di S. Maria della Grotta di Vitulano (BN). 1200-1250, a cura di Antonella Ambrosio, Vera Schwarz-Ricci, Georg Vogeler (con le edizioni di Antonella Ambrosio, Giovanni Araldi, Maria Rosaria Falcone, Paola Massa, Vera Isabell Schwarz-Ricci, Maria Elisabetta Vendemia, Georg Vogeler), versione digitale, n. </xsl:text>
            <!-- Nummer der Urkunde ausgeben -->
            <xsl:value-of select=".//cei:body/cei:idno"></xsl:value-of>
            <xsl:text> (</xsl:text>
            <!-- Link auf Monasterium-Seite einfügen: http://monasterium.net/mom/smg-EV/SMG_2_AA_I_5/charter -->
            <xsl:text>http://monasterium.net/mom/SMG1200-1250/</xsl:text><xsl:value-of select=".//cei:body/cei:idno"></xsl:value-of><xsl:text>/charter</xsl:text>
            <xsl:text>).</xsl:text>
            <!-- Ausgabe des Herausgebers/Codierers -->
            <xsl:if
                test="not(starts-with(atom:content/cei:text/cei:front/cei:sourceDesc/cei:sourceDescVolltext/cei:bibl[1], ' '))">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates
                select="atom:content/cei:text/cei:front/cei:sourceDesc/cei:sourceDescVolltext/cei:bibl"
                mode="meta"/>
        </fo:block>

    </xsl:template>

    <!-- Templates Metadaten -->

    <!-- template text() meta -->
    <xsl:template match="text()" mode="meta">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- template dateRange date meta -->
    <xsl:template match="cei:dateRange | cei:date" mode="meta">
        <xsl:apply-templates select="* | text()" mode="meta"/>
    </xsl:template>

    <!-- template placeName meta -->
    <xsl:template match="cei:placeName" mode="meta">
        <xsl:apply-templates select="* | text()" mode="meta"/>
    </xsl:template>

    <!-- template cei:foreign meta -->
    <xsl:template match="cei:foreign" mode="meta">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="meta"/>
        </fo:inline>
    </xsl:template>

    <!-- template cei:quote meta -->
    <xsl:template match="cei:quote" mode="meta">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="meta"/>
        </fo:inline>
    </xsl:template>

    <!-- template cei:expan meta -->
    <xsl:template match="cei:expan" mode="meta">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="* | text()" mode="meta"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <!-- template cei:bibl meta -->
    <xsl:template match="cei:bibl" mode="meta">
        <xsl:apply-templates select="* | text()" mode="meta"/>
    </xsl:template>

    <!-- template cei:title meta -->
    <xsl:template match="cei:title" mode="meta">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="meta"/>
        </fo:inline>
    </xsl:template>

    <!-- template cei:author meta-->
    <xsl:template match="cei:author" mode="meta">
        <xsl:apply-templates select="* | text()" mode="author"/>
    </xsl:template>

    <!-- template text() autor-->
    <xsl:template match="text()" mode="author">
        <xsl:analyze-string select="." regex="[A-Z]">
            <xsl:matching-substring>
                <xsl:value-of select="."/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <fo:inline font-style="normal" font-size="75%">
                    <xsl:value-of select="upper-case(.)"/>
                </fo:inline>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!-- template cei:persName author meta-->
    <xsl:template match="cei:persName" mode="author meta">
        <xsl:apply-templates select="* | text()" mode="author"/>
    </xsl:template>

    <!-- template cei:surname author meta-->
    <xsl:template match="cei:surname" mode="author meta">
        <xsl:apply-templates select="* | text()" mode="author"> </xsl:apply-templates>
    </xsl:template>

    <!-- template cei:forename author meta -->
    <xsl:template match="cei:forename" mode="author meta">
        <xsl:apply-templates select="* | text()" mode="meta"> </xsl:apply-templates>
    </xsl:template>


    <!-- template cei:p (erstes) -->
    <xsl:template match="cei:p" mode="erstes">
        <xsl:apply-templates select="* | text()" mode="meta"/>
    </xsl:template>

    <!-- template cei:p (nicht_erstes) -->
    <xsl:template match="cei:p" mode="nicht_erstes">
        <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
            <xsl:apply-templates select="* | text()" mode="meta"/>
        </fo:block>
    </xsl:template>


    <!-- Template "tenor" -->
    <xsl:template name="tenor">
        <xsl:apply-templates select=".//cei:pTenor"/>
    </xsl:template>


    <!-- Templates Tenor -->

    <!-- Templates aufrufen für cei:pTenor -->
    <xsl:template match="cei:pTenor">
        <xsl:if test="//cei:tenor/cei:pTenor/text()">
            <fo:block text-indent="10mm" text-align="justify" margin-top="0mm"
                line-height-shift-adjustment="disregard-shifts" line-height="5mm">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Durchreichelemente, die keine Behandlung benötigen -->
    <xsl:template
        match="cei:arenga | cei:corroboratio | cei:datatio | cei:dispositio | cei:inscriptio | cei:invocatio | cei:narratio | cei:notariusSub | cei:sanctio | cei:setPhrase | cei:subscriptio">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>





    <!-- text() (tenor) -->
    <xsl:template match="text()" mode="tenor" priority="-1">
        <xsl:choose>
            <!-- Ausgabe von Textknoten, die an Fußnotenelementen kleben-->
            <xsl:when
                test="
                    not(starts-with(., ' '))
                    and
                    (preceding-sibling::node()[1]
                    [self::cei:add[@hand]
                    or self::cei:add[@type]
                    or self::cei:c[@type]
                    or self::cei:corr[@sic and @type]
                    or self::cei:corr[@sic and not(@type)]
                    or self::cei:corr[@type and not(@sic)]
                    or self::cei:damage[@agent and @extent]
                    or self::cei:damage[@agent and not(@extent)]
                    or self::cei:damage[@extent and not(@agent)]
                    or self::cei:del[@type]
                    or self::cei:handShift[@hand]
                    or self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]
                    or self::cei:sic[@corr]
                    or self::cei:sic[not(attribute())]
                    or self::cei:space
                    or self::cei:supplied[@type]
                    or self::cei:unclear[@reason]
                    or self::cei:note
                    or self::cei:quote[ancestor::cei:cit]]
                    or
                    preceding-sibling::node()[1][not(self::cei:pict or self::cei:space)][not(descendant-or-self::text()[contains(., ' ')])]
                    [preceding-sibling::node()[1]
                    [self::cei:add[@hand]
                    or self::cei:add[@type]
                    or self::cei:c[@type]
                    or self::cei:corr[@sic and @type]
                    or self::cei:corr[@sic and not(@type)]
                    or self::cei:corr[@type and not(@sic)]
                    or self::cei:damage[@agent and @extent]
                    or self::cei:damage[@agent and not(@extent)]
                    or self::cei:damage[@extent and not(@agent)]
                    or self::cei:del[@type]
                    or self::cei:handShift[@hand]
                    or self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]
                    or self::cei:sic[@corr]
                    or self::cei:sic[not(attribute())]
                    or self::cei:space
                    or self::cei:supplied[@type]
                    or self::cei:unclear[@reason]
                    or self::cei:note
                    or self::cei:quote[ancestor::cei:cit]]]
                    or
                    preceding-sibling::node()[1][not(self::cei:pict or self::cei:space)][not(descendant-or-self::text()[contains(., ' ')])]
                    [preceding-sibling::node()[1][not(self::cei:pict or self::cei:space)][not(descendant-or-self::text()[contains(., ' ')])]]
                    [preceding-sibling::node()[1]
                    [self::cei:add[@hand]
                    or self::cei:add[@type]
                    or self::cei:c[@type]
                    or self::cei:corr[@sic and @type]
                    or self::cei:corr[@sic and not(@type)]
                    or self::cei:corr[@type and not(@sic)]
                    or self::cei:damage[@agent and @extent]
                    or self::cei:damage[@agent and not(@extent)]
                    or self::cei:damage[@extent and not(@agent)]
                    or self::cei:del[@type]
                    or self::cei:handShift[@hand]
                    or self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]
                    or self::cei:sic[@corr]
                    or self::cei:sic[not(attribute())]
                    or self::cei:space
                    or self::cei:supplied[@type]
                    or self::cei:unclear[@reason]
                    or self::cei:note
                    or self::cei:quote[ancestor::cei:cit]]])
                    ">



                <xsl:choose>
                    <!-- Der Textknoten hat ein Leerzeichen
                        [not(following::text()[following::text()/generate-id() = current()/generate-id()][contains(., ' ')])]
                    [not(descendant::text()[following::text()/generate-id() = current()/generate-id()][contains(., ' ')])]
                    [not(following::cei:pict[following::text()/generate-id() = current()/generate-id()])]
                    [not(following::cei:space[following::text()/generate-id() = current()/generate-id()])]
                    
                    -->
                    <xsl:when test="contains(., ' ')">
                        <xsl:choose>
                            <!-- Komma (,) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ',')">
                                <xsl:text>, </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Punkt (.) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), '.')">
                                <xsl:text>. </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Doppelpunkt (:) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ':')">
                                <xsl:text>: </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Semikolon (;) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ';')">
                                <xsl:text>; </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- otherwise -->
                            <xsl:otherwise>
                                <xsl:text> </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <!-- Der Textknoten hat kein Leerzeichen -->
                    <xsl:when test="not(contains(., ' '))">
                        <xsl:choose>
                            <!-- endet mit Komma (,) -->
                            <xsl:when test="ends-with(., ',')">
                                <xsl:text>,</xsl:text>
                            </xsl:when>
                            <!-- endet mit Punkt (.) -->
                            <xsl:when test="ends-with(., '.')">
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                            <!-- endet mit Doppelpunkt (:) -->
                            <xsl:when test="ends-with(., ':')">
                                <xsl:text>:</xsl:text>
                            </xsl:when>
                            <!-- endet mit Semikolon (;) -->
                            <xsl:when test="ends-with(., ';')">
                                <xsl:text>;</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- Ausgabe Textknoten, die Teil eines Zitates (cei:quote) sind -->
                            <xsl:when test="ancestor::cei:quote">
                                <xsl:text xml:space="preserve"> </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!-- Ausgabe Textknoten, die nicht an Fußnotenelement kleben -->
            <xsl:otherwise>

                <xsl:choose>

                    <!-- Ausgabe Textknoten, die Teil eines Zitates (cei:quote) sind -->
                    <xsl:when test="starts-with(., ' ') and ancestor::cei:quote">
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                        />
                    </xsl:when>

                    <!-- otherwise  -->
                    <xsl:otherwise>
                        <xsl:copy-of select="cei:prepare_ext(cei:prepare(.), ./ancestor::*)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Templates Tenor Ausgabe Text von Elementen, die nicht an Fußbnotenelementen kleben -->

    <!-- cei:bibl (tenor) -->
    <xsl:template match="cei:bibl" mode="tenor" priority="-1"/>

    <!-- cei:cit (tenor) -->
    <xsl:template match="cei:cit" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:damage[not(attribute())] (tenor) -->
    <!-- evtl. matching ausschließen, wenn cei:damage eine cei:pict enthält -->

    <xsl:template match="cei:damage[not(attribute())]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cei:expan (tenor) -->
    <xsl:template match="cei:expan" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:choose>
                <xsl:when test="contains(./text()[1], 'Iesu')">
                    <xsl:apply-templates select="* | text()" mode="tenor"/>
                    <xsl:if test="ends-with(./text()[last()], ' ')">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="contains(./text()[1], 'Christi')">
                    <xsl:apply-templates select="* | text()" mode="tenor"/>
                    <xsl:if test="ends-with(./text()[last()], ' ')">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>(</xsl:text>
                    <xsl:apply-templates select="* | text()" mode="tenor"/>
                    <xsl:text>)</xsl:text>
                    <xsl:if test="ends-with(./text()[last()], ' ')">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- cei:foreign (tenor) -->
    <xsl:template match="cei:foreign" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi not(attribute())] (tenor) -->
    <xsl:template match="cei:hi[not(attribute())]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] (tenor) -->
    <xsl:template
        match="cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]"
        mode="tenor" priority="-2">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="text() | *" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] (tenor) -->
    <xsl:template
        match="cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]"
        mode="tenor" priority="-2">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- cei:index (tenor) -->
    <xsl:template match="cei:index" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:lb (tenor) -->
    <xsl:template match="cei:lb" mode="tenor" priority="-1">

        <xsl:if
            test="
                preceding-sibling::text()[1] and not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ]) or (starts-with(following::text()[1], ' '))">

            <xsl:choose>
                <xsl:when
                    test="
                        preceding-sibling::node()[1][
                        self::cei:note or
                        self::cei:quote[ancestor::cei:cit] or
                        self::cei:add[@hand] or
                        self::cei:add[@type] or
                        self::cei:c[@type] or
                        self::cei:corr[@sic and @type] or
                        self::cei:corr[@sic and not(@type)] or
                        self::cei:corr[not(@sic) and @type] or
                        self::cei:damage[attribute()][text()] or
                        self::cei:del[@type] or
                        self::cei:handShift[@hand] or
                        self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] or
                        self::cei:sic[@corr or not(attribute())] or
                        self::cei:space or
                        self::cei:supplied[@type] or
                        self::cei:unclear[@reason]
                        ][not(ends-with(text()[1], ' '))][not(starts-with(following::text()[1], ' '))] or (not(preceding-sibling::node() and ancestor::cei:pTenor[1]))"> </xsl:when>
                <xsl:otherwise>

                    <xsl:choose>
                        <!--<xsl:when test="preceding::node()[1][self::cei:damage] and not(starts-with(following::node()[1][self::text()],' ')) or following::node()[1][self::cei:damage] and not(starts-with(preceding::node()[1][self::text()],' '))">
                            <xsl:text> | </xsl:text>
                        </xsl:when>-->
                        <!-- beides Textknoten; beide Leerzeichen -->
                        <xsl:when
                            test="ends-with(preceding::node()[1], ' ') and starts-with(following::node()[1], ' ')">
                            <xsl:text>|</xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster Leerzeichen, zweiter kein Leerzeichen -->
                        <xsl:when
                            test="ends-with(preceding::node()[1], ' ') and matches(substring(following::node()[1], 1, 1), '\S')">
                            <xsl:text>| </xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster kein Leerzeichen, zweiter Leerzeichen -->
                        <xsl:when
                            test="matches(substring(preceding::node()[1], string-length(preceding::node()[1]), 1), '\S') and starts-with(following::node()[1], ' ')">
                            <xsl:text> |</xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster kein Leerzeichen, zweiter kein Leerzeichen -->
                        <xsl:when
                            test="matches(substring(preceding::node()[1], string-length(preceding::text()[1]), 1), '\S') and matches(substring(following::node()[1], 1, 1), '\S')">
                            <xsl:text>|</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>


                            <xsl:choose>
                                <xsl:when test="ends-with(preceding::node()[1], ' ')">
                                    <xsl:text>| </xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(following::node()[1], ' ')">
                                    <xsl:text> |</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>|</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>

            </xsl:choose>
        </xsl:if>

    </xsl:template>

    <!-- cei:persName (tenor)-->
    <xsl:template match="cei:persName" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:pict (tenor) -->
    <xsl:template match="cei:pict" mode="tenor" priority="-1">

        <xsl:if
            test="not(.[@type = 'signum crucis']/ancestor::cei:damage) and .[@type = 'signum crucis']">
            <xsl:text> + </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'signum crucis']/ancestor::cei:damage">
            <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:if
            test=".[@type = 'signum notarii' or @type = 'signum iudicis' or @type = 'signum testis' or @type = 'signum auctoris']">
            <xsl:text> (S) </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'monogramma']">
            <xsl:text> (M) </xsl:text>
        </xsl:if>

    </xsl:template>

    <!-- cei:quote[not(ancestor::cei:cit)] (tenor) -->
    <xsl:template match="cei:quote[not(ancestor::cei:cit)]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])
                or starts-with(descendant::text()[1], ' ')
                ">
            <xsl:text>&#x200B;</xsl:text>
            <fo:inline font-style="italic">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
            </fo:inline>
            <xsl:text>&#x200B;</xsl:text>
        </xsl:if>
    </xsl:template>



    <!-- Templates Tenor Fußnoten-Elemente -->

    <!-- Zahlen (tenor) -->
    <xsl:template match="
            cei:note |
            cei:quote[ancestor::cei:cit]"
        mode="tenor" priority="-1">

        <!-- cei:note  -->
        <xsl:if test="self::cei:note">
            <fo:footnote>
                <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                    <xsl:number
                        value="count(preceding::cei:cit[ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor = current()/ancestor::cei:tenor]) + 1"
                    />
                </fo:inline>
                <fo:footnote-body>
                    <fo:block> </fo:block>
                </fo:footnote-body>
            </fo:footnote>
        </xsl:if>

        <!-- cei:quote -->
        <xsl:if test="self::cei:quote">
            <fo:inline font-style="italic">
                <xsl:apply-templates select="* | text()" mode="tenor"/>

                <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
                <xsl:if test="not(ends-with(., ' '))">
                    <xsl:apply-templates
                        select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::* = current()][contains(., ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                        mode="kleber"/>
                </xsl:if>

                <fo:footnote>
                    <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                        <xsl:number
                            value="count(preceding::cei:cit[ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor = current()/ancestor::cei:tenor]) + 1"
                        />
                    </fo:inline>
                    <fo:footnote-body>
                        <fo:block> </fo:block>
                    </fo:footnote-body>
                </fo:footnote>
            </fo:inline>
        </xsl:if>
    </xsl:template>

    <!-- Buchstaben (tenor)   -->
    <xsl:template
        match="
            cei:add[@hand or @type] |
            cei:c[@type] |
            cei:corr[@sic and @type] |
            cei:corr[@sic and not(@type)] |
            cei:corr[not(@sic) and @type] |
            cei:damage[attribute()] |
            cei:del[@type] |
            cei:handShift[@hand] |
            cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae')) and attribute()] |
            cei:sic[@corr or not(attribute())] |
            cei:space |
            cei:supplied[@type] |
            cei:unclear[@reason]"
        mode="tenor" priority="-1">

        <!-- cei:add[@hand or @type] -->
        <xsl:if test="self::cei:add[@hand or @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>


        <!-- cei:c[@type] -->
        <xsl:if test="self::cei:c[@type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[@sic and @type] -->
        <xsl:if test="self::cei:corr[@sic and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[@sic and not(@type)] -->
        <xsl:if test="self::cei:corr[@sic and not(@type)]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[not(@sic) and @type] -->
        <xsl:if test="self::cei:corr[not(@sic) and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage[@agent and @extent] tenor -->
        <xsl:if test="self::cei:damage[@agent and @extent]">
            <xsl:text>[...]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][matches(substring(., 1, 1), '[\s\.,]')] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage[@agent and not(@extent)] -->
        <xsl:if test="self::cei:damage[@agent and not(@extent)]">

            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="text() | *" mode="tenor"/>
            <xsl:text>]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage [not(@agent) and @extent] -->
        <xsl:if test="self::cei:damage[not(@agent) and @extent]">
            <xsl:text>[...]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:del[@type] -->
        <xsl:if test="self::cei:del[@type]">

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:handshift[@hand]  -->
        <xsl:if test="self::cei:handShift[@hand]">

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
                <xsl:text>&#x200B;</xsl:text>
            </xsl:if>

        </xsl:if>

        <!-- cei:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] -->
        <xsl:if
            test="self::cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
                <xsl:text>&#x200B;</xsl:text>
            </xsl:if>
        </xsl:if>

        <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] -->
        <xsl:if
            test="self::cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:sic[@corr] -->
        <xsl:if test="self::cei:sic[@corr]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:sic[not(attribute())] tenor -->
        <xsl:if test="self::cei:sic[not(attribute())]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:space -->
        <xsl:if test="self::cei:space">
            <xsl:text>***</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:supplied[@type] -->
        <xsl:if test="self::cei:supplied[@type]">
            <xsl:apply-templates select="text() | *" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:unclear[@reason] -->
        <xsl:if test="self::cei:unclear[@reason]">
            <xsl:apply-templates select="text() | *" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[descendant::text()[1][not(matches(substring(., 1, 1), '[\s\.,]'))] or self::cei:lb][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])][not(self::cei:pict)][not(self::cei:space)][not(self::cei:lb[starts-with(following::text()[1], ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(preceding::cei:pict[preceding-sibling::*/generate-id() = current()/generate-id()])][not(preceding::cei:space[preceding-sibling::*/generate-id() = current()/generate-id()])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- Fußnoten -->
        <fo:footnote>

            <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                <xsl:number
                    value="
                        count(preceding::cei:space[ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:damage[attribute()][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:sic[@corr or not(attribute())][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:unclear[@reason][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:add[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:c[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:corr[@sic and @type][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:corr[@type and not(@sic)][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:corr[@sic and not(@type)][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:del[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:handShift[@hand][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:add[@hand][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:supplied[attribute()][ancestor::cei:tenor = current()/ancestor::cei:tenor]) + 1"
                    format="a"/>
            </fo:inline>

            <fo:footnote-body>
                <fo:block> </fo:block>
            </fo:footnote-body>
        </fo:footnote>


    </xsl:template>

    <!-- Templates Tenor Ausgabe Text von Elementen, die an Fußbnotenelementen kleben -->

    <!-- text() kleber -->
    <xsl:template match="text()" mode="kleber">
        <xsl:choose>
            <!-- Der folgende Textknoten hat kein Leerzeichen -->
            <xsl:when test="not(contains(., ' '))">
                <xsl:choose>
                    <!-- Der Textknoten endet mit Punkt -->
                    <xsl:when test="ends-with(., '.')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), '.'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Komma -->
                    <xsl:when test="ends-with(., ',')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ','), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Semikolon -->
                    <xsl:when test="ends-with(., ';')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ';'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Doppelpunkt -->
                    <xsl:when test="ends-with(., ':')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ':'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Punkt voran -->
            <xsl:when test="ends-with(substring-before(., ' '), '.')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), '.'), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Komma voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ',')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ','), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Semikolon voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ';')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ';'), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Doppelpunt voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ':')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ':'), ./ancestor::*)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ' '), ./ancestor::*)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- cei:bibl (kleber) -->
    <xsl:template match="cei:bibl" mode="kleber" priority="-1"/>

    <!-- cei:cit (kleber) -->
    <xsl:template match="cei:cit" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:damage[not(attribute())] (kleber) -->
    <xsl:template match="cei:damage[not(attribute())]" mode="kleber" priority="-1">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="* | text()" mode="tenor"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- cei:expan (kleber) -->
    <xsl:template match="cei:expan" mode="kleber" priority="-1">
        <xsl:choose>
            <xsl:when test="contains(./text()[1], 'Iesu')">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:if test="ends-with(./text()[last()], ' ')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="contains(./text()[1], 'Christi')">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:if test="ends-with(./text()[last()], ' ')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="ends-with(./text()[last()], ' ')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- cei:foreign (kleber) -->
    <xsl:template match="cei:foreign" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:hi not(attribute())] (kleber) -->
    <xsl:template match="cei:hi[not(attribute())]" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] (kleber) -->
    <xsl:template
        match="cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]"
        mode="kleber" priority="-2">
        <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
    </xsl:template>

    <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] (kleber) -->
    <xsl:template
        match="cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]"
        mode="kleber" priority="-2">
        <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
    </xsl:template>

    <!-- cei:index (kleber) -->
    <xsl:template match="cei:index" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:lb (kleber) -->
    <xsl:template match="cei:lb" mode="kleber" priority="-1">
        <!-- <fo:inline color="red"><xsl:text>=</xsl:text></fo:inline> -->
        <xsl:if test="preceding-sibling::text()[1]">
            <xsl:choose>
                <!-- cei:pict oder cei:space -->
                <xsl:when
                    test="preceding-sibling::node()[1]/descendant-or-self::node()[last()]/name() = 'cei:pict' or preceding-sibling::node()[1]/descendant-or-self::node()[last()]/name() = 'cei:space' or following-sibling::node()[1]/descendant-or-self::node()[last()]/name() = 'cei:pict' or following-sibling::node()[1]/descendant-or-self::node()[last()]/name() = 'cei:space'">
                    <xsl:text> | </xsl:text>
                </xsl:when>
                <!-- beides Textknoten; beide Leerzeichen -->
                <xsl:when
                    test="ends-with(preceding::node()[1], ' ') and starts-with(following::node()[1], ' ')">
                    <xsl:text>|</xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster Leerzeichen, zweiter kein Leerzeichen -->
                <xsl:when
                    test="ends-with(preceding::node()[1], ' ') and matches(substring(following::node()[1], 1, 1), '\S')">
                    <xsl:text>| </xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster kein Leerzeichen, zweiter Leerzeichen -->
                <xsl:when
                    test="matches(substring(preceding::node()[1], string-length(preceding::node()[1]), 1), '\S') and starts-with(following::node()[1], ' ')">
                    <xsl:text> |</xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster kein Leerzeichen, zweiter kein Leerzeichen -->
                <xsl:when
                    test="matches(substring(preceding::node()[1], string-length(preceding::node()[1]), 1), '\S') and matches(substring(following::node()[1], 1, 1), '\S')">
                    <xsl:text>|</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="ends-with(preceding::node()[1], ' ')">
                            <xsl:text>| </xsl:text>
                        </xsl:when>
                        <xsl:when test="starts-with(following::node()[1], ' ')">
                            <xsl:text> |</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>|</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="lb_kein">
        <xsl:text>|</xsl:text>
    </xsl:template>
    <xsl:template name="lb_erstes">
        <xsl:text> |</xsl:text>
    </xsl:template>
    <xsl:template name="lb_zweites">
        <xsl:text>| </xsl:text>
    </xsl:template>
    <xsl:template name="lb_beide">
        <xsl:text> | </xsl:text>
    </xsl:template>

    <!-- cei:persName (kleber)-->
    <xsl:template match="cei:persName" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:pict (kleber) -->
    <xsl:template match="cei:pict" mode="kleber" priority="-1">
        <xsl:if
            test="not(.[@type = 'signum crucis']/ancestor::cei:damage) and .[@type = 'signum crucis']">
            <xsl:text> + </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'signum crucis']/ancestor::cei:damage">
            <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:if
            test=".[@type = 'signum notarii' or @type = 'signum iudicis' or @type = 'signum testis' or @type = 'signum auctoris']">
            <xsl:text> (S) </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'monogramma']">
            <xsl:text> (M) </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cei:quote[not(ancestor::cei:cit)] (kleber) -->
    <xsl:template match="cei:quote[not(ancestor::cei:cit)]" mode="kleber" priority="-1">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </fo:inline>
    </xsl:template>


    <!-- Templates Register -->
    
    <xsl:template name="Index">
        <xsl:for-each-group select="//cei:persName[@reg] | //cei:placeName[@reg] | //cei:geogName[@reg]"
            group-by="@reg/substring(lower-case(.), 1, 1)">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block>
                <xsl:for-each
                    select="distinct-values(//cei:persName/@reg[substring(lower-case(.), 1, 1) = current-grouping-key()] | //cei:placeName/@reg[substring(lower-case(.), 1, 1) = current-grouping-key()] |  //cei:geogName/@reg[substring(lower-case(.), 1, 1) = current-grouping-key()])">
                    <xsl:sort select="lower-case(.)"/>
                    <fo:block start-indent="5mm" text-indent="-5mm">
                        <xsl:analyze-string select="current()" regex="/\w?[^/]*\w?/">
                            <xsl:matching-substring>
                                <fo:inline font-style="italic">
                                    <xsl:value-of
                                        select="substring-before(substring-after(., '/'), '/')"/>
                                </fo:inline>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                        <xsl:text>, </xsl:text>
                        <xsl:variable name="entry_nodes">
                        <xsl:for-each select="$result//cei:group/cei:text">
                            <xsl:sort select="concat(.//cei:dateRange/@from, .//cei:witnessOrig//cei:archIdentifier//cei:idno)"></xsl:sort>
                            <xsl:copy-of select="."></xsl:copy-of>
                        </xsl:for-each>
                        </xsl:variable>
                            <xsl:for-each select="$entry_nodes/cei:text[.//cei:persName/@reg = current()] | $entry_nodes/cei:text[.//cei:placeName/@reg = current()] | $entry_nodes/cei:text[.//cei:geogName/@reg = current()]">
                            <xsl:number select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </xsl:for-each>
            </fo:block>
            <fo:block space-after="5mm"/>
        </xsl:for-each-group>
    </xsl:template>

    <!-- Namensregister 
    <xsl:template name="register_name">
        <xsl:for-each-group select="//cei:persName/@reg"
            group-by="//cei:persName/@reg/substring(lower-case(.), 1, 1)">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block>
                <xsl:for-each
                    select="distinct-values(//cei:persName/@reg[substring(lower-case(.), 1, 1) = current-grouping-key()])">
                    <xsl:sort select="lower-case(.)"/>
                    <fo:block start-indent="5mm" text-indent="-5mm">

                        <xsl:analyze-string select="current()" regex="/\w?[^/]*\w?/">
                            <xsl:matching-substring>
                                <fo:inline font-style="italic">
                                    <xsl:value-of
                                        select="substring-before(substring-after(., '/'), '/')"/>
                                </fo:inline>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>

                        <xsl:text>, </xsl:text>
                        <xsl:for-each select="$result//atom:entry[.//cei:persName/@reg = current()]">
                            <xsl:number select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </xsl:for-each>
            </fo:block>
            <fo:block space-after="5mm"/>
        </xsl:for-each-group>
    </xsl:template> -->

    <!-- Ortsregister 
    <xsl:template name="register_place">
        <xsl:for-each-group select="//cei:placeName/@reg"
            group-by="//cei:placeName/@reg/substring(lower-case(.), 1, 1)">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block>
                <xsl:for-each
                    select="distinct-values(//cei:placeName/@reg[substring(lower-case(.), 1, 1) = current-grouping-key()])">
                    <xsl:sort select="lower-case(.)"/>
                    <fo:block start-indent="5mm" text-indent="-5mm">

                        <xsl:analyze-string select="current()" regex="/\w?[^/]*\w?/">
                            <xsl:matching-substring>
                                <fo:inline font-style="italic">
                                    <xsl:value-of
                                        select="substring-before(substring-after(., '/'), '/')"/>
                                </fo:inline>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>

                        <xsl:text>, </xsl:text>
                        <xsl:for-each
                            select="$result//atom:entry[.//cei:placeName/@reg = current()]">
                            <xsl:number select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </xsl:for-each>
            </fo:block>
            <fo:block space-after="5mm"/>
        </xsl:for-each-group>
    </xsl:template>-->

    <!-- Index 
    <xsl:template name="register_index">

        <xsl:for-each-group select="//cei:index/@lemma"
            group-by="//cei:index/@lemma/substring(lower-case(.), 1, 1)">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block>
                <xsl:for-each
                    select="distinct-values(//cei:index/@lemma[substring(lower-case(.), 1, 1) = current-grouping-key()])">
                    <xsl:sort select="lower-case(.)"/>
                    <fo:block start-indent="5mm" text-indent="-5mm">

                        <xsl:analyze-string select="current()" regex="/\w?[^/]*\w?/">
                            <xsl:matching-substring>
                                <fo:inline font-style="italic">
                                    <xsl:value-of
                                        select="substring-before(substring-after(., '/'), '/')"/>
                                </fo:inline>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>

                        <xsl:text>, </xsl:text>
                        <xsl:for-each select="$result//atom:entry[.//cei:index/@lemma = current()]">
                            <xsl:number select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </xsl:for-each>
            </fo:block>
            <fo:block space-after="5mm"/>
        </xsl:for-each-group>
    </xsl:template> -->


</xsl:stylesheet>