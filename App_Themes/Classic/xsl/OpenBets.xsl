<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no" encoding="UTF-8"/>

  <!-- Format "m/d/yyyy hh:mm[:ss] AM/PM" -> "m-d h:mmam/pm" -->
  <xsl:template name="fmt-md-hm">
    <xsl:param name="dt"/>
    <xsl:choose>
      <xsl:when test="contains($dt,'/') and contains($dt,' ')">
        <!-- month, day -->
        <xsl:variable name="m" select="substring-before($dt,'/')"/>
        <xsl:variable name="rest1" select="substring-after($dt,'/')"/>
        <xsl:variable name="d" select="substring-before($rest1,'/')"/>
        <!-- time chunk after the space: 'hh:mm(:ss) AM/PM' -->
        <xsl:variable name="tFull" select="normalize-space(substring-after($dt,' '))"/>
        <xsl:variable name="h" select="substring-before($tFull,':')"/>
        <xsl:variable name="afterFirst" select="substring-after($tFull,':')"/>
        <!-- minutes may be before second ':' or before space -->
        <xsl:variable name="mm1" select="substring-before($afterFirst,':')"/>
        <xsl:variable name="mm2" select="substring-before($afterFirst,' ')"/>
        <xsl:variable name="mm">
          <xsl:choose>
            <xsl:when test="string-length($mm1)&gt;0"><xsl:value-of select="$mm1"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$mm2"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- am/pm (lowercase) -->
        <xsl:variable name="ampmRaw" select="normalize-space(substring-after($tFull,' '))"/>
        <xsl:variable name="ampm" select="translate($ampmRaw,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        <xsl:value-of select="format-number(number($m),'#')"/><xsl:text>-</xsl:text>
        <xsl:value-of select="format-number(number($d),'#')"/><xsl:text> </xsl:text>
        <xsl:value-of select="format-number(number($h),'#')"/><xsl:text>:</xsl:text>
        <xsl:value-of select="format-number(number($mm),'00')"/>
        <xsl:value-of select="$ampm"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dt"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//xml">
    <!-- Show Cancel only if user has at least one delete right -->
    <xsl:variable name="hasCancel" select="@CanDeleteAnytime='1' or @CanDeleteBeforeStart='1'"/>

    <script type="text/javascript">
      function post(){
        var strNum = 'Page=1';
        var strWT = 'WagerType=' + document.forms[0].cWagerType.value;
        var strSP = 'IdSport=' + document.forms[0].cIdSport.value;
        var strID = 'IdPlayer=' + document.forms[0].cPlayer.value;
        var str = strNum + '&amp;' + strSP + '&amp;' + strWT + '&amp;' + strID;
        document.forms[0].action = 'OpenBets.aspx?' + str;
        document.forms[0].submit();
      }
      function ChangePage(){
        var strNum = 'Page=' + document.forms[0].cPageNum.value;
        var strWT = 'WagerType=' + document.forms[0].cWagerType.value;
        var strSP = 'IdSport=' + document.forms[0].cIdSport.value;
        var strID = 'IdPlayer=' + document.forms[0].cPlayer.value;
        var str = strNum + '&amp;' + strSP + '&amp;' + strWT + '&amp;' + strID;
        document.forms[0].action = 'OpenBets.aspx?' + str;
        document.forms[0].submit();
      }
    </script>

    <h3 class="page-title mb-3">Open Bets</h3>

    <!-- Filters -->
    <div class="card mb-3">
      <div class="card-body">
        <div class="row g-2">

          <div class="col-12 col-sm-6 col-lg-3">
            <label class="form-label">Type of Wager</label>
            <select class="form-select form-select-sm" name="cWagerType" onchange="post();">
              <xsl:for-each select="wagertype">
                <option value="{@Value}">
                  <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="@Text"/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div class="col-12 col-sm-6 col-lg-3">
            <label class="form-label">Type of Sport</label>
            <select class="form-select form-select-sm" name="cIdSport" onchange="post();">
              <xsl:for-each select="idsport">
                <option value="{@Value}">
                  <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="@Text"/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div class="col-12 col-sm-6 col-lg-3">
            <label class="form-label">Player Name</label>
            <select class="form-select form-select-sm" name="cPlayer" onchange="post();">
              <xsl:for-each select="player">
                <option value="{@Value}">
                  <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="@Text"/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div class="col-12 col-sm-6 col-lg-2">
            <label class="form-label">Currency</label>
            <select class="form-select form-select-sm" name="cCurrency" onchange="post();">
              <xsl:for-each select="currency">
                <option value="{@IdCurrency}">
                  <xsl:if test="@AgentCurrency='True'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="@Currency"/> (<xsl:value-of select="@Symbol"/>)
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div class="col-12 col-sm-6 col-lg-1 d-flex align-items-end">
            <input type="submit" class="btn btn-primary btn-sm w-100" value="Go"/>
          </div>

        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="table-responsive">
      <table class="table table-bordered table-striped table-sm align-middle">
        <thead class="table-dark">
          <tr>
            <th class="d-none d-md-table-cell" style="width:14%">Placed</th>
            <th class="d-none d-md-table-cell" style="width:14%">Game Date</th>
            <th class="d-none d-sm-table-cell" style="width:10%">Sport</th>
            <th>Description</th>
            <th style="width:14%">Risk / Win</th>
            <xsl:if test="$hasCancel">
              <th class="text-center d-none d-sm-table-cell" style="width:10%">Cancel</th>
            </xsl:if>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="//detail">
            <!-- Player header -->
            <xsl:if test="@Header='True'">
              <tr class="table-primary">
                <td class="fw-bold" colspan="">
                  <xsl:attribute name="colspan">
                    <xsl:choose>
                      <xsl:when test="$hasCancel">7</xsl:when>
                      <xsl:otherwise>6</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="@Text1"/> (<xsl:value-of select="@Text2"/>)
                </td>
              </tr>
            </xsl:if>

            <!-- Data row -->
            <xsl:if test="@Header='False'">
              <tr>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="count(preceding::detail[@Header='False']) mod 2 = 0">evenRow</xsl:when>
                    <xsl:otherwise>oddRow</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>

                <!-- Placed (md+) -->
                <td class="d-none d-md-table-cell text-center">
                  <!-- prefer PlacedDate attribute if present; else try Text1 after BR; else raw Text1 -->
                  <xsl:variable name="placedRaw">
                    <xsl:choose>
                      <xsl:when test="@PlacedDate and string-length(normalize-space(@PlacedDate))&gt;0">
                        <xsl:value-of select="normalize-space(@PlacedDate)"/>
                      </xsl:when>
                      <xsl:when test="contains(@Text1,'&lt;BR /&gt;')">
                        <xsl:value-of select="normalize-space(substring-after(@Text1,'&lt;BR /&gt;'))"/>
                      </xsl:when>
                      <xsl:otherwise><xsl:value-of select="normalize-space(@Text1)"/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:call-template name="fmt-md-hm">
                    <xsl:with-param name="dt" select="$placedRaw"/>
                  </xsl:call-template>
                  <xsl:if test="@TicketNumber">
                    <div class="small text-muted">#<xsl:value-of select="@TicketNumber"/></div>
                  </xsl:if>
					<div class="d-none d-lg-table-cell">
						<xsl:value-of select="@Text2" disable-output-escaping="yes"/>
					</div>
                </td>

                <!-- Game Date (md+) - take only the FIRST block after first BR and before the next BR -->
                <td class="d-none d-md-table-cell">
                  <xsl:variable name="gdFull">
                    <xsl:choose>
                      <xsl:when test="contains(@Text3,'&lt;BR')">
                        <xsl:value-of select="substring-after(@Text3,'&lt;BR /&gt;')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@Text3"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="gdOne" select="normalize-space(substring-before(concat($gdFull,'&lt;BR'), '&lt;BR'))"/>
                  <xsl:call-template name="fmt-md-hm">
                    <xsl:with-param name="dt" select="$gdOne"/>
                  </xsl:call-template>
                </td>

                <!-- Sport (sm+) -->
                <td class="d-none d-sm-table-cell">
                  <xsl:choose>
                    <xsl:when test="@Sport"><xsl:value-of select="@Sport"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="@Text4" disable-output-escaping="yes"/></xsl:otherwise>
                  </xsl:choose>
                </td>

                <!-- Description (always). Mobile also shows compact meta + mobile cancel button -->
                <td>
                  <!-- compact meta (xs only) -->
                  <div class="d-md-none small text-muted mb-1">
                    <!-- Ticket -->
                    <xsl:if test="@TicketNumber">#<xsl:value-of select="@TicketNumber"/><xsl:text> · </xsl:text></xsl:if>
                    <!-- Sport -->
                    <xsl:choose>
                      <xsl:when test="@Sport"><xsl:value-of select="@Sport"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="@Text4" disable-output-escaping="yes"/></xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> · </xsl:text>
                    <!-- Game date (formatted) for XS: only FIRST block -->
                    <xsl:variable name="gdFullXs">
                      <xsl:choose>
                        <xsl:when test="contains(@Text3,'&lt;BR')">
                          <xsl:value-of select="substring-after(@Text3,'&lt;BR /&gt;')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@Text3"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="gdOneXs" select="normalize-space(substring-before(concat($gdFullXs,'&lt;BR'), '&lt;BR'))"/>
                    <xsl:call-template name="fmt-md-hm">
                      <xsl:with-param name="dt" select="$gdOneXs"/>
                    </xsl:call-template>

                    <!-- Mobile cancel button (only if rights and row is deletable) -->
                    <xsl:if test="$hasCancel and @CanDelete='1'">
                      <a class="btn btn-danger btn-sm ms-2 py-0 px-2 align-baseline">
                        <xsl:attribute name="href">
                          <xsl:text>javascript:CancelWagerPopup(</xsl:text>
                          <xsl:value-of select="@TicketNumber"/>
                          <xsl:text>, '</xsl:text>
                          <xsl:value-of select="@Sport"/>
                          <xsl:text>');</xsl:text>
                        </xsl:attribute>
                        <i class="fa fa-times" aria-hidden="true"></i>
                      </a>
                    </xsl:if>
                  </div>

                  <!-- main description -->
                  <xsl:value-of select="@Text5" disable-output-escaping="yes"/>
                </td>

                <!-- Risk / Win -->
                <td class="text-end">
                  <xsl:value-of select="@Text6" disable-output-escaping="yes"/>
                </td>

                <!-- Desktop/tablet Cancel column -->
                <xsl:if test="$hasCancel">
                  <td class="text-center d-none d-sm-table-cell">
                    <xsl:if test="@CanDelete='1'">
                      <a class="btn btn-danger btn-sm deletebtn">
                        <xsl:attribute name="href">
                          <xsl:text>javascript:CancelWagerPopup(</xsl:text>
                          <xsl:value-of select="@TicketNumber"/>
                          <xsl:text>, '</xsl:text>
                          <xsl:value-of select="@Sport"/>
                          <xsl:text>');</xsl:text>
                        </xsl:attribute>
                        <i class="fa fa-times" aria-hidden="true"></i>
                      </a>
                    </xsl:if>
                  </td>
                </xsl:if>
              </tr>
            </xsl:if>
          </xsl:for-each>

          <xsl:if test="count(//detail[@Header='False'])=0">
            <tr>
              <td class="text-center text-muted" colspan="">
                <xsl:attribute name="colspan">
                  <xsl:choose>
                    <xsl:when test="$hasCancel">7</xsl:when>
                    <xsl:otherwise>6</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                No open wagers
              </td>
            </tr>
          </xsl:if>
        </tbody>
      </table>
    </div>

    <!-- Pager -->
    <div class="card mt-3">
      <div class="card-body py-2">
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2">

          <div class="small">
            <xsl:if test="//xml/@Prev != ''">
              <a class="btn btn-link btn-sm px-0 me-2" href="OpenBets.aspx?{//xml/@Prev}">Previous Page</a>
            </xsl:if>
            <span class="text-muted"><xsl:value-of select="//xml/@View"/></span>
            <xsl:if test="//xml/@Next != ''">
              <a class="btn btn-link btn-sm px-0 ms-2" href="OpenBets.aspx?{//xml/@Next}">Next Page</a>
            </xsl:if>
          </div>

          <div>
            <xsl:if test="count(//pagenum) &gt; 0">
              <label class="form-label me-2 mb-0 small">Go to</label>
              <select class="form-select form-select-sm d-inline-block" style="width:auto" name="cPageNum" onchange="ChangePage();">
                <xsl:for-each select="//pagenum">
                  <option value="{@Value}">
                    <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                    <xsl:value-of select="@Text"/>
                  </option>
                </xsl:for-each>
              </select>
            </xsl:if>
          </div>

        </div>
      </div>
    </div>

    <div class="mt-3 text-center">
      <input type="button" value="Close" data-bs-dismiss="modal" class="btn btn-warning btn-sm"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
